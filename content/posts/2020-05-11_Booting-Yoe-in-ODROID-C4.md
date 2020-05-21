+++
title = "Booting Yoe Distribution on ODROID-C4"
date = 2020-05-11T08:31:02-07:00
draft = true
author = "Khem Raj"
+++

# Summary

[ODRIOD-C4](https://www.hardkernel.com/shop/odroid-c4/) is the latest addition
in the line of SBCs from Hardkernel, it is priced at \$50 and comes packed with
high performance parts. Its based on on Amlogic S905X3 quadcore ARM64 (
cortex-a55 ) CPU, 4GB DDRR4 DRAM, 4 USB-3.0 ports, GigE, HDMI 2.0, 40-pin GPIO
header to list a few key features.

![ODROID-C4](/images/posts/2020-05-11_Booting-Yoe-in-ODROID-C4/C4-board4h.jpg)

# Porting Yoe Distribution

Yoe distribution being based on OpenEmbedded architecture can take advantage of
layered architecture where, odroid boards support is added via a BSP overlay
layer, therefore the effort was mainly adding necessary bits in meta-odroid

## New Cortex-a55 tune files

OpenEmbedded allows to use SOC specific optimized flags to build images to
squeeze best out of compiler and therefore new tune file to enumerate cortex-a55
specific tuning options is added

```

DEFAULTTUNE ?= "cortexa55"

TUNEVALID[cortexa55] = "Enable Cortex-A55 specific processor optimizations"
TUNE_CCARGS .= "${@bb.utils.contains('TUNE_FEATURES', 'cortexa55', ' -mcpu=cortex-a55', '', d)}"

require conf/machine/include/arm/arch-armv8a.inc

# Little Endian base configs
AVAILTUNES += "cortexa55 cortexa55-crypto"
ARMPKGARCH_tune-cortexa55             = "cortexa55"
ARMPKGARCH_tune-cortexa55-crypto      = "cortexa55"
TUNE_FEATURES_tune-cortexa55          = "aarch64 cortexa55 crc"
TUNE_FEATURES_tune-cortexa55-crypto   = "aarch64 cortexa55 crc crypto"
PACKAGE_EXTRA_ARCHS_tune-cortexa55             = "${PACKAGE_EXTRA_ARCHS_tune-armv8a-crc} cortexa55"
PACKAGE_EXTRA_ARCHS_tune-cortexa55-crypto      = "${PACKAGE_EXTRA_ARCHS_tune-armv8a-crc-crypto} cortexa55 cortexa55-crypto"
BASE_LIB_tune-cortexa55               = "lib64"
BASE_LIB_tune-cortexa55-crypto        = "lib64"

```

A New machine configuration file to define default tunings and pinning kernel
and bootloader version is created
[ODROID-C4](http://localhost:1314/posts/2020-05-11_booting-yoe-in-odroid-c4/)

## Machine Configuration

```
#@TYPE: Machine
#@NAME: odroid-c4
#@DESCRIPTION: Machine configuration for odroid-c4 systems
#@MAINTAINER: Armin Kuster <akuster808@gmail.com>

DEFAULTTUNE ?= "cortexa55-crypto"

require conf/machine/include/arm/tune-cortexa55.inc
require conf/machine/include/amlogic-meson64.inc
require conf/machine/include/odroid-arm-defaults.inc
...

```

## Recipes for Kernel and bootloader

While upstream support for Amlogic SOCs is sound in mainline kernel, here
emphasis is to port the odroid kernel since that will support needed peripherals
out of box, eventually it might be good to support mainline kernel. hardkernel
currently added full support for C4 into 4.9. Similarily recipe for u-boot
2015.01 is added since that is officially supported bootloader from hardkernel

- [Kernel](https://github.com/akuster/meta-odroid/blob/master/recipes-kernel/linux/linux-hardkernel_6.9.bb)
- [boot loader](https://github.com/akuster/meta-odroid/blob/master/recipes-bsp/u-boot/u-boot-hardkernel_2015.01.bb)

# Yoe Distribution port

Yoe distribution has
[setup script](https://github.com/YoeDistro/yoe-distro/blob/master/envsetup.sh)
to do workspace setup, a new file ( which is just a symlink ) to use ODROID-C4
is added as
[odroid-c4-hardkernel-envsetup](https://github.com/YoeDistro/yoe-distro/blob/master/odroid-c4-hardkernel-envsetup.sh)

## Building yoe-simple-image

```
git clone --recurse-submodules -j8 -b master git://github.com/YoeDistro/yoe-distro.git yoe
cd yoe
. ./odroid-c4-hardkernel-envsetup.sh
yoe_setup
bitbake yoe-simple-image

yoe_install_image /dev/sdX yoe-simple-image
sudo eject /dev/sdX

```

power-on and image should boot into console

![htop with Sato and Kiosk Browser](/images/posts/2020-05-11_Booting-Yoe-in-ODROID-C4/htop-on-c4.jpg)

## Enabling 3.2 Inch LCD Shield

It requires enabling it in device tree and at the same time disabling spidev to
avoid conflicts, the changes are applied in kernel via a
[patch](https://github.com/akuster/meta-odroid/blob/master/recipes-kernel/linux/linux-hardkernel-4.9/0001-ODROID-C4-Enable-LCD-and-Touchscreen.patch)

Building yoe-simple-image with this change will enable it and `/dev/fb4` should
become available which is the fb_hktft32 framebuffer

## Kiosk Broser on LCD Shield

QT5 layer for openembedded has a sample kiosk browser which uses QTWebengine,
for including that in image

`conf/local.conf`

```
IMAGE_INSTALL_append = " qt-kiosk-browser"

```

bake the image again and flash it to SD card, once booted, Kiosk browser can be
launched on LCD

```
export QT_QPA_EGLFS_FB=/dev/fb4
export QT_QPA_PLATFORM=linuxfb:fb=/dev/fb4
export QT_QPA_DEBUG=1
export QT_LOGGING_RULES="qt.qpa.*=true"
export QML2_IMPORT_PATH=/usr/lib/qt5/qml
export QML_IMPORT_PATH=/usr/lib/qt5/qml
qt-kiosk-browser --no-sandbox /etc/qt-kiosk-browser.conf

```

![Kiosk Browser](/images/posts/2020-05-11_Booting-Yoe-in-ODROID-C4/Meet-yoe-C4.jpg)

## what works

X11 over fbdev and plain lunuxfb backend works fine, it consumes 169M when using
just sato UI, when launching kiosk browser, memory consumption increases to
approximately 225M

![Sato UI on C4](/images/posts/2020-05-11_Booting-Yoe-in-ODROID-C4/IMG-4412.jpg)

## Further work

- Add mali bifrost driver support, which should enable wayland as well as gbm
  eglfs backend
- Support mainline linux kernel and u-boot
