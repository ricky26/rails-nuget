class PackagesController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => [:create, :delete]

	def initialize
		@rootGroup = PackageGroup.new "Packages"
			
		@groups = {
			:Packages => :packages,
			:FindPackagesById => :packages_by_id
		}
	end

	def self.parse_id query
		rx = /([^.(]*)(?:\(([^)]*)\))?/
		match = rx.match(query)
		if match.nil?
			nil
		else
			meth = match[1]
			if meth.nil? || meth == ""
				return nil
			end
			meth = meth.to_sym

			params = match[2]
			params = if params.nil? || params == ""
				nil
			else 
				KeyValue.parse(params) unless params.nil?
			end
			
			[meth, params]
		end
	end

	def index
		@query = self.class.parse_id params[:area]

		if not @query.nil?
			@group = send @groups[@query[0]]
			raise ActionController::RoutingError.new('Not Found') if @group.nil?	

			if not params[:$filter].nil?
				@group.filter params[:$filter]
			end
			
			if not params[:$order_by].nil?
				@group.order_by params[:$order_by]
			end

			if not @query[1].nil?
				@package = @group.find_package @query[1]
				raise ActionController::RoutingError.new('Not Found') if @package.nil?	
			end
		end

		respond_to do |fmt|
			fmt.xml
		end
	end

	def metadata
		render :file => "#{Rails.root}/public/_metadata.xml"
	end

	def show
		@package = @rootGroup.find_package :Id => params[:package_id], :Version => params[:version]

		if @package.nil?
			render :status => :not_found, :text => "Not Found"
			return
		end

		redirect_to @package.file.sub("#{Rails.root}/public/", "/")
	end

	def create
		apiKey = request.headers["X-NuGet-ApiKey"]

		if not check_api_key apiKey
			render :status => :forbidden, :text => "Bad API Key"
			return
		end
		
		package = params[:package]
		npkg = NugetPackage.new package.tempfile
		m = PackageMetadata.from_nuget npkg
	
		dest = File.join(Rails.root, "public/Packages/#{m.name}.#{m.version}.nupkg")
		File.open(dest, "wb") { |f| f.write(package.read) }

		@rootGroup.flush_cache

		render :xml => '<ok/>'
	end

	def delete
		apiKey = request.headers["X-NuGet-ApiKey"]

		if not check_api_key apiKey
			render :status => :forbidden, :text => "Bad API Key"
			return
		end

		package = @rootGroup.find_package :Id => params[:package_id], :Version => params[:version]
		if package.nil?
			render :status => :not_found, :text => "Not Found"
			return
		end

		File.delete package.file

		@rootGroup.flush_cache

		render :xml => '<ok/>'
	end

	def check_api_key key
		key == "supersecret"
	end

	private

	def packages
		@rootGroup
	end

	def packages_by_id
		id = nil

		par = params[:id]
		/'([^']*)'/.match(par) do |m|
			id = m[1]
		end

		if not id.nil?
			@rootGroup.packages = @rootGroup.packages.select {|x| x.name == id }
		end
	
		@rootGroup
	end
end
