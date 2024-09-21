# Ingress-nginx



## Troubleshooting

要仔细看日志，看问题在 ingress 还是 upstream。

- `rewrite-target` 导致重定向，结果是 `fastapi` 问题(trailing slash)。 

