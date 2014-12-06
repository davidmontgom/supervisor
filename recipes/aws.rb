include_recipe "python::pip"

python_pip "supervisor" do
  action :install
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

