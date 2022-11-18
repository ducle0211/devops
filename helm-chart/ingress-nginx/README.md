# Note

- Configs for nginx-ingress 
https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/

- Add value into controll.config. Ex:
 ```
  config: 
    use-geoip: "false"
    use-geoip2: "true"
    upstream-keepalive-timeout: 300
    proxy-stream-timeout: 300
    proxy-connect-timeout: 300
    proxy-read-timeout: 300
    proxy-send-timeout: 300
  ```
- Link values origin
https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

helm upgrade --install \
  ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --set controller.service.type=LoadBalancer \
  --create-namespace 
```

```  
helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --values values.yaml
```

