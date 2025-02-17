# Evtl. Nachricht https://github.com/nextcloud/desktop/issues/2564


#### Build NextCloud desktop 3.9.0 on Raspberry Pi Zero 2 W, 64bit, 2GB swap


BIYellow='\033[1;93m'; RED='\033[0;31m'; GREEN='\033[0;32m'; NOCOLOR='\033[0m'; DESCRIPTION () { printf "${BIYellow}$1${NOCOLOR}\n"; }


## Install Debian Qt5 packages by running .sh

# Select Qt5 version by visiting https://github.com/nextcloud/desktop
TAG=v3.10.4
DESCRIPTION "Get source: clone ${TAG}"
[ -d desktop ] || git -c advice.detachedHead=false clone --depth 1 --branch $TAG https://github.com/nextcloud/desktop.git || exit
cd desktop
git submodule update --init || exit


DESCRIPTION 'Build the Makefile'
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
DESCRIPTION 'Build the executable'
time cmake --build build --target install  || exit


DESCRIPTION 'Display the executable'
ls -lh   build/bin/nextcloud
file -b  build/bin/nextcloud
