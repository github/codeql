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
      ql/src/ruby.dbscheme.stats\
      ql/src/ruby.dbscheme

BIN_FILES=target/release/ruby-extractor$(EXE) target/release/ruby-autobuilder$(EXE)

extractor-common:
	rm -rf build/codeql-extractor-ruby
	mkdir -p build/codeql-extractor-ruby
	cp codeql-extractor.yml ql/src/ruby.dbscheme ql/src/ruby.dbscheme.stats build/codeql-extractor-ruby
	cp -r tools build/codeql-extractor-ruby/

.PHONY:	tools
tools: $(BIN_FILES)
	mkdir -p tools/bin
	cp -r target/release/ruby-autobuilder$(EXE) tools/bin/autobuilder$(EXE)
	cp -r target/release/ruby-extractor$(EXE) tools/bin/extractor$(EXE)	

target/release/%$(EXE):
	cargo build --release --bin $(basename $(notdir $@))

dbscheme:
	cargo build --bin ruby-generator
	cargo run -p ruby-generator
	codeql query format -i ql/src/codeql_ruby/ast/internal/TreeSitter.qll

.PHONY:	extractor
extractor:	$(FILES) $(BIN_FILES)
	rm -rf extractor-pack
	mkdir -p extractor-pack/tools/$(CODEQL_PLATFORM)
	cp codeql-extractor.yml extractor-pack/codeql-extractor.yml
	cp tools/qltest.cmd extractor-pack/tools/qltest.cmd
	cp tools/index-files.sh extractor-pack/tools/index-files.sh
	cp tools/index-files.cmd extractor-pack/tools/index-files.cmd
	cp tools/autobuild.sh extractor-pack/tools/autobuild.sh
	cp tools/qltest.sh extractor-pack/tools/qltest.sh
	cp tools/autobuild.cmd extractor-pack/tools/autobuild.cmd
	cp ql/src/ruby.dbscheme.stats extractor-pack/ruby.dbscheme.stats
	cp ql/src/ruby.dbscheme extractor-pack/ruby.dbscheme
	cp target/release/ruby-extractor$(EXE) extractor-pack/tools/$(CODEQL_PLATFORM)/extractor$(EXE)
	cp target/release/ruby-autobuilder$(EXE) extractor-pack/tools/$(CODEQL_PLATFORM)/autobuilder$(EXE)

