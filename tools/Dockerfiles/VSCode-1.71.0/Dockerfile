FROM debian:11-slim
FROM python:3.9.9-slim-buster

ARG USER
ARG UID
ARG GID

ENV CODE_SERVER_VERSION 4.7.0
ENV HTTPS_ENABLED false
ENV APP_BIND_HOST 0.0.0.0
ENV APP_PORT 8080
ENV USER ${USER}
ENV UID ${UID}
ENV GID ${GID}

RUN apt update \
 && apt install \
    ca-certificates sudo curl dumb-init \
    htop locales git procps ssh vim \
    lsb-release wget openssl -y \
  #&& curl -fsSL https://code-server.dev/install.sh | sh \
  && wget https://github.com/cdr/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server_${CODE_SERVER_VERSION}_amd64.deb \
  && dpkg -i code-server_${CODE_SERVER_VERSION}_amd64.deb && rm -f code-server_${CODE_SERVER_VERSION}_amd64.deb \
  && rm -rf /var/lib/apt/lists/* 
  

COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt && \
    rm -rf ~/.cache/pip/*
RUN sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8

RUN chsh -s /bin/bash
ENV SHELL /bin/bash

RUN adduser --gecos '' --disabled-password ec2-user \
  && echo "ec2-user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

RUN ARCH="$(dpkg --print-architecture)" \
  && curl -fsSL "https://github.com/boxboat/fixuid/releases/download/v0.4.1/fixuid-0.4.1-linux-$ARCH.tar.gz" | tar -C /usr/local/bin -xzf - \
  && chown root:root /usr/local/bin/fixuid \
  && chmod 4755 /usr/local/bin/fixuid \
  && mkdir -p /etc/fixuid \
  && printf "user: ec2-user\ngroup: ec2-user\n" > /etc/fixuid/config.yml

COPY bin/entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

USER 1000
ENV USER=ec2-user
WORKDIR /home/ec2-user

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
