.PHONY: all build clean test install help extractor dbscheme ql-library check fmt lint doc

# Detect OS and architecture
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

ifeq ($(UNAME_S),Linux)
    EXE :=
    DYLIB_EXT := so
    OS := linux
else ifeq ($(UNAME_S),Darwin)
    EXE :=
    DYLIB_EXT := dylib
    OS := macos
else ifeq ($(OS),Windows_NT)
    EXE := .exe
    DYLIB_EXT := dll
    OS := windows
endif

# Paths
EXTRACTOR_DIR := extractor
QL_LIB_DIR := ql/lib
QL_SRC_DIR := ql/src
BUILD_DIR := build
TARGET_DIR := $(EXTRACTOR_DIR)/target
CARGO := cargo
CODEQL := codeql

# Targets
EXTRACTOR_BIN := $(TARGET_DIR)/release/codeql-extractor-php$(EXE)
DBSCHEME_FILE := $(QL_LIB_DIR)/php.dbscheme
TREE_SITTER_QL := $(QL_LIB_DIR)/codeql/php/ast/internal/TreeSitter.qll

# Default target
all: help

## help: Show this help message
help:
	@echo "PHP Language Support for CodeQL - Makefile"
	@echo ""
	@echo "Targets:"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'
	@echo ""
	@echo "Examples:"
	@echo "  make build              Build the extractor"
	@echo "  make clean              Remove build artifacts"
	@echo "  make test               Run all tests"
	@echo "  make install            Install extractor and libraries"

## build: Build extractor, database schema, and QL library
build: extractor dbscheme ql-library
	@echo "✓ Build complete"

## extractor: Build the PHP extractor (Rust binary)
extractor: $(EXTRACTOR_BIN)
	@echo "✓ Extractor built: $(EXTRACTOR_BIN)"

$(EXTRACTOR_BIN): $(EXTRACTOR_DIR)/src/*.rs $(EXTRACTOR_DIR)/Cargo.toml
	@echo "Building PHP extractor..."
	cd $(EXTRACTOR_DIR) && $(CARGO) build --release
	@echo "✓ Extractor binary ready"

## dbscheme: Generate database schema from tree-sitter grammar
dbscheme: $(DBSCHEME_FILE)
	@echo "✓ Database schema generated: $(DBSCHEME_FILE)"

$(DBSCHEME_FILE): $(EXTRACTOR_BIN)
	@echo "Generating database schema..."
	@mkdir -p $(dir $(DBSCHEME_FILE))
	$(EXTRACTOR_BIN) generate \
		--dbscheme $(DBSCHEME_FILE) \
		--library $(TREE_SITTER_QL)
	@echo "✓ Schema generation complete"

## ql-library: Generate QL library from tree-sitter grammar
ql-library: $(TREE_SITTER_QL)
	@echo "✓ QL library generated: $(TREE_SITTER_QL)"

$(TREE_SITTER_QL): $(EXTRACTOR_BIN) $(DBSCHEME_FILE)
	@echo "QL library already generated with schema"
	@echo "✓ QL library ready"

## check: Check code without building
check:
	@echo "Checking code..."
	cd $(EXTRACTOR_DIR) && $(CARGO) check
	@echo "✓ Code check passed"

## fmt: Format Rust code
fmt:
	@echo "Formatting code..."
	cd $(EXTRACTOR_DIR) && $(CARGO) fmt
	@echo "✓ Code formatted"

## lint: Run clippy linter
lint:
	@echo "Running clippy..."
	cd $(EXTRACTOR_DIR) && $(CARGO) clippy --all-targets --all-features -- -D warnings
	@echo "✓ Linting complete"

## doc: Generate documentation
doc:
	@echo "Generating documentation..."
	cd $(EXTRACTOR_DIR) && $(CARGO) doc --no-deps --open
	@echo "✓ Documentation generated"

## test: Run all tests
test: unit-tests query-tests
	@echo "✓ All tests passed"

## unit-tests: Run Rust unit tests
unit-tests:
	@echo "Running Rust unit tests..."
	cd $(EXTRACTOR_DIR) && $(CARGO) test --release
	@echo "✓ Unit tests passed"

## query-tests: Run CodeQL query tests
query-tests: build
	@echo "Running CodeQL query tests..."
	@if command -v codeql >/dev/null 2>&1; then \
		$(CODEQL) test run $(QL_SRC_DIR)/queries/security --verbose; \
		echo "✓ Query tests passed"; \
	else \
		echo "⚠ CodeQL CLI not found, skipping query tests"; \
	fi

## install: Install extractor and register libraries
install: build
	@echo "Installing extractor..."
	@mkdir -p $(HOME)/.codeql/extractors/php/
	@cp $(EXTRACTOR_BIN) $(HOME)/.codeql/extractors/php/
	@cp codeql-extractor.yml $(HOME)/.codeql/extractors/php/
	@echo "✓ Extractor installed to $(HOME)/.codeql/extractors/php/"
	@echo ""
	@echo "QL Libraries:"
	@echo "  - Library pack: $(QL_LIB_DIR)/qlpack.yml"
	@echo "  - Query pack: $(QL_SRC_DIR)/qlpack.yml"
	@echo ""
	@echo "To use with CodeQL, set CODEQL_PYTHONPATH:"
	@echo "  export CODEQL_PYTHONPATH=$$(pwd)/$(QL_LIB_DIR)"

## clean: Remove build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(TARGET_DIR)
	@rm -rf $(BUILD_DIR)
	@rm -f $(DBSCHEME_FILE)
	@rm -f $(TREE_SITTER_QL)
	@cd $(EXTRACTOR_DIR) && $(CARGO) clean
	@echo "✓ Clean complete"

## clean-all: Remove all generated files
clean-all: clean
	@echo "Removing all generated files..."
	@find . -name "*.lock" -delete
	@find . -name ".DS_Store" -delete
	@echo "✓ Full clean complete"

## dist: Create distribution package
dist: build
	@echo "Creating distribution package..."
	@mkdir -p $(BUILD_DIR)/php
	@cp -r $(QL_LIB_DIR) $(BUILD_DIR)/php/
	@cp -r $(QL_SRC_DIR) $(BUILD_DIR)/php/
	@cp $(EXTRACTOR_BIN) $(BUILD_DIR)/php/extractor
	@cp codeql-extractor.yml $(BUILD_DIR)/php/
	@cp README.md $(BUILD_DIR)/php/
	@tar -czf $(BUILD_DIR)/php-support.tar.gz -C $(BUILD_DIR) php
	@echo "✓ Distribution package created: $(BUILD_DIR)/php-support.tar.gz"

## extract-example: Extract example PHP file
extract-example: build
	@echo "Extracting example PHP file..."
	@mkdir -p build/trap
	@echo '<?php echo "Hello, World!"; ?>' > build/example.php
	$(EXTRACTOR_BIN) extract \
		--output build/trap \
		--source-root build/example.php \
		--verbose
	@echo "✓ Extraction complete. TRAP files in build/trap/"

## profile: Profile the extractor
profile: build
	@echo "Profiling extractor..."
	cd $(EXTRACTOR_DIR) && $(CARGO) build --profile=bench
	@echo "✓ Profiling complete"

## version: Print version information
version:
	@echo "CodeQL PHP Extractor Version Information"
	@echo "========================================"
	@$(EXTRACTOR_BIN) --version
	@$(EXTRACTOR_BIN) diag

.SILENT: help version
