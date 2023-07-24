# initialize Kubernetes Cluster
kubeadm init --apiserver-advertise-address=$MASTER_IP --pod-network-cidr=$POD_CIDR

# Deploy calico network 
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v${CALICO_VERSION}/manifests/calico.yaml

# Get joining command 
kubeadm token create --print-join-command > $config_path/join.sh


