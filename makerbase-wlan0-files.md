---
title: makerbase-wlan0.service files
layout: page
parent: Modifications by Sovol
---
# makerbase-wlan0.service files
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## /usr/lib/systemd/system/makerbase-wlan0.service
```
[Unit]
Description=Makerbasi mkspi WPA supplicant daemon
BindsTo=sys-subsystem-net-devices-wlan0.device
Before=network.target
Wants=network.target

[Service]
Type=simple
ExecStart=/sbin/wpa_supplicant -c/etc/wpa_supplicant/wpa_supplicant-wlan0.conf -Dnl80211,wext -iwlan0

[Install]
Alias=multi-user.target.wants/makerbase-wlan0.service
```

## /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
```
ctrl_interface=DIR=/run/wpa_supplicant GROUP=netdev
update_config=1

network={
        ssid="MAKERBASE3D"
        psk="makerbase3d"
        disabled=1
}

network={
        ssid="MENSON-WIFI"
        psk="makerbase318"
        disabled=1
}

network={
        ssid="messon_phone"
        psk="11111111"
        disabled=1
}

network={
        ssid="vivo S12"
        psk="66666666"
        disabled=1
}

```

----
Back to [start](index.md)
