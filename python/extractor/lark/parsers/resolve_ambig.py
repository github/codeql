from ..utils import compare
from functools import cmp_to_key

from ..tree import Tree


# Standard ambiguity resolver (uses comparison)
#
# Author: Erez Sh

def _compare_rules(rule1, rule2):
    return -compare( len(rule1.expansion), len(rule2.expansion))

def _sum_priority(tree):
    p = 0

    for n in tree.iter_subtrees():
        try:
            p += n.meta.rule.options.priority or 0
        except AttributeError:
            pass

    return p

def _compare_priority(tree1, tree2):
    tree1.iter_subtrees()

def _compare_drv(tree1, tree2):
    try:
        rule1 = tree1.meta.rule
    except AttributeError:
        rule1 = None

    try:
        rule2 = tree2.meta.rule
    except AttributeError:
        rule2 = None

    if None == rule1 == rule2:
        return compare(tree1, tree2)
    elif rule1 is None:
        return -1
    elif rule2 is None:
        return 1

    assert tree1.data != '_ambig'
    assert tree2.data != '_ambig'

    p1 = _sum_priority(tree1)
    p2 = _sum_priority(tree2)
    c = (p1 or p2) and compare(p1, p2)
    if c:
        return c

    c = _compare_rules(tree1.meta.rule, tree2.meta.rule)
    if c:
        return c

    # rules are "equal", so compare trees
    if len(tree1.children) == len(tree2.children):
        for t1, t2 in zip(tree1.children, tree2.children):
            c = _compare_drv(t1, t2)
            if c:
                return c

    return compare(len(tree1.children), len(tree2.children))


def _standard_resolve_ambig(tree):
    assert tree.data == '_ambig'
    key_f = cmp_to_key(_compare_drv)
    best = max(tree.children, key=key_f)
    assert best.data == 'drv'
    tree.set('drv', best.children)
    tree.meta.rule = best.meta.rule   # needed for applying callbacks

def standard_resolve_ambig(tree):
    for ambig in tree.find_data('_ambig'):
        _standard_resolve_ambig(ambig)

    return tree




# Anti-score Sum
#
# Author: Uriva (https://github.com/uriva)

def _antiscore_sum_drv(tree):
    if not isinstance(tree, Tree):
        return 0

    assert tree.data != '_ambig'

    return _sum_priority(tree)

def _antiscore_sum_resolve_ambig(tree):
    assert tree.data == '_ambig'
    best = min(tree.children, key=_antiscore_sum_drv)
    assert best.data == 'drv'
    tree.set('drv', best.children)
    tree.meta.rule = best.meta.rule   # needed for applying callbacks

def antiscore_sum_resolve_ambig(tree):
    for ambig in tree.find_data('_ambig'):
        _antiscore_sum_resolve_ambig(ambig)

    return tree
