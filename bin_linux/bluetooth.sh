#!/bin/sh

sudo hciconfig hci0 up
sudo systemctl start bluetooth
