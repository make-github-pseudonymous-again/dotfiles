# ~/. dotfiles for Arch Linux

<img src="https://imgs.xkcd.com/comics/the_general_problem.png" width="864">

## Getting started

### Install sak

    mkdir ~/.bin
    git clone https://github.com/aureooms/sak
    cd sak
    make install

### Clone

    git clone https://github.com/aureooms/dotfiles
    cd dotfiles

### Install software

    sudo sh bootstrap/install-base

### Install dotfiles

    bash bootstrap/dotfiles-update

Restart X, then

### Install system

    up -i

### Update system

    up -a


## Usage

See [wiki](https://github.com/aureooms/dotfiles/wiki).


## Credits

  - https://github.com/mathiasbynens/dotfiles
  - https://github.com/thomacer/dotfiles
