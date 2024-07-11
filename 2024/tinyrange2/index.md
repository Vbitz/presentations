---
author: Joshua D. Scarsbrook - The University of Queensland
title: "TinyRange: Next-generation Virtualization for Cyber and Beyond"
date: July 11th, 2024
---

# Slides

[https://vbitz.github.io/presentations/2024/tinyrange2](https://vbitz.github.io/presentations/2023/tinyrange)

<img src="./slides_qr.svg" width=300 height=300>

# $ whoami

**Joshua Scarsbrook** ([j.scarsbrook@uq.edu.au](mailto:j.scarsbrook@uq.edu.au))

Research Officer at `The University of Queensland`

Interested in...

- `Operating Systems`
- `Virtualization`
- `Embedded Hardware`

Working in the `Computational Imaging Group` of `EECS`

# `Virtual Machines` vs. `Containers`

- **Virtual Machines:** Isolated at the CPU Level. Emulates real hardware or specialized virtual hardware.
- **Containers:** Isolated at the Operating System Level. Fast, easy to build, and efferent with resources.

The biggest limiting factor for virtual machines is how you build them.

# How do we get files into `Virtual Machines`?

- **Block Devices:** Direct emulation of hardware. Fast and well supported but slow to build.
- **Network Filesystems:** Moderate support and moderate speed (e.g. `SMB`, `NFS`, `sshfs`).
- **VM Filesystems:** Highly specialized and very fast (e.g. `virtio-fs`, `virtio-9p`).

# What is TinyRange?

> Next-generation Virtualization for Cyber and Beyond

**Long Term Goal**: Make running and building _any_ software effortless on all modern hardware.

**Where are we today?**: Super fast and easy `Linux` virtual machines.

# `TinyRange` is Open Source!

**License**: Apache License 2.0

**Source Code**: [https://github.com/tinyrange/tinyrange](https://github.com/tinyrange/tinyrange/)

# Virtual `ext4` Filesystems.

- A write-only `ext4` driver in `Go`.
- Mapped to virtual machines using `NBD` as a regular block device.
- Performance comparable to a regular disk image or RAM disk.

# How?

- A custom language that defines structures with safe byte-level indexing.

```
type DirEntry2 struct {
    inode               u32_le  // Number of the inode that this directory points to.
    rec_len             u16_le  // Length of this directory entry.
    name_len            u8      // Length of the file name.
    file_type           u8      // File type code, see ftype table below.
}
```

- Virtual memory mapping emulated in Userspace with byte-level granularity.
- ~2000 lines of `Go` to implement `ext4` support.

# Benchmarks

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `tinyrange` | 376.6 ± 1.8 | 372.6 | 379.2 | 2.26 ± 0.20 |
| `docker` | 220.8 ± 16.0 | 199.1 | 259.6 | 1.33 ± 0.15 |
| `podman` | 166.3 ± 14.6 | 145.4 | 200.9 | 1.00 |

# TinyRange Research Gaps

1. **Software Installation:** Now we can get files into a virtual machine how do we get software installed?
2. **Virtualization:** Currently using QEMU. A better replacement could enable running all this in a web browser.
3. **Alternate Guest Operating Systems:** Needs a driver for the filesystem and a bootloader.

# Scripting Preview 

```py
make_vm([
    define.plan(
        builder = "alpine@3.20",
        packages = [
            query("ifupdown-ng"), query("busybox"), query("busybox-binsh"),
            query("alpine-baselayout"), query("openrc"), query("docker"),
            query("docker-openrc"), query("hyperfine"),
        ],
        tags = ["level3"],
    ),
    vm_modfs,
    directive.add_file("/run/openrc/softlevel", file("")),
    directive.add_file("/etc/network/interfaces", file("")),
    directive.run_command("openrc"),
    directive.run_command("service docker start"),
    directive.run_command("""while (! docker version > /dev/null 2>&1); do
  sleep 0.1
done""" ),
])
```

# What am I using this for?

# NeuroDesk

- Headed by Dr. Steffen Bollmann with many other contributors.
- Currently built with generated `Dockerfiles` and two containers using TinyRange.
- Hoping to use TinyRange in the future.
- ~100 Neuroimaging tools distributed publicly with `Docker`, `Singularity`, `CVMFS`.
- Users all over the world.

# Thanks for Listening

`Source Code:` [https://github.com/tinyrange/tinyrange](https://github.com/tinyrange/tinyrange)

`Email:` [j.scarsbrook@uq.edu.au](mailto:j.scarsbrook@uq.edu.au)

`Mastodon:` [@jscarsbrook@infosec.echange](https://infosec.exchange/@jscarsbrook)
