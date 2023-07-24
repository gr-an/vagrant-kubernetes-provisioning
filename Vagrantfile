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
  config.vm.provision "shell", env: {"MASTER_IP" => MASTER_IP, WORKERS_IP => WORKERS_IP, WORKERS_COUNT => WORKERS_COUNT}, inline: <<-SHELL 
    apt update -y 
    echo "$MASTER_IP master-node" >> /etc/hosts
    for i in `seq 1 ${WORKERS_COUNT}`; do 
      echo "$((WORKERS_IP+i)) worker-node${i}" >> /etc/hosts
    done
  SHELL
end
