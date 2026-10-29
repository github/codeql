# Copyright 2006 Google, Inc. All Rights Reserved.
# Licensed to PSF under a Contributor Agreement.

"""Export the Python grammar and symbols."""

# Python imports
import os

# Local imports
from .pgen2 import token
from .pgen2 import driver

# The grammar file
_GRAMMAR_FILE = "Grammar.txt"


class Symbols(object):

    def __init__(self, grammar):
        """Initializer.

        Creates an attribute for each grammar symbol (nonterminal),
        whose value is the symbol's type (an int >= 256).
        """
        for name, symbol in grammar.symbol2number.items():
            setattr(self, name, symbol)


def initialize(cache_dir=None):
    global python2_grammar
    global python2_grammar_no_print_statement
    global python3_grammar
    global python3_grammar_no_async
    global python_symbols

    python_grammar = driver.load_grammar("blib2to3", _GRAMMAR_FILE)
    python_symbols = Symbols(python_grammar)

    # Python 2
    python2_grammar = python_grammar.copy()
    del python2_grammar.keywords["async"]
    del python2_grammar.keywords["await"]

    # Python 2 + from __future__ import print_function
    python2_grammar_no_print_statement = python2_grammar.copy()
    del python2_grammar_no_print_statement.keywords["print"]

    # Python 3
    python3_grammar = python_grammar
    del python3_grammar.keywords["print"]
    del python3_grammar.keywords["exec"]

    #Python 3 wihtout async or await
    python3_grammar_no_async = python3_grammar.copy()
    del python3_grammar_no_async.keywords["async"]
    del python3_grammar_no_async.keywords["await"]
