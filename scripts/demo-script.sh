#!/bin/bash
#==========================================================
#  Script name -- demo-script.sh --
# DESCRIPTION:  Federation v2 Demo
#
#
#  Author:  Lindsey Tulloch , ltulloch@redhat.com
#  CREATED:  2018-04-25 03:42:58 PM EDT

set -e

CONTEXT=us-west
CONTEXT2=us-east
NS=test-namespace

printf "\nkubectl -n federation describe federatedclusters\n"
kubectl -n federation describe federatedclusters

read -n 1 -s
printf "\n ll configs\n"
ls -l configs

read -n 1 -s
printf "\n vim configs/federatedreplicaset-template.yaml\n"
vim configs/federatedreplicaset-template.yaml
read -n 1 -s
printf "\n vim configs/federatedreplicaset-placement.yaml\n"
vim configs/federatedreplicaset-placement.yaml
read -n 1 -s
printf "\n vim configs/federatedreplicaset-override.yaml\n"
vim configs/federatedreplicaset-override.yaml
read -n 1 -s

printf "\nkubectl create -f ./configs/\n"
kubectl create -f ./configs/

read -n 1 -s

printf "Namespaces for existing contexts\n"
for i in ${CONTEXT} ${CONTEXT2}; do echo; echo ------------ ${i} ------------; echo; kubectl --context ${i} get ns test-namespace; echo; echo; done
read -n 1 -s
printf "Configmaps for existing contexts\n"
for i in ${CONTEXT} ${CONTEXT2}; do echo; echo ------------ ${i} ------------; echo; kubectl --context ${i} get configmaps; echo; echo; done
printf "Secrets for existing contexts\n"
read -n 1 -s
for i in ${CONTEXT} ${CONTEXT2}; do echo; echo ------------ ${i} ------------; echo; kubectl --context ${i} get secrets; echo; echo; done
printf "Replicasets for existing contexts\n"
read -n 1 -s
for i in ${CONTEXT} ${CONTEXT2}; do echo; echo ------------ ${i} ------------; echo; kubectl --context ${i} get rs; echo; echo; done
read -n 1 -s

kubectl -n ${NS} edit federatednamespaceplacement ${NS}

sleep 5s

printf "\nReplicasets showing deleted us-east\n"
replicas=5
while [ $replicas -eq 5 ]; do
  printf "\n\t***********\n"
  sleep 7s
  replicas=$(kubectl --context us-east -n ${NS} get rs -o json | jq -r '.items[].status.readyReplicas')
  if [ -z "$replicas" ]; then
    replicas=0
  fi
  for i in ${CONTEXT} ${CONTEXT2}; do echo; echo ------------ ${i} ------------; echo; kubectl --context ${i} -n ${NS} get rs; echo; echo; done
done
sleep 7s
read -n 1 -s

kubectl -n ${NS} edit federatednamespaceplacement ${NS}
sleep 7s

printf "\nReplicasets showing us-east restored\n"
while ! [ $replicas -eq 5 ]; do
  printf "\n\t***********\n"
  replicas=$(kubectl --context us-east -n ${NS} get rs -o json | jq -r '.items[].status.readyReplicas')
  if [ -z "$replicas" ]; then
    replicas=0
  fi
  for i in ${CONTEXT} ${CONTEXT2}; do echo; echo ------------ ${i} ------------; echo; kubectl --context ${i} -n ${NS} get rs; echo; echo; done
  sleep 7s
done
printf "\nSuccessfully restored us-east\n"
printf "\nDone.\n"
