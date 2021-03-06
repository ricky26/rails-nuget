class PackageGroup
	attr_accessor :packages, :name, :title

	def initialize name, options={}
		@name = name
		@title = options[:title] || name

		@packages = Rails.cache.fetch cache_key, :expires_in => 30.seconds do
			Dir.glob("#{source_dir}/*.nupkg").inject([]) do |r, f|
				r << Package.from_file(f)
			end
		end
	end

	def cache_key
		"package_group_#{name}_packages"
	end

	def flush_cache
		Rails.cache.delete cache_key
	end

	def source_dir	
		return "#{Rails.root}/public/#{@name}"
	end

	def updated
		DateTime.now
	end

	def filter val
		@packages = @packages.select { |x| ODataHelper.query x, val }
	end

	def order_by val
		@packages = @packages.sort_by { |x| ODataHelper.query x, val }
	end

	def find_package params={}
		name = params[:Id]
		version = params[:Version]

		@packages.select do |x|
			(name.nil? || x.name == name) &&
				(version.nil? || x.version == version)
		end.first	
	end
end
