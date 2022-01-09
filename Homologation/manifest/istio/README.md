For generate and apply manifest in cluster use following command

```
$ istioctl manifest generate -f - <<EOF | kubectl apply -f -

apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  name: istio-operator
  namespace: istio-system
spec:
  components:
    ingressGateways:
      - k8s:
          hpaSpec:
            maxReplicas: 3
            minReplicas: 2
        name: istio-ingressgateway
  meshConfig:
    accessLogFile: /dev/stdout
    defaultConfig:
      holdApplicationUntilProxyStarts: true
      tracing:
        sampling: 50
    enableTracing: true
  profile: default
  tag: 1.10.3
  values:
    gateways:
      istio-ingressgateway:
        serviceAnnotations:
          service.beta.kubernetes.io/azure-load-balancer-internal: 'true'
EOF
```

For generate and delete manifest in cluster use following command:

```
$ istioctl manifest generate -f - <<EOF | kubectl delete -f -

apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  name: istio-operator
  namespace: istio-system
spec:
  components:
    ingressGateways:
      - k8s:
          hpaSpec:
            maxReplicas: 3
            minReplicas: 2
        name: istio-ingressgateway
  meshConfig:
    accessLogFile: /dev/stdout
    defaultConfig:
      holdApplicationUntilProxyStarts: true
      tracing:
        sampling: 50
    enableTracing: true
  profile: default
  tag: 1.10.3
  values:
    gateways:
      istio-ingressgateway:
        serviceAnnotations:
          service.beta.kubernetes.io/azure-load-balancer-internal: 'true'
EOF
```