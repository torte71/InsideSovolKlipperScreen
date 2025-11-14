---
title: CPU-Cooling-Fan
layout: page
parent: Hardware
---
# CPU-Cooling-Fan
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## CPU-Fan for cooling

The MKS-Klipad50 comes with only passive cooling, which is not really sufficient: The CPU-temperature can easily exceed 60°C, bearing the risk of sudden thermal shutdowns, eMMC failure and generally a faster degradation of the CPU.

Newer revisions (i.e. 1.1 and 1.2) of that board offer a socket for attaching a 24V fan. With the 1.0 board you can still add a fan, but it will need an external power supply.\
The socket fits the "standard" plug which most of these fans come with (I guess it's a 2-pole JST XH 2.54).

There are printable models which allow mounting a cooling fan, e.g.
- [Gergo's case](https://cults3d.com/de/modell-3d/werkzeuge/sovol-klipper-screen-cooling-fan-case-sv07-sv07-sv06-sv06-plus)
  - This model is not free, but worth the price IMO
  - It allows good cooling, as the fan is directly mounted above the CPU
  - There is also an option to replace the WiFi antenna with a better one
- [Backpack fan](https://www.printables.com/model/768054-sovol-sv07-klipper-screen-cooler?lang=de)
  - The fan does not directly blow onto the CPU, the air has to be pushed through the holes of the back cover instead, so cooling is less effective than with Gergo's model (but probably still better, than no fan)

If you encounter instabilities with that board, you can watch the CPU-Temperature and leave it running with the case open. If it runs more stable, adding a fan is recommended.

## Watching CPU-Temperature

To watch the CPU-temperature (just like the bed and hotend temperatures), add following lines to your `printer.cfg`:

```
[temperature_sensor Screen]
sensor_type: temperature_host
min_temp: 10
max_temp: 100
```

