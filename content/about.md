+++
title = "About Yoe"
date = 2020-03-02T11:42:28-05:00
draft = true
author = "Cliff Brake"
+++

The Yoe Distribution is a thin wrapper around OpenEmbedded/Yocto and provides a
clean way to organize your development, capture changes, automate tasks, and
reduce host dependencies. As such, it includes:

- a top level [Git repo](https://github.com/YoeDistro/yoe-distro) that contains
  a number of OpenEmbedded layers (in Git submodules) and configuration files.
- an
  [envsetup.sh](https://github.com/YoeDistro/yoe-distro/blob/master/envsetup.sh)
  bash script that adds a thin layer of automation and convenience.
- the [meta-yoe](https://github.com/YoeDistro/meta-yoe) layer, which defines
  distribution policies, image recipes, and other misc recipies. The Yoe
  Distribution defaults to features and options most systems will need so is a
  great starting point.
- [configuration options](https://github.com/YoeDistro/yoe-distro/tree/master/docs/yoe-profile.md)
  for common technology selections (libc, graphics, and init system)
- a [docker image](https://hub.docker.com/r/yoedistro/yoe-build) that can be
  used to provide a controlled set of host dependencies.
- [documentation](https://github.com/YoeDistro/yoe-distro/tree/master/docs)
