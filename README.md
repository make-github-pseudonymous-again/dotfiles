:wrench: ~/. dotfiles for Arch Linux
[![Build status](https://img.shields.io/travis/aureooms/dotfiles/master.svg)](https://travis-ci.org/aureooms/dotfiles/branches)
==

<p align="center">
<a href="https://xkcd.com/974">
<img src="https://imgs.xkcd.com/comics/the_general_problem.png" width="600">
</a><br/>
© <a href="https://xkcd.com">xkcd.com</a>
</p>

## :raising_hand_man: Advisory

Many scripts will cache data on your drive. This data can be used to
impersonate you. Encrypt your drive before it is too late.

## :rocket: Getting started

### Clone

    cd
    cd dev
    git clone https://github.com/aureooms/dotfiles
    cd dotfiles

### Install software

    sudo sh bootstrap/install-base

### Install dotfiles

    bash bootstrap/dotfiles-update

### Install hardware-dependent software

#### Graphics

Usually **one** of the following drivers will work.
Check the
[intel graphics](https://wiki.archlinux.org/index.php/Intel_graphics),
[nvidia](https://wiki.archlinux.org/index.php/NVIDIA),
and 
[nouveau](https://wiki.archlinux.org/index.php/nouveau)
pages on the wiki.

    pacman -S mesa vulkan-intel
    pacman -S mesa xf86-video-intel
    pacman -S xf86-video-nouveau
    pacman -S xf86-video-ati
    pacman -S nvidia


#### Microcode

Configure [early loading of microcode updates](https://wiki.archlinux.org/index.php/Microcode#Early_loading)
depending on your CPU (if AMD or Intel).


#### SSD ATA_TRIM

Setup
[trimming](https://wiki.archlinux.org/index.php/Solid_state_drive#TRIM) for all
solid-state drives partitions (including the ones under LUKS).


#### Power

In general, check out [*Power management* on the Arch wiki](https://wiki.archlinux.org/index.php/Power_management).

For systems with hybrid graphics (with both an integrated GPU and a dedicated
GPU), see [Bumblebee](https://wiki.archlinux.org/index.php/Bumblebee) to save
laptop battery or energy.

#### Heat

Consider installing [`thermald`](https://wiki.archlinux.org/index.php/CPU_frequency_scaling#thermald).

### Install system
Logout, login, then

    up -i

### Update system

    up -a


## :woman_astronaut: Usage

See [wiki](https://github.com/aureooms/dotfiles/wiki).

## :construction: Plugins (beta)

This repository has grown so large that, without modification or curation, it
is unusable for anybody other than myself. To palliate this issue, I started
moving important functionality away from this repository. The ultimate goal
would be to have a plugin/package and dependency handling system that would
work in the realm of configuration files and scripts. See my [list of *dotfiles
packages*](https://github.com/aureooms?tab=repositories&q=dotfiles) and the
[instruction to install a *dotfiles plugin*](https://github.com/aureooms/dotfiles/wiki/Plugins).

## :clap: Credits

  - [Mathias Bynens](https://github.com/mathiasbynens/dotfiles)
  - [Thomas Perale](https://github.com/tperale/dotfiles)
  - [Chris Down](https://github.com/cdown/dotfiles)
  - [xkcd#974](https://www.explainxkcd.com/wiki/index.php/974)
  - [xkcd#1205](https://www.explainxkcd.com/wiki/index.php/1205)
  - [xkcd#1319](https://www.explainxkcd.com/wiki/index.php/1319)
