# ~/. dotfiles for Arch Linux

![screenshot](https://raw.githubusercontent.com/aureooms/dotfiles/master/files/screenshot.png)
![screenshot](https://raw.githubusercontent.com/aureooms/dotfiles/master/files/screenshot-weather.png)
![screenshot](https://raw.githubusercontent.com/aureooms/dotfiles/master/files/lockscreen.png)

## Getting started

### Install sak

    mkdir ~/.bin
    git clone https://github.com/aureooms/sak
    cd sak
    make install

### Clone

    git clone https://github.com/aureooms/dotfiles --recursive
    cd dotfiles

### Install software

    sudo sh bootstrap/install-base

### Install dotfiles

    bash bootstrap/dotfiles-update

Restart X, then

### Install system

    update -aC

## Usage

### i3

| Key Combination                 | Description                                                                                            |
| ------------------------------- | ------------------------------------------------------------------------------------------------------ |
| winkey + <kbd>p</kbd>                 | Opens a new terminal.                                                                             |
| winkey + <kbd>o</kbd>           | Launch dmenu.                                                                  |
| winkey + shift + <kbd>a</kbd>           | Kill focused window.                                                               |
| winkey + <kbd>j</kbd>           | Change focus (left).                                                                |
| winkey + <kbd>k</kbd>           | (down).                                                           |
| winkey + <kbd>l</kbd>           | (up).                                                                  |
| winkey + <kbd>m</kbd>           | (right).               
| winkey + shift + <kbd>j</kbd>   | Move window (left).                                                                |
| winkey + shift + <kbd>k</kbd>   | (down).                                                           |
| winkey + shift + <kbd>l</kbd>   | (up).                                                                  |
| winkey + shift + <kbd>m</kbd>   | (right).
| winkey + <kbd>h</kbd>           | Split in horizontal orientation.
| winkey + <kbd>v</kbd>           | Split in vertical orientation.
| winkey + <kbd>f</kbd>           | Fullscreen the current window.
| winkey + <kbd>s</kbd>           | Change layout (stacked).
| winkey + <kbd>z</kbd>           | (tabbed).
| winkey + <kbd>e</kbd>           | (change the split).
| winkey + shift + space   | Toggle floating window.
| winkey + space                  | Change focus between tiling and floating windows
| winkey + <kbd>1</kbd> - <kbd>0</kbd> | Change workspace.
| winkey + shift + <kbd>1</kbd> - <kbd>0</kbd> | Move currently focused window.
| winkey + <kbd>r</kbd>           | Resize mode.
| winkey + <kbd>PrtScrn</kbd>     | Screenshot.
| winkey + volume up   | Volume UP.
| winkey + volume down   | Volume DOWN.
| winkey + <kbd>semicolon</kbd>           | Change the workspace output (right).
| winkey + <kbd>colon</kbd>           | (left).
| winkey + shift + <kbd>-</kbd>   | Make the currently focused window a scratchpad.
| winkey + <kbd>-</kbd>           | Show the first scratchpad window.
| winkey + shift + <kbd>c</kbd>   | Reload config file.
| winkey + shift + <kbd>r</kbd>   | Restart i3.

## Manual changes

### Screen brightness and keyboard backlight (MacBook Pro 8,2)

Add those two lines to /etc/sudoers

    ALL ALL = (ALL) NOPASSWD: /usr/bin/tee /sys/class/leds/smc\:\:kbd_backlight/brightness
    ALL ALL = (ALL) NOPASSWD: /usr/bin/tee /sys/class/backlight/gmux_backlight/brightness

### Gimp in single-window mode

Open gimp and select Windows > Single-Window Mode.

## Credits

  - https://github.com/mathiasbynens/dotfiles
  - https://github.com/thomacer/dotfiles
