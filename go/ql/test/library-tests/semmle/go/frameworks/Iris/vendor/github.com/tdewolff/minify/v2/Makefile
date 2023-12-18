SHELL=/usr/bin/env bash
NAME=minify
CMD=./cmd/minify
TARGETS=linux_amd64 linux_arm64 darwin_amd64 darwin_arm64 freebsd_amd64 netbsd_amd64 openbsd_amd64 windows_amd64
VERSION=`git describe --tags`
FLAGS=-ldflags "-s -w -X 'main.Version=${VERSION}'" -trimpath
ENVS=GO111MODULES=on CGO_ENABLED=0

all: install

install:
	echo "Installing ${VERSION}"
	${ENVS} go install ${FLAGS} ./cmd/minify
	. cmd/minify/bash_completion

release:
	TAG=$(shell git describe --tags --exact-match 2> /dev/null);
	if [ "${.SHELLSTATUS}" -eq 0 ]; then \
		echo "Releasing ${VERSION}"; \
	else \
		echo "ERROR: commit is not tagged with a version"; \
		echo ""; \
		exit 1; \
	fi
	rm -rf dist
	mkdir -p dist
	for t in ${TARGETS}; do \
		echo Building $$t...; \
		mkdir dist/$$t; \
		os=$$(echo $$t | cut -f1 -d_); \
		arch=$$(echo $$t | cut -f2 -d_); \
		${ENVS} GOOS=$$os GOARCH=$$arch go build ${FLAGS} -o dist/$$t/${NAME} ${CMD}; \
		\
		cp LICENSE dist/$$t/.; \
		cp cmd/minify/README.md dist/$$t/.; \
		if [ "$$os" == "windows" ]; then \
			mv dist/$$t/${NAME} dist/$$t/${NAME}.exe; \
			zip -jq dist/${NAME}_$$t.zip dist/$$t/*; \
			cd dist; \
			sha256sum ${NAME}_$$t.zip >> checksums.txt; \
			cd ..; \
		else \
			cp cmd/minify/bash_completion dist/$$t/.; \
			cd dist/$$t; \
			tar -cf - * | gzip -9 > ../${NAME}_$$t.tar.gz; \
			cd ..; \
			sha256sum ${NAME}_$$t.tar.gz >> checksums.txt; \
			cd ..; \
		fi; \
		rm -rf dist/$$t; \
	done

clean:
	echo "Cleaning dist/"
	rm -rf dist

.PHONY: install release clean
.SILENT: install release clean
