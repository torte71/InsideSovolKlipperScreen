---
title: makerbase-soft-shutdown.service files
layout: page
parent: Modifications by Sovol
---
# makerbase-soft-shutdown.service files
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## /usr/lib/systemd/system/makerbase-soft-shutdown.service
```
[Unit]
Description=makerbase-soft-shutdown
After=network.target
Wants=udev.target

[Install]
WantedBy=multi-user.target

[Service]
Type=oneshot
ExecStart=/root/soft_shutdown.sh
```

## /root/soft_shutdown.sh
  * Sets up GPIO for the **supper** capacitor
  * does nothing more, because logic is commented out

```
#!/bin/bash


#enable the control of the supper capacitor,GPIO3_A4
if [ -d /sys/class/gpio/gpio100 ]
then
        echo out > /sys/class/gpio/gpio100/direction
        echo 0 > /sys/class/gpio/gpio100/value
else
        echo 100 > /sys/class/gpio/export
        echo out > /sys/class/gpio/gpio100/direction
        echo 0 > /sys/class/gpio/gpio100/value
fi

#power-off signal,gpio85(GPIO2_C5)
if [ -d /sys/class/gpio/gpio85 ]
then
        echo in > /sys/class/gpio/gpio85/direction
else
        echo 85 > /sys/class/gpio/export
        echo in > /sys/class/gpio/gpio85/direction
fi

while :
do
        #level=`cat /sys/class/gpio/gpio85/value` #Detect the power-off signal,gpio85(GPIO1_B2)
        #echo "gpio:$((level))"
        if [ "$level" = 1 ]
        then		
			sync
#           shutdown -h now

        fi
        sync
        sleep 2
done
```

----
Back to [start](index.md)
