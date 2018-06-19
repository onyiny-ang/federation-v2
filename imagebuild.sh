#!/bin/bash
#==========================================================
#  Script name -- imagebuild.sh --  DESCRIPTION:
#
#
#  Author:  Lindsey Tulloch , ltulloch@redhat.com
#  CREATED:  2018-06-15 11:47:57 AM EDT

set -o errexit
set -o nounset
set -o pipefail

REGISTRY="quay.io"
REPO="onyiny_ang"
IMAGE="federation-v2"
TAG="proto"

root_dir="$(cd "$(dirname "$0")/.." ; pwd)"
base_dir="${root_dir}/federation-v2/bin"
cd "$base_dir" || {
  echo "Cannot cd to '$base_dir'. Aborting." >&2
  exit 1

}
ls -l
cd ${root_dir}

IMAGE="$REGISTRY/$REPO/$IMAGE:$TAG"
temp_dir="build/temp"

mkdir -p ${temp_dir}
echo "Copy apiserver"
cp ${base_dir}/apiserver ${temp_dir}/apiserver
echo "Copy controller manager"
cp ${base_dir}/controller-manager ${temp_dir}/controller-manager
echo "Building Federation-v2 docker image"
docker build  .
echo "Pushing build to container registry"
docker push ${IMAGE}

"Removing temp file"
rm -rf ${temp_dir}
