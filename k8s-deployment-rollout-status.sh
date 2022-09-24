#!/bin/bash

#k8s-deployment-rollout-status.sh

sleep 10s

if [[ $(kubectl -n default rollout status deploy ${deploymentName} --timeout 5s) == "deployment "devsecops" successfully rolled out" ]];
then
echo "Deployment ${deploymentName} Rollout is success"
else
echo "deployment ${deploymentName} Rollout has Failed"
kubectl -n default rollout undo deploy ${deploymentName}
exit 1;
fi