#!/usr/bin/bash


# sudo nötig weil sonst der Brwoser nicht öffnet
# TODO NextCloud soll bei Systemstart starten, aber sudo verhindert das

TAG=v3.8.2
WORKINGDIR="nextcloudDesktop${TAG}"
sudo $WORKINGDIR/build/bin/nextcloud
