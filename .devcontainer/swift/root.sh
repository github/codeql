set -xe

apt-get update
export DEBIAN_FRONTEND=noninteractive
apt-get -y install --no-install-recommends \
    zlib1g-dev \
    uuid-dev \
    python3-distutils \
    python3-pip

# Install Bazel
curl -fSsL -o /usr/local/bin/bazelisk https://github.com/bazelbuild/bazelisk/releases/download/${BAZELISK_VERSION}/bazelisk-linux-amd64
([ "${BAZELISK_DOWNLOAD_SHA}" = "dev-mode" ] || echo "${BAZELISK_DOWNLOAD_SHA} */usr/local/bin/bazelisk" | sha256sum --check - )
chmod 0755 /usr/local/bin/bazelisk
ln -s bazelisk /usr/local/bin/bazel
