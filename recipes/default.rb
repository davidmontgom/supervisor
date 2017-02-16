Chef::Provider::Package.include Chef::Mixin::Command
=begin
include_recipe "python::pip"

python_pip "supervisor" do
  action :install
end
=end

package "python-dev" do
  action :install
end



=begin
curl -O http://python-distribute.org/distribute_setup.py
$ python distribute_setup.py
$ curl -O https://raw.github.com/pypa/pip/master/contrib/get-pip.py
$ python get-pip.py
=end


=begin
package "python-setuptools" do
  action [:install,:upgrade]
end
=end

python_package "setuptools" do
  action :upgrade
end

bash "install_pip" do
  cwd "/tmp/"
  code <<-EOH
  wget https://bootstrap.pypa.io/get-pip.py
  /usr/bin/python get-pip.py
EOH
  creates "#{Chef::Config[:file_cache_path]}/get-pip.lock"
  not_if {File.exists?("#{Chef::Config[:file_cache_path]}/get-pip.lock")}
end

=begin
package "python-pip" do
  action :install
end

bash "install_pip" do
  code <<-EOH
  pip install --upgrade pip
  touch "#{Chef::Config[:file_cache_path]}/get-pip.lock"
EOH
  not_if {File.exists?("#{Chef::Config[:file_cache_path]}/get-pip.lock")}
end
=end



python_package "supervisor" do
  action :upgrade
end

directory "/etc/supervisor/conf.d" do
  owner "root"
  group "root"
  mode "0755"
  recursive true
  action :create
end

template "/etc/init.d/supervisord" do
  path "/etc/init.d/supervisord"
  source "supervisord.erb"
  owner "root"
  group "root"
  mode "0755"
end


service "supervisord" do
  supports :restart => true, :start => true, :stop => true, :reload => true
  action [ :enable, :start]
end

template "/etc/supervisord.conf" do
  path "/etc/supervisord.conf"
  source "supervisord.conf.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :restart, resources(:service => "supervisord")
end

