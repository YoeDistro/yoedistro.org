+++
title = "Why Yoe"
date = 2020-02-25T13:59:01-08:00
draft = true
author = "Cliff Brake and Khem Raj"
+++

Summary

<!--more-->

# Introduction

Yoe Distribution is intended for creating a deployment template for embedded linux distribution, it uses
OpenEmbedded build system and several tools from yocto project in the process to establish a
fairly, user friendly, reproducible workflow. The primary focus is on simplicity and ease of
use, while maintaining a robust system, that is reflected in careful selection of tools and processes

# Workspace Setup

We use git submodules to setup full workspace, since git is primary SCM used for metadata layers and other
build artifacts, its easy to use power of git itself to archive a multi-repository setup, instead of using
another external tool to manage bunch of git repositories

# Docker as builder

Organizations and individuals might have different Linux and non-linux environments in-house, and adding yet
another host operating system prerequisite is adding to the problem. Instead Yoe distribution employs docker
runners, There is a standard template which is had needed pre-requisites for build Yoe Distribution packages
This also helps in creating a reproducible build environemnt many years down the lane, when host distros would
have moved to newer verisons and it would be hard to find VMs or machines running specific distribution on
host, that problem has been abstracted with use of containers in Yoe distributions build environment.

# Setup

Setup is using a shell script to setup OpenEmbedded build environemnt and get it ready to build. It works with
several shells, but bash and zsh are more often tested, there
are additional tools which are provided as builtins in this setup. The tools help in creating most frequent
tasks that are performed by embedded system builders and developers, e.g. flashing an image, updating the
workspace, setting up local feed server, adding/deleting metadata layers to name a few, whats more powerful
is that it can be extended to local workflow environments by overriding or adding new functions

# Distribution Feature Policies

Embedded systems have requirements to make custom choices for core components like, compiler, C library
init-systems,grpahics, windowing systems etc.
Yoe distro provides pre-existing templates called `YOE_PROFIILE` to select a combination of them, at the
same time, makes sane choices for other policies which are requires but are not often marked for selection

# Images

Yoe Distribution provides a few base images, for common usecases
  * `yoe-simple-image` - Basic console image
  * `yoe-debug-image`  - Image with ptests, debug tools, profiling tools this can be used for running `-ctestimage` targets
  * `yoe-qt5-wayland-image` - Reference image with QT5 samples, e.g. cinematicexperience running out of box on wayland/weston
  * `yoe-qt5-x11-image -  Same as above, except it uses X11 instead of wayland
  * `yoe-qt5-eglfs-image` - Same as above except it does not use X11 or wayland but runs on EGLFS directly
  * `initramfs-image` - Small image for bundling into kernel as initramfs used as updater or recovery
  * `yoe-simpleiot-image` - Reference tiny image, suitable for IOT devices

# Reference Machines

Its regularly tested on, `raspberrypi3`,`beaglebone black` along with QEMU machines for all supported architectures e.g.
ARM/ARM64/x86/x86-64/ppc/mips/mips64/RISCV64/RISCV32

