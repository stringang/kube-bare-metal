# kubernetes bare metal

记录 k8s 相关内容

```shell
kube-bare-metal/
|-- components # k8s 相关组件
|   |-- calico
|   |-- containerd
|   |-- ingress-nginx
|   `-- logging
|       |-- audit  # 审计
|       |-- kube-eventer # 事件
|       `-- loggie
|-- examples # 使用示例
|-- mirrors  # 镜像源
|   `-- verdaccio
`-- os      # 系统相关
    |-- debian
    `-- rhel
```