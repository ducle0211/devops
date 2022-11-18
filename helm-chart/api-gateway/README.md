# Install 

- Add repo chart
```
helm repo add apisix https://charts.apiseven.com
helm repo update
```

- Install
```
helm install [RELEASE_NAME] apisix/apisix --namespace ingress-apisix --create-namespace

```

- Uninstall 

```
helm uninstall [RELEASE_NAME] --namespace ingress-apisix

```

