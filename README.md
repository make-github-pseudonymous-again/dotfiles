:wrench: ~/. dotfiles for Arch Linux
[![Tests](https://img.shields.io/github/actions/workflow/status/make-github-pseudonymous-again/dotfiles/ci:test.yml?branch=master&event=push&label=tests)](https://github.com/make-github-pseudonymous-again/dotfiles/actions/workflows/ci:test.yml?query=branch:master)
==

<p align="center">
<a href="https://xkcd.com/974">
<img src="https://imgs.xkcd.com/comics/the_general_problem.png" width="600">
</a><br/>
© <a href="https://xkcd.com">xkcd.com</a>
</p>

## :raising_hand_man: Advisory

Many scripts will cache data on your storage device. This data can be used to
impersonate you. Encrypt your storage device before it is too
late.[\*](#warning-please-use-storage-device-encryption)

## :rocket: Getting started

### Clone

    cd
    cd dev
    git clone https://github.com/make-github-pseudonymous-again/dotfiles
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

See [wiki](https://github.com/make-github-pseudonymous-again/dotfiles/wiki).

## :construction: Plugins (beta)

This repository has grown so large that, without modification or curation, it
is unusable for anybody other than myself. To palliate this issue, I started
moving important functionality away from this repository. The goal would be to
have a plugin/package and dependency handling system that would work in the
realm of configuration files and scripts. See my [list of *dotfiles
packages*](https://github.com/make-github-pseudonymous-again?tab=repositories&q=dotfiles) and the
[instructions to install a *dotfiles plugin*](https://github.com/make-github-pseudonymous-again/dotfiles/wiki/Plugins).

## :warning: Please use storage device encryption
The [advisory](#raising_hand_man-advisory) above remains relevant even if you do not use these
configuration files: you most probably do not use a stateless machine that
forgets everything on each reboot.
Inside your *permanent* storage device you
will find *temporary* authentication keys/tokens (e.g. a subset of the
browser *cookies*) for all kinds of services (your bank, your e-mail
provider, ...).
This is so for *convenience* and is considered standard practice.

A lower bound on the number of services directly vulnerable to impersonation
attacks in case of theft of your computer can be computed by taking the sum of
services you actively use and for which you *conveniently* do not have to
enter a password each time you reboot. In most cases, this number is quite
high.

Once theft as occurred, in order to defend yourself effectively, you have to
revoke all stolen keys/tokens **before they get abused**. Do you have a list?
Are you fast at keyboard typing and point-and-click games? Do you enjoy
stressful situations?

Fortunately, a lot of services have traded convenience for security. For
instance most banks would use [*Multi-factor
authentication*](https://en.wikipedia.org/wiki/Multi-factor_authentication)
(e.g. Two-factor authentication, or 2FA) to sign any transaction, service
change, or even login. Also most of these temporary keys and tokens are
really temporary: if your thief waits for too long he will not be able to
abuse them.

However, considering I have only given you a glimpse at the list of possible
attack vectors enabled by data theft (do you want your family pictures to be
dumped on the web?) and considering the availability of good encryption
software on most modern operating systems (for server, desktop, laptop,
**tablet**, **and mobile**), you should consider the investment worth it.

Oh! And *theft* does not need to occur inside your 24/7 camera-covered,
dog-guarded, three-meter-high-fenced property. It can happen anywhere you
bring your portable devices. It can also happen in a dumpster, right after
you *"recyled"* your *"old"* device.

Please use storage device encryption.


## :clap: Credits

  - [Mathias Bynens](https://github.com/mathiasbynens/dotfiles)
  - [Thomas Perale](https://github.com/tperale/dotfiles)
  - [Chris Down](https://github.com/cdown/dotfiles)
  - [xkcd#974](https://www.explainxkcd.com/wiki/index.php/974)
  - [xkcd#1205](https://www.explainxkcd.com/wiki/index.php/1205)
  - [xkcd#1319](https://www.explainxkcd.com/wiki/index.php/1319)
