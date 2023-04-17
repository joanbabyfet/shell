#!/bin/bash
# 监控mongo服务与挂掉重启

# 导入文件
. /root/scripts/notify.sh

function send_notify() {
 text=$1
 ret=$(send_tg $text)
 echo "$(date +%Y-%m-%d%n%H:%M:%S) : $ret" >> /root/scripts/check_mongo.log
}

function restart_service() {
 $(systemctl start mongod)
}

# -w 精确匹配, -v 排除grep, 不加会导致进程数量不准确
count=$(ps -ef|grep -w mongod|grep -v grep|wc -l)

if [ $count != 1 ]
then
 $(send_notify "檢測到mongo宕機,正嘗試重啟")
 $(restart_service)
 sleep 3

 if [ $(ps -ef|grep -w mongod|grep -v grep|wc -l) != 1 ]
 then
  $(send_notify "mongo重启失败,请求人工介入")
 else
  $(send_notify "mongo重启成功,守护进程将持续监控")
 fi
else
  echo "[$(date +%Y-%m-%d%n%H:%M:%S)] mongo运行正常" >> /root/scripts/check_mongo.log
fi


