---
title: makerbase-beep.service files
layout: page
parent: Modifications by Sovol
---
# makerbase-beep.service files
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## /usr/lib/systemd/system/makerbase-beep.service
```
[Unit]
Description=Touch beep Service
After=KlipperScreen.service

[Service]
ExecStart=/root/beep.sh

[Install]
WantedBy=multi-user.target
```

## /root/beep.sh
```
#!/bin/bash

# 设置GPIO控制蜂鸣器的管脚
BEEP_GPIO=82  # 替换为实际的GPIO管脚号

# 检查GPIO是否已经导出
if [ ! -d "/sys/class/gpio/gpio$BEEP_GPIO" ]; then
    # 导出GPIO管脚
    echo $BEEP_GPIO > /sys/class/gpio/export
fi

# 设置GPIO管脚为输出模式
echo "out" > /sys/class/gpio/gpio$BEEP_GPIO/direction

# 控制蜂鸣器响声函数
function beep() {
    # 设置GPIO管脚电平为高，触发蜂鸣器
    echo "1" > /sys/class/gpio/gpio$BEEP_GPIO/value
   # read -t 1  # 控制蜂鸣器响声持续时间，这里是0.1秒
  sleep 0.005  # 控制蜂鸣器响声持续时间
#   ./delay 100

    # 设置GPIO管脚电平为低，停止蜂鸣器
    echo "0" > /sys/class/gpio/gpio$BEEP_GPIO/value
}


TOUCHSCREEN_DEV=""

# 遍历/dev/input目录下的event设备
for event_device in /dev/input/event*; do
    # 检查设备是否为输入设备
    if [[ -c $event_device ]]; then
        # 检查设备是否为HID设备，并且Vendor和Product ID匹配
        vendor_product_id=$(udevadm info --query=property --path=/sys/class/input/$(basename $event_device) | grep -E "ID_VENDOR_ID|ID_MODEL_ID")
        if [[ $vendor_product_id == *1a86*e5e3* ]]; then
            TOUCHSCREEN_DEV=$event_device
            break
        fi
    fi
done

if [[ -z $TOUCHSCREEN_DEV ]]; then
    echo "无法找到USB触摸屏设备。"
    exit 1
else
    echo "找到USB触摸屏设备，事件设备路径为：$$TOUCHSCREEN_DEV"
fi







        # 使用evtest命令进行异步事件监听
        evtest $TOUCHSCREEN_DEV | while read -r line

        do
            # 检测是否触摸屏按下事件
            if [[ $line =~ "type 1 (EV_KEY), code 330 (BTN_TOUCH), value 1" ]]
            then
		if grep -q "beep" /home/mks/KlipperScreen/KlipperScreen.conf; then
			echo "disable beep"
		else
                # 发出蜂鸣器声音
                beep &
            fi

            fi
 #           sleep 0.01
        done
 


# 清理GPIO资源
if [ -d "/sys/class/gpio/gpio$BEEP_GPIO" ]; then
    echo $BEEP_GPIO > /sys/class/gpio/unexport
fi
```

## Required changes for recent images
change `/root/beep.sh`
  * from:
```
        if [[ $vendor_product_id == *1a86*e5e3* ]]; then
            TOUCHSCREEN_DEV=$event_device
            break
        fi
```
  * to:
```
        if [[ $vendor_product_id == *1a86*e5e3* ]] \
        || [[ $vendor_product_id == *e5e3*1a86* ]]; then
            TOUCHSCREEN_DEV=$event_device
            break
        fi
```

