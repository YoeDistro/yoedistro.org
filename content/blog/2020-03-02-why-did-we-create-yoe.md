+++
title = "Why Did We Create Yoe"
date = 2020-03-02

[extra]
author = "Cliff Brake"
+++

The Yoe Distribution is a thin template that uses OpenEmbedded and Yocto to build Embedded Linux systems. As we reflect back on its origins and changes, it has evolved to support the needs of both maintainers and product developers.

<!-- more -->

## The Challenge

Building embedded Linux systems is complex. Yocto and OpenEmbedded provide powerful tools, but the learning curve can be steep. Many teams struggle with:

- Complex directory structures that obscure what's actually happening
- Build environments that break when host systems are updated
- Difficulty tracking and reproducing builds across team members
- Hours spent searching for documentation on common tasks

## Our Solution

Yoe addresses these challenges by providing:

1. **A clean, logical structure** - Git submodules organize layers clearly
2. **Docker-based builds** - Consistent environment regardless of host OS
3. **Sensible defaults** - Common features enabled out of the box
4. **Clear documentation** - Get productive quickly

## Who Is Yoe For?

Yoe is designed for teams building real products. Whether you're a startup shipping your first device or an established company maintaining multiple product lines, Yoe helps you focus on your product rather than fighting the build system.

Get started at [github.com/YoeDistro/yoe-distro](https://github.com/YoeDistro/yoe-distro).
