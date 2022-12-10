# TERRAFORM

- Edit storage_account_name, container_name, access_key in provider.tf

- Initialize a working directory containing Terraform configuration files

```
terraform init
```

- Check validates the configuration files in a directory

```
terraform validate
```

- Preview the changes that Terraform plans to make to your infrastructure
```
terraform plan
```

- Apply terraform

```
terraform apply
```

## Note
storage.tf: deploy resource group, storage enable static web, upload resource to container 'web' and assign role user to storage
akf.tf: deploy AKS cluster
cdn.tf: deploy CDN profile and endpoint match with storage 
backend
web-pubsub.tf: deploy webpubsub