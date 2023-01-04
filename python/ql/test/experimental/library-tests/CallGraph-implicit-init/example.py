"""
Test that we can resolve callables correctly without using explicit __init__.py files

This is not included in the standard `CallGraph/code` folder, since we're testing our
understanding import work properly, so it's better to have a clean test setup that is
obviously correct (the other one isn't in regards to imports).

Technically this is part of PEP 420 -- Implicit Namespace Packages, but does not use the
*real* namespace package feature of allowing source code for a single package to reside
in multiple places.

Maybe this should have been an import resolution test, and not a call-graph test ¯\_(ツ)_/¯

Since PEP 420 was accepted in Python 3, this test is Python 3 only.
"""

from foo.bar.a import afunc
from foo_explicit.bar.a import explicit_afunc

afunc() # $ MISSING: pt,tt=afunc

explicit_afunc() # $ pt=explicit_afunc MISSING: tt=explicit_afunc
