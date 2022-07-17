## build:
##     Build a docker image.
build: override program := $(or $(value BUILD_PROGRAM),source $(BASE_DIR)/build.bash)
build: override flags := $(value BUILD_FLAGS)
build: override targets := $(value BUILD_TARGETS)
build: override pre_cmd := $(value PRE_BUILD)
build: override post_cmd := $(value POST_BUILD)
build:
	$(cmd)
.PHONY: build
