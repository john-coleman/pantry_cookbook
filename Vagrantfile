# -*- mode: ruby -*-
# vi: set ft=ruby tabstop=2 expandtab shiftwidth=2 :
# Development machine Vagrant
VAGRANT_API_VERSION = "2"

ruby_file_path = File.expand_path(File.dirname(__FILE__))

apt_cache = ENV['VAGRANT_APT_CACHE'] || File.join(ruby_file_path, "tmp", "apt-cache")
pantry_path = ENV['PANTRY_PATH'] || ::File.join(ruby_file_path, "../pantry")
daemons_paths = Dir[ENV['DAEMON_PATH'] || ::File.join(ruby_file_path, "../*_handler")]
pantry_daemon_common_path = ENV['DAEMON_COMMON_PATH'] || ::File.join(ruby_file_path, "../pantry_daemon_common")
FileUtils.mkdir_p(File.join(apt_cache, "partial"))

Vagrant.require_version ">= 1.6.3"
Vagrant.configure(VAGRANT_API_VERSION) do |config|
  config.vm.box = 'opscode-ubuntu-12.04'
  config.vm.box_url = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box'
  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest
  config.vm.network :forwarded_port, guest: 8080, host: 18080
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :forwarded_port, guest: 443, host: 8443
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 1024]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
  config.vm.synced_folder apt_cache, "/var/cache/apt/archives/"
  config.vm.synced_folder pantry_daemon_common_path, "/home/vagrant/pantry_daemon_common"
  config.vm.provision :shell, :inline => "ulimit -n 16048; apt-get update"
  config.vm.synced_folder pantry_path, "/home/vagrant/pantry"
  config.ssh.forward_agent = true
  daemons_paths.each do |path|
    config.vm.synced_folder path, "/home/vagrant/#{File.basename(path)}"
  end
  config.vm.provision :chef_solo do |chef|
    chef.log_level = :info
    chef.add_recipe "apt"
    chef.add_recipe "pantry::dev_test_packages"
    chef.add_recipe 'pantry::ruby'
    chef.add_recipe "build-essential"
    chef.add_recipe "mysql::server"
    chef.add_recipe "database"
    chef.add_recipe "pantry::database"
    chef.json = {
      pantry: {
        database_name: 'pantry_test'
      },
      :build_essential => {
        :compiletime => true
      },
      :mysql => {
        :server_root_password => "pantryroot",
        :server_repl_password => "pantryrepl",
        :server_debian_password => "pantrydebian"
      }
    }
  end
end
