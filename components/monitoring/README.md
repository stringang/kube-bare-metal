# Monitoring

## logging
日志包括：
- 审计日志
- 事件
- 应用日志
- 组件日志(k8s组件，自定义组件)

### Audit log

`kube-audit-rest` 项目是使用 validating webhook 记录操作行为。

#### 存在的问题
1. controller 更新 configmap 请求太多(例如：ingress-nginx-controller)
2. 请求体太大输出 stdout 导致 containerd 封装成 2 行日志
3. 嵌套对象太多/以及包含 `.` 属性，[使用 `enabled: false` 来禁止 ES 映射](https://stackoverflow.com/a/45750679/5204695)

##### 华为云 prometheus-operator:v0.53.1 总是更新 service, secret
原因是华为云 kube-system resource-tenant-temp-aksk secret 总是被更新导致 operator 发生 reconcile loop，由于排除了 kube-system 审计日志只看到了 monitoring 空间的改变。

查看源码，增加日志定位问题
```
curl 10.0.0.1:8080/metrics | grep prometheus_operator_reconcile_operations_total
```

### Ingress access log

配置 Ingress 日志格式：
```
log-format-escape-json: 'true'
log-format-upstream: '{"time": "$time_iso8601", "service_name": "$namespace.$service_name", "remote_addr": "$remote_addr", "remote_port": "$remote_port", "server_addr": "$server_addr", "server_port": "$server_port", "http_x_forwarded_for": "$proxy_add_x_forwarded_for", "request_id": "$req_id", "bytes_sent": $bytes_sent, "request_time": $request_time, "status": $status, "host": "$host", "server_protocol": "$server_protocol", "uri": "$uri", "request_query": "$args", "request_length": $request_length, "request_time": $request_time,"request_method": "$request_method", "http_referer": "$http_referer", "http_user_agent": "$http_user_agent", "upstream_addr": "$upstream_addr", "upstream_response_time": "$upstream_response_time", "upstream_status": "$upstream_status", "server_protocol": "$server_protocol", "scheme": "$scheme"}'
```

### ES

- es 创建 index template 和 index lifecycle policy
- kibana 创建 index pattern（注意配置 time filter 字段）
- 数据写入 es 需要有 time filter 字段信息，否则 kibana index pattern 无法匹配