class ApiKey < ActiveRecord::Base
	include ActiveModel::ForbiddenAttributesProtection

	before_validation(:on => :create) do
		self.generate_key
	end

	def regex
		@regex ||= Regexp.new regex_str
	end

	def can_read? package
		can_read && (regex_str.nil? || regex.match(package))
	end

	def can_publish? package
		can_publish && (regex_str.nil? || regex.match(package))
	end

	def can_delete? package
		can_delete && (regex_str.nil? || regex.match(package))
	end

	def generate_key
		self.key ||= self.class.generate_key
	end

	def self.generate_key
		SecureRandom.hex(16)
	end

	def self.from_key str
		str && where(:key => str).first
	end
end
