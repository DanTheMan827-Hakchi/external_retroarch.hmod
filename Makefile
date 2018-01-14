MOD_NAME := external_retroarch
GIT_COMMIT := $(shell echo "`git rev-parse --short HEAD``git diff-index --quiet HEAD -- || echo '-dirty'`")

all: out/$(MOD_NAME)-$(GIT_COMMIT).hmod

out/$(MOD_NAME)-$(GIT_COMMIT).hmod: mod/usr/share/$(MOD_NAME)/transferring.xz
	mkdir -p "out/"
	cd "mod/"; tar -czvf "../$@" *
	touch "$@"

mod/usr/share/$(MOD_NAME)/transferring.xz: bin/decodepng
	mkdir -p "mod/usr/share/$(MOD_NAME)"
	"./$<" "images/transferring.png" | xz -cze9 > "$@"

bin/decodepng:
	mkdir -p "bin"
	gcc -o "$@" decodepng/*.c '-DBUILD_DATE=""' '-DBUILD_COMMIT=""'
	chmod +x "$@"

clean:
	-rm -rf "out/" "bin/" "mod/usr/"

.PHONY: clean

