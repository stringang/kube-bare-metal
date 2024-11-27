# Skopeo


```shell
# 登录
skopeo login harbor.xxxx.cn -u test -p xxxx
# 将镜像复制到内网 registry
skopeo copy --insecure-policy --override-os linux --override-arch amd64 docker://docker.io/busybox:stable-glibc docker://harbor.xxxx.cn/library/busybox:stable-glibc

# https://github.com/containers/skopeo/issues/1586#issuecomment-1060736427
skopeo inspect --raw docker://docker.io/busybox:stable-glibc | jq

skopeo --override-os linux --override-arch amd64 docker://docker.io/busybox:stable-glibc

skopeo copy --insecure-policy docker://docker.io/busybox:stable-glibc@sha256:1f3c4ec00c804f65805bd22b358c8fbba6b0ab4e32171adba33058cf635923aa docker://harbor.xxxx.cn/library/busybox:stable-glibc
skopeo copy docker-daemon:sha256:698668 docker://xxxx --insecure-policy --override-os linux --override-arch amd64
```

## Reference

[镜像搬运工 skopeo](https://blog.k8s.li/skopeo.html)

