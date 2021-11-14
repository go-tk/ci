## fmtmod:
##     Format the go.mod file.
fmtmod: override program := $(or $(value FMTMOD_PROGRAM),go mod edit -fmt)
fmtmod: override flags := $(or $(value FMTMOD_FLAGS),-go=$(go_version))
fmtmod: override targets := $(or $(value FMTMOD_TARGETS),go.mod)
fmtmod: override pre_cmd := $(value PRE_FMTMOD)
fmtmod: override post_cmd := $(value POST_FMTMOD)
fmtmod:
	$(cmd)
.PHONY: fmtmod
default: fmtmod
