override vet_prog := $(or $(value VET_PROG),go vet)
override vet_flags := $(value VET_FLAGS)
override pre_vet := $(value PRE_VET)
override post_vet := $(value POST_VET)

## vet:
##     Examine the source code.
vet:
	$(pre_vet)
	$(vet_prog) $(vet_flags) ./...
	$(post_vet)
.PHONY: vet
default: vet
