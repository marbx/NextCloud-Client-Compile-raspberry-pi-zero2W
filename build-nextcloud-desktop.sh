#!/usr/bin/bash

# Evtl. Nachricht https://github.com/nextcloud/desktop/issues/2564


#### Build NextCloud desktop 3.9.0 on Raspberry Pi Zero 2 W, 64bit, 2GB swap


GREEN='\033[0;32m'; BIYellow='\033[1;93m'; RED='\033[0;31m'; NOCOLOR='\033[0m'; DESCRIPTION () { printf "${BIYellow}$1${NOCOLOR}\n"; }


#source /etc/dphys-swapfile

## nicht nörig?? qutebrowser-qtwebengine

DESCRIPTION 'Ensure Debian packagess'
packagesWanted=( qt5-qmake cmake g++ openssl libssl-dev libzip-dev qtwebengine5-dev libqt5webengine-data qutebrowser-qtwebengine qtbase5-private-dev qtdeclarative5-dev qt5keychain-dev qttools5-dev sqlite3 libsqlite3-dev libqt5svg5-dev zlib1g-dev libqt5websockets5-dev qtquickcontrols2-5-dev libkf5archive-dev extra-cmake-modules libkf5kio-dev libqt5webkit5-dev inkscape doxygen )
packagesMissing=()
for apackage in "${packagesWanted[@]}"; do
    # Add to list unlesss installed (dpkg --verify returns true if it can verify install)
    dpkg --verify "$apackage" || packagesMissing+=("$apackage")
done
if (( ${#packagesMissing[@]} != 0 )); then
    sudo apt update
    sudo apt install --yes ${packagesMissing[*]}
fi


TAG=v3.8.2
WORKINGDIR="nextcloudDesktop${TAG}"
INSTALLDIR="~/nextcloud-desktop-client${TAG}"

DESCRIPTION "Get source: clone ${TAG}"
[ -d $WORKINGDIR ] || git -c advice.detachedHead=false clone --depth 1 --branch $TAG https://github.com/nextcloud/desktop.git $WORKINGDIR|| exit
cd $WORKINGDIR
git submodule update --init || exit


DESCRIPTION 'Meta make: create the build/Makefile'
cmake -S . -B build -DCMAKE_INSTALL_PREFIX=$INSTALLDIR -DCMAKE_BUILD_TYPE=Debug || exit


#DESCRIPTION 'Even the user install requires access to two system directories'
#DIR4U=/usr/lib/aarch64-linux-gnu/qt5/plugins/kf5/overlayicon     && ([ -d $DIR4U ] || sudo mkdir $DIR4U) && sudo chmod 777 $DIR4U
#DIR4U=/usr/lib/aarch64-linux-gnu/qt5/plugins/kf5/kfileitemaction && ([ -d $DIR4U ] || sudo mkdir $DIR4U) && sudo chmod 777 $DIR4U
## Mmmh
#-- Up-to-date: /usr/lib/aarch64-linux-gnu/qt5/plugins/kf5/overlayicon/nextclouddolphinoverlayplugin.so
#-- Installing: /usr/lib/aarch64-linux-gnu/qt5/plugins/kf5/kfileitemaction/nextclouddolphinactionplugin.so
#-- Set runtime path of "/usr/lib/aarch64-linux-gnu/qt5/plugins/kf5/kfileitemaction/nextclouddolphinactionplugin.so" to "/home/markus/nextcloud-desktop-client/lib"
#-- Installing: /home/markus/nextcloud-desktop-client/etc/Nextcloud/sync-exclude.lst


# target install also installs the tests :-(
DESCRIPTION 'Make: create the executable'
#time cmake --build build --target install  || exit
time cmake --build build --target nextcloud  || exit


#DESCRIPTION 'Display the installed executable'
#ls -lh   $INSTALLDIR/bin/nextcloud
#file -b  $INSTALLDIR/bin/nextcloud

DESCRIPTION 'Display the WORKINGDIR executable'
ls -lh   build/bin/nextcloud
file -b  build/bin/nextcloud

#DESCRIPTION 'Compare the executables'
#diff desktop/build/bin/nextcloud $INSTALLDIR/bin/nextcloud
