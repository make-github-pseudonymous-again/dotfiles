# ~/. dotfiles for Arch Linux

<img src="https://imgs.xkcd.com/comics/the_general_problem.png" width="864">

## Advisory

Many scripts will cache data on your hard drive. This data can be used to
impersonate you. Encrypt your hard drive before it is too late.

## Getting started

### Clone

    cd
    cd dev
    git clone git@github.com:aureooms/dotfiles
    cd dotfiles

### Install software

    sudo sh bootstrap/install-base

### Install dotfiles

    bash bootstrap/dotfiles-update

### Install appropriate graphics driver

Usually one of the following, check the
[intel graphics](https://wiki.archlinux.org/index.php/Intel_graphics),
[nvidia](https://wiki.archlinux.org/index.php/NVIDIA),
and 
[nouveau](https://wiki.archlinux.org/index.php/nouveau)
pages on the wiki.

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


## Usage

See [wiki](https://github.com/aureooms/dotfiles/wiki).


## Credits

  - https://github.com/mathiasbynens/dotfiles
  - https://github.com/thomacer/dotfiles
