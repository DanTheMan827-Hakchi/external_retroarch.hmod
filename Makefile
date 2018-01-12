MOD_NAME := external_retroarch
GIT_COMMIT := $(shell echo "`git rev-parse --short HEAD``git diff-index --quiet HEAD -- || echo '-dirty'`")

all: out/$(MOD_NAME)-$(GIT_COMMIT).hmod

out/$(MOD_NAME)-$(GIT_COMMIT).hmod:
	mkdir -p out/
	cd mod/; tar -czvf "../$@" *
	touch "$@"

clean:
	-rm -rf out/

.PHONY: clean

