## test:
##     Run tests.
test: override program := $(or $(value TEST_PROGRAM),go test)
test: override flags := $(value TEST_FLAGS)
test: override targets := $(or $(value TEST_TARGETS),./...)
test: override pre_cmd := $(value PRE_TEST)
test: override post_cmd := $(value POST_TEST)
test:
	$(cmd)
.PHONY: test
default: test
