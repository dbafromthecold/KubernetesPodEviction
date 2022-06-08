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



# expose deployment
kubectl expose deployment sqlserver-deployment --port 1433 --target-port 1433 --type LoadBalancer



# confirm deployment
kubectl get all



# confirm pod
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



# view pods
kubectl get pods -o wide --watch



# confirm pod
kubectl get pods -o wide



# get new pod
PODNAME=$(kubectl get pods -o jsonpath='{.items[0].metadata.name}') && echo $PODNAME



# describe pod
kubectl describe pod $PODNAME



# restart node in AKS in other terminal
az vmss start --name $VMSSNAME --instance-ids $INSTANCEID --resource-group $RESOURCEGROUP



# watch nodes
kubectl get nodes --watch



# confirm pods
kubectl get pods -o wide



# confirm database
mssql-cli -S $IpAddress -U sa -P Testing1122 -Q "SELECT [name] FROM [sys].[databases];"



# clean up
kubectl delete deployment sqlserver-deployment
kubectl delete pvc sqldata-pvc sqllog-pvc sqlsystem-pvc