# Evtl. Nachricht https://github.com/nextcloud/desktop/issues/2564


#### Build NextCloud desktop 3.9.0 on Raspberry Pi Zero 2 W, 64bit, 2GB swap


BIYellow='\033[1;93m'; RED='\033[0;31m'; GREEN='\033[0;32m'; NOCOLOR='\033[0m'; DESCRIPTION () { printf "${BIYellow}$1${NOCOLOR}\n"; }


## Install Debian packages
#sudo apt update && sudo apt install --yes qt5-qmake cmake g++ openssl libssl-dev libzip-dev qtbase5-private-dev qtdeclarative5-dev qtwebengine5-dev qt5keychain-dev qttools5-dev sqlite3 libsqlite3-dev libqt5svg5-dev zlib1g-dev libqt5websockets5-dev qtquickcontrols2-5-dev libkf5archive-dev extra-cmake-modules libkf5kio-dev libqt5webkit5-dev inkscape doxygen

TAG=v3.9.0
DESCRIPTION "Get source: clone ${TAG}"
[ -d desktop ] || git -c advice.detachedHead=false clone --depth 1 --branch $TAG https://github.com/nextcloud/desktop.git || exit
cd desktop
git submodule update --init || exit


DESCRIPTION 'Meta make: create the build/Makefile'
cmake -S . -B build -DCMAKE_INSTALL_PREFIX=~/nextcloud-desktop-client -DCMAKE_BUILD_TYPE=Debug || exit


DESCRIPTION 'Even the user install requires access to two system directories'
DIR4U=/usr/lib/aarch64-linux-gnu/qt5/plugins/kf5/overlayicon     && ([ -d $DIR4U ] || sudo mkdir $DIR4U) && sudo chmod 777 $DIR4U
DIR4U=/usr/lib/aarch64-linux-gnu/qt5/plugins/kf5/kfileitemaction && ([ -d $DIR4U ] || sudo mkdir $DIR4U) && sudo chmod 777 $DIR4U
## Mmmh
#-- Up-to-date: /usr/lib/aarch64-linux-gnu/qt5/plugins/kf5/overlayicon/nextclouddolphinoverlayplugin.so
#-- Installing: /usr/lib/aarch64-linux-gnu/qt5/plugins/kf5/kfileitemaction/nextclouddolphinactionplugin.so
#-- Set runtime path of "/usr/lib/aarch64-linux-gnu/qt5/plugins/kf5/kfileitemaction/nextclouddolphinactionplugin.so" to "/home/markus/nextcloud-desktop-client/lib"
#-- Installing: /home/markus/nextcloud-desktop-client/etc/Nextcloud/sync-exclude.lst


# TODO --target nextcloud
DESCRIPTION 'Make: create the executable'
time cmake --build build --target install  || exit


DESCRIPTION 'Display the executable'
ls -lh   /home/markus/nextcloud-desktop-client/bin/nextcloud
file -b  /home/markus/nextcloud-desktop-client/bin/nextcloud
