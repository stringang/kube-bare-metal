#!/usr/bin/env bash

set -e
set -o pipefail
set -u

# 重新生成证书
kubeadm init phase certs apiserver --config /home/kubeadm.yaml

# node 节点使用外部 VIP 连接 api-service
vim /etc/kubernetes/kubelet.conf


# network-bonding
cat > /etc/sysconfig/network-scripts/ifcfg-bond0 << EOF
DEVICE=bond0
TYPE=Bond
BOOTPROTO=none
USERCTL=no
IPADDR=10.255.0.107
NETMASK=255.255.254.0
GATEWAY=10.255.0.1
DNS1=114.114.114.114
BONDING_OPTS="mode=6 miimon=100"
ONBOOT=yes
BONDING_MASTER=yes
EOF

cat > /etc/sysconfig/network-scripts/ifcfg-enp4s0 << EOF
DEVICE=enp4s0
NAME=enp4s0
TYPE=Ethernet
USERCTL=no
ONBOOT=yes
MASTER=bond0
SLAVE=yes
BOOTPROTO=none
EOF
