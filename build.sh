#!/bin/bash

HA_VERSION=$(grep homeassistant requirements.txt | cut -d '=' -f 3)

docker build --build-arg HA_VERSION="$HA_VERSION" -t RomRider/hass-custom-devcontainer:"$HA_VERSION" .