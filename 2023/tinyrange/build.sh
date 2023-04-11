#!/bin/bash

set -ex

pandoc -t revealjs -s -o index.html index.md -V revealjs-url=https://unpkg.com/reveal.js/ --include-in-header=slides.html --reference-location=block