#!/bin/bash
#==========================================================
#  Script name -- minikube-fed.sh --  DESCRIPTION:
#
#
#  Author:  Lindsey Tulloch , ltulloch@redhat.com
#  CREATED:  2018-06-12 10:42:51 AM EDT

set -o errexit
set -o nounset
set -o pipefail

#source "$(dirname "${BASH_SOURCE}")"
export GOPATH=~/src/v2
export GOBIN=~/src/v2/bin

kubectl config use-context us-east

CONTEXT="$(kubectl config current-context)"

./scripts/deploy-federation-latest.sh ap-north eu-central


printf "\nFederation is now set up!\n"
read -n 1 -s
printf "\nkubectl -n federation-system describe federatedclusters\n"
read -n 1 -s
kubectl -n federation-system describe federatedclusters


