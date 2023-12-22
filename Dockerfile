FROM golang:1.20-alpine3.18

RUN apk add --no-cache \
        bash \
        coreutils \
        curl \
        docker-cli \
        docker-compose \
        findutils \
        gcc \
        git \
        grep \
        make \
        musl-dev \
        sed \
    ;

COPY . /ci
