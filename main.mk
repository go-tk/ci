override SHELL := bash
override .SHELLFLAGS := -eu$(if $(value DEBUG),x)o pipefail -c

.SILENT:
.ONESHELL:

.PHONY: all
all: generate fmt lint vet test

.PHONY: generate
generate:
ifdef PRE_GENERATE
	eval $${PRE_GENERATE}
endif
ifdef POST_GENERATE
	trap 'eval $${POST_GENERATE}' EXIT
endif
	go generate $${GO_GENERATE_FLAGS:-} ./...

.PHONY: fmt
fmt: | $(value GOBIN)/goimports
ifdef PRE_FMT
	eval $${PRE_FMT}
endif
ifdef POST_FMT
	trap 'eval $${POST_FMT}' EXIT
endif
	go fmt -n ./... |
		grep --perl-regexp --only-matching --null-data '(?<= -l -w ).+(?=\n)' |
		xargs --null $| -format-only -l -w $${GOIMPORTS_FLAGS:-}

.PHONY: lint
lint: | $(value GOBIN)/golint
ifdef PRE_LINT
	$${eval PRE_LINT}
endif
ifdef POST_LINT
	trap 'eval $${POST_LINT}' EXIT
endif
	$| $${GOLINT_FLAGS:+$${GOLINT_FLAGS/-set_exit_status/}} ./... | "$${CI_DIR}/golint-filter"

.PHONY: vet
vet:
ifdef PRE_VET
	eval $${PRE_VET}
endif
ifdef POST_VET
	trap 'eval $${POST_VET}' EXIT
endif
	go vet $${GO_VET_FLAGS:-} ./...

.PHONY: test
test:
ifdef PRE_TEST
	eval $${PRE_TEST}
endif
ifdef POST_TEST
	trap 'eval $${POST_TEST}' EXIT
endif
	go test $${GO_TEST_FLAGS:-} ./...

.PHONY: clean
clean:
ifdef PRE_CLEAN
	eval $${PRE_CLEAN}
endif
ifdef POST_CLEAN
	trap 'eval $${POST_CLEAN}' EXIT
endif
	go clean $${GO_CLEAN_FLAGS:-} ./...

$(value GOBIN)/goimports:
	go install $(if $(value DEBUG),-v) golang.org/x/tools/cmd/goimports@latest

$(value GOBIN)/golint:
	go install $(if $(value DEBUG),-v) golang.org/x/lint/golint@latest
