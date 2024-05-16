all: gen extractor

EXTRACTOR_PACK_OUT = build/codeql-extractor-go

.PHONY: extractor gen clean autoformat check-formatting

clean:
	rm -rf $(EXTRACTOR_PACK_OUT) build/stats build/testdb

autoformat:
	find ql -iregex '.*\.qll?' -print0 | xargs -0 codeql query format -qq -i
	find . -path '**/vendor' -prune -or -type f -iname '*.go' ! -empty -print0 | xargs -0 grep -L "//\s*autoformat-ignore" | xargs gofmt -w

check-formatting:
	@output=$$(find . -path '**/vendor' -prune -or -type f -iname '*.go' ! -empty -print0 | xargs -0 grep -L "//\s*autoformat-ignore" | xargs gofmt -l 2>&1); \
	if [ -n "$$output" ]; then \
		echo "The following files need to be reformatted using gofmt or have compilation errors:"; \
		echo "$$output"; \
	fi; \
	test -z "$$output"

ifeq ($(QHELP_OUT_DIR),)
# If not otherwise specified, compile qhelp to markdown in place
QHELP_OUT_DIR := ql/src
endif

qhelp-to-markdown:
	scripts/qhelp-to-markdown.sh ql/src "$(QHELP_OUT_DIR)"

extractor:
	bazel run :create-extractor-pack

gen:
	bazel run :gen

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
	codeql test run -j0 ql/test --search-path build/codeql-extractor-go --consistency-queries ql/test/consistency --compilation-cache=$(cache)
#	use GOOS=linux because GOOS=darwin GOARCH=386 is no longer supported
	env GOOS=linux GOARCH=386 codeql$(EXE) test run -j0 ql/test/query-tests/Security/CWE-681 --search-path build/codeql-extractor-go --consistency-queries ql/test/consistency --compilation-cache=$(cache)
	cd extractor; bazel test ...
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
