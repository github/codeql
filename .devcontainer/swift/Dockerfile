# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.236.0/containers/cpp/.devcontainer/base.Dockerfile

# [Choice] Debian / Ubuntu version (use Debian 11, Ubuntu 18.04/22.04 on local arm64/Apple Silicon): debian-11, debian-10, ubuntu-22.04, ubuntu-20.04, ubuntu-18.04
FROM mcr.microsoft.com/vscode/devcontainers/cpp:0-ubuntu-22.04

USER root
ADD root.sh /tmp/root.sh
ADD update-codeql.sh /usr/local/bin/update-codeql
RUN bash /tmp/root.sh && rm /tmp/root.sh
