FROM golang:1.16-alpine3.13

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

ADD . /ci
