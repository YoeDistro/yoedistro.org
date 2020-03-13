---
date: 2020-02-14T12:07:42-05:00
---

The Yoe Distribution is a collection of documentation and best practices using
the OpenEmbedded build system and tooling from the Yocto project to create
products. This distribution does not end at demo images but rather begins there.

## Simple

Yoe keeps your build system as simple as possible by using Git repositories and
Bash scripts. No external tools (like Repo) are required. No complex scripts
copying files from obscure locations during setup. Directory structure is
organized and easy to search. Any changes made are easily captured with Git. No
magic -- just common sense tooling.

## Maintainable

An optional Docker container is provided to simplify building images on any
Linux machine over the lifecycle or your product.

## Configurable with Sane defaults

There are many choices to make when creating an Embedded Linux system. We chose
default policies that make sense and provide templates for selecting the
init-system, graphics libraries, windowing system, etc.

## Well Documented

Clear documentation on how to get started and accomplish common tasks.

## Broad architecture support

Yoe supports standard reference platforms like the Raspberry PI and Beaglebone.
Any machine (ARM/ARM64/x86/x86-64/ppc/mips/mips64/RISCV64/RISCV32) can be added.

## Current and well Supported

We continually test the latest OpenEmbedded layers and maintain copies of all
repositories to ensure things work, as well work with upstream providers as
needed to resolve issues.
