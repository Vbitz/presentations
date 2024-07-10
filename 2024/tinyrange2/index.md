---
author: Joshua D. Scarsbrook - The University of Queensland
title: TinyRange
subtitle: "TinyRange: Next-generation Virtualization for Cyber and Beyond"
date: July 10th, 2024
---

# Slides

[https://vbitz.github.io/presentations/2024/tinyrange2](https://vbitz.github.io/presentations/2023/tinyrange)

# $ whoami

**Joshua Scarsbrook** ([j.scarsbrook@uq.edu.au](mailto:j.scarsbrook@uq.edu.au))

Research Officer at `The University of Queensland`

Interested in...

- `Operating Systems`
- `Virtualization`
- `Embedded Hardware`

Working in the `Computational Imaging Group` of `EECS`

# What is TinyRange?

> Next-generation Virtualization for Cyber and Beyond

**Long Term Goal**: Make running and building _any_ software effortless for all modern hardware.

**Where am I today?**: Super fast and easy `Linux` virtual machines.

# This time last year.

- TinyRange was closed source.
- The biggest limiting factor was transferring files into VMs.
- Adhoc system for defining virtual machines and running software.

# `TinyRange` is Open Source!

**License**: Apache License 2.0

**Source Code**: [https://github.com/tinyrange/tinyrange](https://github.com/tinyrange/tinyrange/)

# What else is new?

- Virtual `ext4` Filesystems!
- New scriptable build system for writing package managers.

# Virtual `ext4` Filesystems.

- A write-only `ext4` driver in `Go`.
- Mapped to virtual machines using `NBD` as a regular block device.
- Performance comparable to a regular disk image or RAM disk.

# How?

- A custom language that defines structures with safe byte-level indexing.
- Virtual memory mapping emulated in Userspace with byte-level granularity.

# Scriptable Build System

- Not a new package manager. A new way to write package managers.
- Integrates with `TinyRange` as a virtualization host.
- Able to build a full `Alpine Linux` system without

# What is the Computational Imaging Group?

- Headed by Dr. Steffen Bollmann
- Research into `MRI` Imaging with a focus on reproducible science.
- Works on [NeuroDesk](https://www.neurodesk.org/) among other projects.

# NeuroDesk

- ~100 Neuroimaging tools distributed publicly with `Docker`, `Singularity`, `CVMFS`.
- Users all over the world.
- Currently built with generated `Dockerfiles`.

# TinyRange Research Gaps

1. **Virtualization:** Currently using QEMU. A better replacement could enable running all this in a web browser.
2. **Bootloader:** Currently ties us to Linux.
2. **Alternate Guest Operating Systems:** Needs a driver for the filesystem and a bootloader.

# Thanks for Listening

`Source Code:` [https://github.com/tinyrange/tinyrange](https://github.com/tinyrange/tinyrange)

`Email:` [j.scarsbrook@uq.edu.au](mailto:j.scarsbrook@uq.edu.au)

`Mastodon:` [@jscarsbrook@infosec.echange](https://infosec.exchange/@jscarsbrook)
