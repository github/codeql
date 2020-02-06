all: tools ql/src/go.dbscheme

ifeq ($(OS),Windows_NT)
EXE = .exe
CODEQL_PLATFORM = win64
else
EXE =
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
CODEQL_PLATFORM = linux64
endif
ifeq ($(UNAME_S),Darwin)
CODEQL_PLATFORM = osx64
endif
endif

CODEQL_TOOLS = $(addprefix codeql-tools/,autobuild.cmd autobuild.sh index.cmd index.sh)

EXTRACTOR_PACK_OUT = build/codeql-extractor-go

BINARIES = go-extractor go-tokenizer go-autobuilder go-bootstrap

.PHONY: tools tools-codeql tools-codeql-full clean \
	tools-linux64 tools-osx64 tools-win64

clean:
	rm -rf tools/bin tools/linux64 tools/osx64 tools/win64 tools/net tools/opencsv
	rm -rf $(EXTRACTOR_PACK_OUT) build/stats-project build/testdb

tools: $(addsuffix $(EXE),$(addprefix tools/bin/,$(BINARIES))) tools/tokenizer.jar

$(addsuffix $(EXE),$(addprefix tools/bin/,$(BINARIES))):
	go build -mod=vendor -o $@ ./extractor/cli/$(basename $(notdir $@))

tools-codeql: tools-$(CODEQL_PLATFORM)

tools-codeql-full: tools-linux64 tools-osx64 tools-win64

tools-linux64: $(addprefix tools/linux64/,$(BINARIES)) tools/tokenizer.jar

$(addprefix tools/linux64/,$(BINARIES)):
	GOOS=linux GOARCH=amd64 go build -mod=vendor -o $@ ./extractor/cli/$(notdir $@)

tools-osx64: $(addprefix tools/osx64/,$(BINARIES)) tools/tokenizer.jar

$(addprefix tools/osx64/,$(BINARIES)):
	GOOS=darwin GOARCH=amd64 go build -mod=vendor -o $@ ./extractor/cli/$(notdir $@)

tools-win64: $(addsuffix .exe,$(addprefix tools/win64/,$(BINARIES))) tools/tokenizer.jar

$(addsuffix .exe,$(addprefix tools/win64/,$(BINARIES))):
	env GOOS=windows GOARCH=amd64 go build -mod=vendor -o $@ ./extractor/cli/$(basename $(notdir $@))

.PHONY: extractor-common extractor extractor-full
extractor-common: codeql-extractor.yml COPYRIGHT LICENSE ql/src/go.dbscheme \
	tools/tokenizer.jar $(CODEQL_TOOLS)
	rm -rf $(EXTRACTOR_PACK_OUT)
	mkdir -p $(EXTRACTOR_PACK_OUT)
	cp codeql-extractor.yml COPYRIGHT LICENSE ql/src/go.dbscheme ql/src/go.dbscheme.stats $(EXTRACTOR_PACK_OUT)
	mkdir $(EXTRACTOR_PACK_OUT)/tools
	cp -r tools/tokenizer.jar $(CODEQL_TOOLS) $(EXTRACTOR_PACK_OUT)/tools

extractor: extractor-common tools-codeql
	cp -r tools/$(CODEQL_PLATFORM) $(EXTRACTOR_PACK_OUT)/tools

extractor-full: extractor-common tools-codeql-full
	cp -r $(addprefix tools/,linux64 osx64 win64) $(EXTRACTOR_PACK_OUT)/tools

tools/tokenizer.jar: tools/net/sourceforge/pmd/cpd/GoLanguage.class
	jar cf $@ -C tools net
	jar uf $@ -C tools opencsv

tools/net/sourceforge/pmd/cpd/GoLanguage.class: extractor/net/sourceforge/pmd/cpd/GoLanguage.java
	javac -cp extractor -d tools $^
	rm tools/net/sourceforge/pmd/cpd/AbstractLanguage.class
	rm tools/net/sourceforge/pmd/cpd/SourceCode.class
	rm tools/net/sourceforge/pmd/cpd/TokenEntry.class
	rm tools/net/sourceforge/pmd/cpd/Tokenizer.class

ql/src/go.dbscheme: tools/$(CODEQL_PLATFORM)/go-extractor$(EXE)
	env TRAP_FOLDER=/tmp $^ --dbscheme $@

ql/src/go.dbscheme.stats: ql/src/go.dbscheme
	odasa createProject --force --template templates/project --threads 4 \
		--variable repository https://github.com/golang/tools \
		--variable revision 6e04913c \
		--variable SEMMLE_REPO_URL golang.org/x/tools \
		build/stats-project
	odasa addSnapshot --latest --overwrite --name revision --project build/stats-project
	odasa buildSnapshot --latest --project build/stats-project
	odasa collectStats --dbscheme $^ --db build/stats-project/revision/working/db-go --outputFile $@

test: all extractor build/testdb/check-upgrade-path
	codeql test run ql/test --search-path . --additional-packs ql
	cd extractor; go test -mod=vendor ./... | grep -vF "[no test files]"

.PHONY: build/testdb/check-upgrade-path
build/testdb/check-upgrade-path : build/testdb/go.dbscheme ql/src/go.dbscheme
	codeql dataset upgrade build/testdb --search-path upgrades
	diff -q build/testdb/go.dbscheme ql/src/go.dbscheme

build/testdb/go.dbscheme: upgrades/initial/go.dbscheme
	echo >build/empty.trap
	codeql dataset import -S upgrades/initial/go.dbscheme build/testdb build/empty.trap
