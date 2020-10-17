# :wrench: ~/. dotfiles for Arch Linux [![Build status](https://img.shields.io/travis/aureooms/dotfiles/master.svg)](https://travis-ci.org/aureooms/dotfiles/branches)

<img src="https://imgs.xkcd.com/comics/the_general_problem.png" width="864">

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

### Install appropriate graphics driver

Usually **one of the following**.
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

See also [Bumblebee](https://wiki.archlinux.org/index.php/Bumblebee) to save
laptop battery or power.

### Install system
Logout, login, then

    up -i

### Update system

    up -a


## :woman_astronaut: Usage

See [wiki](https://github.com/aureooms/dotfiles/wiki).


## :clap: Credits

  - https://github.com/mathiasbynens/dotfiles
  - https://github.com/thomacer/dotfiles
