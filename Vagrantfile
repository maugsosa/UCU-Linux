# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    if Vagrant.has_plugin?("vagrant-cachier")
        config.cache.scope = :box
    end

     config.vm.define "control" do |control|
        control.vm.box ="ubuntu/trusty64"
        control.vm.hostname = "control"
        control.vm.network "private_network", ip: "10.0.0.223"
        control.vm.provision "shell", path: "provision/control.sh"
        control.vm.provider"virtualbox" do |vbox|
            vbox.memory = 128
            vbox.cpus = 1
        end
    end

    config.vm.define "server", primary: true do |server|
        server.vm.box ="ubuntu/trusty64"
        server.vm.hostname = "server"
        server.vm.network "private_network", ip: "10.0.0.210"
        server.vm.provision "shell", path: "provision/server.sh"
        server.vm.network "forwarded_port", guest:80, host:8080
        server.vm.provider"virtualbox" do |vbox|
            vbox.memory = 512
            vbox.cpus = 1
        end
    end

    config.vm.define "datos" do |datos|
        datos.vm.box ="ubuntu/trusty64"
        datos.vm.hostname = "datos"
        datos.vm.network "private_network", ip: "10.0.0.222"
        datos.vm.provision "shell", path: "provision/datos.sh"
        datos.vm.provider"virtualbox" do |vbox|
            vbox.memory = 256
            vbox.cpus = 1
        end
    end

   

end
