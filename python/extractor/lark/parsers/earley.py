"This module implements an Earley Parser"

# The parser uses a parse-forest to keep track of derivations and ambiguations.
# When the parse ends successfully, a disambiguation stage resolves all ambiguity
# (right now ambiguity resolution is not developed beyond the needs of lark)
# Afterwards the parse tree is reduced (transformed) according to user callbacks.
# I use the no-recursion version of Transformer, because the tree might be
# deeper than Python's recursion limit (a bit absurd, but that's life)
#
# The algorithm keeps track of each state set, using a corresponding Column instance.
# Column keeps track of new items using NewsList instances.
#
# Author: Erez Shinan (2017)
# Email : erezshin@gmail.com

from ..tree import Tree
from ..visitors import Transformer_InPlace, v_args
from ..exceptions import ParseError, UnexpectedToken
from .grammar_analysis import GrammarAnalyzer
from ..grammar import NonTerminal


class Derivation(Tree):
    def __init__(self, rule, items=None):
        Tree.__init__(self, 'drv', items or [])
        self.meta.rule = rule
        self._hash = None

    def _pretty_label(self):    # Nicer pretty for debugging the parser
        return self.rule.origin if self.rule else self.data

    def __hash__(self):
        if self._hash is None:
            self._hash = Tree.__hash__(self)
        return self._hash

class Item(object):
    "An Earley Item, the atom of the algorithm."

    def __init__(self, rule, ptr, start, tree):
        self.rule = rule
        self.ptr = ptr
        self.start = start
        self.tree = tree if tree is not None else Derivation(self.rule)

    @property
    def expect(self):
        return self.rule.expansion[self.ptr]

    @property
    def is_complete(self):
        return self.ptr == len(self.rule.expansion)

    def advance(self, tree):
        assert self.tree.data == 'drv'
        new_tree = Derivation(self.rule, self.tree.children + [tree])
        return self.__class__(self.rule, self.ptr+1, self.start, new_tree)

    def __eq__(self, other):
        return self.start is other.start and self.ptr == other.ptr and self.rule == other.rule

    def __hash__(self):
        return hash((self.rule, self.ptr, id(self.start)))   # Always runs Derivation.__hash__

    def __repr__(self):
        before = list(map(str, self.rule.expansion[:self.ptr]))
        after = list(map(str, self.rule.expansion[self.ptr:]))
        return '<(%d) %s : %s * %s>' % (id(self.start), self.rule.origin, ' '.join(before), ' '.join(after))

class NewsList(list):
    "Keeps track of newly added items (append-only)"

    def __init__(self, initial=None):
        list.__init__(self, initial or [])
        self.last_iter = 0

    def get_news(self):
        i = self.last_iter
        self.last_iter = len(self)
        return self[i:]



class Column:
    "An entry in the table, aka Earley Chart. Contains lists of items."
    def __init__(self, i, FIRST, predict_all=False):
        self.i = i
        self.to_reduce = NewsList()
        self.to_predict = NewsList()
        self.to_scan = []
        self.item_count = 0
        self.FIRST = FIRST

        self.predicted = set()
        self.completed = {}
        self.predict_all = predict_all

    def add(self, items):
        """Sort items into scan/predict/reduce newslists

        Makes sure only unique items are added.
        """
        for item in items:

            item_key = item, item.tree  # Elsewhere, tree is not part of the comparison
            if item.is_complete:
                # XXX Potential bug: What happens if there's ambiguity in an empty rule?
                if item.rule.expansion and item_key in self.completed:
                    old_tree = self.completed[item_key].tree
                    if old_tree == item.tree:
                        is_empty = not self.FIRST[item.rule.origin]
                        if not is_empty:
                            continue

                    if old_tree.data != '_ambig':
                        new_tree = old_tree.copy()
                        new_tree.meta.rule = old_tree.meta.rule
                        old_tree.set('_ambig', [new_tree])
                        old_tree.meta.rule = None    # No longer a 'drv' node

                    if item.tree.children[0] is old_tree:   # XXX a little hacky!
                        raise ParseError("Infinite recursion in grammar! (Rule %s)" % item.rule)

                    if item.tree not in old_tree.children:
                        old_tree.children.append(item.tree)
                    # old_tree.children.append(item.tree)
                else:
                    self.completed[item_key] = item
                self.to_reduce.append(item)
            else:
                if item.expect.is_term:
                    self.to_scan.append(item)
                else:
                    k = item_key if self.predict_all else item
                    if k in self.predicted:
                        continue
                    self.predicted.add(k)
                    self.to_predict.append(item)

            self.item_count += 1    # Only count if actually added


    def __bool__(self):
        return bool(self.item_count)
    __nonzero__ = __bool__  # Py2 backwards-compatibility

