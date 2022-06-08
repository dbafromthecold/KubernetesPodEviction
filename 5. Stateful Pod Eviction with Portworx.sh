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