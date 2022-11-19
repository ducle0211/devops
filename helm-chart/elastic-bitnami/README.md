# Artifacthub
https://artifacthub.io/packages/helm/bitnami/kibana?modal=values

https://artifacthub.io/packages/helm/bitnami/elasticsearch


## Install Elasticsearch Bitnami
```
helm install elasticsearch bitnami/elasticsearch -f values.yaml -n backend 

helm upgrade elasticsearch bitnami/elasticsearch -f values.yaml -n backend 
```



## Install Kibana Bitnami

```
helm install kibana bitnami/kibana -f kibana.yml -n backend

helm upgrade kibana bitnami/kibana -f kibana.yml -n backend

```
