# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos-6.4-x86_64"
  config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130309.box"

  config.vm.network :forwarded_port, guest: 80, host: 8888

  config.vm.network :private_network, ip: "192.168.33.10"

  config.vm.synced_folder "./shared/www", "/www", :mount_options => ["dmode=777,fmode=777"]
  config.vm.synced_folder "./shared/logs", "/logs",  :mount_options => ["dmode=777,fmode=777"]

  config.vm.provider "virtualbox" do |v|
      v.memory = 1024
  end

  config.vm.provision :puppet,
    :facter => { "fqdn" => "vagrant.vagrantup.com" }  do |puppet|
       puppet.manifests_path = "manifests"
       puppet.manifest_file = "base.pp"
       puppet.module_path = "modules"
       puppet.hiera_config_path = "hiera.yaml"
       puppet.working_directory = "./"
  end
end