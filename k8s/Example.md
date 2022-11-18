- Add Secret To Connect Gitlab Registry Gitlab

```
kubectl create secret docker-registry registry-gitlab-com --docker-server=registry.gitlab.com --docker-username=<user> --docker-password=<pass> --docker-email=<user mail>
```