# PEP 758 allows unparenthesized exception types when there is no `as` clause.
# Every import below except `NeverUsed` is used, leaving one expected result.
from relaxed_except_defs import Delta, Gamma, NeverUsed


# The `except Alpha, Beta:` case is covered separately in the Python 2 and
# Python 3 test directories because its semantics differ between versions.
#
# The version-specific files deliberately contain no `except A, B, C:` clause.
# Three or more unparenthesized types fail the default parser, which sends the
# whole file to the tree-sitter parser and would mask the behavior under test.
def parenthesized():
    try:
        pass
    except (Gamma, Delta):
        raise
