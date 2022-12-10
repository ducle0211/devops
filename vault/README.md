# Setup Vault On AKS

Refer this link: https://samcogan.com/creating-kubernetes-secrets-from-azure-key-vault-with-the-csi-driver/

## Enable vault
az aks enable-addons --addons azure-keyvault-secrets-provider --name `<name-cluster>`--resource-group `<name-group>`


## Create key vault
az keyvault create -n `<name-key-vault>` -g `<name-group>` -l `<location>`


az keyvault secret set --vault-name `<name-key-vault>` -n `<key>` --value "`<value>`"


## Assign role
aksManagedIdentityId=$(az aks show -g `<name-group>` -n `<name-cluster>` --query addonProfiles.azureKeyvaultSecretsProvider.identity.clientId -o tsv)

az keyvault set-policy -n `<name-key-vault>` --key-permissions get --spn $aksManagedIdentityId

az keyvault set-policy -n `<name-key-vault>` --secret-permissions get --spn $aksManagedIdentityId

az keyvault set-policy -n `<name-key-vault>` --certificate-permissions get --spn $aksManagedIdentityId

## Apply
kubectl apply -f provider_class.yaml

kubectl apply -f pod.yaml

## Note
- Secrets are stored at rest in Key Vault, in a secure encrypted store.
- Secrets are only stored in the AKS cluster when a pod is running with the secret mounted. As soon as those pods are removed, the secret is removed from the cluster, rather than with Kubernetes secrets which will be retained after a pod is removed.
- Key Vault remains the source of truth for the secret, so you can update the secret in a single place and roll it out to your clusters.
- You can take advantage of features in Key Vault, such as auto certificate renewal or key rotation.


