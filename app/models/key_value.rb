class KeyValue
	def self.parse_value str
		/'([^']*)'/.match(str) do |m|
			return m[1].to_s
		end

		raise "Bad Value '#{str}'"
	end

	def self.parse_kv str
		vals = str.split('=')
		key = vals[0].to_sym
		value = parse_value vals[1]
		
		[key, value]
	end

	def self.parse str
		str.split(',').inject({}) do |r,skv|
			kv = parse_kv(skv)
			r[kv[0]] = kv[1]
			r
		end
	end

	def self.value_to_s v
		return "'#{v.to_s}'"
	end

	def self.kv_to_s k, v
		return "#{k}=#{value_to_s v}"
	end

	def self.to_s obj
		obj.inject("") do |r,kv|
			r << "," unless r.empty?
			r << self.kv_to_s(kv[0], kv[1])
		end
	end
end
