## release:
##     Release a docker image.
release: override program := $(or $(value RELEASE_PROGRAM),source $(BASE_DIR)/release.bash)
release: override flags := $(value RELEASE_FLAGS)
release: override targets := $(value RELEASE_TARGETS)
release: override pre_cmd := $(value PRE_RELEASE)
release: override post_cmd := $(value POST_RELEASE)
release:
	$(cmd)
.PHONY: release
