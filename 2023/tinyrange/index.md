---
author: Joshua D. Scarsbrook - The University of Queensland
title: TinyRange
subtitle: Tiny run everywhere Linux networks for Cyber Security education
date: April 26th, 2023
parallaxBackgroundImage: ./images/uq_background.jpg
title-slide-attributes:
  data-background-image: ./images/uq_background.jpg
---

# Slides

[https://vbitz.github.io/presentations/2023/tinyrange](https://vbitz.github.io/presentations/2023/tinyrange)

# $ whoami

**Joshua Scarsbrook** ([j.scarsbrook@uq.edu.au](mailto:j.scarsbrook@uq.edu.au))

Research Officer at `The University of Queensland`

Interested in...

- `Operating Systems`
- `Virtualization`
- `Embedded Hardware`

Ran 10 `CTFs` of various sizes and 4 `Attack / Defense` challenges on various infrastructure.

# Live Demo

Running `Metasploit` on a `Dell Optiplex 9020`

- 8GB RAM and `Intel` i5-4590T.
- Running up-to-data `Windows 10`.
  - Only admin change made is enabling `Windows Hypervisor Platform`.
    - Only done for speed.

# What is TinyRange?

The overall goal of `TinyRange` is to reduce the `cost`, `complexity`, and `time` to setup lab environments to zero.

## Limitations

- No `Windows` guest support.
- Designed for a single user sitting in front of the computer.
- Lower performance for booted VMs than `VMWare` / `Hyper V` / etc...
- VMs are not connected to the Internet.
- Difficult to interface with hardware.

## What does it do?

- It's a `Cyber Security` lab in a box.
- Tiny means it runs in minimal resources.
- Everywhere means run everywhere.
  - Everything from large servers to tiny laptops.
  - Can run in as little as 300MB of RAM.

## Platform Support

For now it runs on `Windows`, `MacOS`, and `Linux` regardless of the system security configuration.

- No admin privileges.
- No mandatory installation.
  - Optional installation to make VMs faster (enable Hardware Acceleration).
- So long as you can run an executable you can run `TinyRange`.

More platform support is a long term goal.

- Mobile, Web Browsers, etc...

# Open Source Status

- We are working though the process to Open Source the core (what you've seen).
  - Having a hard time finding a good license.
- It will be under a permissive license (GPL-like).
- Dual License option as well.

# How?

- User-mode Networking
- Micro VMs
- Custom Boot Process
- Monolithic Core

## User-mode Networking

This is how `TinyRange` runs without Admin privileges.

It's based on `Google`'s `gVisor` network stack.

From a host perspective the VM software is just a regular application talking to other apps on UDP sockets.

This is why VMs don't have unrestricted internet access.

## Micro VMs

VMs have minimal hardware and boot directly into a `Linux` kernel.

Some custom solutions (`Firecracker`, etc...) but most require `KVM`.

Used by `Amazon` for `Lambda`.

Leads to very low Virtual Machine overhead.

## Custom Boot Process

VMs network boot from small images into a RAM Disk.

The first code running in User Space connects to the environment and handles operating system installation.

Installation comes from `Alpine Linux` repos or a `Docker` image.

It's still running after the VM is booted to push files and run commands on the VM (like a remote admin tool).

## Monolithic Core

This is why `TinyRange` is low in resource consumption.

`DNS`, `DHCP`, `HTTP` Proxies, and others are all part of the main executable.

Each of these services is minimal enough for the VMs in the environment.

The services intergrade with each other.

# Who?

_High Schools & High School Students_

- Students and Teachers are highly cost sensitive.
- Teachers want packaged highly functional solutions.
- There is a desire from students to learn.

# Why reinvent the wheel?

- Safety.
- Ease of Use.
- Cost.
- No noisy neighbors.

## Safety

The biggest initial motivation was safety.

I don't want to...

- change any system configuration to run VMs.
- to worry about leaked resources / new security holes.
- break my networking 10 minutes before a meeting because of a misspelt command run as root.

## Layers of Isolation

- VMs are the main isolation barrier.
- VMs don't persist anything to disk by default.
- Almost everything happens in memory.
- Starting the scenario again is always a clean reset.
- The environment uses no kernel resources besides unprivileged filesystem and network access.
- The environment runs as a unprivileged user.

## Ease of Use

I've made plenty of CTF and Attack/Defense challenges in the past.

Slow iteration time is painful.

The goal of `TinyRange` is **to make deploying a lab environment as effortless as opening a Word document**.

- _For 99% of documents there is no external dependencies. No setup._

Part of this is integrating everything together to reduce the number of moving parts.

- I don't want to install a `DNS` server or a `DHCP` server.
- I want all the configuration done in the background so I don't need to think about it.

## Cost

As cost increases centralization and maintenance increases.

- Development systems become soft production systems with uptime guarantees.
- Users are brought onto a single host for more effective use of resources and easier maintained.

## Using hardware people already have

- That means regular laptops and desktops running other software at the same time.

## Low cost makes cloud hard

- Every virtual machine running is a line item costing cents for every hour it's turned on.
- Anything above zero user cost adds significant friction.
  - Especially to high-school students without credit cards.
- Cloud resources invite malicious user behaviors.
  - Like cryptocurrency, malware domains, and DDOS.
  - The solution is to provide no resources.

## What you have is fast enough

- `Steam` hardware survey shows the average gaming computer has 6 CPU cores at 2.7-2.9 Ghtz, 16GB of RAM, and `Windows 10`.
  - 95% of machines have >= 8GB of RAM.
  - 97% of machines are running `Windows`.
- But I doubt this is representative of the average computer system.
  - I've also tested on `Raspberry PIs`, `Chromebooks`, and low-spec machines.
    - From brand new systems costing <$300 AUD to 8 year old ex-lease systems.
- `TinyRange` can run a Linux VM on `Windows` with about 220MB of RAM overhead.
  - That's 220MB to start a VM and get a usable console.

## No noisy neighbors.

- I'm used to cloud environments sharing compute time with students and colleagues.
- Neighbors consume lots of disk space, lots of memory, lots of CPU time.
- Neighbors mean thinking "is this VM more important than the one my colleague is running".
- Running on your own desktop cancels that entirely.

# Why not Docker?

- On `Windows` and `MacOS` you're generally running `Docker` inside a `Linux` VM anyway.
- VMs have a higher degree of isolation compared to containers.
- Some workloads can't run inside containers (e.g. `Docker` inside `Docker`).
- `Docker` is just a container management system. You need to bring plenty of other parts to make a cyber lab.
- The standard `Docker` configuration requires root privileges and a `Linux` host.

# Next Steps?

## Better VM definitions.

The goal is to make writing scenarios approachable to people of all skill levels.

## Extensibility/Plugin support.

Currently the core is highly monolithic. The goal is a modular micro kernel type approach.

## Networked environments.

- Make it super easy to network together multiple environments.
- Make a cluster from a computer lab.
- Hard due to firewalls and setup.

## More platform support.

- Web browsers.
  - Needs new virtualization tech designed for portability.
    - `QEMU` is too big.
    - Existing solutions like `JSLinux` don't have orchestration.
- `Android` phones/tablets.
  - Hardware acceleration is not generally possible.
  - Otherwise very doable.
- `iOS` phones/tablets.
  - Hard due to current App Store restrictions.
    - Any downloaded code needs to be modifiable by the user.
      - No binary downloads.
      - Fully integrated edit/compile process.

# Acknowledgments

- `Dr. Marie Boden`
  - Works with High School teachers.
  - Organized our external engagement with schools.
- `Prof. Ryan Ko`
  - My Mentor.
  - A brilliant Cyber Security strategist.
- `UniQuest & Research Legal`
  - Assistance with Open Source licensing.
- `Many Others...`

# Thanks for Listening

`Placeholder GitHub (Star/Follow here):` [https://github.com/tinyrange/tinyrange](https://github.com/tinyrange/tinyrange)

`Email:` [j.scarsbrook@uq.edu.au](mailto:j.scarsbrook@uq.edu.au)

`Twitter:` [@Vbitz](https://twitter.com/vbitz)

`Mastodon:` [@jscarsbrook@infosec.echange](https://infosec.exchange/@jscarsbrook)
