#!/bin/sh

bold=$(tput bold)
normal=$(tput sgr0)

DISTRO=$( cat /etc/*-release | tr [:upper:] [:lower:] | grep -Poi '(ubuntu|fedora|arch|freedesktop)' | uniq )
FINISHMESSAGE="${bold}Grapejuice was installed successfully!${normal}\nOpen Grapejuice using grapejuice-gui or from your application menu!\n\nWe recommend installing graphics drivers if you haven't already:\nhttps://github.com/lutris/docs/blob/master/InstallingDrivers.md"

if [ "$DISTRO" = "freedesktop" ]; then
        echo "${bold}ERROR: Running burgerjuice via VSCode is unsupported.${normal}"
        exit
    fi
if [ -z $DISTRO ]; then
    if [ "$DISTRO" = "freedesktop" ]; then
        echo "${bold}ERROR: This distribution is unsupported by Burgerjuice.${normal}"
    fi
fi

if [ "$DISTRO" = "arch" ]; then
        # Install dependecies
        sudo pacman -Syu wine gnutls lib32-gnutls libpulse lib32-libpulse git curl --needed --noconfirm
        # Install Grapejuice
        git clone --depth=1 https://aur.archlinux.org/grapejuice-git.git /tmp/grapejuice-git
        cd /tmp/grapejuice-git
        makepkg -si
        clear
        echo -e $FINISHMESSAGE
        exit
    fi
if [ "$DISTRO" = "fedora" ]; then
        # Install dependecies
        sudo dnf install gettext git python3-devel python3-pip cairo-devel gobject-introspection-devel cairo-gobject-devel make xdg-utils glx-utils
        # Install Grapejuice
        git clone --depth=1 https://gitlab.com/brinkervii/grapejuice.git /tmp/grapejuice
        cd /tmp/grapejuice
        ./install.py
        clear
        echo -e $FINISHMESSAGE
        exit
    fi
if [ "$DISTRO" = "debian" ]; then
        # Install dependecies
        # Add Grapejuice repo
        sudo dpkg --add-architecture i386
        curl https://gitlab.com/brinkervii/grapejuice/-/raw/master/ci_scripts/signing_keys/public_key.gpg | sudo tee /usr/share/keyrings/grapejuice-archive-keyring.gpg
        sudo tee /etc/apt/sources.list.d/grapejuice.list <<< 'deb [signed-by=/usr/share/keyrings/grapejuice-archive-keyring.gpg] https://brinkervii.gitlab.io/grapejuice/repositories/debian/ universal main'
        sudo apt update && sudo apt upgrade -y

        # Install wine
        sudo mkdir -pm755 /etc/apt/keyrings
        sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key

        sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources
        sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bullseye/winehq-bullseye.sources

        sudo apt update
        sudo apt install --install-recommends winehq-staging

        # Install Grapejuice
        sudo apt install -y grapejuice
        clear
        echo -e $FINISHMESSAGE
        exit
    fi
if [ "$DISTRO" = "ubuntu" ]; then
        # Install dependecies
        # Add Grapejuice repo
        sudo dpkg --add-architecture i386
        curl https://gitlab.com/brinkervii/grapejuice/-/raw/master/ci_scripts/signing_keys/public_key.gpg | sudo tee /usr/share/keyrings/grapejuice-archive-keyring.gpg
        sudo tee /etc/apt/sources.list.d/grapejuice.list <<< 'deb [signed-by=/usr/share/keyrings/grapejuice-archive-keyring.gpg] https://brinkervii.gitlab.io/grapejuice/repositories/debian/ universal main'
        sudo apt update && sudo apt upgrade -y

        # Install wine
        sudo mkdir -pm755 /etc/apt/keyrings
        sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key

        sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/kinetic/winehq-kinetic.sources
        sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources
        sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources
        sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/bionic/winehq-bionic.sources

        sudo apt update
        sudo apt install --install-recommends winehq-staging

        # Install Grapejuice
        sudo apt install -y grapejuice
        clear
        echo -e $FINISHMESSAGE
        exit
    fi
