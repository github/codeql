"This module implements an experimental Earley Parser with a dynamic lexer"

# The parser uses a parse-forest to keep track of derivations and ambiguations.
# When the parse ends successfully, a disambiguation stage resolves all ambiguity
# (right now ambiguity resolution is not developed beyond the needs of lark)
# Afterwards the parse tree is reduced (transformed) according to user callbacks.
# I use the no-recursion version of Transformer and Visitor, because the tree might be
# deeper than Python's recursion limit (a bit absurd, but that's life)
#
# The algorithm keeps track of each state set, using a corresponding Column instance.
# Column keeps track of new items using NewsList instances.
#
# Instead of running a lexer beforehand, or using a costy char-by-char method, this parser
# uses regular expressions by necessity, achieving high-performance while maintaining all of
# Earley's power in parsing any CFG.
#
#
# Author: Erez Shinan (2017)
# Email : erezshin@gmail.com

from collections import defaultdict

from ..exceptions import ParseError, UnexpectedCharacters
from ..lexer import Token
from ..tree import Tree
from .grammar_analysis import GrammarAnalyzer
from ..grammar import NonTerminal, Terminal

from .earley import ApplyCallbacks, Item, Column


class Parser:
    def __init__(self,  parser_conf, term_matcher, resolve_ambiguity=None, ignore=(), predict_all=False, complete_lex=False):
        self.analysis = GrammarAnalyzer(parser_conf)
        self.parser_conf = parser_conf
        self.resolve_ambiguity = resolve_ambiguity
        self.ignore = [Terminal(t) for t in ignore]
        self.predict_all = predict_all
        self.complete_lex = complete_lex

        self.FIRST = self.analysis.FIRST
        self.postprocess = {}
        self.predictions = {}
        for rule in parser_conf.rules:
            self.postprocess[rule] = getattr(parser_conf.callback, rule.alias)
            self.predictions[rule.origin] = [x.rule for x in self.analysis.expand_rule(rule.origin)]

        self.term_matcher = term_matcher


    def parse(self, stream, start_symbol=None):
        # Define parser functions
        start_symbol = NonTerminal(start_symbol or self.parser_conf.start)
        delayed_matches = defaultdict(list)
        match = self.term_matcher

        text_line = 1
        text_column = 1

        def predict(nonterm, column):
            assert not nonterm.is_term, nonterm
            return [Item(rule, 0, column, None) for rule in self.predictions[nonterm]]

        def complete(item):
            name = item.rule.origin
            return [i.advance(item.tree) for i in item.start.to_predict if i.expect == name]

        def predict_and_complete(column):
            while True:
                to_predict = {x.expect for x in column.to_predict.get_news()
                              if x.ptr}  # if not part of an already predicted batch
                to_reduce = column.to_reduce.get_news()
                if not (to_predict or to_reduce):
                    break

                for nonterm in to_predict:
                    column.add( predict(nonterm, column) )
                for item in to_reduce:
                    new_items = list(complete(item))
                    if item in new_items:
                        raise ParseError('Infinite recursion detected! (rule %s)' % item.rule)
                    column.add(new_items)

        def scan(i, column):
            to_scan = column.to_scan

            for x in self.ignore:
                m = match(x, stream, i)
                if m:
                    delayed_matches[m.end()] += set(to_scan)
                    delayed_matches[m.end()] += set(column.to_reduce)

                    # TODO add partial matches for ignore too?
                    # s = m.group(0)
                    # for j in range(1, len(s)):
                    #     m = x.match(s[:-j])
                    #     if m:
                    #         delayed_matches[m.end()] += to_scan

            for item in to_scan:
                m = match(item.expect, stream, i)
                if m:
                    t = Token(item.expect.name, m.group(0), i, text_line, text_column)
                    delayed_matches[m.end()].append(item.advance(t))

                    if self.complete_lex:
                        s = m.group(0)
                        for j in range(1, len(s)):
                            m = match(item.expect, s[:-j])
                            if m:
                                t = Token(item.expect.name, m.group(0), i, text_line, text_column)
                                delayed_matches[i+m.end()].append(item.advance(t))

            next_set = Column(i+1, self.FIRST, predict_all=self.predict_all)
            next_set.add(delayed_matches[i+1])
            del delayed_matches[i+1]    # No longer needed, so unburden memory

            if not next_set and not delayed_matches:
                raise UnexpectedCharacters(stream, i, text_line, text_column, {item.expect for item in to_scan}, set(to_scan))

            return next_set

        # Main loop starts
        column0 = Column(0, self.FIRST, predict_all=self.predict_all)
        column0.add(predict(start_symbol, column0))

        column = column0
        for i, token in enumerate(stream):
            predict_and_complete(column)
            column = scan(i, column)

            if token == '\n':
                text_line += 1
                text_column = 1
            else:
                text_column += 1

        predict_and_complete(column)

        # Parse ended. Now build a parse tree
        solutions = [n.tree for n in column.to_reduce
                     if n.rule.origin==start_symbol and n.start is column0]

        if not solutions:
            expected_tokens = [t.expect for t in column.to_scan]
            raise ParseError('Unexpected end of input! Expecting a terminal of: %s' % expected_tokens)

        elif len(solutions) == 1:
            tree = solutions[0]
        else:
            tree = Tree('_ambig', solutions)

        if self.resolve_ambiguity:
            tree = self.resolve_ambiguity(tree)

        return ApplyCallbacks(self.postprocess).transform(tree)
