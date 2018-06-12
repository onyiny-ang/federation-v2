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

source "$(dirname "${BASH_SOURCE}")/util.sh"
export PATH=$PATH:/usr/local/apiserver-builder/bin
export GOPATH=~/src/v2
export GOBIN=~/src/v2/bin

NS=federation
IMAGE_NAME="gcr.io/jiji-168714/federation-v2:openshift-update"

CONTEXT="$(kubectl config current-context)"

JOIN_CLUSTERS="${*}"

#printf "\nJoin the host cluster (us-east) to the federation\n"
#read -n 1 -s
#printf "\nkubefnord join "us-east" --host-cluster-context "us-east" --add-to-registry --v=2\n"
#read -n 1 -s
#kubefnord join "${CONTEXT}" --host-cluster-context "${CONTEXT}" --add-to-registry --v=2


printf "\nJoin the other clusters (ap-north and eu-central) to the federation\n"
read -n 1 -s
printf "\nfor c in ap-north eu-central; do
    kubefnord join "{c}" --host-cluster-context us-east --add-to-registry --v=2
done\n"
read -n 1 -s
for c in ${JOIN_CLUSTERS}; do kubefnord join "${c}" --host-cluster-context "${CONTEXT}" --add-to-registry --v=2
done


printf "\nFederation is now set up!\n"
read -n 1 -s
printf "\nkubectl -n federation describe federatedclusters\n"
read -n 1 -s
kubectl -n federation describe federatedclusters


