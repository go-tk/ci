## gen:
##     Generate files.
gen: override program := $(or $(value GEN_PROGRAM),go generate)
gen: override flags := $(value GEN_FLAGS)
gen: override targets := $(or $(value GEN_TARGETS),./...)
gen: override pre_cmd := $(value PRE_GEN)
gen: override post_cmd := $(value POST_GEN)
gen:
	$(cmd)
.PHONY: gen
default: gen
