#!/bin/bash

total_fail=$(kube-bench run --targets node --version 1.15 --check 2.2 --json | jq .[].total_fail)

if [[ "$total_fail" -ne 0 ]];
then
echo "CIS benchmark failed kubelet while testing for 4.2.1 4.2.2"
exit 1;
else
echo "CIS benchmark passed kubelet for 4.2.1, and so"
fi;