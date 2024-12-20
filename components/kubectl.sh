# 获取挂载存储 Pod
kubectl get pods --all-namespaces -o=json | jq -r '.items[] | {name: .metadata.name, namespace: .metadata.namespace, claimName: .spec | select(has("volumes")).volumes[]? | select(has("persistentVolumeClaim")).persistentVolumeClaim.claimName} | select(.claimName != null) | [.namespace, .name, .claimName] | @csv | gsub("\""; "")'
# 获取 Pod 对应的 containerID
kubectl get pod -o jsonpath='{.status.containerStatuses[].containerID}'

# 查看 NAT 并根据 sourceIP 排序
conntrack -L | awk '{print $6}' | uniq -c | sort -nr

# 更新 secret
TLS_CRT=$(kubectl get secrets -n nginx-demo xxx -o jsonpath="{.data.tls\.crt}")
TLS_KEY=$(kubectl get secrets -n nginx-demo xxxx -o jsonpath="{.data.tls\.key}")
for namespace in $(kubectl get secrets -A | grep xxx | awk '{print $1}'); do kubectl patch secret xxx -n $namespace -p "{\"data\":{\"tls.crt\":\"$TLS_CRT\",\"tls.key\":\"$TLS_KEY\"}}" --dry-run=client; done