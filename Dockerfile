# Container image that runs your code
FROM ubuntu:latest

LABEL author="Fadzril"
LABEL version="1.0.7"

ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    git-all && \
    curl -s "https://raw.githubusercontent.com/\kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["sh", "/entrypoint.sh"]


