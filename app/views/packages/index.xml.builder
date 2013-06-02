xml.instruct!

if not @package.nil?
	xml << render(:partial => 'package', :locals => { :package => @package, :group => @group })
elsif not @group.nil?
	[@group].each do |group|
		xml.tag!('feed', {
			"xmlns" => "http://www.w3.org/2005/Atom",
			"d" => "http://schemas.microsoft.com/ado/2007/08/dataservices",
			"m" => "http://schemas.microsoft.com/ado/2007/08/dataservices/metadata",
			"xml:base" => "https://nuget.org/api/v2/" }) do

			xml.title group.title, :type => "text"
			xml.id(packages_url group.name)
			xml.updated group.updated
			xml.link :rel => "self", :title => group.title, :href => group.name
			
			group.packages.each do |package|
				xml << render(:partial => 'package', :locals => { :package => package, :group => group })
			end
		end
	end
else
	xml.tag!('service', {
		"xmlns:atom" => "http://www.w3.org/2005/Atom",
		"xmlns:app" => "http://www.w3.org/2007/app",
		"xmlns" => "http://www.w3.org/2007/app",
		"xml:base" => "https://nuget.org/api/v2/" }) do

		xml.workspace do
			xml.atom :title, "Default"
			xml.collection :href => 'Packages' do
				xml.atom :title, "Packages"
			end
		end
	end
end
