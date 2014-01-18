#
# Cookbook Name:: deis
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'deis::users'

# create a log directory writeable by the deis user

directory node.deis.log_dir do
  user node.deis.username
  group node.deis.group
  mode 0755
end

# TODO: remove forced apt-get update when default indexes are fixed
bash 'force-apt-get-update' do
  code "apt-get update && touch #{home_dir}/prevent-apt-update"
  not_if "test -e #{home_dir}/prevent-apt-update"
end

# always install these packages

package 'fail2ban'
package 'python-setuptools'
package 'python-pip'
package 'debootstrap'
package 'git'
package 'make'

