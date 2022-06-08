############################################################################
############################################################################
#
# Kubernets Pod Eviction - Stateful Pod Eviction with Azure Disk - Andrew Pruski
# @dbafromthecold
# dbafromthecold@gmail.com
# https://github.com/dbafromthecold/KubernetesPodEviction
#
############################################################################
############################################################################



# set location
cd /mnt/c/git/dbafromthecold/KubernetesPodEviction && pwd



# create storage for sql server deployment
kubectl apply -f ./yaml/azure-disk/sqlserver-azuredisk-pvc.yaml



# create deployment
kubectl apply -f ./yaml/azure-disk/sqlserver-azuredisk-deployment.yaml



# confirm storage
kubectl get pvc
kubectl get pv



# confirm deployment
kubectl get all



# get node pod is running on
kubectl get pods -o wide



# switch to other terminal
# get node pod is running on
NODE=$(kubectl get pods -o jsonpath="{.items[0].spec.nodeName}") && echo $NODE



# get vmms name and instance id
VMSSNAME=${NODE:0:27} && echo $VMSSNAME 
INSTANCEID=$(echo ${NODE:27} | sed 's/0*//') && echo $INSTANCEID



# shutdown node in AKS
az vmss deallocate --name $VMSSNAME --instance-ids $INSTANCEID --resource-group $RESOURCEGROUP



# watch pods
kubectl get pods -o wide --watch



# restart node in AKS
az vmss start --name $VMSSNAME --instance-ids $INSTANCEID --resource-group $RESOURCEGROUP



# delete deployment
kubectl delete deployment sqlserver
kubectl delete pvc sqldata-pvc sqllog-pvc sqlsystem-pvc