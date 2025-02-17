---
title: makerbase-timezone-monitor.service files
layout: page
parent: Modifications by Sovol
---
# makerbase-timezone-monitor.service files
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## /usr/lib/systemd/system/makerbase-timezone-monitor.service
```
[Unit]
Description=Timezone Monitor Service
After=network.target

[Service]
ExecStart=/root/set-timezone.sh

[Install]
WantedBy=multi-user.target
```

## /root/set-timezone.sh
  * Update timezone to that from `/home/mks/target_timezone.txt`
  * Fetches time via NTP every 3 seconds, effectively spams syslog

```
#!/bin/bash

synced=false

while true; do
    # 读取目标时区文件
    target_tz=$(cat /home/mks/target_timezone.txt)

    echo "目标时区是：$target_tz"

    # 使用timedatectl命令获取当前时区
    current_tz=$(timedatectl show --property=Timezone --value)

    echo "当前时区是：$current_tz"

    # 检查当前时区与目标时区是否匹配
    if [ "$current_tz" != "$target_tz" ]; then
        # 检查目标时区是否有效
        if timedatectl list-timezones | grep -q "^$target_tz$"; then
            # 使用timedatectl命令修改系统时区
            sudo timedatectl set-timezone "$target_tz"
            echo "系统时区已成功更改为$target_tz"
        else
            echo "无效的时区: $target_tz"
        fi
    fi

    # 验证时间是否正确设置为新时区
    current_time=$(date)
    echo "当前时间: $current_time"

    # 延时5秒
    sleep 3
	
	if ! $synced; then		
		if ping -c 1 -W 3 ntp.aliyun.com &> /dev/null; then
			echo "网络连接正常"
			# 进行NTP时间同步
			/usr/sbin/ntpdate ntp.aliyun.com >/dev/null 2>&1
			
			synced=true
			echo "时间已成功同步"
		else
			echo "无法连接到网络"
		fi
	fi
	
	if ! $synced; then
		
		if ping -c 1 -W 3 pool.ntp.org &> /dev/null; then
			echo "网络连接正常"

			# 进行NTP时间同步
			/usr/sbin/ntpdate pool.ntp.org >/dev/null 2>&1
			synced=true
			echo "时间已成功同步"
		else
			echo "无法连接到网络"
		fi
	fi
	

done
```

