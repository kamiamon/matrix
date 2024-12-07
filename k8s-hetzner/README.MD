1. Up servers via terraform
```aiignore
 sudo kubeadm init --control-plane-endpoint "k8s.atpstealer.com:6443" --upload-certs --pod-network-cidr=192.168.0.0/16
```

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/
https://metallb.universe.tf/configuration/_advanced_ipaddresspool_configuration/

