---
title: GPIO naming
layout: page
parent: Hardware
---
# GPIO naming
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## GPIO controllers

The rk3328 cpu has 4 main gpio controllers, each has 32 lanes:

```
gpio0: lane  0 ..  31
gpio1: lane 31 ..  63
gpio2: lane 64 ..  95
gpio3: lane 96 .. 127
```

## GPIO lanes

The 32 lanes of each controller are named `A0` .. `D7`:

```
lane  0 = A0  |  lane  8 = B0  |  lane 16 = C0  |  lane 24 = D0
lane  1 = A1  |  lane  9 = B1  |  lane 17 = C1  |  lane 25 = D1
lane  2 = A2  |  lane 10 = B2  |  lane 18 = C2  |  lane 26 = D2
lane  3 = A3  |  lane 11 = B3  |  lane 19 = C3  |  lane 27 = D3
lane  4 = A4  |  lane 12 = B4  |  lane 20 = C4  |  lane 28 = D4
lane  5 = A5  |  lane 13 = B5  |  lane 21 = C5  |  lane 29 = D5
lane  6 = A6  |  lane 14 = B6  |  lane 22 = C6  |  lane 20 = D6
lane  7 = A7  |  lane 15 = B7  |  lane 23 = C7  |  lane 31 = D7
```

## Relative vs. absolute lane numbers

To calculate the relative lane number, divide the absolute lane number by 32. The remainder is the relative lane number.

``` 
gpio0   :  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31
gpio1   : 32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63
gpio2   : 64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82  83  84  85  86  87  88  89  90  91  92  93  94  95
gpio3   : 96  97  98  99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127
Relative:  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31
```

## Examples

**What is "gpio100"?**
- lane 100 (absolute) belongs to gpio3
- the relative lane number is 4
- the symbolic name is "gpio3 A4"

**What is "gpio82"?**
- lane 82 (absolute) belongs to gpio2
- the relative lane number is 18
- the symbolic name is "gpio2 C2"

### Shell naming scheme
The shell uses absolute lane numbers.

- Example: `gpio82`
- Example (long):
```
echo 0  > /sys/class/gpio/gpio82/value
```

### Devicetree naming scheme
Devicetree files use A0 to D7 relative lane names (prepended with "RK_P")

- Example: `&gpio2 RK_PC2`
- Example (long):
```
gpios = <&gpio2 RK_PC2 GPIO_ACTIVE_HIGH>;
```

### Klipper naming scheme
Klipper uses relative lane numbers. "rpi" refers to the mcu.

- Example: `rpi:gpiochip2/gpio18`
- Example (long):

```
[mcu rpi]
serial: /tmp/klipper_host_mcu

[output_pin beeper_pin]
pin: rpi:gpiochip2/gpio18
```

