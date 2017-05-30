#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
package "httpd" do
	action :install
end

node["apache"]["sites"].each do |sitename, data|
  document_root = "/content/sites/#{sitename}"
  
  directory document_root do
	mode "0755"
	recursive true
  end
template "/etc/hhpd/config.d/#{sitename}.conf do
	source "vhost.erb" 
	mode "0644"
	variable(
		:document_root => document_root
		:port => data["port"]
		:domain => data["domain"]  
	)
	nofifies :restart, service,["http"]
	
end

end


service "httpd" do
	action [:enable, :start]
end
 
