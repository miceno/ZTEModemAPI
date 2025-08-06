# ZTE Modem API by [An1by](https://aniby.net)
This is Python API-Library for managing ZTE USB-modems.
## Requirements

Use python 3.10.

There is a `requirements.txt` file, you may install them in a custom virtualenv, like this:
```
virtualenv ~/venv/zte
source ~/venv/zte/bin/activate
pip install -r requirements.txt
```

## Authentication

### MF79U
On ZTE MF79U, authentication is very easy, you only needd to provide the password as a base64 encoded string, and make sure you also URL encode it.

To generate the base64 of the password using shell, you can use:
```bash
echo -n 'admin' | base64
YWRtaW4=
```
Use `-n` to avoid adding a newline character at the end of the string.

The default password is `admin`, so you can use the following shell commands:
```bash
echo -n 'admin' | base64 | sed 's/+/ /g;s/=/%3D/g;s/\//%2F/g'
YWRtaW4%3D
```

### U10

On ZTE U10, authentication is a bit more complex, you need to get a seed from the modem, using command `LD`, using a request like this:
```javascript
fetch("http://192.168.0.1/goform/goform_get_cmd_process?isTest=false&cmd=LD", {
  "headers": {
    "accept": "application/json, text/javascript, */*; q=0.01",
    "accept-language": "en-US,en-GB;q=0.9,en;q=0.8,es-ES;q=0.7,es;q=0.6,ca;q=0.5,gl;q=0.4,it;q=0.3",
    "cache-control": "no-cache",
    "pragma": "no-cache",
    "sec-gpc": "1",
    "x-requested-with": "XMLHttpRequest"
  },
  "referrer": "http://192.168.0.1/index.html",
  "body": null,
  "method": "GET",
  "mode": "cors",
  "credentials": "omit"
});
```
The response changes after every successful login, so you need to get it every time you want to login.

The response is a json object with a `LD` field, which is a 64-byte hexadecimal string. You can use this seed to generate the password.
```json
{
  "LD": "59A5445F4DA1B9F2D93E02A444A21FB81F3829EAA74BBE1A39EDAF80C57E919D"
}
```

This seed is used to encode the password, using SHA256 algorithm.

The password is encoded using the following formula:
```javascript
base64(
    sha256(
        sha256(password) + LD
    )
)
```

You can reproduce it using shell commands like this:
```bash
echo -n $(echo -n $PASSWORD | sha256 | tr a-z A-Z)"$LD" | sha256 | tr a-z A-Z
```

Then a request to the login endpoint is made, like this:
```javascript
fetch("https://192.168.0.1/goform/goform_set_cmd_process", {
  "headers": {
    "accept": "application/json, text/javascript, */*; q=0.01",
    "accept-language": "en-US,en-GB;q=0.9,en;q=0.8,es-ES;q=0.7,es;q=0.6,ca;q=0.5,gl;q=0.4,it;q=0.3",
    "cache-control": "no-cache",
    "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
    "pragma": "no-cache",
    "sec-ch-ua": "\"Not)A;Brand\";v=\"8\", \"Chromium\";v=\"138\", \"Brave\";v=\"138\"",
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "\"macOS\"",
    "sec-fetch-dest": "empty",
    "sec-fetch-mode": "cors",
    "sec-fetch-site": "same-origin",
    "sec-gpc": "1",
    "x-requested-with": "XMLHttpRequest"
  },
  "referrer": "https://192.168.0.1/index.html",
  "body": "isTest=false&goformId=LOGIN&password=XXXXXXX",
  "method": "POST",
  "mode": "cors",
  "credentials": "include"
});
```

The response to this endpoint will include a set of cookies, which you can use to authenticate future requests.

```yaml
Set-Cookie: stok=49F2F525EC4DEBE9E3F8DFE47609621264BDA8BAB6E8F7A70A2E0145E0A46D9E;path=/;HttpOnly=1;Expires=Mon, 1 Jan 2050 00:00:00 GMT
```

