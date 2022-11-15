#!/bin/bash
set -e

docker save --output ot.tar ot
sshpass -p 'root' rsync ot.tar -e 'ssh -p 2222' --progress root@127.0.0.1:/root/ot.tar
sshpass  -p 'root' ssh -o StrictHostKeychecking=no -p 2222 root@127.0.0.1 "sudo k3s ctr images import /root/ot.tar"

helm uninstall ingress-nginx --namespace ingress-nginx
helm upgrade --install ingress-nginx \
  /workspace/gitpod-k3s/projects/ingress-nginx/charts/ingress-nginx \
  --values /workspace/gitpod-k3s/projects/ingress-nginx/charts/ingress-nginx/values.yaml \
  --namespace ingress-nginx --create-namespace
