#!/bin/bash
set -e

kubectl port-forward --namespace=ingress-nginx service/ingress-nginx-controller 8090:80
