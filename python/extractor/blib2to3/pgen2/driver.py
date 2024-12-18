# Copyright 2004-2005 Elemental Security, Inc. All Rights Reserved.
# Licensed to PSF under a Contributor Agreement.

# Modifications:
# Copyright 2006 Google, Inc. All Rights Reserved.
# Licensed to PSF under a Contributor Agreement.

"""Parser driver.

This provides a high-level interface to parse a file into a syntax tree.

"""

__author__ = "Guido van Rossum <guido@python.org>"

__all__ = ["load_grammar"]

# Python imports
import os
import logging
import pkgutil
import sys

# Pgen imports
from . import grammar, pgen

if sys.version < "3":
    from cStringIO import StringIO
else:
    from io import StringIO

def load_grammar(package, grammar):
    """Load the grammar (maybe from a pickle)."""
    data = pkgutil.get_data(package, grammar)
    stream = StringIO(data.decode("utf8"))
    g = pgen.generate_grammar(grammar, stream)
    return g
