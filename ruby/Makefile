all: extractor dbscheme

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

FILES=codeql-extractor.yml\
      tools/qltest.cmd\
      tools/index-files.sh\
      tools/index-files.cmd\
      tools/autobuild.sh\
      tools/qltest.sh\
      tools/autobuild.cmd\
      ql/lib/ruby.dbscheme.stats\
      ql/lib/ruby.dbscheme

BIN_FILES=target/release/ruby-extractor$(EXE) target/release/ruby-autobuilder$(EXE)

extractor-common:
	rm -rf build
	mkdir build
	mkdir build/codeql-extractor-ruby
	cp codeql-extractor.yml ql/lib/ruby.dbscheme ql/lib/ruby.dbscheme.stats build/codeql-extractor-ruby
	cp -r tools build/codeql-extractor-ruby/

.PHONY:	tools
tools: $(BIN_FILES)
	rm -rf tools/bin
	mkdir tools/bin
	cp -r target/release/ruby-autobuilder$(EXE) tools/bin/autobuilder$(EXE)
	cp -r target/release/ruby-extractor$(EXE) tools/bin/extractor$(EXE)	

target/release/%$(EXE):
	cargo build --release --bin $(basename $(notdir $@))

dbscheme:
	cargo build --bin ruby-generator
	cargo run -p ruby-generator -- --dbscheme ql/lib/ruby.dbscheme --library ql/lib/codeql/ruby/ast/internal/TreeSitter.qll
	codeql query format -i ql/lib/codeql/ruby/ast/internal/TreeSitter.qll

.PHONY:	extractor
extractor:	$(FILES) $(BIN_FILES)
	rm -rf extractor-pack
	mkdir extractor-pack
	mkdir extractor-pack/tools
	mkdir extractor-pack/tools/$(CODEQL_PLATFORM)
	cp codeql-extractor.yml extractor-pack/codeql-extractor.yml
	cp tools/qltest.cmd extractor-pack/tools/qltest.cmd
	cp tools/index-files.sh extractor-pack/tools/index-files.sh
	cp tools/index-files.cmd extractor-pack/tools/index-files.cmd
	cp tools/autobuild.sh extractor-pack/tools/autobuild.sh
	cp tools/qltest.sh extractor-pack/tools/qltest.sh
	cp tools/autobuild.cmd extractor-pack/tools/autobuild.cmd
	cp ql/lib/ruby.dbscheme.stats extractor-pack/ruby.dbscheme.stats
	cp ql/lib/ruby.dbscheme extractor-pack/ruby.dbscheme
	cp target/release/ruby-extractor$(EXE) extractor-pack/tools/$(CODEQL_PLATFORM)/extractor$(EXE)
	cp target/release/ruby-autobuilder$(EXE) extractor-pack/tools/$(CODEQL_PLATFORM)/autobuilder$(EXE)

test: extractor dbscheme
	codeql test run --check-databases --check-unused-labels --check-repeated-labels --check-redefined-labels --check-use-before-definition --search-path extractor-pack --consistency-queries ql/consistency-queries ql/test
