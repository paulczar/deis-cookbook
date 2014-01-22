
include_recipe 'apt'

apt_repository 'dotcloud' do
  key node['deis']['docker']['key_url']
  uri node['deis']['docker']['deb_url']
  distribution 'docker'
  components ['main']
end

package "lxc-docker-#{node['deis']['docker']['version']}"

service 'docker' do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

# create a docker user
# and make sure it owns /var/run/docker.sock

user 'docker' do
  action :create
  system true
  not_if { 'id docker' }
end

execute 'set-docker-sock-perms' do
  command 'chgrp docker /var/run/docker.sock'
  not_if "ls -l /var/run/docker.sock | awk {'print $4'} | grep docker"
  action :run
end

