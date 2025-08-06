#!/usr/bin/env bash
set -a

# make sure you have previously run u10-login.sh to create cookies.txt
# and that you have jq installed

if [ ! -f cookies.txt ]; then
  echo "Error: cookies.txt not found in the current directory."
  exit 1
fi


URL_MF90='http://192.168.0.1/goform/goform_get_cmd_process?isTest=false&multi_data=1&cmd=battery_vol_percent,battery_charging,wifi_coverage,wan_ipaddr,lte_rsrp,network_type,signalbar,monthly_rx_bytes,monthly_time,monthly_tx_bytes,realtime_tx_bytes,realtime_rx_bytes,realtime_time,realtime_tx_thrpt,realtime_rx_thrpt,wifi_chip1_ssid1_access_sta_num,wifi_access_sta_num'
URL_U10='http://192.168.0.1/goform/goform_get_cmd_process?multi_data=1&isTest=false&sms_received_flag_flag=0&sts_received_flag_flag=0&cmd=modem_main_state%2Cpin_status%2Copms_wan_mode%2Copms_wan_auto_mode%2Cloginfo%2Cnew_version_state%2Ccurrent_upgrade_state%2Cis_mandatory%2Cwifi_dfs_status%2Cbattery_value%2Cppp_dial_conn_fail_counter%2Cdhcp_wan_status%2Csignalbar%2Cnetwork_type%2Cnetwork_provider%2Cwifi_lbd_enable%2Cbattery_charg_type%2Cexternal_charging_flag%2Cmode_main_state%2Cbattery_temp%2COperator%2Cbattery_customer_mode%2Cppp_status%2CEX_SSID1%2Csta_ip_status%2CEX_wifi_profile%2Cm_ssid_enable%2CRadioOff%2Cwifi_onoff_state%2Cwifi_chip1_ssid1_ssid%2Cwifi_chip2_ssid1_ssid%2Cwifi_chip1_ssid1_switch_onoff%2Cwifi_chip2_ssid1_switch_onoff%2Cwifi_chip1_ssid1_access_sta_num%2Cwifi_chip2_ssid1_access_sta_num%2Csimcard_roam%2Clan_ipaddr%2Cstation_mac%2Cwifi_access_sta_num%2Cbattery_charging%2Cbattery_vol_percent%2Cbattery_pers%2Cspn_name_data%2Cspn_b1_flag%2Cspn_b2_flag%2Cmdm_mcc%2Cmdm_mnc%2Csim_iccid%2Crealtime_tx_bytes%2Crealtime_rx_bytes%2Crealtime_time%2Crealtime_tx_thrpt%2Crealtime_rx_thrpt%2Cmonthly_rx_bytes%2Cmonthly_tx_bytes%2Cmonthly_time%2Cdate_month%2Cdata_volume_limit_switch%2Cdata_volume_limit_size%2Cdata_volume_alert_percent%2Cdata_volume_limit_unit%2Croam_setting_option%2Cupg_roam_switch%2Cssid%2Cwifi_enable%2Cwifi_5g_enable%2Ccheck_web_conflict%2Cdial_mode%2Cppp_dial_conn_fail_counter%2Cwan_lte_ca%2Cprivacy_read_flag%2Cis_night_mode%2Cpppoe_status%2Cdhcp_wan_status%2Cstatic_wan_status%2Cvpn_conn_status%2Cwan_connect_status%2Csms_received_flag%2Csts_received_flag%2Csms_unread_num%2Cwifi_chip1_ssid2_access_sta_num%2Cwifi_chip2_ssid2_access_sta_num&_=1754482082041'

curl $URL_MF90 -b cookies.txt -c cookies.txt \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'Accept-Language: en-US,en-GB;q=0.9,en;q=0.8,es-ES;q=0.7,es;q=0.6,ca;q=0.5,gl;q=0.4,it;q=0.3' \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Pragma: no-cache' \
  -H 'Referer: http://192.168.0.1/index.html' \
  -H 'Sec-GPC: 1' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36' \
  -H 'X-Requested-With: XMLHttpRequest' \
  --insecure | jq -S

curl $URL_U10 -b cookies.txt -c cookies.txt \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'Accept-Language: en-US,en-GB;q=0.9,en;q=0.8,es-ES;q=0.7,es;q=0.6,ca;q=0.5,gl;q=0.4,it;q=0.3' \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Pragma: no-cache' \
  -H 'Referer: http://192.168.0.1/index.html' \
  -H 'Sec-GPC: 1' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36' \
  -H 'X-Requested-With: XMLHttpRequest' \
  --insecure | jq -S
