#!/bin/bash

#k8s-deployment-rollout-status.sh

sleep 60s

if [[ $(kubectl -n default rollout status deploy ${deploymentName} --timeout 5s) != "deployment ${deploymentName} successfully rolled out" ]];
then
echo "deployment ${deploymentName} Rollout has Failed"
kubectl -n default rollout undo deploy ${deploymentName}
exit 1;
else
echo "Deployment ${deploymentName} Rollout is success"
fi