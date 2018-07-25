#!/usr/bin/env bash

# This script automates deployment of a federation - as documented
# in the README - to the current kubectl context.
#
# If using minikube, a cluster must be deleteed prior to invoking this
# script:
#
#   $ minikube delete
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

export PATH=$PATH:/usr/local/apiserver-builder/bin
export GOPATH=~/src/v2
export GOBIN=~/src/v2/bin


CONTEXT="us-east"
CONTEXT2="eu-central"
CONTEXT3="ap-north"

minikube-linux delete -p ${CONTEXT}
minikube-linux delete -p ${CONTEXT2}
minikube-linux delete -p ${CONTEXT3}
