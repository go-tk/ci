override test_prog := $(or $(value TEST_PROG),go test)
override test_flags := $(value TEST_FLAGS)
override pre_test := $(value PRE_TEST)
override post_test := $(value POST_TEST)

## test:
##     Run tests.
test:
	$(pre_test)
	$(test_prog) $(test_flags) ./...
	$(post_test)
.PHONY: test
default: test
