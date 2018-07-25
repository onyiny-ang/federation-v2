#!/bin/bash

source "$(dirname "${BASH_SOURCE}")/util.sh"
KCD="kubectl --ignore-not-found=true delete"

${KCD} federatednamespaceplacement.core.federation.k8s.io "test-namespace"
${KCD} federateddeployment.core.federation.k8s.io "test-deployment"
${KCD} federateddeploymentplacement.core.federation.k8s.io "test-deployment"
${KCD} federateddeploymentoverride.core.federation.k8s.io "test-deployment"

function ns-deleted() {
  kubectl get ns "${1}" &> /dev/null
  [[ "$?" = "1" ]]
}

util::wait-for-condition "removal of namespace 'test-namespace'" "ns-deleted test-namespace" 120

