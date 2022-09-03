#!/bin/bash
set -e

sudo apt install -y sshpass rsync
script_dirname="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
rootfslock="${script_dirname}/_output/rootfs/rootfs-ready.lock"
k3sreadylock="${script_dirname}/_output/rootfs/k3s-ready.lock"

install_option="--disable=traefik"
/workspace/gitpod-k3s/.gitpod/ssh.sh "curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC=${install_option} sh -"

mkdir -p ~/.kube
/workspace/gitpod-k3s/.gitpod/scp.sh root@127.0.0.1:/etc/rancher/k3s/k3s.yaml ~/.kube/config

echo "✅ k3s server is ready"
sudo curl -o /usr/bin/kubectl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x /usr/bin/kubectl
kubectl get pods --all-namespaces

touch "${k3sreadylock}"

wget https://github.com/vmware-tanzu/octant/releases/download/v0.25.1/octant_0.25.1_Linux-64bit.deb
sudo dpkg -i ./octant_0.25.1_Linux-64bit.deb
rm octant_0.25.1_Linux-64bit.deb

/workspace/gitpod-k3s/.gitpod/prepare_helm.sh
sudo cp /workspace/gitpod-k3s/.gitpod/hosts /etc/hosts

kubectl get pods
