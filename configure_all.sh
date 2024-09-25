#!/bin/sh

SCRIPT_PATH=`readlink -f $0`
BASE_DIR=`dirname $SCRIPT_PATH`
OFFICIAL_PACKAGES_FILE="$BASE_DIR/official_packages.txt"
AUR_PACKAGES_FILE="$BASE_DIR/aur_packages.txt"
OFFICIAL_PACKAGES=`tr "\n" " " < $OFFICIAL_PACKAGES_FILE`
AUR_CLONE_DIR="~/aur"
AUR_CLONE_BASE_URL="https://aur.archlinux.org"

echo "-- Updating official packages"
sudo pacman -Syu

echo "-- Installing official packages from $OFFICIAL_PACKAGES_FILE"
sudo pacman -S $OFFICIAL_PACKAGES

echo "-- Installing AUR packages from $AUR_PACKAGES_FILE"
while IFS= read -r package; do
    PACKAGE_DIR=$AUR_CLONE_DIR/$package
    PACKAGE_URL=$AUR_CLONE_BASE_URL/$package.git
    echo "Installing AUR package from $PACKAGE_URL (cloning into $PACKAGE_DIR)"
    mkdir -p $PACKAGE_DIR
    git clone $PACKAGE_URL $PACKAGE_DIR
    makepkg -sirc --dir $PACKAGE_DIR
done < $AUR_PACKAGES_FILE

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
link home/.config/picom ~/.config
link home/.config/redshift ~/.config
link home/.config/systemd/user ~/.config/systemd
link home/.config/xmobar ~/.config
link home/.local/bin ~/.local
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

echo "-- Linking config files from usr"
link_as_root usr/share/oh-my-zsh/custom /usr/share/oh-my-zsh
link_as_root usr/share/X11/xkb/symbols/custom /usr/share/X11/xkb/symbols

systemctl --user daemon-reload
