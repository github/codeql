all: tools ql/src/go.dbscheme

ifeq ($(OS),Windows_NT)
EXE = .exe
else
EXE =
endif

.PHONY: tools
tools: tools/bin/go-extractor$(EXE) tools/bin/go-tokenizer$(EXE) tools/bin/go-autobuilder$(EXE) tools/tokenizer.jar tools/bin/go-bootstrap$(EXE)

tools/bin/go-extractor$(EXE): FORCE
	go build -mod=vendor -o $@ ./extractor/cli/go-extractor

tools/bin/go-tokenizer$(EXE): FORCE
	go build -mod=vendor -o $@ ./extractor/cli/go-tokenizer

tools/bin/go-autobuilder$(EXE): FORCE
	go build -mod=vendor -o $@ ./extractor/cli/go-autobuilder

tools/bin/go-bootstrap$(EXE): FORCE
	go build -mod=vendor -o $@ ./extractor/cli/go-bootstrap

FORCE:

tools/tokenizer.jar: tools/net/sourceforge/pmd/cpd/GoLanguage.class
	jar cf $@ -C tools net
	jar uf $@ -C tools opencsv

tools/net/sourceforge/pmd/cpd/GoLanguage.class: extractor/net/sourceforge/pmd/cpd/GoLanguage.java
	javac -cp extractor -d tools $^
	rm tools/net/sourceforge/pmd/cpd/AbstractLanguage.class
	rm tools/net/sourceforge/pmd/cpd/SourceCode.class
	rm tools/net/sourceforge/pmd/cpd/TokenEntry.class
	rm tools/net/sourceforge/pmd/cpd/Tokenizer.class

ql/src/go.dbscheme: tools/bin/go-extractor$(EXE)
	env TRAP_FOLDER=/tmp tools/bin/go-extractor --dbscheme $@

ql/src/go.dbscheme.stats: ql/src/go.dbscheme
	odasa createProject --force --template templates/project --threads 4 \
		--variable repository https://github.com/golang/tools \
		--variable revision 6e04913c \
		--variable SEMMLE_REPO_URL golang.org/x/tools \
		build/stats-project
	odasa addSnapshot --latest --overwrite --name revision --project build/stats-project
	odasa buildSnapshot --latest --project build/stats-project
	odasa collectStats --dbscheme $^ --db build/stats-project/revision/working/db-go --outputFile $@

test: all build/testdb/check-upgrade-path
	odasa qltest --language go --library ql/src ql/test
	cd extractor; go test -mod=vendor ./... | grep -vF "[no test files]"

.PHONY: build/testdb/check-upgrade-path
build/testdb/check-upgrade-path : build/testdb/go.dbscheme ql/src/go.dbscheme
	odasa upgradeDatabase --db build/testdb --upgrade-packs upgrades
	diff -q build/testdb/go.dbscheme ql/src/go.dbscheme

build/testdb/go.dbscheme: upgrades/initial/go.dbscheme
	echo >build/empty.trap
	odasa cli --dbscheme upgrades/initial/go.dbscheme --import build/empty.trap --db build/testdb
