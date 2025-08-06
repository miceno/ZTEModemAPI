#!/usr/bin/env bash

set -a

if [ -z "$1" ]; then
  echo "Usage: $0 <password>"
  exit 1
fi
PASSWORD="$1"

LD=$(curl -s 'http://192.168.0.1/goform/goform_get_cmd_process?isTest=false&cmd=LD&_=1754492963415' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'Accept-Language: en-US,en-GB;q=0.9,en;q=0.8,es-ES;q=0.7,es;q=0.6,ca;q=0.5,gl;q=0.4,it;q=0.3' \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Pragma: no-cache' \
  -H 'Referer: http://192.168.0.1/index.html' \
  -H 'Sec-GPC: 1' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36' \
  -H 'X-Requested-With: XMLHttpRequest' \
  --insecure \
  | jq -r '.LD')

echo $LD
HASH=$(echo -n $(echo -n $PASSWORD | sha256 | tr a-z A-Z)"$LD" | sha256 | tr a-z A-Z)

curl -v -b cookies.txt -c cookies.txt 'http://192.168.0.1/goform/goform_set_cmd_process' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'Accept-Language: en-US,en-GB;q=0.9,en;q=0.8,es-ES;q=0.7,es;q=0.6,ca;q=0.5,gl;q=0.4,it;q=0.3' \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
  -H 'Origin: http://192.168.0.1' \
  -H 'Pragma: no-cache' \
  -H 'Referer: http://192.168.0.1/index.html' \
  -H 'Sec-GPC: 1' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36' \
  -H 'X-Requested-With: XMLHttpRequest' \
  --data-raw 'isTest=false&goformId=LOGIN&password='$(echo -n $HASH) \
  --insecure

