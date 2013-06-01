Nuget::Application.routes.draw do
	# API
	namespace :api do
		namespace :v2 do
			namespace :package do
				put '/' => 'packages#create'
				delete '/:package_id/:version' => 'packages#delete'
				get '/:package_id/:version' => 'package#show'
			end
		end
	end

	put '/' => 'packages#create'
	delete '/:package_id/:version' => 'packages#delete'

	get 'Packages' => 'packages#index'
end
