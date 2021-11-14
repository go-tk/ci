## clean:
##     Remove the cache.
clean: override program := $(or $(value CLEAN_PROGRAM),rm)
clean: override flags := $(or $(value CLEAN_FLAGS),--recursive --force)
clean: override targets := $(or $(value CLEAN_TARGETS),$(CACHE_DIR))
clean: override pre_cmd := $(value PRE_CLEAN)
clean: override post_cmd := $(value POST_CLEAN)
clean:
	$(cmd)
.PHONY: clean
