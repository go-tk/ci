override fmtmod_prog := $(or $(value FMTMOD_PROG),go mod edit -fmt)
override fmtmod_flags := $(or $(value FMTMOD_FLAGS),-go=$(go_version))
override pre_fmtmod := $(value PRE_FMTMOD)
override post_fmtmod := $(value POST_FMTMOD)

## fmtmod:
##     Format the go.mod file.
fmtmod:
	$(pre_fmtmod)
	$(fmtmod_prog) $(fmtmod_flags)
	$(post_fmtmod)
.PHONY: fmtmod
default: fmtmod
