.PHONY: all
.DEFAULT: all
all:

OS = $(shell uname)

GIT_ROOT = $(shell git rev-parse --show-toplevel)

TOKENIZER_FILE = semmle/python/parser/tokenizer.py
TOKENIZER_DEPS = tokenizer_generator/state_transition.txt tokenizer_generator/tokenizer_template.py
# Must use the same Python version as on jenkins, since output differs per version.
# However, output is unstable on Python 3.5 (which jenkins uses)
TOKENIZER_CMD = python3 -m tokenizer_generator.gen_state_machine $(TOKENIZER_DEPS)

.PHONY: tokenizer
tokenizer: $(TOKENIZER_FILE)

$(TOKENIZER_FILE): $(TOKENIZER_DEPS)
	$(TOKENIZER_CMD) > $@


MASTER_FILE = semmle/python/master.py

DBSCHEME_FILE = $(GIT_ROOT)/python/ql/lib/semmlecode.python.dbscheme

.PHONY: dbscheme
dbscheme: $(MASTER_FILE)
	python3 -m semmle.dbscheme_gen $(DBSCHEME_FILE)

AST_GENERATED_DIR = $(GIT_ROOT)/python/ql/lib/semmle/python/
AST_GENERATED_FILE = $(AST_GENERATED_DIR)AstGenerated.qll

.PHONY: ast
ast: $(MASTER_FILE)
	python3 -m semmle.query_gen $(AST_GENERATED_DIR)
	codeql query format --in-place $(AST_GENERATED_FILE)

################################################################################
# Tests
################################################################################

.PHONY: test-all
test-all: test-3

.PHONY: test-3
test-3: pytest-3 test-tokenizer

.PHONY: test-tokenizer
test-tokenizer: SHELL:=/bin/bash
test-tokenizer:
	@echo Not running test-tokenizer as jenkins uses Python 3.5
	# TODO: Enable again once we run Python > 3.5 on Jenkins
	# diff -u $(TOKENIZER_FILE) <($(TOKENIZER_CMD))

.PHONY: pytest-3
pytest-3:
	poetry run pytest

.PHONY: pytest-3-deprecation-error
pytest-3-deprecation-error:
	PYTHONWARNINGS='error::DeprecationWarning' poetry run pytest
