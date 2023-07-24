#########################################                                       
# Vagrant provisioner file              #
#                                       #
#                                       #
# author: Andranik Grigoryan            #
# repo: vagrant-kubernetis-provisioning #
#                                       #
#########################################

# -*- mode: ruby -*-
# vi: set ft=ruby :

require "yaml"
settings = YAML.load_file("settings.yaml") # Reading settings file 

MASTER_IP = settings["network"]["master_ip"] # Getting master node's IP from settings
WORKERS_IP = MASTER_IP.split('.')[0..2].join('.') + '.' # First tree octets of workers IP 
WORKERS_COUNT = settings["nodes"]["workers"]["count"] # Count of worker nodes 

# Adding configuration to /etc/host for vms 
Vagrant.configure("2") do |config|
  # Initial configuration script 
  config.vm.provision "shell", env: { "MASTER_IP" => MASTER_IP, "WORKERS_IP" => WORKERS_IP, "WORKERS_COUNT" => WORKERS_COUNT }, inline: <<-SHELL
      yum update -y
      echo "$MASTER_IP master-node" >> /etc/hosts
      for i in `seq 1 ${NUM_WORKER_NODES}`; do
        echo "${WORKERS_IP} ${i} worker-node0${i}" >> /etc/hosts
      done
  SHELL

  # Setting up vm-s os 
  if `uname -m`.strip == "aarch64"
    config.vm.box = settings["additional"]["box"] + "-arm64"
  else
    config.vm.box = settings["additional"]["box"]
  end
  config.vm.box_check_update = true
  
  # Master node configuration
  config.vm.define "master" do |master|
    master.vm.hostname = "master-node"
    master.vm.network "private_network", ip: MASTER_IP
    
    # TODO: Add sync_folders option 

    master.vm.provider "virtualbox" do |vb|
        vb.cpus = settings["nodes"]["control"]["cpu"]
        vb.memory = settings["nodes"]["control"]["memory"]
        if settings["cluster_name"] and settings["cluster_name"] != ""
          vb.customize ["modifyvm", :id, "--groups", ("/" + settings["cluster_name"])]
        end
    end
  end

  # Worker nodes configuration 
  (1..WORKERS_COUNT).each do |i| # Loop for each worker nodes: (to change nodes count see settings.yaml)
      config.vm.define "node0#{i}" do |node|
        node.vm.hostname = "worker-node0#{i}"
        node.vm.network "private_network", ip: WORKERS_IP + "#{10 + i}"

      # TODO: sync_folders settings to add
      
        node.vm.provider "virtualbox" do |vbox|
          vbox.cpus = settings["nodes"]["workers"]["cpu"]
          vbox.memory = settings["nodes"]["workers"]["memory"]
          if settings["cluster_name"] and settings["cluster_name"] != ""
            vbox.customize ["modifyvm", :id, "--groups", ("/" + settings["cluster_name"])]
          end
        end
      end
  end

end
