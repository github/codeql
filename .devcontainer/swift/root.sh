set -xe

BAZELISK_VERSION=v1.12.0
BAZELISK_DOWNLOAD_SHA=6b0bcb2ea15bca16fffabe6fda75803440375354c085480fe361d2cbf32501db

apt-get update
export DEBIAN_FRONTEND=noninteractive
apt-get -y install --no-install-recommends \
    zlib1g-dev \
    uuid-dev \
    python3-distutils \
    python3-pip \
    bash-completion

# Install Bazel
curl -fSsL -o /usr/local/bin/bazelisk https://github.com/bazelbuild/bazelisk/releases/download/${BAZELISK_VERSION}/bazelisk-linux-amd64
echo "${BAZELISK_DOWNLOAD_SHA} */usr/local/bin/bazelisk" | sha256sum --check -
chmod 0755 /usr/local/bin/bazelisk
ln -s bazelisk /usr/local/bin/bazel

# install latest codeql
update-codeql
