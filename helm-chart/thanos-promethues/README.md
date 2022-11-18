# Install Prometheus And Thanos To Monitor

- Install Promethues And Expose With LoadBalancer
```
helm upgrade --install prometheus-operator bitnami/kube-prometheus -f prometheus/values.yaml -n monitor --create-namespace
```

- Install Thanos To Collect Metrics Clusters
```
helm upgrade --install thanos bitnami/thanos -f thanos/values.yaml -n monitor
```