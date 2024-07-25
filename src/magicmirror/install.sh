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

# Ubuntu mirror, only run when OS is Ubuntu
UBUNTU_MIRROR=${UBUNTU_MIRROR:-""}
echo "UBUNTU_MIRROR: $UBUNTU_MIRROR"
if [ "${OS}" = '"Ubuntu"' ] && [ -n "${UBUNTU_MIRROR}" ]; then
    echo "Creating /etc/apt/sources.list with mirror = ${UBUNTU_MIRROR}"
    cp /etc/apt/sources.list /etc/apt/sources.list.mm.bak
    sed -i "s/archive.ubuntu.com/${UBUNTU_MIRROR}/g" /etc/apt/sources.list
    sed -i "s/security.ubuntu.com/${UBUNTU_MIRROR}/g" /etc/apt/sources.list
    sed -i "s/ports.ubuntu.com/${UBUNTU_MIRROR}/g" /etc/apt/sources.list
fi

# Pypi mirror.
PYPI_MIRROR=${PYPI_MIRROR:-""}
echo "PYPI_MIRROR: $PYPI_MIRROR"
if [ -n "${PYPI_MIRROR}" ]; then
    echo "Seting up pypi mirror via /etc/pip.conf: index-url = ${PYPI_MIRROR}"
    touch /etc/pip.conf && cp /etc/pip.conf /etc/pip.conf.mm.bak
    echo "[global]" >> /etc/pip.conf
    echo "index-url = ${PYPI_MIRROR}" >> /etc/pip.conf
fi

# Alpine apk mirror, only run when OS is Alpine
APK_MIRROR=${APK_MIRROR:-""}
echo "APK_MIRROR: $APK_MIRROR"
if [ "${OS}" = '"Alpine Linux"' ] && [ -n "${APK_MIRROR}" ]; then
    echo "Creating /etc/apk/repositories with mirror = ${APK_MIRROR}"
    cp /etc/apk/repositories /etc/apk/repositories.mm.bak
    sed -i "s/dl-cdn.alpinelinux.org/${APK_MIRROR}/g" /etc/apk/repositories
fi

# add entrypoint script
cat > /usr/local/bin/magicmirror.sh << EOF
#!/bin/sh
set -a; . /etc/environment; set +a;
EOF
chmod +x /usr/local/bin/magicmirror.sh

# Set Huggingface mirror if it's provided
HUGGINGFACE_MIRROR=${HUGGINGFACE_MIRROR:-""}
echo "HUGGINGFACE_MIRROR: $HUGGINGFACE_MIRROR"
if [ -n "${HUGGINGFACE_MIRROR}" ]; then
    echo "Enabling Huggingface mirror: ${HUGGINGFACE_MIRROR}"
    touch /etc/environment && cp /etc/environment /etc/environment.mm.bak
    echo "HF_ENDPOINT=${HUGGINGFACE_MIRROR}" >> /etc/environment
fi
