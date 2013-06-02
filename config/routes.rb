Nuget::Application.routes.draw do
	# API

	def api
		scope '/package' do
			put '' => 'packages#create', :as => :create_package
			delete ':package_id/:version' => 'packages#delete', :constraints => { :package_id => /[^\/]*/, :version => /[^\/]*/ }, :as => :delete_package
			get ':package_id/:version' => 'packages#show', :constraints => { :package_id => /[^\/]*/, :version => /[^\/]*/ }, :as => :show_package
		end

		put '' => 'packages#create', :as => :create_package
		delete ':package_id/:version' => 'packages#delete', :constraints => { :package_id => /[^\/]*/, :version => /[^\/]*/ }, :as => :delete_package
		get ':package_id/:version' => 'packages#show', :constraints => { :package_id => /[^\/]*/, :version => /[^\/]*/ }, :as => :show_package

		get ':metadata' => 'packages#metadata', :constraints => { :metadata => /\$metadata/ }
		get ':area' => 'packages#index', :defaults => { :format => 'xml' },
				:constraints => { :area => /.*/ }, :as => :packages
		root :to => 'packages#index', :defaults => { :format => 'xml' }
	end

	scope '/api' do
		scope '/v2' do
			api
		end
	end

	root :to => 'home#index'
end
