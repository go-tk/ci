## vet:
##     Examine the source code.
vet: override program := $(or $(value VET_PROGRAM),go vet)
vet: override flags := $(value VET_FLAGS)
vet: override targets := $(or $(value VET_TARGETS),./...)
vet: override pre_cmd := $(value PRE_VET)
vet: override post_cmd := $(value POST_VET)
vet:
	$(cmd)
.PHONY: vet
default: vet
