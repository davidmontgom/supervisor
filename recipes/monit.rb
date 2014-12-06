service "monit"
template "/etc/monit/conf.d/supervisor.conf" do
  path "/etc/monit/conf.d/supervisor.conf"
  source "monit.supervisor.conf.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :restart, resources(:service => "monit")
end