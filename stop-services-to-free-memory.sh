
BIYellow='\033[1;93m'; RED='\033[0;31m'; GREEN='\033[0;32m'; NOCOLOR='\033[0m'; DESCRIPTION () { printf "${BIYellow}$1${NOCOLOR}\n"; }

DESCRIPTION 'RAM sparen'
sudo /etc/init.d/lightdm stop
sudo systemctl        stop cups-browsed
sudo systemctl        stop avahi-daemon.socket   && sudo systemctl        stop avahi-daemon
     systemctl --user stop pulseaudio.socket     &&      systemctl --user stop pulseaudio.service
     systemctl --user stop pipewire.socket       &&      systemctl --user stop pipewire.service
     systemctl --user stop pipewire-pulse.socket &&      systemctl --user stop pipewire-pulse.service
