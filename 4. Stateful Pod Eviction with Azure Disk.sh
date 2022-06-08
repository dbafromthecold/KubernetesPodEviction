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


# view storage classes
kubectl get storageclass



# create storage for sql server deployment
kubectl apply -f ./yaml/azure-disk/sqlserver-azuredisk-pvc.yaml



# create deployment
kubectl apply -f ./yaml/azure-disk/sqlserver-azuredisk-deployment.yaml



# expose deployment
kubectl expose deployment sqlserver-deployment --port 1433 --target-port 1433 --type LoadBalancer



# confirm storage
kubectl get pvc
kubectl get pv



# confirm deployment
kubectl get all



# view node pod is running on
kubectl get pods -o wide


# grab service external IP address
IpAddress=$(kubectl get service sqlserver-deployment --no-headers -o custom-columns=":status.loadBalancer.ingress[*].ip") && echo $IpAddress



# create a database
mssql-cli -S $IpAddress -U sa -P Testing1122 -Q "CREATE DATABASE [testdatabase]"



# confirm database
mssql-cli -S $IpAddress -U sa -P Testing1122 -Q "SELECT [name] FROM [sys].[databases];"



# switch to new terminal
# get node pod is running on
NODE=$(kubectl get pods -o jsonpath="{.items[0].spec.nodeName}" | sed 's/.$/\U&/')  && echo $NODE


# get vmms name and instance id
VMSSNAME=${NODE:0:27} && echo $VMSSNAME 
INSTANCEID=$(az vmss list-instances --name $VMSSNAME --resource-group $RESOURCEGROUP --query "[?osProfile.computerName=='$NODE'].[instanceId]" -o tsv) && echo $INSTANCEID



# shutdown node in AKS
az vmss deallocate --name $VMSSNAME --instance-ids $INSTANCEID --resource-group $RESOURCEGROUP



# watch nodes
kubectl get nodes --watch



# watch pods
kubectl get pods -o wide --watch



# get new pod
PODNAME=$(kubectl get pods --field-selector=status.phase=Pending -o jsonpath="{.items[0].metadata.name}") && echo $PODNAME



# describe pod
kubectl describe pod $PODNAME



# restart node in AKS
az vmss start --name $VMSSNAME --instance-ids $INSTANCEID --resource-group $RESOURCEGROUP



# watch nodes
kubectl get nodes --watch



# watch pods
kubectl get pods --watch



# confirm database
mssql-cli -S $IpAddress -U sa -P Testing1122 -Q "SELECT [name] FROM [sys].[databases];"



# delete deployment
kubectl delete deployment sqlserver-deployment
kubectl delete pvc sqldata-pvc sqllog-pvc sqlsystem-pvc