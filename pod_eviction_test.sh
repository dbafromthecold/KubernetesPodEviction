############################################################################
############################################################################
#
# Kubernets Pod Eviction - Andrew Pruski
# @dbafromthecold
# dbafromthecold@gmail.com
# https://github.com/dbafromthecold/KubernetesPodEviction
#
############################################################################
############################################################################



# set location
cd /mnt/c/git/dbafromthecold/KubernetesPodEviction && pwd



# log into Azure
az login



# create resource group
az group create --name kubernetes --location EASTUS



# create AKS cluster
az aks create --name kubernetes1 --resource-group kubernetes --node-count 3 --generate-ssh-keys



# get credentials to connect to cluster
az aks get-credentials --name kubernetes1 --resource-group kubernetes



# view AKS nodepool
az aks nodepool list --cluster-name kubernetes1 --resource-group kubernetes -o table



# set resource group
RESOURCEGROUP="MC_kubernetes_kubernetes1_eastus"



# list vmss
# https://docs.microsoft.com/en-us/cli/azure/vmss?view=azure-cli-latest#az-vmss-list
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



# view pods
kubectl get pods -o wide --watch



# switch to new terminal
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



# try connecting to nginx
curl $IpAddress --connect-timeout 5



# restart node in AKS
az vmss start --name $VMSSNAME --instance-ids $INSTANCEID --resource-group $RESOURCEGROUP



# view nodes
kubectl get nodes --watch



# view pods
kubectl get pods -o wide



# try connecting to nginx
curl $IpAddress --connect-timeout 5



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



# portworx setup
# https://docs.portworx.com/portworx-install-with-kubernetes/cloud/azure/aks/1-prepare/
# https://portworx.com/blog/how-to-run-ha-sql-server-on-azure-kubernetes-service/



# confirm storage class
kubectl get storageclass



# confirm portworx pods
kubectl get pods -n=kube-system -l name=portworx



# create storage for sql server deployment
kubectl apply -f ./yaml/portworx/sqlserver-portworx-pvc.yaml



# confirm pvc and pv
kubectl get pvc
kubectl get pv



# create deployment
kubectl apply -f ./yaml/portworx/sqlserver-portworx-deployment.yaml



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



#view pods
kubectl get pods -o wide



# restart node in AKS
az vmss start --name $VMSSNAME --instance-ids $INSTANCEID --resource-group $RESOURCEGROUP