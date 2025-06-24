#!/bin/sh

SCRIPT_PATH=`readlink -f $0`
BASE_DIR=`dirname $SCRIPT_PATH`
OFFICIAL_PACKAGES_FILE="$BASE_DIR/pkglist.txt"
AUR_PACKAGES_FILE="$BASE_DIR/pkglist_aur.txt"
AUR_CLONE_DIR="~/aur"
AUR_CLONE_BASE_URL="https://aur.archlinux.org"

echo "-- Updating packages"
sudo pacman -Syu

echo "-- Installing packages from $OFFICIAL_PACKAGES_FILE"
sudo pacman -S --needed - < $OFFICIAL_PACKAGES_FILE

echo "-- Installing AUR packages from $AUR_PACKAGES_FILE"
while IFS= read -r package; do
    PACKAGE_DIR=$AUR_CLONE_DIR/$package
    PACKAGE_URL=$AUR_CLONE_BASE_URL/$package.git
    echo "Installing AUR package from $PACKAGE_URL (cloning into $PACKAGE_DIR)"
    mkdir -p $PACKAGE_DIR
    git clone $PACKAGE_URL $PACKAGE_DIR
    makepkg -sirc --dir $PACKAGE_DIR
done < $AUR_PACKAGES_FILE
