- Datadog Cluster Agent when using Azure Kubernetes Service (AKS).
```
https://docs.datadoghq.com/agent/faq/rbac-for-dca-running-on-aks-with-helm/

```

- Add repo and install Datadog. Replace API KEY, APP into values file.
```
helm repo add datadog https://helm.datadoghq.com
helm repo update
```

```
helm install datadog datadog/datadog -f datadog/values.yaml -n datadog --create-namespace
```

```
helm upgrade --install datadog datadog/datadog -f values.yaml -n datadog --create-namespace 
```

```
  networkMonitoring:
    # datadog.networkMonitoring.enabled -- Enable network performance monitoring
    enabled: false
```
