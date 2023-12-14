# Vagrantfile

Vagrant.configure("2") do |config|

    # general options
    config.vm.box = "debian/bullseye64"
    config.vm.provision "shell", path: "provision.sh"
    config.vm.provider :virtualbox do |vb|
        vb.memory = 256
        vb.cpus = 1
        vb.linked_clone = true
    end

    # ftp server - it will have 2 network interfaces, one for the anon server and another for the local users
    config.vm.define "ftp-server" do |vm|
        vm.vm.hostname = "ftp.sri.ies"
        vm.vm.network :private_network, type: "static", ip: "192.168.57.20"
        vm.vm.network :private_network, type: "static", ip: "192.168.57.30"
    end

    # ns server
    config.vm.define "ns-server" do |vm|
        vm.vm.hostname = "ns.sri.ies"
        vm.vm.network :private_network, type: "static", ip: "192.168.57.10"
    end
end
