
Vagrant.configure("2") do |config|

  #######################################
  #### deploy cluster infrastructure ####
  #######################################
  
  vm_workers = [
    { name: 'kube-lb1', role: 'load_balancer', ip: '192.168.57.11' },
    { name: 'kube-lb2', role: 'load_balancer', ip: '192.168.57.12' },
    { name: 'kube-controller1', role: 'controller', ip: '192.168.57.13' },
    { name: 'kube-controller2', role: 'controller', ip: '192.168.57.14' },
    { name: 'kube-controller3', role: 'controller', ip: '192.168.57.15' },
    { name: 'kube-compute1', role: 'compute', ip: '192.168.57.16' },
    { name: 'kube-compute2', role: 'compute', ip: '192.168.57.17' },
    { name: 'kube-compute3', role: 'compute', ip: '192.168.57.18' }
  ]

  vm_workers.each do |vm_config|
    config.vm.define vm_config[:name] do |vm|
      vm.vm.box = "ubuntu/jammy64"

      vm.vm.provider "virtualbox" do |vb|
        vb.name = vm_config[:name]
        vb.memory = "2048"
        vb.cpus = 2
      end

      vm.vm.network "private_network", type: "static", ip: vm_config[:ip], adapter: 2

      vm.vm.hostname = vm_config[:name]

      vm.vm.provision "shell", inline: <<-SHELL
        echo "%vagrant ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/90-nopassword-vagrant
        mkdir -p /home/vagrant/.ssh
        cat /vagrant/ansible/keys/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
        chown -R vagrant: /home/vagrant/.ssh
        chmod 600 /home/vagrant/.ssh/*
        hostnamectl set-hostname #{vm_config[:name]}
      SHELL

      vm.vm.provision "shell", inline: <<-SHELL
        echo "VM #{vm_config[:name]} with role #{vm_config[:role]} has been provisioned"
      SHELL

    end
  end

  #######################################
  #### deploy ansible infrastructure ####
  #######################################

  vm_orchestrator = [
    { name: 'orca-mgmt', role: 'load_balancer', ip: '192.168.57.100' }
  ]
    
  vm_orchestrator.each do |vm_config|
    config.vm.define vm_config[:name] do |vm|
      vm.vm.box = "ubuntu/jammy64"

      vm.vm.provider "virtualbox" do |vb|
        vb.name = vm_config[:name]
        vb.memory = "2048"
        vb.cpus = 2
      end

      vm.vm.network "private_network", type: "static", ip: vm_config[:ip], adapter: 2

      vm.vm.hostname = vm_config[:name]

      vm.vm.provision "shell", inline: <<-SHELL
        echo "%vagrant ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/90-nopassword-vagrant
        mkdir -p /root/.ssh
        mkdir -p /home/vagrant/.ssh
        cat /vagrant/ansible/keys/id_rsa > /root/.ssh/id_rsa
        cat /vagrant/ansible/keys/id_rsa > /home/vagrant/.ssh/id_rsa
        cat /vagrant/ansible/keys/id_rsa.pub > /home/vagrant/.ssh/authorized_keys
        echo "Host 192.168.57.*" > /home/vagrant/.ssh/config
        echo "  User vagrant" >> /home/vagrant/.ssh/config
        echo "  IdentityFile ~/.ssh/id_rsa" >> /home/vagrant/.ssh/config
        echo "  IdentitiesOnly yes" >> /home/vagrant/.ssh/config
        echo "  UserKnownHostsFile /dev/null" >> /home/vagrant/.ssh/config
        echo "  StrictHostKeyChecking no" >> /home/vagrant/.ssh/config
        chown -R root: /root/.ssh
        chmod 600 /root/.ssh/*
        chown -R vagrant: /home/vagrant/.ssh
        chmod 600 /home/vagrant/.ssh/*
        hostnamectl set-hostname #{vm_config[:name]}
        #### run ansible plays
        apt update && apt install ansible -y        
        cd /vagrant/ansible
        rm -rf cache
        ansible-playbook playbooks/deploy_haproxy_lb.yml -l load_balancers
        ansible-playbook playbooks/deploy_k8s.yml -l k8s_cluster
      SHELL

      vm.vm.provision "shell", inline: <<-SHELL
        echo "VM #{vm_config[:name]} with role #{vm_config[:role]} has been provisioned"
      SHELL

    end
  end

end
