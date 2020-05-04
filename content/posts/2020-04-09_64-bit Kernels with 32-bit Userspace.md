+++
title = "64 Bit Kernels With 32 Bit Userspace"
date = 2020-04-09T08:31:02-07:00
draft = true
author = "Khem Raj"
+++

# Summary

As 64-bit processors are becoming more and more common in embedded system
designs, there is significant need for software porting to run native 64bit,
however, there are challanges involved firstly in ensuring that applications are
correctly ported forward which is a time consuming task, in some cases it may be
a legacy application which may not make sense to forward port. However it is
essential for complete solution.

# Introduction

A plenty of new SBCs and SOMs are increasingly being designed using 64bit ARM
(aarch64) CPU architecture notably, RaspberryPI3 (cortext-a53) RaspberryPI4
(cortex-a72), iMX8 based SOMs are also using armv8+ architecture. The board
support package is supporting native 64bit on these platforms and it is quite
stable, however, application stacks may require to be run in 32bit mode for
serveral reasons,

# Choices

Therefore, we have options to run it

- Use full 32bit mode, which would limit the use of 64bit ISA completely

- Run kernel in 64bit mode but let whole userspace run as 32bit bit

- Run kernel in 64bit mode with 64bit userspace and additionally support 32bit
  runtime

These options come with their own set of advantages and limitations, doing
everything in 32bit mode, while backward compatible, cant use 64bit mode ISA and
kernel cant see more memory

second option lets one use the BSP defaults to let kernel run in 64bit mode but
keeps userspace 32bit, which essentialy is path of least resistance for using
existing userspace software without any significant porting efforts.

Third option, offers a mix of 32bit and 64bit userspace, which comes with added
duplication of runtimes, increasing the static footprint of the firmware, which
could be a design factor for lot of embedded systems. Runtime DRAM requirements
for applications is also higher, which might not be suitable for the embedded
system at hand, as DRAM is a precious resourse.

# Enabling 32-bit images on 64-bit kernels in Yoe

Enable Yocto multilib configuration settings in `conf/local.conf`

```bash
    # multilib arm
    require conf/multilib.conf
    MULTILIBS = "multilib:lib32"
    DEFAULTTUNE_virtclass-multilib-lib32 = "armv7athf-neon-vfpv4"

```

These settings will intruct the build to enable building applications in 32bit
mode if desired, `DEFAULTTUNE` is an important setting and it could be set to
same value as it was being used in pure 32bit build perhaps in older machine
designs.

# Building 32bit-only Userspace Image

```bash
    . ./raspberrypi3-64-envsetup.sh
    bitbake lib32-yoe-kiosk-imgae
```

This should build a 64bit kernel and pure 32bit kiosk image witth all multilib
settings in place such that 64bit kernel can boot into 32bit userspace

# Building 64bit+32bit mixed Usespace Image

Add needed 32bit applications to image via `IMAGE_INSTALL` in `local.conf`

```bash
IMAGE_INSTALL_append = " lib32-python3-core lib32-htop"
```

This will add 32bit version of htop application and 32bit python to the
otherwise 64bit image

Now build the image

```bash
bitbake yoe-kiosk-image
```

# Flashing Image

```bash
yoe_install_image /dev/sd<X> yoe-kiosk-image
```

Replace `X` with the device letter 'a' 'b' 'c' .. Use `dmesg | tail` to check
where SD card is mounted.

# Summary

Yoe distro enjoys the sound multilib support provided by OpenEmbedded build
system, the design choices as needed can be easiliy bolted in early software
development, at the same time its easy to generate different combinations of
multlibbed images and test them out along the way to test and try our
suitability of a given combination, since it highly depends on usecase it is
being deployed into.
