# SETUP KUMA

## Document
Link: https://kuma.io/policies/

## Install kumactl
```
brew install kumactl
```

## Install and setup on Kubernetes (Helm)
Follow: https://kuma.io/docs/2.0.x/installation/helm/

Add repo
```
helm repo add kuma https://kumahq.github.io/charts
```

Install
```
helm install --create-namespace --namespace kuma-system kuma kuma/kuma
```

Use service
```
kubectl port-forward svc/kuma-control-plane -n kuma-system 5681:5681

```

## Deployment Guide
Refer this link: https://github.com/kumahq/kuma-demo/tree/master/kubernetes

- Install observability: 
```kumactl install observability | kubectl apply -f -```

- Install metrics:
```kumactl install metrics | kubectl apply -f -```

- Install tracing
```kumactl install tracing | kubectl apply -f -```



## Features (https://github.com/kumahq/kuma/blob/master/README.md)

* **Universal Control Plane**: Easy to use, distributed, runs anywhere on both Kubernetes and VM/Bare Metal.
* **Lightweight Data Plane**: Powered by Envoy to process any L4/L7 traffic, with automatic Envoy bootstrapping.
* **Automatic DP Injection**: No code changes required in K8s. Easy YAML specification for VM and Bare Metal deployments.
* **Multi-Mesh**: To setup multiple isolated Meshes in one cluster and one Control Plane, lowering OPs cost.
* **Single and Multi Zone**: To deploy a service mesh that is cross-platform, cross-cloud and cross-cluster.
* **Automatic Discovery & Ingress**: With built-in service discovery and connectivity across single and multi-zones.
* **Global & Remote CPs**: For scalability across deployments with multiple zones, including hybrid VMs + K8s meshes.
* **mTLS**: Automatic mTLS issuing, identity and encryption with optional support for third-party CA.
* **TLS Rotation**: Automatic certificate rotation for all the data planes, with configurable settings.
* **Internal & External Services**: Aggregation of internal services and support for services outside the mesh.
* **Traffic Permissions**: To firewall traffic between the services of a Mesh.
* **Traffic Routing**: With dynamic load-balancing for blue/green, canary, versioning and rollback deployments.
* **Fault Injection**: To harden our systems by injecting controlled artificial faults and observe the behavior.
* **Traffic Logs**: To log all the activity to a third-party service, like Splunk or ELK.
* **Traffic Tracing**: To observe the full trace of the service traffic and determine bottlenecks.
* **Traffic Metrics**: For every Envoy dataplane managed by Kuma with native Prometheus/Grafana support.
* **Retries**: To improve application reliability by automatically retrying requests.
* **Proxy Configuration Templating**: The easiest way to run and configure Envoy with low-level configuration.
* **Gateway Support**: To support any API Gateway or Ingress, like [Kong Gateway](https://github.com/Kong/kong).
* **Healthchecks**: Both active and passive.
* **GUI**: Out of the box browser GUI to explore all the Service Meshes configured in the system.
* **Tagging Selectors**: To apply sophisticated regional, cloud-specific and team-oriented policies.
* **Platform-Agnostic**: Support for Kubernetes, VMs, and bare metal. Including hybrid deployments.
* **Transparent Proxying**: Out of the box transparent proxying on Kubernetes, VMs and any other platform.
* **Network Overlay**: Create a configurable Mesh overlay across different Kubernetes clusters and namespaces.


## Policies (https://kuma.io/docs/2.0.x/policies/introduction/)
* Security (Identity, Encryption and Compliance
)
    * **Mesh**: This resource describes a very important concept in Kuma, and that is the ability of creating multiple isolated service meshes within the same Kuma cluster which in turn make Kuma a very simple and easy project to operate in environments where more than one mesh is required based on security, segmentation or governance requirements.
    * **Mutual (mTLS)**: This policy enables automatic encrypted mTLS traffic for all the services in a Mesh, as well as assigning an identity to every data plane proxy. 
    * **Traffic Permissions**: Traffic Permissions is an inbound policy. Dataplanes whose configuration is modified are in the destinations matcher.


* Traffic Control (Routing, Ingress, Failover
) 
    * **Traffic Routing**: This policy lets you configure routing rules for the traffic in the mesh. It supports weighted routing and can be used to implement versioning across services or to support deployment strategies such as blue/green or canary.
    * **Retries**: This policy enables Kuma to know how to behave if there is a failed scenario (i.e. HTTP request) which could be retried.
    * **Fault Injection**: FaultInjection policy helps you to test your microservices against resiliency. Kuma provides 3 different types of failures that could be imitated in your environment. These faults are Delay, Abort and ResponseBandwidth limit.
    * **Healthchecks**: This policy enables Kuma to keep track of the health of every data plane proxy, with the goal of minimizing the number of failed requests in case a data plane proxy is temporarily unhealthy.
    * **Circuit Breaker**: This policy will look for errors in the live traffic being exchanged between our data plane proxies and it will mark a data proxy as an unhealthy if certain conditions are met and - by doing so - making sure that no additional traffic can reach an unhealthy data plane proxy until it is healthy again.
    * **External Service**: This policy allows services running inside the mesh to consume services that are not part of the mesh.
    * **Timeout**: This policy enables Kuma to set timeouts on the outbound connections depending on the protocol.
    * **Rate Limit**: The RateLimit policy leverages Envoy’s local rate limiting to allow for per-instance service request limiting. All HTTP/HTTP2 based requests are supported.


* Observability (Metrics, Logs and Traces
)
    * **Traffic Logs**: With the Traffic Log policy you can easily set up access logs on every data plane in a mesh.
    * **Traffic Tracing**: This policy enables tracing logging to a third party tracing solution.
    * **Traffic Metrics**: Kuma facilitates consistent traffic metrics across all data plane proxies in your mesh.