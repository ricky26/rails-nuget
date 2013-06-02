require 'zip/zip'
require 'digest/sha1'
require 'nokogiri'

class NugetPackage
	def initialize file
		@path = file
		@zip = Zip::ZipFile.open(file)
		if not @zip.nil?
			@rels = Nokogiri::XML(@zip.read("_rels/.rels"))
		end
	end

	def get_rel_element ns
		@rels.css('Relationships Relationship').each do |e|
			return e.attr('Target')
		end
	end

	def get_rel ns
		path = get_rel_element ns
		if path.start_with? "/"
			path = path[1..-1]
		end
		@zip.read path
	end

	def spec
		@spec ||= Nuspec.from_string(get_rel("http://schemas.microsoft.com/packaging/2010/07/manifest"))
	end

	def size
		@size ||= File.size(@path)
	end

	def hash_algorithm
		"SHA512"
	end
	
	def hash
		@hash ||= File.open(@path, "rb") do |f|
			contents = f.read
			f.close

			Digest::SHA2.new(512).base64digest(contents)
		end		
	end
end
