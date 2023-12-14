# Vagrantfile

Vagrant.configure("2") do |config|

    # method to create the machines
    def create_machine(config, name, box, linked_clone: true, hostname: name, net_type:"dhcp", cpus:1, memory:256, ip_add: nil, provision: nil)
        config.vm.provider :virtualbox do |vb|
            vb.memory = memory
            vb.cpus = cpus
            vb.linked_clone = linked_clone
        end
        config.vm.define name do |node|
            node.vm.box = box
            node.vm.hostname = hostname

            # net configuration
            if net_type == "dhcp"
                node.vm.network :public_network, type: "dhcp"
            elsif net_type == "static"
                node.vm.network :public_network, type: "static", ip: ip_add
            end

            # provision configuration
            if provision
                node.vm.provision "shell", path: provision
            end
        end
    end

    create_machine(config, "ftp-server", "debian/bullseye64", net_type: "static", ip_add: "192.168.57.30")

end
