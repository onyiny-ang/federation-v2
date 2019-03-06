#!/bin/bash
#==========================================================
#  -- meetup demo-script.sh --
# DESCRIPTION:  Federation v2 Demo
#

set -e

CONTEXT=eu-central
CONTEXT2=us-east
CONTEXT3=ap-north
NS=test-namespace

printf "\nkubectl -n federation describe federatedclusters\n"
kubectl -n federation-system describe federatedclusters

read -n 1 -s
printf "\n ll config\n"
ls -l configs

read -n 1 -s
printf "\n vim configs/federateddeployment.yaml\n"
vim configs/federateddeployment.yaml
read -n 1 -s

kubectl create -f ./configs/namespace.yaml
printf "\nkubectl create -f ./configs/\n"
kubectl create -f ./configs/federatednamespace.yaml
kubectl create -f ./configs/federatedconfigmap.yaml
kubectl create -f ./configs/federateddeployment.yaml
kubectl create -f ./configs/federatedsecret.yaml

read -n 1 -s

printf "**Namespaces for existing contexts**\n"
for i in ${CONTEXT} ${CONTEXT2} ${CONTEXT3}; do echo; echo ------------ ${i} ------------; echo; kubectl --context ${i} get ns test-namespace; echo; echo; done
read -n 1 -s
printf "**Configmaps for existing contexts**\n"
for i in ${CONTEXT} ${CONTEXT2} ${CONTEXT3}; do echo; echo ------------ ${i} ------------; echo; kubectl --context ${i} --namespace ${NS} get configmaps; echo; echo; done
printf "**Secrets for existing contexts**\n"
read -n 1 -s
for i in ${CONTEXT} ${CONTEXT2} ${CONTEXT3}; do echo; echo ------------ ${i} ------------; echo; kubectl --context ${i} --namespace ${NS} get secrets; echo; echo; done
printf "**Deployments for existing contexts**\n"
read -n 1 -s
for i in ${CONTEXT} ${CONTEXT2} ${CONTEXT3}; do echo; echo ------------ ${i} ------------; echo; kubectl --context ${i}  --namespace ${NS} get deployments; echo; echo; done
read -n 1 -s

sleep 5s
read -n 1 -s
kubectl -n ${NS} edit federateddeployment
kubectl -n ${NS} edit federatednamespace ${NS}

sleep 5s

printf "\n**Replicasets showing deleted us-east**\n"
replicas=5
while [ $replicas -eq 5 ]; do
  printf "\n\t***********\n"
  sleep 7s
  replicas=$(kubectl --context us-east -n ${NS} get deployments -o json | jq -r '.items[].status.readyReplicas')
  if [ -z "$replicas" ]; then
    replicas=0
  fi
  for i in ${CONTEXT} ${CONTEXT2} ${CONTEXT3}; do echo; echo ------------ ${i} ------------; echo; kubectl --context ${i} -n ${NS} get deployments; echo; echo; done
done
sleep 7s
read -n 1 -s

printf "**Namespaces for existing contexts**\n"
for i in ${CONTEXT} ${CONTEXT2} ${CONTEXT3}; do echo; echo ------------ ${i} ------------; echo; kubectl --context ${i} get ns test-namespace; echo; echo; done
read -n 1 -s
printf "**Configmaps for existing contexts**\n"
read -n 1 -s
for i in ${CONTEXT} ${CONTEXT2} ${CONTEXT3}; do echo; echo ------------ ${i} ------------; echo; kubectl --context ${i} --namespace ${NS} get configmaps; echo; echo; done
read -n 1 -s
printf "**Deployments for existing contexts**\n"
read -n 1 -s
for i in ${CONTEXT} ${CONTEXT2} ${CONTEXT3}; do echo; echo ------------ ${i} ------------; echo; kubectl --context ${i}  --namespace ${NS} get deployments; echo; echo; done
read -n 1 -s


kubectl -n ${NS} edit federatednamespace ${NS}
kubectl -n ${NS} edit federateddeployment
sleep 7s

printf "\n**Deployments showing us-east restored**\n"
while ! [ $replicas -eq 3 ]; do
  printf "\n\t***********\n"
  replicas=$(kubectl --context us-east -n ${NS} get deployments -o json | jq -r '.items[].status.readyReplicas')
  if [ -z "$replicas" ]; then
    replicas=0
  fi
  for i in ${CONTEXT} ${CONTEXT2} ${CONTEXT3}; do echo; echo ------------ ${i} ------------; echo; kubectl --context ${i} -n ${NS} get rs; echo; echo; done
  sleep 7s
done
printf "**Namespaces for existing contexts**\n"
for i in ${CONTEXT} ${CONTEXT2} ${CONTEXT3}; do echo; echo ------------ ${i} ------------; echo; kubectl --context ${i} get ns test-namespace; echo; echo; done
read -n 1 -s
printf "**Configmaps for existing contexts**\n"
read -n 1 -s
for i in ${CONTEXT} ${CONTEXT2} ${CONTEXT3}; do echo; echo ------------ ${i} ------------; echo; kubectl --context ${i} --namespace ${NS} get configmaps; echo; echo; done
read -n 1 -s
printf "**Deployments for existing contexts**\n"
read -n 1 -s
for i in ${CONTEXT} ${CONTEXT2} ${CONTEXT3}; do echo; echo ------------ ${i} ------------; echo; kubectl --context ${i}  --namespace ${NS} get deployments; echo; echo; done
read -n 1 -s


printf "\nSuccessfully restored us-east\n"
printf "\nDone.\n"
printf "\n\nWaiting to trigger deletion.\n"

read -n 1 -s

kubectl delete ns test-namespace

