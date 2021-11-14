## fmt:
##     Format go files.
fmt: override program := $(or $(value FMT_PROGRAM),$(BASE_DIR)/xgoimports -format-only)
fmt: override flags := $(or $(value FMT_FLAGS),-l -w)
fmt: override targets := $(or $(value FMT_TARGETS),./...)
fmt: override pre_cmd := $(value PRE_FMT)
fmt: override post_cmd := $(value POST_FMT)
fmt:
	$(cmd)
.PHONY: fmt
default: fmt
