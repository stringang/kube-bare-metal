/usr/bin/env bash

# kubeadm

containerd config default > /etc/containerd/config.toml

# pin sandbox(pause) image

# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd
# /var/lib/kubelet/kubeadm-flags.env
KUBELET_KUBEADM_ARGS="--network-plugin=cni --pod-infra-container-image=harbor.xxxxx.cn/google_containers/pause:3.5 --container-runtime=remote --container-runtime-endpoint=/run/containerd/containerd.sock --image-gc-high-threshold=40 --image-gc-low-threshold=20"