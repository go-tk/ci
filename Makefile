override SHELL := bash
override .SHELLFLAGS := -c
override .SHELLFLAGS := $(shell echo '-eu$${DEBUG+x}o pipefail') $(.SHELLFLAGS)

export override BASE_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
export override PATH := $(BASE_DIR)/bin:$(PATH)
export override CACHE_DIR := $(abspath .cache/ci.v1)
override go_version := $(shell go version | grep --perl-regexp --only-matching --max-count=1 '(?<=go)\d+\.\d+')
ifneq ($(.SHELLSTATUS),0)
$(error failed to get go version)
endif
export override GOMODCACHE := $(CACHE_DIR)/go$(go_version)/mod
export override GOCACHE := $(CACHE_DIR)/go$(go_version)/build

default:
.PHONY: default

override define cmd =
	$(pre_cmd)
	$(program) $(flags) $(targets)
	$(post_cmd)
endef

include \
	$(BASE_DIR)/gen.mk \
	$(BASE_DIR)/fmt.mk \
	$(BASE_DIR)/fmtmod.mk \
	$(BASE_DIR)/lint.mk \
	$(BASE_DIR)/vet.mk \
	$(BASE_DIR)/test.mk \
	$(BASE_DIR)/build.mk \
	$(BASE_DIR)/release.mk \
	$(BASE_DIR)/clean.mk \
	$(additional_makefiles)

help:
	@source $(BASE_DIR)/help.bash $(MAKEFILE_LIST)
.PHONY: help
