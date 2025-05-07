# Vagrant



```shell
vagrant box list
# 添加 pre-build VM images
vagrant box add bento/ubuntu-22.04 --box-version 202502.21.0 --provider virtualbox

# 全局设置 Virtualbox
VBoxManage setextradata global "VBoxInternal/Devices/pcbios/0/Config/DebugLevel"
# 停止
vagrant halt
# 启动
vagrant up --provider virtualbox
vagrant reload --provision
# 删除
vagrant destroy -f
# 连接 VM
vagrant ssh
ssh vagrant@localhost -p 2222 # password: vagrant
```

## Reference
- [oracle-base vagrant-a-beginners-guide](https://oracle-base.com/articles/vm/vagrant-a-beginners-guide)