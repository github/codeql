set -xe

BAZELISK_VERSION=v1.12.0
BAZELISK_DOWNLOAD_SHA=6b0bcb2ea15bca16fffabe6fda75803440375354c085480fe361d2cbf32501db

# install git lfs apt source
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

# install gh apt source
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
&& sudo mkdir -p -m 755 /etc/apt/keyrings \
&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \

apt-get update
export DEBIAN_FRONTEND=noninteractive
apt-get -y install --no-install-recommends \
    zlib1g-dev \
    uuid-dev \
    python3-distutils \
    python3-pip \
    bash-completion \
    git-lfs \
    gh

# Install Bazel
curl -fSsL -o /usr/local/bin/bazelisk https://github.com/bazelbuild/bazelisk/releases/download/${BAZELISK_VERSION}/bazelisk-linux-amd64
echo "${BAZELISK_DOWNLOAD_SHA} */usr/local/bin/bazelisk" | sha256sum --check -
chmod 0755 /usr/local/bin/bazelisk
ln -s bazelisk /usr/local/bin/bazel

# install latest codeql
update-codeql
