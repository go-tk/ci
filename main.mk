override SHELL := bash

.PHONY: all
all: generate fmt lint vet test

.PHONY: generate
.ONESHELL:
generate:
	@
ifdef PRE_GENERATE
	$(PRE_GENERATE)
endif
ifdef POST_GENERATE
	trap "$(POST_GENERATE)" EXIT
endif
	go generate $(GO_GENERATE_FLAGS) ./...

.PHONY: fmt
.ONESHELL:
fmt: | $(GOBIN)/goimports
	@
ifdef PRE_FMT
	$(PRE_FMT)
endif
ifdef POST_FMT
	trap "$(POST_FMT)" EXIT
endif
	go fmt -n ./... |
		grep --perl-regexp --only-matching --null-data '(?<= -l -w ).+(?=\n)' |
		xargs --null $| -format-only -l -w $(GOIMPORTS_FLAGS)

.PHONY: lint
.ONESHELL:
lint: | $(GOBIN)/golint
	@
ifdef PRE_LINT
	$(PRE_LINT)
endif
ifdef POST_LINT
	trap "$(POST_LINT)" EXIT
endif
	$| $(filter-out -set_exit_status,$(GOLINT_FLAGS)) ./... | $(CI_DIR)/golint-filter

.PHONY: vet
.ONESHELL:
vet:
	@
ifdef PRE_VET
	$(PRE_VET)
endif
ifdef POST_VET
	trap "$(POST_VET)" EXIT
endif
	go vet $(GO_VET_FLAGS) ./...

.PHONY: test
.ONESHELL:
test:
	@
ifdef PRE_TEST
	$(PRE_TEST)
endif
ifdef POST_TEST
	trap "$(POST_TEST)" EXIT
endif
	go test $(GO_TEST_FLAGS) ./...

.PHONY: clean
.ONESHELL:
clean:
	@
ifdef PRE_CLEAN
	$(PRE_CLEAN)
endif
ifdef POST_CLEAN
	trap "$(POST_CLEAN)" EXIT
endif
	go clean $(GO_CLEAN_FLAGS) ./...

$(GOBIN)/goimports:
	@go install $(if $(DEBUG),-v) golang.org/x/tools/cmd/goimports@latest

$(GOBIN)/golint:
	@go install $(if $(DEBUG),-v) golang.org/x/lint/golint@latest
