require 'nokogiri'

class Nuspec
	def self.from_string src
		new Nokogiri::Slop src
	end

	def initialize source
		@xml = source
	end

	def metadata
		@xml.css('metadata').first
	end
end
