#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

#source "$(dirname "${BASH_SOURCE}")"
export GOPATH=~/src/v2
export GOBIN=~/src/v2/bin

CONTEXT="us-east"
CONTEXT2="eu-central"
CONTEXT3="ap-north"

kubectl config use-context us-east

CONTEXT="$(kubectl config current-context)"

./scripts/deploy-federation-latest.sh ap-north eu-central


printf "\nFederation is now set up!\n"
read -n 1 -s
printf "\nkubectl -n federation-system describe federatedclusters\n"
read -n 1 -s
kubectl -n federation-system describe federatedclusters


