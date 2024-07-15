#!/bin/sh
set -e

echo "Activating feature 'magicmirror'"

# The 'install.sh' entrypoint script is always executed as the root user.
#
# These following environment variables are passed in by the dev container CLI.
# These may be useful in instances where the context of the final 
# remoteUser or containerUser is useful.
# For more details, see https://containers.dev/implementors/features#user-env-var
echo "The effective dev container remoteUser is '$_REMOTE_USER'"
echo "The effective dev container remoteUser's home directory is '$_REMOTE_USER_HOME'"

echo "The effective dev container containerUser is '$_CONTAINER_USER'"
echo "The effective dev container containerUser's home directory is '$_CONTAINER_USER_HOME'"

OS=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
echo "Target OS is ${OS}"

# Ubuntu mirror. TODO[sidecus]: Check this is Ubuntu
UBUNTU_MIRROR=${UBUNTU_MIRROR:-""}
echo "UBUNTU_MIRROR: $UBUNTU_MIRROR"
if [ "${OS}" = '"Ubuntu"' ] && [ -n "${UBUNTU_MIRROR}" ]; then
    echo "Creating /etc/apt/sources.list with mirror = ${UBUNTU_MIRROR}"
    cp /etc/apt/sources.list /etc/apt/sources.list.bak
    sed -i s/archive.ubuntu.com/$UBUNTU_MIRROR/g /etc/apt/sources.list
    sed -i s/security.ubuntu.com/$UBUNTU_MIRROR/g /etc/apt/sources.list
    sed -i s/ports.ubuntu.com/$UBUNTU_MIRROR/g /etc/apt/sources.list
fi

# Pypi mirror. TODO[sidecus]: Check Python installation
PYPI_MIRROR=${PYPI_MIRROR:-""}
echo "PYPI_MIRROR: $PYPI_MIRROR"
if [ -n "${PYPI_MIRROR}" ]; then
    echo "Creating /etc/pip.conf with index-url = ${PYPI_MIRROR}"
    echo "[global]" > /etc/pip.conf
    echo "index-url = ${PYPI_MIRROR}" >> /etc/pip.conf
fi

# Alpine apk mirror.
APK_MIRROR=${APK_MIRROR:-""}
echo "APK_MIRROR: $APK_MIRROR"
if [ "${OS}" = '"Alpine Linux"' ] && [ -n "${APK_MIRROR}" ]; then
    echo "Creating /etc/apk/repositories with mirror = ${APK_MIRROR}"
    sed -i "s/dl-cdn.alpinelinux.org/${APK_MIRROR}/g" /etc/apk/repositories
fi