#!/usr/bin/env bash

# This script automates deployment of a federation - as documented
# in the README - to the current kubectl context.
#
# If using minikube, a cluster must be started prior to invoking this
# script:
#
#   $ minikube start
#
# This script depends on crinit, kubectl, and apiserver-boot being
# installed in the path.  These binaries can be installed via the
# download-test-binaries.sh script, which downloads to ./bin:
#
#   $ ./scripts/download-test-binaries.sh
#   $ export PATH=$(pwd)/bin:${PATH}
#
# To redeploy federation from scratch, prefix the deploy invocation with the deletion script:
#
#   # WARNING: The deletion script will remove federation and cluster registry data
#   $ ./scripts/delete-federation.sh && ./scripts/deploy-test-federation.sh <image>
#

set -o errexit
set -o nounset
set -o pipefail

source "$(dirname "${BASH_SOURCE}")/util.sh"

export PATH=$PATH:/usr/local/apiserver-builder/bin
export GOPATH=~/src/v2
export GOBIN=~/src/v2/bin

NS=federation
IMAGE_NAME="gcr.io/jiji-168714/federation:v2"

CONTEXT="us-west"
CONTEXT2="us-east"

minikube start --vm-driver kvm -p ${CONTEXT}
minikube start --vm-driver kvm -p ${CONTEXT2}

kubectl config use-context ${CONTEXT}
kubectl config set-context ${CONTEXT} --namespace=test-namespace
kubectl config set-context ${CONTEXT2} --namespace=test-namespace

# Wait for the storage provisioner to be ready.  If crinit is called
# before dynamic provisioning is enabled, the pvc for etcd will never
# be bound.
function storage-provisioner-ready() {
  result="$(kubectl -n kube-system get pod storage-provisioner -o jsonpath='{.status.conditions[?(@.type == "Ready")].status}' 2> /dev/null)"
  [[ "${result}" = "True" ]]
}
util::wait-for-condition "storage provisioner readiness" 'storage-provisioner-ready' 60

crinit aggregated init mycr

kubectl create ns "${NS}"

apiserver-boot run in-cluster --name "${NS}" --namespace "${NS}" --image "${IMAGE_NAME}" --controller-args="-logtostderr,-v=4"

# Create a permissive rolebinding to allow federation controllers to run.
# TODO(marun) Make this more restrictive.
kubectl create clusterrolebinding federation-admin --clusterrole=cluster-admin --serviceaccount="${NS}:default"


# Increase the memory limit of the apiserver to ensure it can start.
kubectl -n federation patch deploy federation -p '{"spec":{"template":{"spec":{"containers":[{"name":"apiserver","resources":{"limits":{"memory":"128Mi"},"requests":{"memory":"64Mi"}}}]}}}}'

# Wait for the apiserver to become available so that join can be performed.
function apiserver-available() {
  # Being able to retrieve without error indicates the apiserver is available
  kubectl get federatedcluster 2> /dev/null
}
util::wait-for-condition "apiserver availability" 'apiserver-available' 60

# Join the host cluster
go build -o bin/kubefnord cmd/kubefnord/kubefnord.go
./bin/kubefnord join "${CONTEXT}" --host-cluster-context "${CONTEXT}" --add-to-registry --v=2

./bin/kubefnord join "${CONTEXT2}" --host-cluster-context "${CONTEXT}" --add-to-registry --v=2
