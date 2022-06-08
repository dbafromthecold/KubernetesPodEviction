############################################################################
############################################################################
#
# Kubernets Pod Eviction - Non-stateful pod eviction - Andrew Pruski
# @dbafromthecold
# dbafromthecold@gmail.com
# https://github.com/dbafromthecold/KubernetesPodEviction
#
############################################################################
############################################################################



# set location
cd /mnt/c/git/dbafromthecold/KubernetesPodEviction && pwd



# set resource group
RESOURCEGROUP="MC_kubernetes_kubernetes1_eastus"



# list vmss
az vmss list --resource-group $RESOURCEGROUP -o table



# view AKS nodes
kubectl get nodes



# deploy test application
kubectl create deployment test --image=nginx



# expose deployment
kubectl expose deployment test --port 80 --target-port 80 --type LoadBalancer



# view deployment
kubectl get all



# grab service external IP
IpAddress=$(kubectl get service test -o custom-columns=":status.loadBalancer.ingress[*].ip") && echo $IpAddress



# confirm connecting to nginx
curl $IpAddress --connect-timeout 5



# view nodes
kubectl get nodes --watch



# switch to new terminal
# get node pod is running on
NODE=$(kubectl get pods -o jsonpath="{.items[0].spec.nodeName}" | sed 's/.$/\U&/')  && echo $NODE


# get vmms name and instance id
VMSSNAME=${NODE:0:27} && echo $VMSSNAME 
INSTANCEID=$(az vmss list-instances --name $VMSSNAME --resource-group $RESOURCEGROUP --query "[?osProfile.computerName=='$NODE'].[instanceId]" -o tsv) && echo $INSTANCEID



# shutdown node in AKS
az vmss deallocate --name $VMSSNAME --instance-ids $INSTANCEID --resource-group $RESOURCEGROUP



# view nodes
kubectl get nodes



# view pods
kubectl get pods -o wide



# try connecting to nginx
curl $IpAddress --connect-timeout 5



# watch pods
kubectl get pods -o wide --watch



# restart node in AKS
az vmss start --name $VMSSNAME --instance-ids $INSTANCEID --resource-group $RESOURCEGROUP



# view nodes
kubectl get nodes --watch



# view pods
kubectl get pods -o wide



# try connecting to nginx
curl $IpAddress --connect-timeout 5