#!/bin/bash

# tg发送信息
function send_tg() {
 token=''
 chat_id=''

 curl "https://api.telegram.org/bot${token}/sendMessage" \
 -H 'Content-Type: application/json' \
 -d '{
	"chat_id": "'$chat_id'",
	"text": "'$1'",
	"parse_mode": "HTML",
	"disable_web_page_preview": True
	
 }'
}

# line发送信息
function send_line() {
 token=''
 
 curl -X POST "https://notify-api.line.me/api/notify" \
 -H "Authorization: Bearer $token" \
 -F "message=$1"
}
