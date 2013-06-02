class HomeController < ApplicationController
	def index
		respond_to do |fmt|
			fmt.html
		end
	end
end
