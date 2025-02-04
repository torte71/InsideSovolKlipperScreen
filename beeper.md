---
title: Beeper macro
layout: page
parent: Configuring
nav_order: 2
---
# Beeper macro (for use in Klipper)
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

  * Beeper script:
    * Based on solution by "Bastian" on <https://forum.sovol3d.com>
    * <https://forum.sovol3d.com/t/use-beeper-from-mks-sbc-which-pin/3606/5>

  * Requires udev rule to change rights for gpio access
    * Based on solution by "MikeDK" on <https://forums.raspberrypi.com>
    * <https://forums.raspberrypi.com/viewtopic.php?t=9667>

  * /etc/udev/rules.d/90-gpio.rules

```
SUBSYSTEM=="gpio", KERNEL=="gpiochip*", ACTION=="add", PROGRAM="/bin/sh -c 'chown root:dialout /sys/class/gpio/export /sys/class/gpio/unexport ; chmod 220 /sys/class/gpio/export /sys/class/gpio/unexport'"
SUBSYSTEM=="gpio", KERNEL=="gpio*", ACTION=="add", PROGRAM="/bin/sh -c 'chown root:dialout /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value ; chmod 660 /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value'"
```

  * /home/mks/printer_data/config/printer.cfg:

{% raw  %}
```
[gcode_macro BEEP]
gcode:
  {% set beep_count = params.BC|default("3") %}
  {% set beep_duration = params.BD|default("0.2") %}
  {% set pause_duration = params.PD|default("1") %}
  RUN_SHELL_COMMAND CMD=beep PARAMS='{beep_count} {beep_duration} {pause_duration}'

[gcode_shell_command beep]
command: bash /home/mks/printer_data/config/macro/macro-beep.sh
timeout: 10
verbose: False
```
{% endraw  %}

  * /home/mks/printer_data/config/macros/macro-beep.sh:

```
#!/bin/bash
# usage: beep.sh [BEEPCOUNT] [BEEPDURATION] [PAUSEDURATION]

# Output raw passed parameters
echo "Raw parameters: $@"

# Default values
BEEPCOUNT=${1:-3}
BEEPDURATION=${2:-0.1}
PAUSEDURATION=${3:-0.5}

# Output all passed parameters
echo "Beep count: $BEEPCOUNT, beep duration: $BEEPDURATION, pause duration: $PAUSEDURATION"


# Function to play a beep
play_beep() {
    echo 1 > /sys/class/gpio/gpio82/value
    sleep $BEEPDURATION
    echo 0 > /sys/class/gpio/gpio82/value
}

# Play the beep for the specified count
for (( i=0; i<BEEPCOUNT; i++ )); do
    play_beep
    sleep $PAUSEDURATION
done
```

----
Back to [start](index.html)
