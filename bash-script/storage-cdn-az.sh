#!/bin/bash

# Create a file and write name storage in this file
file="storage.txt"
lines=$(cat $file)

for i in $lines
do 
    az storage account create --name <name>$i --resource-group <resource-group> --access-tier Hot --default-action Allow --encryption-services {blob,file,queue,table} --https-only true --location eastasia --kind StorageV2 --min-tls-version TLS1_2 --public-network-access Enabled --allow-shared-key-access true --routing-choice InternetRouting --sku Standard_RAGRS
    az storage blob service-properties update --account-name <name>$i --static-website --index-document index.html
    az cdn endpoint create --resource-group <resource-group> --name <name>-$i --profile-name gamify-cdn-<name> --origin <name>$i.<domain-storage-azure> --origin-host-header <name>$i.<domain-storage-azure> --no-http true --enable-compression true --location Global --query-string-caching-behavior IgnoreQueryString
    az cdn endpoint rule add -g <resource-group> -n <name>-$i --profile-name gamify-cdn-<name> --order 1 --rule-name "redirect" --match-variable RequestScheme --operator Equal --match-values HTTP --action-name "UrlRedirect" --redirect-protocol Https --redirect-type Moved
    sleep 15
done