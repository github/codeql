# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.162.0/containers/rust/.devcontainer/base.Dockerfile

FROM mcr.microsoft.com/vscode/devcontainers/rust:0-1

RUN apt-key --keyring /usr/share/keyrings/githubcli-archive-keyring.gpg adv \
    --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0 && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages $(lsb_release -cs) main" \
    |  tee /etc/apt/sources.list.d/github-cli2.list > /dev/null


RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends gh 

COPY post_create.sh /bin/post_create.sh
COPY post_attach.sh /bin/post_attach.sh
