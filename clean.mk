override clean_prog := $(or $(value CLEAN_PROG),rm)
override clean_flags := $(or $(value CLEAN_FLAGS),--recursive --force)
override pre_clean := $(value PRE_CLEAN)
override post_clean := $(value POST_CLEAN)

## clean:
##     Remove the cache.
clean:
	$(pre_clean)
	$(clean_prog) $(clean_flags) $(CACHE_DIR)
	$(post_clean)
.PHONY: clean
