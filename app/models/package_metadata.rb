class PackageMetadata
	private
	
	@@NAME_MAP = {}
	@@LOCAL_MAP = {}
	@@PARAM_MAP = {}

	def self.declare_member local, name, params={}
		@@NAME_MAP[name] = local
		@@LOCAL_MAP[local] = name
		@@PARAM_MAP[local] = params

		attr_accessor local
	end

	# members
	declare_member :version, "Version"
	declare_member :copyright, "Copyright"
	declare_member :created, "Created", :type => "Edm.DateTime"
	declare_member :dependencies, "Dependencies"
	declare_member :description, "Description"
	declare_member :download_count, "DownloadCount", :type => "Edm.Int32"
	declare_member :gallery_details_url, "GalleryDetailsUrl"
	declare_member :icon_url, "IconUrl"
	declare_member :is_latest_version, "IsLatestVersion", :type => "Edm.Bool"
	declare_member :is_absolute_latest_version, "IsAbsoluteLatestVersion", :type => "Edm.Bool"
	declare_member :is_prerelease, "IsPrerelease", :type => "Edm.Bool"
	declare_member :language, "Language"
	declare_member :published, "Published", :type => "Edm.DateTime"
	declare_member :license_url, "LicenseUrl"
	declare_member :package_hash, "PackageHash"
	declare_member :package_hash_algorithm, "PackageHashAlgorithm"
	declare_member :package_size, "PackageSize", :type => "Edm.Int64"
	declare_member :project_url, "ProjectUrl"
	declare_member :report_abuse_url, "ReportAbuseUrl"
	declare_member :release_notes, "ReleaseNotes"
	declare_member :require_license_acceptance, "RequireLicenseAcceptance", :type => "Edm.Bool"
	declare_member :tags, "Tags"
	declare_member :title, "Title"
	declare_member :version_download_count, "VersionDownloadCount", :type => "Edm.Int64"
	declare_member :min_client_version, "MinClientVersion"
	declare_member :summary, "Summary"

	public
	attr_accessor :name, :authors

	def self.from_nuget nupkg
		m = nupkg.spec.metadata
		ret = new

		basicText = lambda do |n|
			el = m.css(n).first
			el && el.text		
		end

		ret.package_size = nupkg.size
		ret.package_hash = nupkg.hash
		ret.package_hash_algorithm = nupkg.hash_algorithm

		[ 'version', 'title', 'copyright', 'summary', 'description', 'tags', 'authors' ].each do |x|
			ret.send "#{x}=", basicText.call(x)
		end

		{
			"name" => "id",
			"release_notes" => "releaseNotes",
			"icon_url" => "iconUrl",
			"project_url" => "projectUrl",
			"license_url" => "licenseUrl",
		}.each do |k,v|
			ret.send "#{k}=", basicText.call(v)
		end

		ret.require_license_acceptance = (basicText.call('requireLicenseAcceptance') == 'true')

		ret.dependencies = m.css('dependencies dependency').inject("") do |r,e|
			r << "#{e.attr('id')}:#{e.attr('version')}:"
			r
		end

		ret
	end

	def initialize
		@download_count = 0
		@is_latest_version = true
		@is_absolute_latest_version = true
		@is_prerelease = false
		@published = DateTime.now
		@created = DateTime.now
		@packages_size = 0
		@require_license_acceptance = false
		@version_download_count = 0
		@description = ""
	end

	def to_xml xml
		@@LOCAL_MAP.each do |local, name|
			args = {}
			params = @@PARAM_MAP[local]
			value = send local
		
			if not params[:type].nil?
				args["m:type"] = params[:type]
			end

			if value.nil?
				value = ""
				args["m:null"] = "true"
			end

			xml.d(name.to_sym, value.to_s, args)
		end
	end
end
