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
