/usr/bin/env bash

# ubuntu

# https://mirrors.tuna.tsinghua.edu.cn/help/docker-ce/
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
# Add Docker's official GPG key:
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# https://docs.docker.com/engine/install/ubuntu/#installation-methods
# install latest version
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# List the available versions:
sudo sed -i 's/noble/jammy/g' /etc/apt/sources.list.d/docker.list
sudo apt-get update

# install specific version
apt-cache madison docker-ce | awk '{ print $3 }'
VERSION_STRING=5:20.10.24~3-0~ubuntu-jammy
sudo apt-get install docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-buildx-plugin docker-compose-plugin
jq '."data-root" |= "/data/docker"' /etc/docker/daemon.json | sudo tee /etc/docker/daemon.json
jq '."max-concurrent-downloads" |= 100' /etc/docker/daemon.json | sudo tee /etc/docker/daemon.json
jq '."default-runtime" |= "nvidia"' /etc/docker/daemon.json | sudo tee /etc/docker/daemon.json

systemctl enable docker.service

# nvidia
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl daemon-reload
sudo systemctl restart docker

# disk
echo "run disk setup"
parted /dev/sdb mklabel gpt mkpart primary ext4 0% 100%
echo "parted done"
sleep 15
mkfs.ext4 -q /dev/sdb1
echo "mkfs done"
mkdir -p /data
mount -o defaults /dev/sdb1 /data
echo "mount done"
echo -e "UUID=`ls -l /dev/disk/by-uuid | grep sdb1 | awk '{print $9}'`      /data    ext4    defaults      0 0" >> /etc/fstab
echo "disk setup done"

# install kubernetes
# https://developer.aliyun.com/mirror/kubernetes
sudo apt-get install -y kubeadm=1.22.15-00 kubectl=1.22.15-00 kubelet=1.22.15-00

sudo hostnamectl set-hostname cs-node-10-255-0-160

mkdir -p /etc/kubernetes/ssl
ln -s /etc/kubernetes/ssl pki

# join node
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#join-nodes
kubeadm join
kubeadm reset --force

swapoff -a


copy /etc/cni/net.d/calico.conflist.template