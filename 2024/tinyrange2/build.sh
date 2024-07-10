#!/bin/bash

set -ex

pandoc -t revealjs --slide-level=2 -s -o index.html index.md -V revealjs-url=https://unpkg.com/reveal.js/ --include-in-header=slides.html --reference-location=block