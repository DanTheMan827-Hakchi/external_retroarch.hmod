MOD_NAME := external_retroarch
GIT_COMMIT := $(shell echo "`git rev-parse --short HEAD``git diff-index --quiet HEAD -- || echo '-dirty'`")

all: out/$(MOD_NAME)-$(GIT_COMMIT).hmod

out/$(MOD_NAME)-$(GIT_COMMIT).hmod: mod/usr/share/$(MOD_NAME)/transferring.xz
	mkdir -p "out/" "temp/"
	rsync -a "mod/" "temp/" --links --delete
	echo "---" > temp/readme.md
	echo "Name: `head -n 1 mod/readme.md | cut -c 3-`" >> temp/readme.md
	echo "Creator: DanTheMan827" >> temp/readme.md
	echo "Category: USB-Host" >> temp/readme.md
	echo "Packed on: `date`" >> temp/readme.md
	echo "Git commit: $(GIT_COMMIT)" >> temp/readme.md
	echo "---" >> temp/readme.md
	sed 1d mod/readme.md >> temp/readme.md
	cd "temp/"; tar -czvf "../$@" *
	rm -r "temp/"
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

