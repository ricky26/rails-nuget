namespace :db do
	desc "Add a new API key"
	task :add_api_key, [:perms, :regex] => [:environment] do |t, args|
		perms = args[:perms] || "rpd"
		regex = args[:regex] || ".*"

		can_read = perms.include? 'r'
		can_publish = perms.include? 'p'
		can_delete = perms.include? 'd'

		key = ApiKey.new :can_read => can_read, :can_publish => can_publish, :can_delete => can_delete
		key.save

		puts "Created key #{key.key} with permissions #{perms}"
	end

	desc "Remove an API key"
	task :remove_api_key, [:key] => [:environment] do |t, args|
		key = ApiKey.from_key args[:key]
		raise "Invalid API Key '#{args[:key]}'" if key.nil?
		
		key.destroy
		puts "Deleted key #{key.key}"
	end
end
