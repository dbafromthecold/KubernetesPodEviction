############################################################################
############################################################################
#
# Kubernets Pod Eviction - Non-stateful pod eviction with tolerations -Andrew Pruski
# @dbafromthecold
# dbafromthecold@gmail.com
# https://github.com/dbafromthecold/KubernetesPodEviction
#
############################################################################
############################################################################



# set location
cd /mnt/c/git/dbafromthecold/KubernetesPodEviction && pwd



# view deployment
kubectl get all




# edit deployment adding in tolerations
kubectl edit deployment test



      tolerations:
      - key: "node.kubernetes.io/unreachable"
        operator: "Exists"
        effect: "NoExecute"
        tolerationSeconds: 10
      - key: "node.kubernetes.io/not-ready"
        operator: "Exists"
        effect: "NoExecute"
        tolerationSeconds: 10



# switch to other terminal
# get node pod is running on
NODE=$(kubectl get pods -o jsonpath="{.items[0].spec.nodeName}") && echo $NODE



# get vmms name and instance id
VMSSNAME=${NODE:0:27} && echo $VMSSNAME 
INSTANCEID=$(echo ${NODE:27} | sed 's/0*//') && echo $INSTANCEID



# shutdown node in AKS
az vmss deallocate --name $VMSSNAME --instance-ids $INSTANCEID --resource-group $RESOURCEGROUP



# view nodes
kubectl get nodes



# view pods
kubectl get pods -o wide



# restart node in AKS
az vmss start --name $VMSSNAME --instance-ids $INSTANCEID --resource-group $RESOURCEGROUP



# view nodes
kubectl get nodes



# view pods
kubectl get pods -o wide



# delete deployment
kubectl delete deployment test