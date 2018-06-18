#!/bin/bash
#==========================================================
#  Script name -- imagebuild.sh --  DESCRIPTION:
#
#
#  Author:  Lindsey Tulloch , ltulloch@redhat.com
#  CREATED:  2018-06-15 11:47:57 AM EDT

set -e

REGISTRY="quay.io"
REPO=
IMAGE="federation-v2"
TAG="proto"

IMAGE="$REGISTRY/$REPO/$IMAGE:$TAG"
root_dir="$(pwd)"
temp_dir="${root_dir}/build"

echo "Building controller manager"
go build -o ${temp_dir}/controller-manager ${root_dir}/cmd/controller-manager/main.go
echo "Building apiserver"
go build -o ${temp_dir}/apiserver ${root_dir}/cmd/apiserver/main.go
echo "Building Federation-v2 docker image"
docker build  .
echo "Pushing build to container registry"
docker push quay.io/onyiny_ang/federation-v2:openshift-update

"Removing temp file"
rm -rf ${temp_dir}
