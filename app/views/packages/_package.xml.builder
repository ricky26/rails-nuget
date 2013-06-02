xml.entry({
	"xml:base" => "https://nuget.org/api/v2/",
	"xmlns:d" => "http://schemas.microsoft.com/ado/2007/08/dataservices",
	"xmlns:m" => "http://schemas.microsoft.com/ado/2007/08/dataservices/metadata",
	"xmlns" => "http://www.w3.org/2005/Atom",
	}) do

	kv = KeyValue.to_s({:Id=>package.name, :Version=>package.version})
	localpath = "#{group.name}(#{kv})"

	xml.id("#{packages_url group.name}(#{kv})")
	xml.title package.name, :type => 'text'
	xml.summary package.summary, :type => 'text'
	xml.updated package.updated
	xml.author { xml.name package.author }

	xml.link :rel => 'edit-media', :title => 'V2FeedPackage', :href => "#{localpath}/$value"
	xml.link :rel => 'edit', :title => 'V2FeedPackage', :href => "#{localpath}"

	xml.category :term => 'NuGetGallery.V2FeedPackage', :scheme => "http://schemas.microsoft.com/ado/2007/08/dataservices/scheme"
	xml.content :type => 'application/zip', :src => (show_package_url :package_id => package.name, :version => package.version)
	
	xml.m(:properties, {
		"xmlns:m" => "http://schemas.microsoft.com/ado/2007/08/dataservices/metadata",
		"xmlns:d" => "http://schemas.microsoft.com/ado/2007/08/dataservices" }) do
	
		package.metadata.to_xml xml
	end
end
