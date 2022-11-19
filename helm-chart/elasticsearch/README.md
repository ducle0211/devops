# Elastic Stack Kubernetes Helm Charts

- This chart will install follow example/security

- Create secret to store user, password elasticsearch

```
cd helm-chart/elasticsearch/elasticsearch/examples/security/

make secrets
```

- Add key store with Azure Storage infomation
    - Refer this link: https://songer.pro/elasticsearch-snapshots-with-azure-part-1-setting-up-azure-blob/
    - azure-client-secondary-account: name storage Azure
    - azure-client-secondary-key: key access to storage Azure

```
kubectl create secret generic azure-client-secondary-account --from-literal=azure.client.secondary.account='<name-storage>' -n elastic

kubectl create secret generic azure-client-secondary-key --from-literal=azure.client.secondary.key='<key-storage>' -n elastic
```

- Config values.yaml

```
keystore:
  - secretName: azure-client-secondary-account
  - secretName: azure-client-secondary-key
```

- Config plugin Azure
```
extraVolumes:
  - name: plugins
    emptyDir: {}

extraVolumeMounts:
  - name: plugins
    mountPath: /usr/share/elasticsearch/plugins
    readOnly: false

extraInitContainers:
  - name: install-plugins
    image: docker.elastic.co/elasticsearch/elasticsearch:7.17.3
    imagePullPolicy: IfNotPresent
    command:
    - sh
    - -c
    - |
      bin/elasticsearch-plugin install --batch repository-azure
    volumeMounts:
      - name: plugins
        mountPath: /usr/share/elasticsearch/plugins
```

- Install chart
```
helm install elasticsearch elastic/elasticsearch -f values.yaml -n elastic

```