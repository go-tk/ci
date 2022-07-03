## lint:
##     Check the code style.
lint: override program := $(or $(value LINT_PROGRAM),golint -set_exit_status)
lint: override flags := $(value LINT_FLAGS)
lint: override targets := $(or $(value LINT_TARGETS),./...)
lint: override pre_cmd := $(value PRE_LINT)
lint: override post_cmd := $(value POST_LINT)
lint:
	$(cmd)
.PHONY: lint
default: lint
