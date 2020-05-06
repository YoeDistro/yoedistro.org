+++
title = "64 Bit Kernels With 32 Bit Userspace"
date = 2020-04-09T08:31:02-07:00
draft = false
author = "Khem Raj"
+++

# Summary

As 64-bit processors are becoming more common in embedded systems, there is
significant need for software to run native 64bit. However, there are challenges
involved first in ensuring that applications are correctly ported which is a
time consuming task, and in some cases it may not make sense to port a legacy
application to 64-bit. However it is essential for a complete solution.

# Introduction

New SBCs and SOMs are increasingly being designed using the 64bit ARM (aarch64)
CPU architecture. Examples include the RaspberryPI3 (cortext-a53), RaspberryPI4
(cortex-a72), and iMX8 based SOMs -- these all use the armv8+ architecture. The
board support packages for these platforms all support native 64bit and are
quite stable. However, some applications stacks may still require 32bit mode
support for various reasons. Additionally, 64-bit applications typically use
more DRAM and may perform slower than the same application compiled in 32-bit
mode.

# Choices

Therefore, we have several options for running 32bit applications on 64bit
platforms:

1. Use full 32bit mode, which would limit the use of 64bit ISA completely
1. Run kernel in 64bit mode but let whole userspace run as 32bit bit
1. Run kernel in 64bit mode with 64bit userspace and additionally support 32bit
   runtime

These options come with their own set of tradeoffs.

Doing everything in 32bit mode (#1) gives us backward compatibility, but then we
can't use 64bit mode ISA and we are limited to a 4GB virtual memory space.

The second option lets one use the BSP defaults to run the kernel in 64bit mode
but keeps userspace 32bit. This is the path of least resistance for using
existing userspace software without any significant porting efforts.

The third option offers a mix of 32bit and 64bit userspace, which comes with
added duplication of runtimes, increasing the static footprint of the firmware,
which could be a design factor for a lot of embedded systems. Runtime DRAM
requirements for applications is also higher, which might not be suitable for
the embedded system at hand, as DRAM is a precious resource.

# Enabling 32-bit images on 64-bit kernels in Yoe

Enable Yocto multilib configuration settings in `conf/local.conf`

```bash
    # multilib arm
    require conf/multilib.conf
    MULTILIBS = "multilib:lib32"
    DEFAULTTUNE_virtclass-multilib-lib32 = "armv7athf-neon-vfpv4"

```

These settings will instruct the build to enable building applications in 32bit
mode if desired, `DEFAULTTUNE` is an important setting and it could be set to
same value as it was being used in pure 32bit build perhaps in older machine
designs.

# Building 32bit-only Userspace Image

```bash
    . ./raspberrypi3-64-envsetup.sh
    bitbake lib32-yoe-kiosk-imgae
```

This should build a 64bit kernel and pure 32bit kiosk image with all multilib
settings in place such that 64bit kernel can boot into 32bit userspace

# Building 64bit+32bit mixed Userspace Image

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

The Yoe distribution enjoys sound multilib support provided by the OpenEmbedded
build system. Design choices can be made early in the software development
process, and it is easy to generate different combinations of multi-libbed
images and test the suitability of a given combination. Whatever your 32/64-bit
needs are, Yoe gives you options to get there.
