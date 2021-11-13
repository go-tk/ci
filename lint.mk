override lint_prog := $(or $(value LINT_PROG),$(BASE_DIR)/xgolint)
override lint_flags := $(value LINT_FLAGS)
override pre_lint := $(value PRE_LINT)
override post_lint := $(value POST_LINT)

## lint:
##     Check the code style.
lint:
	$(pre_lint)
	$(lint_prog) $(lint_flags) ./...
	$(post_lint)
.PHONY: lint
default: lint
