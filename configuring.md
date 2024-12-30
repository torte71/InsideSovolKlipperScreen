---
title: Configuring
layout: page
nav_order: 7
---
# Configuring
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## Logging, etc.

### Timezone updates spamming syslog

Edit `/root/set-timezone.sh` (around line 33), replace unconditional `sleep 3` so it sleeps 1 hour, once it received a valid time via NTP:

```
    current_time=$(date)
    echo "当前时间: $current_time"

    # 延时5秒
#TM#    sleep 3
#TM-->
        if ! $synced ; then
          sleep 3
        else
          sleep 3600
        fi
#TM<--

        if ! $synced; then
```

----
Back to [start](index.html)
