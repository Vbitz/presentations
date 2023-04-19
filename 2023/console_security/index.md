---
author: Joshua D. Scarsbrook
title: Introduction to Console Security
subtitle: Your Game Console is not a PC
date: April 5, 2023
---

### `joshua@joshua-pc3 $ whoami`

Joshua Scarsbrook

Research Officer/PhD Student at the University of Queensland

Researching Applied Cyber Security and Cyber Security in Education

Interested in Operating Systems and Embedded Hardware

---

## Disclaimer

**I did not hack these consoles myself or develop the exploits.** All the content in this presentation is from publicly available sources online.

The main references I will be using are:

- [https://hackmii.com/](https://hackmii.com/) (Focuses on Nintendo Wii)
- [https://wiibrew.org/wiki/Main_Page](https://wiibrew.org/wiki/Main_Page) (Focuses on Nintendo Wii)
- [https://xosft.dev/wiki/](https://xosft.dev/wiki/) (Xbox One Research Wiki)
- [https://fail0verflow.com/blog/](https://fail0verflow.com/blog/) (Fail0verflow "focuses on Wii U and PS4")
- [https://www.copetti.org/writings/consoles/](https://www.copetti.org/writings/consoles/) (Great research on the hardware architecture of all consoles)
- [https://www.platformsecuritysummit.com/2019/speaker/chen/](https://www.platformsecuritysummit.com/2019/speaker/chen/) (Great talk by Tony Chen at Microsoft discussing the security architecture of the Xbox One)

---

## Overview

:::::::::::::: {.columns}
::: {.column width="40%"}

- What is a Console?
- Hardware Security Assumptions
- Nintendo Wii
  - System Architecture
  - Secure Boot Process
- Nintendo Wii U
  - System Architecture
  - Secure Boot Process
- Playstation 4
  - System Architecture
- Xbox One
  - System Architecture

:::
::: {.column width="60%"}
![Consoles](./images/consoles.png)
:::
::::::::::::::

::: notes
The boot process of Xbox Ones and PS4s are not that interesting. It’s very similar to the Wii U.

I’m intentionally using the first generation images of each console since the later revisions can come with major hardware changes (e.g. PS4 Pro and Xbox One X).
:::

---

## What is a PC?

^[Source https://fail0verflow.com/media/33c3-slides/#/24](https://fail0verflow.com/media/33c3-slides/#/24)^

- 8259 Programmable Interrupt Controller (PIC)
- 8253 Programmable Interval Timer (PIT)
- 8250 UART at I/O `3f8h`
- 8042 PS/2 Keyboard Controller
- MC146818 RTC/CMOS
- ISA bus
- VGA

---

## What is a Game Console?

### _Not a PC._

::: notes
First things first. Game Consoles are not PCs.

They are unique embedded platforms bespoke silicon and bespoke operating systems.
Assumptions that work for PCs very rarely carry over to consoles.

For instance all the consoles we will discuss have strongly encrypted storage using console managed keys. In a PC sense all of them use full-disk encryption.
:::

---

### PC Security Architecture

**TPM (Trusted Platform Module)**

Security microcontroller handling measurement and secure key storage.

**SGX (Software Guard Extensions)**

Provides application isolation using hardened enclaves.

**Intel CSME / AMD PSP / ARM TrustZone**

Embedded CPU core running manufacturer firmware providing bootstrap, security, and remote management.

::: {.smaller}
_Thanks Guangdong Bai for suggesting this slide._
:::

---

### Hardware Security Assumptions - What’s at Stake

::: {.smaller}

Only the CPU silicon die is trustworthy (not economically feasible to mod 28nm die).

- Intercepting and modifying data on any motherboard bus is easy.
- Any SoC external pin will be manipulated in the worst possible way. JTAG Debug, Clock, voltage, and reset pins are primary targets.
- All PCIe, SATA, USB data can certainly be manipulated.

Current PC hardware design is not resilient against hardware attacks:

- DRAM not encrypted or integrity protected
- Bus between CPU and South Bridge not protected.
  - Most of Intel’s “secure boot” functionality implemented in South Bridge.
  - At boot time, CPU asks South bridge (though insecure bus) whenever it needs to secure boot.
- TPM chip connected to CPU through insecure LPC bus. Any TPM measurement can be forged.

:::

[Source https://www.platformsecuritysummit.com/2019/speaker/chen/](https://www.platformsecuritysummit.com/2019/speaker/chen/)

::: notes
Now about security. Why are consoles so interesting from a security standpoint?

This slide lists a few of the assumptions Microsoft made when developing the security system of the Xbox One.
You can’t trust anything outside the main CPU silicon. Even the pins can be manipulated to lead to security compromises.
The RAM has to be encrypted and protected. Assume that it will be compromised and modified.

Most of the research you’ll see later in this presentation comes from consoles that didn’t yet learn these lessons.
:::

---

## The Nintendo Wii

:::::::::::::: {.columns}
::: {.column width="35%"}
**Architecture:** GameCube++

**CPU:**

- IBM PowerPC “Broadway”
- ARM926EJ-S “Starlet”

**GPU:**

- ATI Graphics (ATI is now owned by AMD)
- GameCube's GPU

**RAM:** “It’s complicated”
:::
::: {.column width="65%"}
![Architecture Diagram](./images/wii-arch.png)
**Source:** [https://www.copetti.org/writings/consoles/wii/](https://www.copetti.org/writings/consoles/wii/)
:::
::::::::::::::

::: notes
The Wii is just a Nintendo GameCube with additional hardware. I won’t be going over the security details of the GameCube in this talk since it’s not super interesting.
Fun fact: Most consoles use AMD GPUs these days. The Nintendo Switch is the odd one out using a Nvidia GPU.
Get used to complicated architecture diagrams.
Yes the Wifi is connected via a SD Card like interface. That’s pretty common.
Looking at this diagram which is the main CPU?
:::

---

### Side Note: One-time Programmable Memory (OTP/eFUSEs)

Super common kind of memory in modern systems that is used to set system configuration at manufacturing time.

You don’t have enough money to reprogram them (requires specialized(/very expensive)) silicon rework hardware.

Common in lots of modern hardware:

- All the consoles we’re talking about.
- Most Android Phones.
- All iPhones/iPads/iOS devices.

::: notes
As a side note since it will keep coming up.
One time programmable memory (sometimes called eFUSEs) are super common in modern hardware from your mobile phones to game consoles.
They are little metal jumpers inside the CPU that get overvolted to program them. This programming processes involves “blowing” this part of the system using high voltage.
They are the difference between super open development hardware and the locked down devices that are sold to consumers.
:::

---

## Wii: Starlet vs. Broadway

**Broadway (IBM PowerPC (PPC))**

- It’s where the games (and System Menu) run.
- Runs a Operating System called Revolution OS.
- Controlled by Starlet.

**Starlet (ARM)**

- It’s where the main “operating system” (IOS) runs.
- Connected to hardware.
- Handles the boot process for the rest of the system.

::: notes
The Nintendo Wii has 2 different processors. The Starlet and the Broadway.
The Starlet is a ARM core and the Broadway is a PowerPC core (like Apple used to run on it’s Macs).
PowerPC was common for this console generation. The Xbox 360 and Playstation 3 both had PowerPC based processors.
IOS here does not refer to Apple’s iOS or Cisco’s IOS (It has no relation to either).
There is no real operating system running on Broadway. Games from this generation (and previous) provide their own operating system and run independently of other software.
:::

---

## Wii Operating System: IOS

- It’s not really a normal operating system.
- It’s a Microkernel (If you’ve used Minix before it looks familiar).
- It’s closest relative is Unix or Plan 9.
- The Wii stores multiple copies of IOS and games each target a specific version.
- The version of IOS being used can be changed easily.

::: notes
As I said before there’s no real operating system running on Broadway. Each game brings its own Operating System.
Starlark does run a real operating system called IOS. It’s a vaguely a Microkernel and looks kinda like Unix on the surface.
IOS runs at a higher permission level than code running on Broadway (e.g. the System Menu and Games).
:::

---

![**Wii Boot Process**](./images/wii-boot-process.svg)

::: notes
Now onto the boot process.
All of this establishes a “Chain of Trust”. Everything running on the system has to be approved by the code running before it. The root is Nintendo so they have final say in what runs on the Wii.

Boot0 is the first thing that runs when you turn on your Wii. It comes from “Mask ROM” which is part of the silicon.
Boot1 is loaded from flash by Boot0.
Boot2 is loaded from flash by Boot1 etc.

So why all the steps.
Mask ROM is really expensive so Boot0 had to be super small. All it can do is load Boot1 and check it’s hash against a SHA1 stored in One-time Programmable Memory.
Boot1 loads Boot2 from flash and uses RSA signature verification to verify it. Boot2 can therefore be updated.
Boot2 loads IOS which loads the system menu. This is verified using a system of “Tickets” which are too much of a tangent to get into right now.
Boot1 can not be updated once the console leaves the factory. Boot2 has been updated by Nintendo (not very successfully).
:::

---

## Notable Wii Exploits

**Tweezer Attack**

- Shorting address pins while in GameCube compatibility mode allowed dumping of memory.

**Twilight Hack**

- It’s a buffer overflow in the save data of The Legend of Zelda: Twilight Princess.

**Boot1 Fake-signing Bug**

- Allows replacing Boot2 with a custom executable. Gives full low-level control over the system.
  Not fixable in software since Boot1 can’t be updated.

::: notes
And finally what are the exploits.

The tweezer attack started it all. Since the Gamecube mode was relatively easy to compromise people started there and moved upwards.
The tweezer attack allowed dumping significant parts of system memory early in the console’s lifecycle.

“Fake-signing” refers to a process to forge a digital signature. In this case it was used to make a replacement for Boot2 allowing lower level control of the Nintendo Wii.
Also very useful as brick protection since the Nintendo Wii is a very fragile piece of hardware.

A lot of these exploits were made easier since the Wii only verifies software as it’s being installed. Once it’s on the system it’s considered trusted.
:::

---

## The Nintendo Wii U

:::::::::::::: {.columns}
::: {.column width="35%"}

**Architecture:** Wii++ (Not a PC)

**CPU:**

- 3 core IBM “Espresso”
- ARM “Starbuck”

**GPU:**

- Wii’s GPU (Based on ATI)
- AMD Radeon

**RAM:** 2 GB (+ some other bits)

:::
::: {.column width="65%"}
![Architecture Diagram](./images/wiiu-arch.webp)
**Source:** [https://www.copetti.org/writings/consoles/wiiu/](https://www.copetti.org/writings/consoles/wiiu/)
:::
::::::::::::::

::: notes
Welcome to the Wii U.
Nintendo had a hell of a time advertising this at the start since everyone thought it was a Wii. Everyone was only mostly wrong.
Notice here how there’s nothing removed compared to the Wii but only some new additions. This is for backwards compatibility reasons.
The big additions here are more processors, more RAM, and a modern GPU.
Otherwise the Architecture looks like more of the same. The “Latte” is still the main CPU and the Espresso is under its control.
:::

---

## Wii vs. Wii U: Overview

| **Wii**                                                                                                              | **Wii U**                                                                                                    |
| -------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| Games run on the Broadway, on the bare metal.                                                                        | Runs Cafe OS, a custom multiprocess OS running on the Espresso with process isolation and memory management. |
| The Starlet runs IOS, a microkernel OS handling security, crypto and I/O services                                    | Similar, but IOS is larger and significantly changed (we call it IOSU).                                      |
| Games and software are loaded from disc or NAND flash. RSA signatures checked at installation time, not launch time. | Also includes 8 or 32GB of eMMC storage for user software. RSA signatures also checked at launch time.       |

[Source https://fail0verflow.com/media/30c3-slides/#/6](https://fail0verflow.com/media/30c3-slides/#/6)

::: notes
Rather than looking at the entire architecture of the Wii U let’s just talk about the differences from the Wii.

There are a few useful security advancements here and a real operating system running on Espresso.
The Wii used to effectively implement device drivers inside games so this is a major advancement.
:::

---

![**Wii U Boot Process**](./images/wiiu-boot-process.svg)

::: notes
The Wii U boots in mostly the same way as the Wii but we see a few more parts going on here.
Unlike the Wii the Wii U runs a operating system on the Espresso called Cafe OS.
Revolution OS is more of a shared software library linked into games rather than a traditional operating system.

Boot0 and Boot1 are now effectively merged and running from Mask ROM.
It also supports booting a signed recovery image which is a super useful compared to the Wii which could be easily broken by badly written software.
Boot2 (technically Boot1) handles booting IOSU.

There’s a separate Chain of Trust for the Espresso started from a “Mask ROM”. It boots signed and encrypted “ancast” images only.
This boots Cafe OS which is a real operating system running on Espresso.

We also see some backwards compatibility here in the form of “cafe2wii”. This temporarily makes your Wii U a Wii and allows you to run Wii games.
:::

---

## Wii U Exploits

**_Wii Compatibility Mode_ exploits**

- They got in through the Nintendo Wii compatibility mode.

**Nintendo**

- They left a memory flag to reenable boot0.
- They didn’t strip the symbols of cafe2wii.

**WebKit bugs**

- Incredibly common and super boring.

---

### The Sony Playstation 4: Overview

:::::::::::::: {.columns}
::: {.column width="35%"}

The most PC-like _not a PC_ we’ve seen so far.

- It has a x86_64 CPU
- It has a AMD GPU
- It runs FreeBSD

:::
::: {.column width="65%"}
![](./images/ps4-highres.jpg)
:::
::::::::::::::

::: notes
The PS4 looks like a PC on the surface.
It has a x86_64 CPU. It could technically run Windows or Linux.
It has a AMD GPU. You might have something very similar in your laptop/desktop.
It runs FreeBSD which you can download and run on your desktop now.
But it’s not quite that simple.

The PS4 is a real oddity.
The hard drive is connected via USB (technically it has USB-to-SATA internally)
That Aeolia southbridge should look familiar to people who were listening 5 minutes ago when we were talking about the Wii and Wii U.
It’s not that though. The Southbridge is running FreeBSD as well but it doesn’t have nearly the same level of control as the ARM CPU on the Wii and Wii U.
And what did I say about it running FreeBSD?
:::

---

### The Sony Playstation 4

:::::::::::::: {.columns}
::: {.column width="35%"}

**Architecture:** Like a PC (but…)

**CPU:**

- AMD x86_64
- Marvell Armada (ARM)

**GPU:**

- AMD GCN “Sea Islands”

**RAM:** 8GB
:::
::: {.column width="65%"}
![Architecture Diagram](./images/ps4-arch.svg)
:::
::::::::::::::

::: notes
The PS4 runs an operating system based on FreeBSD. It provides a very FreeBSD like user space API to games with a few custom additions.

Both the PS3 and PS5 run a operating system of the same lineage.

Yes the system menu is written in C# and runs with Mono. Sony used to be kinda interesting in getting people to run games in .Net around the same time Microsoft was (does anyone remember XNA).
:::

---

## {data-background-image="./images/ps4-system-menu.jpg"}

It’s based on FreeBSD with plenty of modifications by Sony.

The PS3, PS4, and PS5 all use similar operating systems.

The system menu is written in C#.

::: notes
I didn’t put anything on this slide since the content is so boring.

The PS4 runs a derivative of FreeBSD and Sony did a bunch of random changes. Once you get code running in userland your pretty close to getting something running in kernel mode.

How do you get something running in Userland? Well it has a web browser so you just exploit the browser.
:::

---

### PS4 Exploits

- Webkit
- FreeBSD Kernel Exploits

---

### The Microsoft Xbox One

:::::::::::::: {.columns}
::: {.column width="50%"}

**Architecture:** Not a PC (not a PC4 either).

**CPUs:** AMD x86_64

**GPUs:** AMD Radeon

**RAM:** 8GB

**Operating System:** Windows

:::
::: {.column width="50%"}
![Xbox One Architecture Diagram](./images/durango_southbridge_soc.gif)
:::
::::::::::::::

_Source: [https://xosft.dev/wiki/southbridge/](https://xosft.dev/wiki/southbridge/)_

::: notes
On the surface this may remind you fo the PS4. The similarities end with the CPU core and GPU core.
The Southbridge is considered untrusted on the Xbox One.
The Main SoC is definitely the main CPU on the system. Everything is running there.
The Xbox One runs Windows (I’ll elaborate on this soon).
:::

---

## What is Windows?

:::::::::::::: {.columns}
::: {.column width="50%"}

**Windows NT Kernel**

- Uses native APIs.
- Internally structured like Unix but different.
- Uses UNC path notation as the “native” format.
- First released in 1993 (Happy Birthday in July).

:::
::: {.column width="50%"}

**Win32 APIs**

- First released in 1985.
- Uses `C:\` and other drive letters.
- Your Windows desktop and most Windows UI is provided by Win32.
- A completely different set of APIs to the NT Native APIs.

:::
::::::::::::::

All the Xbox consoles have used derivatives of Windows NT.

The Xbox One(/ Series X/S) run some Win32 APIs but not everything.

::: notes
So I just said the Xbox runs Windows.

That depends on your definition of Windows though.
It doesn’t have a Desktop or support for running regular Windows apps.
It does have drive letters but many more than your used to.
:::

---

### Hypervisors on Game Consoles

:::::::::::::: {.columns}
::: {.column width="50%"}

**Does not have a Hypervisor**

- Playstation 4
- Nintendo Wii
- Nintendo Wii U
- Nintendo Switch

:::
::: {.column width="50%"}

**Has a Hypervisor**

- Playstation 3
- Playstation 5
- Xbox 360
- Xbox One
- Xbox Series S/X

:::
::::::::::::::

**What is a Hypervisor**

A Hypervisor virtualizes access to hardware resources. At a basic level it intercepts any hardware access and turns it into a protected interrupt.

::: notes
Well oops.

So a core part of the system architecture of the Xbox One is its use of a Hypervisor to segment different kinds of applications.

These are super common on consoles except the ones we’ve talked about.

On the Wii and Wii U IOS and IOSU act as mediators for hardware access so are analogous to hypervisors on those platforms. But they act more like weird operating systems rather than the machine virtualisation done on the consoles with hypervisors.

As a general note the consoles running hypervisors have more than one operating system running at the same time.
:::

---

### Xbox One Operating Systems

**Host OS:** Host operating system running modified Windows 8. No GUI presented to the User.

**System OS:** Runs the main UI and dashboard. Based on Windows 'OneCoreUAP'.

**Game/ERA OS:** Games run inside here. Uses Windows 8 like Host OS but modified.

::: notes
There are 3 different Windows installations you deal with on the Xbox One.

The Host OS is the first operating system that boots and it hosts all the Virtual Machines.
The System OS is what you interact with day-to-day. It’s also where most of the applications run. There’s less resources available here.
The Game/ERA OS is only used for games. Each game gets its own Virtual Machine. Here you can use most of the consoles resources.
:::

---

### Xbox One Exploits

Nothing Notable.

::: notes
The Xbox One has kept to a very high degree of system security.

This is down to a few basic reasons.
The web browser requires a connection to Xbox Live and up-to-date system software. This means any browser based exploits are highly limited.
There’s a development mode you can enable that gives you sandboxed access to System OS. That’s all you really need for Homebrew.
The console runs Windows so any exploits targeting the console possibility target desktop Windows as well. This means anyone who discovers an exploit is more likely to sell it rather than use it for piracy.

The research that has happened is due to leaked console development kits mostly.
:::

---

### Developer Kits

- Requires a NDA to purchase (\*).
- Modern ones need regular internet access to work (\*).
- Generally the same hardware (maybe more networking or RAM).
  - _For the Xbox One it's exactly the same hardware. (\*)_
- Connects to a PC and runs development signed code (\*).
- Can't run retail games (\*).

---

### Other Consoles

**Playstation 3**

- Thoroughly compromised due to a signing bug in the system. (Similar to Nintendo Wii)
- Runs a similar operating system to the PS4 and weird hardware based on IBM’s Cell processor.

**Nintendo Switch**

- Uses a Nvidia Tegra SoC.
- Old consoles have a bootrom vulnerability granting low-level access.
- Runs a variant of the Nintendo 3DS’s operating system rather than something Wii/Wii U like.

**iPhone/iPad/Apple Silicon Macs**

- Not a game console but share a similar security architecture.

::: notes
I didn’t have time to cover all the consoles in this presentation. Here are just a few more interesting ones.
:::

---

## {data-background-image="./images/ship_of_theseus.jpg"}

### What is a PC?

- ~~8259 Programmable Interrupt Controller (PIC)~~ _APIC_
- ~~8253 Programmable Interval Timer (PIT)~~ _APIC_
- ~~8250 UART at I/O `3f8h`~~ _USB_
- ~~8042 PS/2 Keyboard Controller~~ _USB_
- ~~MC146818 RTC/CMOS~~ _Part of the Southbridge_
- ~~ISA bus~~ _PCI Express_
- ~~VGA~~ _Discrete Graphics with a GPU_

PS4, Wii, Wii U support Linux.

Xbox One runs (modified) Windows.

::: {.smaller}
_Background Image Credit: Chatterton, E. Keble (Edward Keble), 1878–1944_

_[What is a PC source: https://fail0verflow.com/media/33c3-slides/#/24](https://fail0verflow.com/media/33c3-slides/#/24)_
:::

---

## Thanks for Listening
