FROM golang:1.19-alpine3.17

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
