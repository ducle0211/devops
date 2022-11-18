# Installing

```
helm repo add jetstack https://charts.jetstack.io

helm install cert-manager jetstack/cert-manager --values values.custom.yaml -n cert-manager --create-namespace

helm upgrade cert-manager jetstack/cert-manager --values values.custom.yaml -n ingress-basic

kubectl apply -f cluster-issuer.yaml
```