class Parser:
    def __init__(self, parser_conf, term_matcher, resolve_ambiguity=None):
        analysis = GrammarAnalyzer(parser_conf)
        self.parser_conf = parser_conf
        self.resolve_ambiguity = resolve_ambiguity

        self.FIRST = analysis.FIRST
        self.postprocess = {}
        self.predictions = {}
        for rule in parser_conf.rules:
            self.postprocess[rule] = rule.alias if callable(rule.alias) else getattr(parser_conf.callback, rule.alias)
            self.predictions[rule.origin] = [x.rule for x in analysis.expand_rule(rule.origin)]

        self.term_matcher = term_matcher


    def parse(self, stream, start_symbol=None):
        # Define parser functions
        start_symbol = NonTerminal(start_symbol or self.parser_conf.start)

        _Item = Item
        match = self.term_matcher

        def predict(nonterm, column):
            assert not nonterm.is_term, nonterm
            return [_Item(rule, 0, column, None) for rule in self.predictions[nonterm]]

        def complete(item):
            name = item.rule.origin
            return [i.advance(item.tree) for i in item.start.to_predict if i.expect == name]

        def predict_and_complete(column):
            while True:
                to_predict = {x.expect for x in column.to_predict.get_news()
                              if x.ptr}  # if not part of an already predicted batch
                to_reduce = set(column.to_reduce.get_news())
                if not (to_predict or to_reduce):
                    break

                for nonterm in to_predict:
                    column.add( predict(nonterm, column) )

                for item in to_reduce:
                    new_items = list(complete(item))
                    if item in new_items:
                        raise ParseError('Infinite recursion detected! (rule %s)' % item.rule)
                    column.add(new_items)

        def scan(i, token, column):
            next_set = Column(i, self.FIRST)
            next_set.add(item.advance(token) for item in column.to_scan if match(item.expect, token))

            if not next_set:
                expect = {i.expect.name for i in column.to_scan}
                raise UnexpectedToken(token, expect, considered_rules=set(column.to_scan))

            return next_set

        # Main loop starts
        column0 = Column(0, self.FIRST)
        column0.add(predict(start_symbol, column0))

        column = column0
        for i, token in enumerate(stream):
            predict_and_complete(column)
            column = scan(i, token, column)

        predict_and_complete(column)

        # Parse ended. Now build a parse tree
        solutions = [n.tree for n in column.to_reduce
                     if n.rule.origin==start_symbol and n.start is column0]

        if not solutions:
            raise ParseError('Incomplete parse: Could not find a solution to input')
        elif len(solutions) == 1:
            tree = solutions[0]
        else:
            tree = Tree('_ambig', solutions)

        if self.resolve_ambiguity:
            tree = self.resolve_ambiguity(tree)

        return ApplyCallbacks(self.postprocess).transform(tree)


class ApplyCallbacks(Transformer_InPlace):
    def __init__(self, postprocess):
        self.postprocess = postprocess

    @v_args(meta=True)
    def drv(self, children, meta):
        return self.postprocess[meta.rule](children)
