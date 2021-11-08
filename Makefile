override SHELL := bash
override .SHELLFLAGS := -eu$(if $(value DEBUG),x)o pipefail -c

override BASE_DIR := $(abspath .ci.v1)
override GO_VERSION := $(shell go version | grep --perl-regexp --only-matching '(?<=go)\d+\.\d+')
export override GOMODCACHE := $(BASE_DIR)/cache/go$(GO_VERSION)/mod
export override GOCACHE := $(BASE_DIR)/cache/go$(GO_VERSION)/build

.SILENT:
.ONESHELL:

.PHONY: all

.PHONY: generate
generate:
	$(value PRE_GENERATE)
	go generate $${GO_GENERATE_FLAGS:-} ./...
	$(value POST_GENERATE)
all: generate

.PHONY: fmt
fmt: $(BASE_DIR)/bin/goimports
	$(value PRE_FMT)
	go fmt -n ./... |
		grep --perl-regexp --only-matching --null-data '(?<= -l -w ).+(?=\n)' |
		xargs $(if $(value DEBUG),--verbose) --null $| -format-only -l -w $${GOIMPORTS_FLAGS:-}
	$(value POST_FMT)
all: fmt

.PHONY: lint
lint: $(BASE_DIR)/bin/golint
	$(value PRE_LINT)
	$| $${GOLINT_FLAGS:+$${GOLINT_FLAGS/-set_exit_status/}} ./... | /ci/golint-filter
	$(value POST_LINT)
all: lint

.PHONY: vet
vet:
	$(value PRE_VET)
	go vet $${GO_VET_FLAGS:-} ./...
	$(value POST_VET)
all: vet

.PHONY: test
test:
	$(value PRE_TEST)
	go test $${GO_TEST_FLAGS:-} ./...
	$(value POST_TEST)
all: test

.PHONY: clean
clean:
	$(value PRE_CLEAN)
	go clean $${GO_CLEAN_FLAGS:-} ./...
	$(value POST_CLEAN)

$(BASE_DIR)/bin/goimports:
	GOBIN=$(BASE_DIR)/bin go install $(if $(value DEBUG),-v) golang.org/x/tools/cmd/goimports@latest

$(BASE_DIR)/bin/golint:
	GOBIN=$(BASE_DIR)/bin go install $(if $(value DEBUG),-v) golang.org/x/lint/golint@latest
