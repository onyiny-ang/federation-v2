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

CONTEXT="us-east"
CONTEXT2="eu-central"
CONTEXT3="ap-north"

printf "\nkubectl config use-context ${CONTEXT}\n"
kubectl config use-context ${CONTEXT}

read -n 1 -s

if [[ -z "${IMAGE_NAME}" ]]; then
 >&2 echo "Usage: $0 <image> [join-cluster]...

<image>        should be in the form <containerregistry>/<username>/<imagename>:<tagname>

Example: docker.io/<username>/federation-v2:test

If intending to use the docker hub as the container registry to push
the federation image to, make sure to login to the local docker daemon
to ensure credentials are available for push:

  $ docker login --username <username>

<join-cluster> should be the kubeconfig context name for the additional cluster to join.
               NOTE: The host cluster is already included in the join.

"
  exit 2
fi

function storage-provisioner-ready() {
  local result="$(kubectl -n kube-system get pod storage-provisioner -o jsonpath='{.status.conditions[?(@.type == "Ready")].status}' 2> /dev/null)"
  [[ "${result}" = "True" ]]
}
util::wait-for-condition "storage provisioner readiness" 'storage-provisioner-ready' 60


printf "\nStart cluster registry\n"
read -n 1 -s
printf "\ncrinit aggregated init mycr --host-cluster-context=us-east\n"
read -n 1 -s
crinit aggregated init mycr --host-cluster-context=${CONTEXT}


printf "\nCreate federation namespace\n"
read -n 1 -s
printf "\nkubectl create ns federation\n"
read -n 1 -s
kubectl create ns "${NS}"


printf "\nAssuming federation image is pushed to docker and federation repo has been built with apiserver builder. . .\n"
read -n 1 -s
printf "\nkubectl apply -f config/apiserver.yaml\n"
read -n 1 -s
kubectl apply -f config/apiserver.yaml
rm -rf ~/.kube/cache/discovery/
printf "\nList api versions\n"
read -n 1 -s
kubectl api-versions

printf "\nCreate a permissive rolebinding to allow federation controllers to run.\n"
read -n 1 -s
printf "\nkubectl create clusterrolebinding federation-admin --clusterrole=cluster-admin --serviceaccount="federation:default"\n"
read -n 1 -s
kubectl create clusterrolebinding federation-admin --clusterrole=cluster-admin --serviceaccount="${NS}:default"


printf "\nIncrease the memory limit of the apiserver to ensure it can start.\n"
read -n 1 -s
printf "\nkubectl -n federation patch deploy federation -p '{"spec":{"template":{"spec":{"containers":[{"name":"apiserver","resources":{"limits":{"memory":"128Mi"},"requests":{"memory":"64Mi"}}}]}}}}'\n"
read -n 1 -s
kubectl -n federation patch deploy federation -p '{"spec":{"template":{"spec":{"containers":[{"name":"apiserver","resources":{"limits":{"memory":"128Mi"},"requests":{"memory":"64Mi"}}}]}}}}'


printf "\nWait for the apiserver to become available so that join can be performed.\n"
function apiserver-available() {
  # Being able to retrieve without error indicates the apiserver is available
  kubectl get federatedcluster 2> /dev/null
}
util::wait-for-condition "apiserver availability" 'apiserver-available' 60
printf "\nREADY\n"

printf "\nList available types\n"
read -n 1 -s
printf "\nll config/federatedtypes/\n"
ll config/federatedtypes
printf "\nCreate types\n"
read -n 1 -s
for filename in config/federatedtypes/*.yaml; do
  kubectl create -f "${filename}"
done


printf "\nJoin the host cluster (us-east) to the federation\n"
read -n 1 -s
printf "\nkubefnord join "us-east" --host-cluster-context "us-east" --add-to-registry --v=2\n"
read -n 1 -s
kubefnord join "${CONTEXT}" --host-cluster-context "${CONTEXT}" --add-to-registry --v=2


printf "\nJoin the other clusters (ap-north and eu-central) to the federation\n"
read -n 1 -s
printf "\nfor c in ap-north eu-central; do
    kubefnord join "{c}" --host-cluster-context us-east --add-to-registry --v=2
done\n"
read -n 1 -s
for c in ${CONTEXT2} ${CONTEXT3}; do
    kubefnord join "${c}" --host-cluster-context "${CONTEXT}" --add-to-registry --v=2
done


printf "\nFederation is now set up!\n"
read -n 1 -s
printf "\nkubectl -n federation describe federatedclusters\n"
read -n 1 -s
kubectl -n federation describe federatedclusters


