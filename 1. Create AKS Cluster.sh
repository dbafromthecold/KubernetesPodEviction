############################################################################
############################################################################
#
# Kubernets Pod Eviction - Create AKS Cluster - Andrew Pruski
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



# test connecting to cluster
kubectl get nodes