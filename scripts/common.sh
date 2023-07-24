# Script to run on both master and worker nodes

# Disable firewall 
systemctl disable firewalld; systemctl stop firewalld

# Disable swap 
swapoff -a; sed -i '/swap/d' /etc/fstab

# Disable SELinux 
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux 

# Update sysctl settings for kubernetes networking 
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# Install Docker engine 
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce-19.03.12 
systemctl enable --now docker

## kubernetes setup 
#

# Add yum repository 
cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Getting version from settings 
VERSION="$(echo ${KUBERNETES_VERSION} | grep -oE '[0-9]+\.[0-9]+')"

# Install kubernetes components
yum install -y kubelet-"$KUBERNETES_VERSION" kubectl-"$KUBERNETES_VERSION" kubeadm-"$KUBERNETES_VERSION"

# Enable and start kubelet service
systemctl enable --now kubelet
