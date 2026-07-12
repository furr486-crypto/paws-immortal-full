FROM alpine:latest

LABEL maintainer="thaipuri"
LABEL project="PAWS-IMMORTAL-FULL"

# Install dependencies
RUN apk add --no-cache \
    bash \
    curl \
    wget \
    jq \
    python3 \
    py3-pip \
    openssh \
    tmux \
    screen \
    supervisor \
    && pip3 install --upgrade pip

# Install Python packages
COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt

# Copy semua file
COPY scripts/ /usr/local/bin/
COPY config.yml /etc/immortal/config.yml
COPY .env.example /etc/immortal/.env

# Set permission
RUN chmod +x /usr/local/bin/*.sh \
    && chmod +x /usr/local/bin/*.py \
    && mkdir -p /var/log/immortal

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
