# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  (1..6).each do |i|
    vmname="ubuntu-#{i}"
    config.vm.define "#{vmname}" do |s|
      s.vm.box = "ubuntu/xenial64"
      s.vm.hostname = "#{vmname}"
      s.vm.network "private_network", ip: "172.28.148.#{1+i}"
      s.vm.provision :shell, path: "provision.sh"
      s.vm.provider "virtualbox" do |v|
        v.name = "#{vmname}"
        v.memory = 1024
        v.gui = false
      end
    end
  end
end