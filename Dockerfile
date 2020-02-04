# Container image that runs your code
FROM ubuntu:latest

LABEL author="Fadzril"
LABEL version="1.0.2"

# Install dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git-all

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["sh", "/entrypoint.sh"]


