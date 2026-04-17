ARG PYTHON_VERSION=3.14
FROM mcr.microsoft.com/devcontainers/python:${PYTHON_VERSION}

ARG NODE_VERSION=24

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        bluez \
        libffi-dev \
        libssl-dev \
        libjpeg-dev \
        zlib1g-dev \
        autoconf \
        build-essential \
        libopenjp2-7 \
        libtiff6 \
        libturbojpeg0-dev \
        tzdata \
        ffmpeg \
        liblapack3 \
        liblapack-dev \
        \
        git \
        libpcap-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && source /usr/local/share/nvm/nvm.sh \
    && nvm install "${NODE_VERSION}" \
    && npm install -g yarn \
    && pip install --upgrade wheel pip

COPY --from=ghcr.io/alexxit/go2rtc:latest /usr/local/bin/go2rtc /bin/go2rtc
RUN pip3 install uv
RUN echo "alias activate='source \"$VIRTUAL_ENV/bin/activate\"'" >> /etc/bash.bashrc

EXPOSE 8123

RUN mkdir -p /config && chown vscode:vscode /config
VOLUME /config

USER vscode
ARG HA_VERSION
RUN echo "${HA_VERSION}" > /config/.HA_VERSION

ENV VIRTUAL_ENV="/home/vscode/.local/ha-venv"
RUN uv venv --python "${PYTHON_VERSION}" $VIRTUAL_ENV
COPY requirements.txt /tmp/requirements.txt
RUN source "$VIRTUAL_ENV/bin/activate" && uv pip install -r /tmp/requirements.txt
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY /bin /usr/local/bin

CMD container