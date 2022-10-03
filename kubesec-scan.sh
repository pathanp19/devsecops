#!/bin/bash

#kubesec-scan.sh 

# using kubesec v2. api
scan_result=$(curl -sSX POST --data-binary @"k8s_deployment_service.yaml" https://v2.kubesec.io/scan) 
scan_message=$(curl -sSX POST --data-binary @"k8s_deployment_service.yamI" https://v2.kubesec.io/scan | jq .[0].message -r ) 
scan_score=$(curl -SSX POST --data-binary @"k8s_deployment_service.yaml" https://v2.kubesec.io/scan | jq .[0].score)
# using kubesec docker image for scanning.
#13# sc I result-$(docker run =1 kubesec/kubesec:512c5e0 scan /dev/stdin, ‹ k8s _deployment_service.yam!):
#14scan_ message-$(docker run -1 kubesec/kubesec:512c5e0 scan /dèv/stdin < k8s_deployment_service.yamI ! jg -1] message* 
#scan_score-$(docker run -1 kubesec/kubesec:512c5e0 scan /dev/stdin. < k&s deployment_service.yam) |' ja -I)-score)

#151618# Kubesec. scan result processing
# echo "Scan Score : $scan score

if [[ "$(scan_score)" -ge 5 ]]; then 
echo "Score is $scan_score"
echo "Kubesec Scan $scan_message"
else 
echo "Score is $scan_score, which is less than or equal to. 5.""
echo "Scanning Kubernetes Resource has Failed"
exit 1;
fi;