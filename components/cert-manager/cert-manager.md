# cert-manager



## Caveats

- 需要配置时区，否则生成证书时间会是本地时间，导致证书有效期与当前时间不一致(tls 证书中 Validity 信息)，导致连接失败。错误信息：`remote error: tls: bad certificate`

## Troubleshooting

- 查询 `Issuer`、`Certificate` 资源状态
