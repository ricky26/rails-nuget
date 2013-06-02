class Package
	attr_accessor :metadata, :name, :author, :file

	@@ODATA_MAP = {
		:Id => :name,
	}

	def self.from_file path
		nupkg = NugetPackage.new path
		spec = nupkg.spec
		m = spec.metadata

		ret = self.new
		ret.file = path
		ret.metadata = PackageMetadata.from_nuget nupkg
		ret.metadata.created = ret.metadata.published = File.mtime(path).to_datetime
		ret.name = ret.metadata.name
		ret.author = ret.metadata.authors.sub(/,/, ", ")
		
		ret
	end

	def odata_prop name
		send @@ODATA_MAP[name] if @@ODATA_MAP.include? name
	end

	def title
		metadata.title
	end

	def version
		metadata.version
	end

	def summary
		metadata.summary
	end

	def updated
		metadata.published
	end
end
