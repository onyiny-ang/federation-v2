#!/usr/bin/env bash

# This script removes the cluster registry and federation from the
# current kubectl context.

set -o errexit
set -o nounset
set -o pipefail

source "$(dirname "${BASH_SOURCE}")/util.sh"

KCD="kubectl --ignore-not-found=true delete"

# Remove the federation service account for the current context.
CONTEXT="$(kubectl config current-context)"
SA_NAME="${CONTEXT}-${CONTEXT}"
${KCD} -n federation sa "${SA_NAME}"
${KCD} -n federation clusterrole "federation-controller-manager:${SA_NAME}"
${KCD} -n federation clusterrolebinding "federation-controller-manager:${SA_NAME}"

# Remove federation
${KCD} apiservice v1alpha1.federation.k8s.io
${KCD} namespace federation

# Remove cluster registry
${KCD} clusterrolebinding federation-admin
${KCD} apiservice v1alpha1.clusterregistry.k8s.io
${KCD} namespace clusterregistry
${KCD} clusterrole clusterregistry.k8s.io:apiserver
${KCD} clusterrolebinding clusterregistry.k8s.io:apiserver
${KCD} clusterrolebinding clusterregistry.k8s.io:apiserver-auth-delegator
${KCD} -n kube-system rolebinding clusterregistry.k8s.io:extension-apiserver-authentication-reader

# Wait for the namespaces to be removed
function ns-deleted() {
  kubectl get ns "${1}" &> /dev/null
  [[ "$?" = "1" ]]
}
util::wait-for-condition "removal of namespace 'federation'" "ns-deleted federation" 120
util::wait-for-condition "removal of namespace 'clusterregistry'" "ns-deleted clusterregistry" 120
