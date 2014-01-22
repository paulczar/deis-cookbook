Vagrant.require_plugin "vagrant-berkshelf"
Vagrant.require_plugin "vagrant-chef-zero"
Vagrant.require_plugin "vagrant-omnibus"

Vagrant.configure("2") do |config|
  # Berkshelf plugin configuration
  config.berkshelf.enabled = true

  # Chef-Zero plugin configuration
  config.chef_zero.enabled = true
  config.chef_zero.chef_repo_path = "."
  config.chef_zero.data_bags = "./data_bags"

  # Omnibus plugin configuration
  config.omnibus.chef_version = :latest

  # Deis Controller
  config.vm.define :controller do |controller|
    controller.vm.hostname = "deis-controller"
    controller.vm.box = "ubuntu1204-3.8"
    controller.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/ubuntu-12.04.3-amd64-vbox.box"
    controller.vm.network "forwarded_port", guest: 80, host: 8080     # dashboard
    controller.vm.network "private_network", ip: "192.168.77.70"
    controller.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--memory", 2048]
    end
    controller.vm.provision :chef_client do |chef|
      #chef.environment = chef_environment
      chef.json = {
        deis: {
          knife: {
            client_key_source: '/etc/chef/client.pem',
            validation_key_source: '/tmp/vagrant-chef-1/validation.pem',
            client_rb_source: '/tmp/vagrant-chef-1/client.rb'
          }
        }
      }
      chef.run_list = [ 'recipe[deis::controller]' ]
    end
    controller.vm.provision :shell, inline: <<-SCRIPT
      cp /tmp/vagrant-chef-1/* /etc/chef/
      chmod 777 /etc/chef/*
    SCRIPT
  end

  # Deis Controller
  config.vm.define :node do |node|
    node.vm.hostname = "deis-node"
    node.vm.box = "ubuntu1204-3.8"
    node.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/ubuntu-12.04.3-amd64-vbox.box"
    node.vm.network "forwarded_port", guest: 80, host: 8081     # proxy
    node.vm.network "private_network", ip: "192.168.77.71"
    node.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--memory", 1024]
    end
    node.vm.provision :chef_client do |chef|
      #chef.environment = chef_environment
      chef.json = {
      }
      chef.run_list = [ 'recipe[deis::default]' ]
    end
  end

end
