# Ingress-nginx



## Troubleshooting

要仔细看日志，看问题在 ingress 还是 upstream。

- `rewrite-target` 导致重定向，结果是 `fastapi` 问题(trailing slash)。 


### 源 IP 丢失
网络拓扑：交换机 ->  (metallb BGP)service -> ingress

使用 `loadBalancer` service 时(且 `.spec.externalTrafficPolicy = cluster`)，kube-proxy(IPVS) 将使用 `IPTABLES` 做 `MASQUERADE` 导致源 IP 丢失，变成节点IP。

```shell
iptables -t nat -nL | grep KUBE-LOAD-BALANCER
ipset list KUBE-LOAD-BALANCER
ipvsadm -ln
```

- https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/
- [NAT](https://arthurchiao.art/blog/nat-zh/)