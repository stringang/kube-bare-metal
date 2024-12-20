# 故障排查

## 部署

- api-service延迟大 ```kubectl get apiservices.apiregistration.k8s.io```
- 节点 kubelet 不要使用内部 VIP 连接 api-server。

## Pod 相关

1. FailedCreatePodSandBox: Failed to create pod sandbox，CNI插件导致（token过期）

## 网络
针对网卡进行抓包-[抓包思路](https://www.hwchiu.com/docs/2021/k8s-tcpdump)



## cloud provider

### 阿里云 clb 注解不生效

[查询 cloud controller manager 日志是证书过期导致](https://help.aliyun.com/zh/ack/ack-managed-and-ack-dedicated/user-guide/add-annotations-to-the-yaml-file-of-a-service-to-configure-clb-instances)。