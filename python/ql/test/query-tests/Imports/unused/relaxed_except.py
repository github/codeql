# PEP 758 allows unparenthesized exception types when there is no `as` clause.
# Every name below is used as an exception type, so no import here is unused.
# `NeverUsed` is imported and never used, and is the one expected result.
#
# Each name appears in exactly one clause on purpose: a name that also appeared
# in a parenthesized clause would be a use regardless, and would mask the
# behaviour under test.
#
# This file deliberately contains no `except A, B, C:` clause. Three or more
# unparenthesized types fail the default parser, which sends the whole file to
# the tree-sitter parser and would likewise mask it.
from relaxed_except_defs import Alpha, Beta, Delta, Gamma, NeverUsed


def unparenthesized():
    try:
        pass
    except Alpha, Beta:
        raise


def parenthesized():
    try:
        pass
    except (Gamma, Delta):
        raise
