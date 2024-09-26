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
