#!/bin/bash

#k8s-deployment-rollout-status.sh

sleep 30s

if [[ $(kubectl -n prod rollout status deploy ${deploymentName} --timeout 5s) != *"successfully rolled out"* ]];
then
echo "Deployment ${deploymentName} Rollout has Failed"
kubectl -n prod rollout undo deploy ${deploymentName}
exit 1;
else
echo "Deployment ${deploymentName} Rollout is success"
fi