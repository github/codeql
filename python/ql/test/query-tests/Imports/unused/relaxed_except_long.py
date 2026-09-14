# Three or more unparenthesized exception types. These fail the default parser
# and are extracted by the tree-sitter parser instead; all names are still uses.
from relaxed_except_defs import Delta, Epsilon, Gamma, Zeta


def three():
    try:
        pass
    except Gamma, Delta, Epsilon:
        raise


def four():
    try:
        pass
    except Gamma, Delta, Epsilon, Zeta:
        raise
