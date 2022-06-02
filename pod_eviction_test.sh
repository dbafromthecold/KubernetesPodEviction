


az login



az group create --name kubernetes --location EASTUS



az aks create --name kubernetes1 --resource-group kubernetes --node-count 3 --generate-ssh-keys



az aks get-credentials --name kubernetes1 --resource-group kubernetes



az aks nodepool list --cluster-name kubernetes1 --resource-group kubernetes



# https://docs.microsoft.com/en-us/cli/azure/vmss?view=azure-cli-latest#az-vmss-list
az vmss list --resource-group MC_kubernetes_kubernetes1_eastus
az vmss deallocate --instance-ids 6 --name aks-nodepool1-96936133-vmss --resource-group MC_kubernetes_kubernetes1_eastus
az vmss start --instance-ids 6 --name aks-nodepool1-96936133-vmss --resource-group MC_kubernetes_kubernetes1_eastus



kubectl get nodes



kubectl create deployment test --image=nginx



kubectl get all



kubectl get pods -o wide --watch



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



