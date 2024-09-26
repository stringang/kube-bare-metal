#!/usr/bin/env bash

if [ $1 != "" ]; then
  bash $1 &
  pid=$!
  echo $pid
fi

[ -z ${POD_IP+x} ]&&POD_IP=127.0.0.1
[ -z ${APP_NAME+x} ]&&APP_NAME=k8s-prestop

function now { date +"%Y-%m-%dT%H:%M:%S.%3N%:z" | tr -d '\n' ;}
function msg { println "$*" >&2 ;}
function println { printf "[%s] [INFO] [] [com.k8s.prestop] [] [%s] [%s] [] [] [] [] [k8s-prestop: %s] ## ''\n" "$(now)" $POD_IP $APP_NAME "$*" | tee -a ./$APP_NAME/logs/app-k8s-prestop.log ;}

[ -z ${TERMINATION_SECONDS+x} ]&&TERMINATION_SECONDS=30

if [[ "$TERMINATION_SECONDS" =~ ^[0-9]+$ ]]; then
  if [ $TERMINATION_SECONDS -gt 600 ]; then
      msg "ENV->TERMINATION_SECONDS等于${TERMINATION_SECONDS}  大于 600,采用预设值600"
      TERMINATION_SECONDS=600
  elif [ $TERMINATION_SECONDS -lt 30 ]; then
      msg "ENV->TERMINATION_SECONDS等于${TERMINATION_SECONDS}  小于 30,采用预设值30"
      TERMINATION_SECONDS=30
  else
      msg "ENV->TERMINATION_SECONDS等于${TERMINATION_SECONDS}"
  fi
else
  msg "ENV->TERMINATION_SECONDS等于${TERMINATION_SECONDS} 无效，采用默认值30s"
  TERMINATION_SECONDS=30
fi

TERMINATION_SECONDS_STEP1=$(($TERMINATION_SECONDS / 2))

CURL_BUFF_TIME=2
if [ $TERMINATION_SECONDS -gt 60 ]; then
    msg "TERMINATION_SECONDS 计算CURL_BUFF_TIME 大于 60"
    CURL_BUFF_TIME=5
else
    msg "TERMINATION_SECONDS 计算CURL_BUFF_TIME 小于 60"
fi

msg "关键参数       CURL_BUFF_TIME计算为 [${CURL_BUFF_TIME}]"
msg "关键参数 TERMINATION_SECONDS:计算为 [${TERMINATION_SECONDS}]"

result=$(curl -s -S -X GET "http://127.0.0.1:10087/offline" > prestop-response.log 2> prestop-error.log)

if [ $? -eq 0 ]; then
    msg "dubbo offline执行成功"
    POST_B=prestop-response.log
else
    msg "dubbo offline执行失败"
    POST_B=prestop-error.log
fi
msg "输出dubbo offline执行结果result:'$(cat $POST_B)'"
sleep $CURL_BUFF_TIME

zkconn=$(netstat -ano | awk '/2181/ {print $5}' | sort | uniq | awk '{print $1}' | tr "\n" ",")
msg "当前实例中的zk连接信息:${zkconn}"
graceOffline=$(curl -X POST --data-binary "@${POST_B}" -H "Content-Type: application/octet-stream" -H "authorization:$(cat /run/secrets/kubernetes.io/serviceaccount/token)" "http://grace-offline.kube-system:8080/api/v1/$zkconn/offline/$(echo $POD_IP)?workload=$(echo $HOSTNAME)")

msg "输出dubbo k8s-ops offline执行结果result:${graceOffline}"
sleep $CURL_BUFF_TIME

msg "sleep:${TERMINATION_SECONDS_STEP1}，开始等待上游接收通知"
sleep $TERMINATION_SECONDS_STEP1

msg "开始停止进程，剩余时间为$(($TERMINATION_SECONDS - $TERMINATION_SECONDS_STEP1 - $CURL_BUFF_TIME - $CURL_BUFF_TIME))"

kill -15 $(pgrep 'java|dotnet|python|nginx|node')