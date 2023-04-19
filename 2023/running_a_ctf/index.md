---
author: Joshua D. Scarsbrook
title: Running a Capture the Flag Challenge
subtitle: It's like making a Cyber Security Game 😁
date: April 19th, 2023
---

### `joshua@joshua-pc3 $ whoami`

Joshua Scarsbrook

Research Officer/PhD Student at the University of Queensland

Researching Applied Cyber Security and Cyber Security in Education

Interested in Operating Systems and Embedded Hardware

---

## Overview

- Designing a CTF
- Designing Challenges
- Setting up Infrastructure

---

## Reasons to run a CTF

- Training
- Selection
- Engagement
- Research

---

## Consider your Audience

- Who are they?
- What experience level?
- What hardware will they have?
- How long is the CTF?

---

## Challenge Categories

### Main Ones

- Reverse Engineering
- Binary Exploitation
- Web Application Security
- Cryptography
- Forensics

### Others

- OSINT (Open Source Intelligence)
- Mobile Applications
- Cloud
- Hardware
- Cryptocurrencies / Smart Contracts

---

## Challenge Ideas / Difficulty Level

- These are not hard boundaries.
- A badly designed Hard challenge can turn into a Easy challenge.
- Just like a badly designed Easy challenge can turn into a h4sh challenge.
- Keep in mind the infrastructure and coding.
  - Hosting a VM for each participant is not easy to get right.

---

### Beginner

- Web Exploitation
  - SQL Injection.
  - Cross-site Scripting.
- Forensics
  - File Metadata
- Cryptography
  - Caesar Cipher

---

### Intermediate

- Basic Binary Exploitation
  - Disable modern mitigation's.
  - Buffer Overflows.
- Reverse Engineering
  - C / Golang / Rust / C#
- Forensics
  - Disk Image forensics

---

### Hard

- Advanced Binary Exploitation
  - ROP Chains
  - Static/Dynamic Analysis
- Forensics
  - Memory forensics

---

### `h4sh`

- Linux Kernel Exploits
- Browser Exploits
- Custom Operating Systems
- BIOS Exploits
- Satellites

---

## Challenge Design

- Learn about game design. A CTF is just a domain-specific game.

---

## Writing a Challenge

- Most challenges are written in JavaScript, Python, or C.
  - This is because most people are familiar with coding in these languages.
  - Sometimes you want to use a more exotic language.
- We'll be writing a easy web challenge in Python.

---

## Infrastructure Overview

- We're starting with 2 Ubuntu VMs.
- Where they're hosted doesn't matter too much.
- The installation is already done and now we'll setup the software.
  - The install took about an hour.

---

## Setting up Tailscale

[https://tailscale.com/download/linux](https://tailscale.com/download/linux)

`curl -fsSL https://tailscale.com/install.sh | sh`

_Manual Instructions also exist_

Connect over SSH.

---

## Setting up CTFd using Docker Compose

- [https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)
  - Don't install Docker Desktop
  - Don't install from package repos or snap (can be an old version)
- [https://docs.ctfd.io/docs/deployment/installation](https://docs.docker.com/engine/install/ubuntu/)

---

## Using Tailscale Funnel

It configures HTTPS for you and lets you connect to any machine on your Tailnet over the internet.

`tailscale serve https / http://127.0.0.1:3000`

---

## Adding the Challenge

- Setup Tailscale on the challenge machine.
- Setup Docker on the challenge machine.
- Run the challenge using Docker.
- Run `tailscale serve`.
