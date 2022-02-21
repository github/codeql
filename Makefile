all: extractor ql/lib/go.dbscheme install-deps

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

CODEQL_TOOLS = $(addprefix codeql-tools/,autobuild.cmd autobuild.sh pre-finalize.cmd pre-finalize.sh index.cmd index.sh linux64 osx64 win64 tracing-config.lua)

EXTRACTOR_PACK_OUT = build/codeql-extractor-go

BINARIES = go-extractor go-tokenizer go-autobuilder go-build-runner go-bootstrap go-gen-dbscheme

.PHONY: tools tools-codeql tools-codeql-full clean autoformat \
	tools-linux64 tools-osx64 tools-win64 check-formatting

clean:
	rm -rf tools/bin tools/linux64 tools/osx64 tools/win64 tools/net tools/opencsv
	rm -rf $(EXTRACTOR_PACK_OUT) build/stats build/testdb

DATAFLOW_BRANCH=main

autoformat:
	find ql -iregex '.*\.qll?' -print0 | xargs -0 codeql query format -qq -i
	find . -path '**/vendor' -prune -or -type f -iname '*.go' ! -empty -print0 | xargs -0 grep -L "//\s*autoformat-ignore" | xargs gofmt -w

check-formatting:
	find ql -iregex '.*\.qll?' -print0 | xargs -0 codeql query format --check-only
	test -z "$$(find . -path '**/vendor' -prune -or -type f -iname '*.go' ! -empty -print0 | xargs -0 grep -L "//\s*autoformat-ignore" | xargs gofmt -l)"

install-deps:
	bash scripts/install-deps.sh $(CODEQL_LOCK_MODE)

ifeq ($(QHELP_OUT_DIR),)
# If not otherwise specified, compile qhelp to markdown in place
QHELP_OUT_DIR := ql/src
endif

qhelp-to-markdown:
	scripts/qhelp-to-markdown.sh ql/src "$(QHELP_OUT_DIR)"

tools: $(addsuffix $(EXE),$(addprefix tools/bin/,$(BINARIES))) tools/tokenizer.jar

.PHONY: $(addsuffix $(EXE),$(addprefix tools/bin/,$(BINARIES)))
$(addsuffix $(EXE),$(addprefix tools/bin/,$(BINARIES))):
	go build -mod=vendor -o $@ ./extractor/cli/$(basename $(@F))

tools-codeql: tools-$(CODEQL_PLATFORM)

tools-codeql-full: tools-linux64 tools-osx64 tools-win64

tools-linux64: $(addprefix tools/linux64/,$(BINARIES))

.PHONY: $(addprefix tools/linux64/,$(BINARIES))
$(addprefix tools/linux64/,$(BINARIES)):
	GOOS=linux GOARCH=amd64 go build -mod=vendor -o $@ ./extractor/cli/$(@F)

tools-osx64: $(addprefix tools/osx64/,$(BINARIES))

.PHONY: $(addprefix tools/osx64/,$(BINARIES))
$(addprefix tools/osx64/,$(BINARIES)):
	GOOS=darwin GOARCH=amd64 go build -mod=vendor -o $@ ./extractor/cli/$(@F)

tools-win64: $(addsuffix .exe,$(addprefix tools/win64/,$(BINARIES)))

.PHONY: $(addsuffix .exe,$(addprefix tools/win64/,$(BINARIES)))
$(addsuffix .exe,$(addprefix tools/win64/,$(BINARIES))):
	env GOOS=windows GOARCH=amd64 go build -mod=vendor -o $@ ./extractor/cli/$(basename $(@F))

.PHONY: extractor-common extractor extractor-full install-deps
extractor-common: codeql-extractor.yml LICENSE ql/lib/go.dbscheme \
	tools/tokenizer.jar $(CODEQL_TOOLS)
	rm -rf $(EXTRACTOR_PACK_OUT)
	mkdir -p $(EXTRACTOR_PACK_OUT)
	cp codeql-extractor.yml LICENSE ql/lib/go.dbscheme ql/lib/go.dbscheme.stats $(EXTRACTOR_PACK_OUT)
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
	javac -cp extractor -d tools $<
	rm tools/net/sourceforge/pmd/cpd/AbstractLanguage.class
	rm tools/net/sourceforge/pmd/cpd/SourceCode.class
	rm tools/net/sourceforge/pmd/cpd/TokenEntry.class
	rm tools/net/sourceforge/pmd/cpd/Tokenizer.class

ql/lib/go.dbscheme: tools/$(CODEQL_PLATFORM)/go-gen-dbscheme$(EXE)
	$< $@

build/stats/src.stamp:
	mkdir -p $(@D)/src
	git clone 'https://github.com/golang/tools' $(@D)/src
	git -C $(@D)/src checkout 9b52d559c609 -q
	touch $@

ql/lib/go.dbscheme.stats: ql/lib/go.dbscheme build/stats/src.stamp extractor
	rm -rf build/stats/database
	codeql database create -l go -s build/stats/src -j4 --search-path . build/stats/database
	codeql dataset measure -o $@ build/stats/database/db-go

test: all build/testdb/check-upgrade-path
	codeql test run ql/test --search-path . --consistency-queries ql/test/consistency
  #	use GOOS=linux because GOOS=darwin GOARCH=386 is no longer supported
	env GOOS=linux GOARCH=386 codeql$(EXE) test run ql/test/query-tests/Security/CWE-681 --search-path . --consistency-queries ql/test/consistency
	cd extractor; go test -mod=vendor ./... | grep -vF "[no test files]"
	bash extractor-smoke-test/test.sh || (echo "Extractor smoke test FAILED"; exit 1)

.PHONY: build/testdb/check-upgrade-path
build/testdb/check-upgrade-path : build/testdb/go.dbscheme ql/lib/go.dbscheme
	codeql dataset upgrade build/testdb --search-path ql/lib
	diff -q build/testdb/go.dbscheme ql/lib/go.dbscheme

.PHONY: build/testdb/go.dbscheme
build/testdb/go.dbscheme: ql/lib/upgrades/initial/go.dbscheme
	rm -rf build/testdb
	echo >build/empty.trap
	codeql dataset import -S ql/lib/upgrades/initial/go.dbscheme build/testdb build/empty.trap

.PHONY: sync-dataflow-libraries
sync-dataflow-libraries:
	for f in DataFlowImpl.qll DataFlowImpl2.qll DataFlowImplCommon.qll DataFlowImplConsistency.qll tainttracking1/TaintTrackingImpl.qll tainttracking2/TaintTrackingImpl.qll FlowSummaryImpl.qll AccessPathSyntax.qll;\
	do\
		curl -s -o ./ql/lib/semmle/go/dataflow/internal/$$f https://raw.githubusercontent.com/github/codeql/$(DATAFLOW_BRANCH)/java/ql/lib/semmle/code/java/dataflow/internal/$$f;\
	done
