override fmt_prog := $(or $(value FMT_PROG),$(BASE_DIR)/xgoimports -format-only)
override fmt_flags := $(or $(value FMT_FLAGS),-l -w)
override pre_fmt := $(value PRE_FMT)
override post_fmt := $(value POST_FMT)

## fmt:
##     Format go files.
fmt:
	$(pre_fmt)
	$(fmt_prog) $(fmt_flags) ./...
	$(post_fmt)
.PHONY: fmt
default: fmt
