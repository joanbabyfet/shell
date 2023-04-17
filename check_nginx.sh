#!/bin/bash
# 监控nginx服务与挂掉重启

# 导入文件
. /root/scripts/notify.sh

function send_notify() {
 text=$1
 ret=$(send_tg $text)
 echo "$(date +%Y-%m-%d%n%H:%M:%S) : $ret" >> /root/scripts/check_nginx.log
}

function restart_service() {
 $(systemctl start nginx)
}

# -w 精确匹配, -v 排除grep, 不加会导致进程数量不准确
count=$(ps -ef|grep -w nginx|grep -v grep| grep -v php-fpm|wc -l)

if [ $count -le 1 ]
then
 $(send_notify "檢測到nginx宕機,正嘗試重啟")
 $(restart_service)
 sleep 3

 if [ $(ps -ef|grep -w nginx|grep -v grep| grep -v php-fpm|wc -l) -le 1 ]
 then
  $(send_notify "nginx重启失败,请求人工介入")
 else
  $(send_notify "nginx重启成功,守护进程将持续监控")
 fi
else
  echo "[$(date +%Y-%m-%d%n%H:%M:%S)] nginx运行正常" >> /root/scripts/check_nginx.log
fi