Request like this:
```commandline
curl 'http://192.168.0.1/goform/goform_get_cmd_process?multi_data=1&isTest=false&sms_received_flag_flag=0&sts_received_flag_flag=0&cmd=modem_main_state%2Cpin_status%2Copms_wan_mode%2Copms_wan_auto_mode%2Cloginfo%2Cnew_version_state%2Ccurrent_upgrade_state%2Cis_mandatory%2Cwifi_dfs_status%2Cbattery_value%2Cppp_dial_conn_fail_counter%2Cdhcp_wan_status%2Csignalbar%2Cnetwork_type%2Cnetwork_provider%2Cwifi_lbd_enable%2Cbattery_charg_type%2Cexternal_charging_flag%2Cmode_main_state%2Cbattery_temp%2COperator%2Cbattery_customer_mode%2Cppp_status%2CEX_SSID1%2Csta_ip_status%2CEX_wifi_profile%2Cm_ssid_enable%2CRadioOff%2Cwifi_onoff_state%2Cwifi_chip1_ssid1_ssid%2Cwifi_chip2_ssid1_ssid%2Cwifi_chip1_ssid1_switch_onoff%2Cwifi_chip2_ssid1_switch_onoff%2Cwifi_chip1_ssid1_access_sta_num%2Cwifi_chip2_ssid1_access_sta_num%2Csimcard_roam%2Clan_ipaddr%2Cstation_mac%2Cwifi_access_sta_num%2Cbattery_charging%2Cbattery_vol_percent%2Cbattery_pers%2Cspn_name_data%2Cspn_b1_flag%2Cspn_b2_flag%2Cmdm_mcc%2Cmdm_mnc%2Csim_iccid%2Crealtime_tx_bytes%2Crealtime_rx_bytes%2Crealtime_time%2Crealtime_tx_thrpt%2Crealtime_rx_thrpt%2Cmonthly_rx_bytes%2Cmonthly_tx_bytes%2Cmonthly_time%2Cdate_month%2Cdata_volume_limit_switch%2Cdata_volume_limit_size%2Cdata_volume_alert_percent%2Cdata_volume_limit_unit%2Croam_setting_option%2Cupg_roam_switch%2Cssid%2Cwifi_enable%2Cwifi_5g_enable%2Ccheck_web_conflict%2Cdial_mode%2Cppp_dial_conn_fail_counter%2Cwan_lte_ca%2Cprivacy_read_flag%2Cis_night_mode%2Cpppoe_status%2Cdhcp_wan_status%2Cstatic_wan_status%2Cvpn_conn_status%2Cwan_connect_status%2Csms_received_flag%2Csts_received_flag%2Csms_unread_num%2Cwifi_chip1_ssid2_access_sta_num%2Cwifi_chip2_ssid2_access_sta_num&_=1754493682325' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'Accept-Language: en-US,en-GB;q=0.9,en;q=0.8,es-ES;q=0.7,es;q=0.6,ca;q=0.5,gl;q=0.4,it;q=0.3' \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Pragma: no-cache' \
  -H 'Referer: http://192.168.0.1/index.html' \
  -H 'Sec-GPC: 1' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36' \
  -H 'X-Requested-With: XMLHttpRequest' \
  --insecure
  -b 'stok=DD2650E6AA340EC5318572A136BE810D341BDB2A4E472EB1C12AB03C1749B31B' \
```

### Configure firewall

Activate Port Mapping:
```commandline
curl 'http://192.168.0.1/goform/goform_set_cmd_process' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'Accept-Language: en-US,en-GB;q=0.9,en;q=0.8,es-ES;q=0.7,es;q=0.6,ca;q=0.5,gl;q=0.4,it;q=0.3' \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
  -b 'stok=B81CAF02F145D885DE6EFB5995BE88AED6A83F0019A74FABB49681740052428F' \
  -H 'Origin: http://192.168.0.1' \
  -H 'Pragma: no-cache' \
  -H 'Referer: http://192.168.0.1/index.html' \
  -H 'Sec-GPC: 1' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36' \
  -H 'X-Requested-With: XMLHttpRequest' \
  --data-raw 'isTest=false&goformId=ADD_PORT_MAP&portMapEnabled=1&AD=6338FD25A7457048FDB1A52336144AA1FA76B7781C730035B57E208E682CBEEE' \
  --insecure
```

## Tested on:
* ZTE MF79U
#
## Documentation
[Attributes list](./docs/ATTRIBUTES.md)\
[**--get** arguments](./docs/GET_ARGUMENTS.md)
#
## ♥ Special thanks to:
[pmcrwf-mid/ZTE-MF79U-api](https://github.com/pmcrwf-mid/ZTE-MF79U-api) - for list of attributes and request templates.\
[paulo-correia/ZTE_API_and_Hack](https://github.com/paulo-correia/ZTE_API_and_Hack) - for list of Requests.\
[rkarimabadi/ZTE-MF79-usb-modem-Send-SMS](https://github.com/rkarimabadi/ZTE-MF79-usb-modem-Send-SMS) - for useful SMS Request.
