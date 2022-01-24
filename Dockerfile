FROM golang:1.17-alpine3.15

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
