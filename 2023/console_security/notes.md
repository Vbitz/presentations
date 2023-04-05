# Overview

The boot process of Xbox Ones and PS4s are not that interesting. It’s very similar to the Wii U.

I’m intentionally using the first generation images of each console since the later revisions can come with major hardware changes (e.g. PS4 Pro and Xbox One X).

# What is a Game Console?

First things first. Game Consoles are not PCs.

They are unique embedded platforms bespoke silicon and bespoke operating systems.
Assumptions that work for PCs very rarely carry over to consoles.

For instance all the consoles we will discuss have strongly encrypted storage using console managed keys. In a PC sense all of them use full-disk encryption.

# Hardware Security Assumptions

Now about security. Why are consoles so interesting from a security standpoint?

This slide lists a few of the assumptions Microsoft made when developing the security system of the Xbox One.
You can’t trust anything outside the main CPU silicon. Even the pins can be manipulated to lead to security compromises.
The RAM has to be encrypted and protected. Assume that it will be compromised and modified.

Most of the research you’ll see later in this presentation comes from consoles that didn’t yet learn these lessons.

# The Nintendo Wii

The Wii is just a Nintendo GameCube with additional hardware. I won’t be going over the security details of the GameCube in this talk since it’s not super interesting.
Fun fact: Most consoles use AMD GPUs these days. The Nintendo Switch is the odd one out using a Nvidia GPU.
Get used to complicated architecture diagrams.
Yes the Wifi is connected via a SD Card like interface. That’s pretty common.
Looking at this diagram which is the main CPU?

# Side Note: One-time Programmable Memory (OTP/eFUSEs)

As a side note since it will keep coming up.
One time programmable memory (sometimes called eFUSEs) are super common in modern hardware from your mobile phones to game consoles.
They are little metal jumpers inside the CPU that get overvolted to program them. This programming processes involves “blowing” this part of the system using high voltage.
They are the difference between super open development hardware and the locked down devices that are sold to consumers.

# Wii: Starlet vs. Broadway

The Nintendo Wii has 2 different processors. The Starlet and the Broadway.
The Starlet is a ARM core and the Broadway is a PowerPC core (like Apple used to run on it’s Macs).
PowerPC was common for this console generation. The Xbox 360 and Playstation 3 both had PowerPC based processors.
IOS here does not refer to Apple’s iOS or Cisco’s IOS (It has no relation to either).
There is no real operating system running on Broadway. Games from this generation (and previous) provide their own operating system and run independently of other software.

# Wii Operating System: IOS

As I said before there’s no real operating system running on Broadway. Each game brings its own Operating System.
Starlark does run a real operating system called IOS. It’s a vaguely a Microkernel and looks kinda like Unix on the surface.
IOS runs at a higher permission level than code running on Broadway (e.g. the System Menu and Games).

# Wii Boot Process

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

# Wii Exploits

And finally what are the exploits.

The tweezer attack started it all. Since the Gamecube mode was relatively easy to compromise people started there and moved upwards.
The tweezer attack allowed dumping significant parts of system memory early in the console’s lifecycle.

“Fake-signing” refers to a process to forge a digital signature. In this case it was used to make a replacement for Boot2 allowing lower level control of the Nintendo Wii.
Also very useful as brick protection since the Nintendo Wii is a very fragile piece of hardware.

A lot of these exploits were made easier since the Wii only verifies software as it’s being installed. Once it’s on the system it’s considered trusted.

# The Nintendo Wii U

Welcome to the Wii U.
Nintendo had a hell of a time advertising this at the start since everyone thought it was a Wii. Everyone was only mostly wrong.
Notice here how there’s nothing removed compared to the Wii but only some new additions. This is for backwards compatibility reasons.
The big additions here are more processors, more RAM, and a modern GPU.
Otherwise the Architecture looks like more of the same. The “Latte” is still the main CPU and the Espresso is under its control.

# Wii vs. Wii U

Rather than looking at the entire architecture of the Wii U let’s just talk about the differences from the Wii.

There are a few useful security advancements here and a real operating system running on Espresso.
The Wii used to effectively implement device drivers inside games so this is a major advancement.

# Wii U Boot Process

The Wii U boots in mostly the same way as the Wii but we see a few more parts going on here.
Unlike the Wii the Wii U runs a operating system on the Espresso called Cafe OS.
Revolution OS is more of a shared software library linked into games rather than a traditional operating system.

Boot0 and Boot1 are now effectively merged and running from Mask ROM.
It also supports booting a signed recovery image which is a super useful compared to the Wii which could be easily broken by badly written software.
Boot2 (technically Boot1) handles booting IOSU.

There’s a separate Chain of Trust for the Espresso started from a “Mask ROM”. It boots signed and encrypted “ancast” images only.
This boots Cafe OS which is a real operating system running on Espresso.

We also see some backwards compatibility here in the form of “cafe2wii”. This temporarily makes your Wii U a Wii and allows you to run Wii games.

# The Sony Playstation 4

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

# PS4 Operating System

The PS4 runs an operating system based on FreeBSD. It provides a very FreeBSD like user space API to games with a few custom additions.

Both the PS3 and PS5 run a operating system of the same lineage.

Yes the system menu is written in C# and runs with Mono. Sony used to be kinda interesting in getting people to run games in .Net around the same time Microsoft was (does anyone remember XNA).

# PS4 Exploits

I didn’t put anything on this slide since the content is so boring.

The PS4 runs a derivative of FreeBSD and Sony did a bunch of random changes. Once you get code running in userland your pretty close to getting something running in kernel mode.

How do you get something running in Userland? Well it has a web browser so you just exploit the browser.

# The Microsoft Xbox One

On the surface this may remind you fo the PS4. The similarities end with the CPU core and GPU core.
The Southbridge is considered untrusted on the Xbox One.
The Main SoC is definitely the main CPU on the system. Everything is running there.
The Xbox One runs Windows (I’ll elaborate on this soon).

# What is Windows?

So I just said the Xbox runs Windows.

That depends on your definition of Windows though.
It doesn’t have a Desktop or support for running regular Windows apps.
It does have drive letters but many more than your used to.

# Hypervisors on Game Consoles

Well oops.

So a core part of the system architecture of the Xbox One is its use of a Hypervisor to segment different kinds of applications.

These are super common on consoles except the ones we’ve talked about.

On the Wii and Wii U IOS and IOSU act as mediators for hardware access so are analogous to hypervisors on those platforms. But they act more like weird operating systems rather than the machine virtualisation done on the consoles with hypervisors.

As a general note the consoles running hypervisors have more than one operating system running at the same time.

# Xbox One Operating Systems

There are 3 different Windows installations you deal with on the Xbox One.

The Host OS is the first operating system that boots and it hosts all the Virtual Machines.
The System OS is what you interact with day-to-day. It’s also where most of the applications run. There’s less resources available here.
The Game/ERA OS is only used for games. Each game gets its own Virtual Machine. Here you can use most of the consoles resources.

# Xbox One Exploits

The Xbox One has kept to a very high degree of system security.

This is down to a few basic reasons.
The web browser requires a connection to Xbox Live and up-to-date system software. This means any browser based exploits are highly limited.
There’s a development mode you can enable that gives you sandboxed access to System OS. That’s all you really need for Homebrew.
The console runs Windows so any exploits targeting the console possibility target desktop Windows as well. This means anyone who discovers an exploit is more likely to sell it rather than use it for piracy.

The research that has happened is due to leaked console development kits mostly.

# Other Consoles

I didn’t have time to cover all the consoles in this presentation. Here are just a few more interesting ones.
