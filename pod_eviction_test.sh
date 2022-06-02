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



# https://docs.microsoft.com/en-us/cli/azure/vmss?view=azure-cli-latest#az-vmss-list
# list vmss
az vmss list --resource-group MC_kubernetes_kubernetes1_eastus -o table



# view AKS nodes
kubectl get nodes -o jsonpath="{.items[0].metadata.name}"



# deploy test application
kubectl create deployment test --image=nginx



# view deployment
kubectl get all



# view pods
kubectl get pods -o wide --watch



# switch to new terminal
# shutdown node in AKS
az vmss deallocate --instance-ids 6 --name aks-nodepool1-96936133-vmss --resource-group MC_kubernetes_kubernetes1_eastus



# restart node in AKS
az vmss start --instance-ids 6 --name aks-nodepool1-96936133-vmss --resource-group MC_kubernetes_kubernetes1_eastus



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
# shutdown node in AKS
az vmss deallocate --instance-ids 6 --name aks-nodepool1-96936133-vmss --resource-group MC_kubernetes_kubernetes1_eastus



# restart node in AKS
az vmss start --instance-ids 6 --name aks-nodepool1-96936133-vmss --resource-group MC_kubernetes_kubernetes1_eastus
