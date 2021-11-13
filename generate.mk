override generate_prog := $(or $(value GENERATE_PROG),go generate)
override generate_flags := $(value GENERATE_FLAGS)
override pre_generate := $(value PRE_GENERATE)
override post_generate := $(value POST_GENERATE)

## generate:
##     Generate files.
generate:
	$(pre_generate)
	$(generate_prog) $(generate_flags) ./...
	$(post_generate)
.PHONY: generate
default: generate
