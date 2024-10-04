#!/bin/sh

SCRIPT_PATH=`readlink -f $0`
BASE_DIR=`dirname $SCRIPT_PATH`

_link() {
    FROM=$BASE_DIR/$1
    BASENAME=`basename $FROM`
    TO=$2/$BASENAME
    COMMAND_PREFIX=$3
    RM_COMMAND=`echo "$COMMAND_PREFIX rm -r $TO" | sed "s/^[[:space:]]*//"`
    LN_COMMAND=`echo "$COMMAND_PREFIX ln -sf $FROM $TO" | sed "s/^[[:space:]]*//"`
    `$RM_COMMAND`
    echo "$LN_COMMAND"
    `$LN_COMMAND`
}

link() {
    _link $1 $2
}

link_as_root() {
    _link $1 $2 "sudo"
}

echo "-- Linking config files from home"
mkdir -p ~/.config
mkdir -p ~/.config/systemd
mkdir -p ~/.local
link home/.config/autorandr ~/.config
link home/.config/dunst ~/.config
link home/.config/fontconfig ~/.config
link home/.config/nvim ~/.config
link home/.config/nsxiv ~/.config
link home/.config/picom ~/.config
link home/.config/redshift ~/.config
link home/.config/systemd/user ~/.config/systemd
link home/.config/xmobar ~/.config
link home/.local/bin ~/.local
link home/.ssh/config ~/.ssh
link home/scripts ~
link home/.vim ~
link home/.xmonad ~
link home/.clang-format ~
link home/compile_flags.txt ~
link home/.gitconfig ~
link home/.xbindkeysrc ~
link home/.xinitrc ~
link home/.Xresources ~
link home/.zshrc ~

echo "-- Linking config files from etc"
link_as_root etc/X11/xorg.conf.d/00-keyboard.conf /etc/X11/xorg.conf.d
link_as_root etc/X11/xorg.conf.d/30-touchpad.conf /etc/X11/xorg.conf.d
link_as_root etc/X11/xorg.conf.d/40-libinput.conf /etc/X11/xorg.conf.d
link_as_root etc/udev/rules.d/99-udisks2.rules /etc/udev/rules.d

echo "-- Linking config files from usr"
link_as_root usr/share/oh-my-zsh/custom /usr/share/oh-my-zsh
link_as_root usr/share/X11/xkb/symbols/custom /usr/share/X11/xkb/symbols

systemctl --user daemon-reload
