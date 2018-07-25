#!/bin/bash
#==========================================================
#  Script name -- openshift-udpate.sh --
# DESCRIPTION:  Federation v2 Demo
#
#
#  Author:  Lindsey Tulloch , ltulloch@redhat.com
#  CREATED:  2018-04-25 03:42:58 PM EDT

set -e

CONTEXT=us-east
CONTEXT2=eu-central
CONTEXT3=ap-north
NS=test-namespace



printf "\n Create test-namespace namespace in the federation\n"
read -n 1 -s
printf "\n Federated namespace template file\n"
read -n 1 -s
vim scripts/update-configs/federatednamespace-template.yaml
printf "\n Federated namespace placement file\n"
read -n 1 -s
vim scripts/update-configs/federatednamespace-placement.yaml

for filename in ./scripts/update-configs/federatednamespace*.yaml; do
  kubectl create -f "${filename}"
done

printf "\n Create nginx deployment in the federation\n"
read -n 1 -s
printf "\n Federated deployment template file\n"
read -n 1 -s
vim scripts/update-configs/federateddeployment-template.yaml
printf "\n Federated deployment placement file\n"
read -n 1 -s
vim scripts/update-configs/federateddeployment-placement.yaml
kubectl create -f ./scripts/update-configs/federateddeployment-template.yaml
kubectl create -f ./scripts/update-configs/federateddeployment-placement.yaml

read -n 1 -s

printf "Deployment of nginx for existing contexts\n"
read -n 1 -s
for r in deploy; do
  sleep 2s
    for c in ${CONTEXT} ${CONTEXT2} ${CONTEXT3}; do
        echo; echo ------------ ${c} ------------; echo
        kubectl --context=${c} -n test-namespace get ${r}
        echo; echo
    done
done
read -n 1 -s


printf "\n vim configs/federatedreplicaset-override.yaml\n"
vim scripts/update-configs/federateddeployment-override.yaml
read -n 1 -s

printf "\nkubectl create -f federateddeployment-placement.yaml\n"
kubectl create -f ./scripts/update-configs/federateddeployment-override.yaml
read -n 1 -s

printf "Deployment of nginx for existing contexts\n"
replicas=0
while ! [ $replicas -eq 9 ]; do
  printf "\n\t***********\n"
  replicas=$(kubectl --context eu-central -n ${NS} get rs -o json | jq -r '.items[].status.readyReplicas')
  if [ -z "$replicas" ]; then
    replicas=0
  fi
  for r in deploy; do
    for c in ${CONTEXT} ${CONTEXT2} ${CONTEXT3}; do
        echo; echo ------------ ${c} ------------; echo
        kubectl --context=${c} -n test-namespace get ${r}
        echo; echo
    done
  done
  sleep 5s
done
read -n 1 -s

kubectl -n ${NS} edit federatednamespaceplacement ${NS}

sleep 5s

printf "\nDeployments showing deleted eu-central\n"
replicas=9
while [ $replicas -eq 9 ]; do
  printf "\n\t***********\n"
  replicas=$(kubectl --context eu-central -n ${NS} get rs -o json | jq -r '.items[].status.readyReplicas')
  if [ -z "$replicas" ]; then
    replicas=0
  fi
  for r in deploy; do
    for c in ${CONTEXT} ${CONTEXT2} ${CONTEXT3}; do
        echo; echo ------------ ${c} ------------; echo
        kubectl --context=${c} -n test-namespace get ${r}
        echo; echo
    done
  done
  sleep 7s
done
read -n 1 -s

kubectl -n ${NS} edit federatednamespaceplacement ${NS}
sleep 5s

printf "\nDeployment showing eu-central restored\n"
while ! [ $replicas -eq 9 ]; do
  printf "\n\t***********\n"
  replicas=$(kubectl --context eu-central -n ${NS} get rs -o json | jq -r '.items[].status.readyReplicas')
  if [ -z "$replicas" ]; then
    replicas=0
  fi
  for r in deploy; do
    for c in ${CONTEXT} ${CONTEXT2} ${CONTEXT3}; do
        echo; echo ------------ ${c} ------------; echo
        kubectl --context=${c} -n test-namespace get ${r}
        echo; echo
    done
  done
  sleep 8s
done
printf "\nSuccessfully restored eu-central\n"
printf "\nDone.\n"
