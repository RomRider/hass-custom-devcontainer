#!/bin/bash

HA_VERSION=$(grep homeassistant requirements.txt | cut -d '=' -f 3)

docker buildx build --platform linux/amd64,linux/arm64 --build-arg HA_VERSION="$HA_VERSION" -t romrider/hass-custom-devcontainer:"$HA_VERSION" -t romrider/hass-custom-devcontainer:latest .