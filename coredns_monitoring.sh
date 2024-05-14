#!/bin/bash

# Define coresPerReplica ratio
coresPerReplica=256  # 256 is the coredns recommended value for AS https://github.com/coredns/helm?tab=readme-ov-file#configuration

# Get the number of nodes in the cluster
numNodes=$(kubectl get nodes --no-headers | wc -l)

# Get the total number of cores in the cluster
totalCores=0
for cores in $(kubectl get nodes -o jsonpath='{.items[*].status.capacity.cpu}')
do
  totalCores=$((totalCores + cores))
done

# Calculate the number of CoreDNS replicas based on coresPerReplica ratio
numReplicas=$((totalCores / coresPerReplica))

# Get the current number of CoreDNS replicas
currentReplicas=$(kubectl get deployment coredns -n kube-system -o jsonpath='{.status.replicas}')

echo "Number of nodes: $numNodes"
echo "Total cores: $totalCores"
echo "Current number of CoreDNS replicas: $currentReplicas"
echo "Number of CoreDNS replicas needed: $numReplicas"

# Check if the number of CoreDNS replicas needs to be increased
if [[ $numReplicas -gt $currentReplicas ]]; then
  echo "The number of CoreDNS replicas needs to be increased."
else
  echo "The number of CoreDNS replicas does not need to be increased."
fi
