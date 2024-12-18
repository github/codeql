from collections import defaultdict

from .tree import Tree
from .visitors import Transformer_InPlace
from .common import ParserConf, PatternStr
from .lexer import Token
from .parsers import earley, resolve_ambig
from .grammar import Rule, Terminal, NonTerminal



def is_discarded_terminal(t):
    return t.is_term and t.filter_out

def is_iter_empty(i):
    try:
        _ = next(i)
        return False
    except StopIteration:
        return True

class WriteTokensTransformer(Transformer_InPlace):
    def __init__(self, tokens):
        self.tokens = tokens

    def __default__(self, data, children, meta):
        #  if not isinstance(t, MatchTree):
            #  return t
        if not getattr(meta, 'match_tree', False):
            return Tree(data, children)

        iter_args = iter(children)
        to_write = []
        for sym in meta.orig_expansion:
            if is_discarded_terminal(sym):
                t = self.tokens[sym.name]
                assert isinstance(t.pattern, PatternStr)
                to_write.append(t.pattern.value)
            else:
                x = next(iter_args)
                if isinstance(x, list):
                    to_write += x
                else:
                    if isinstance(x, Token):
                        assert Terminal(x.type) == sym, x
                    else:
                        assert NonTerminal(x.data) == sym, (sym, x)
                    to_write.append(x)

        assert is_iter_empty(iter_args)
        return to_write


class MatchTree(Tree):
    pass

class MakeMatchTree:
    def __init__(self, name, expansion):
        self.name = name
        self.expansion = expansion

    def __call__(self, args):
        t = MatchTree(self.name, args)
        t.meta.match_tree = True
        t.meta.orig_expansion = self.expansion
        return t

class Reconstructor:
    def __init__(self, parser):
        # XXX TODO calling compile twice returns different results!
        tokens, rules, _grammar_extra = parser.grammar.compile()

        self.write_tokens = WriteTokensTransformer({t.name:t for t in tokens})
        self.rules = list(self._build_recons_rules(rules))

    def _build_recons_rules(self, rules):
        expand1s = {r.origin for r in rules if r.options and r.options.expand1}

        aliases = defaultdict(list)
        for r in rules:
            if r.alias:
                aliases[r.origin].append( r.alias )

        rule_names = {r.origin for r in rules}
        nonterminals = {sym for sym in rule_names
                       if sym.name.startswith('_') or sym in expand1s or sym in aliases }

        for r in rules:
            recons_exp = [sym if sym in nonterminals else Terminal(sym.name)
                          for sym in r.expansion if not is_discarded_terminal(sym)]

            # Skip self-recursive constructs
            if recons_exp == [r.origin]:
                continue

            sym = NonTerminal(r.alias) if r.alias else r.origin

            yield Rule(sym, recons_exp, MakeMatchTree(sym.name, r.expansion))

        for origin, rule_aliases in aliases.items():
            for alias in rule_aliases:
                yield Rule(origin, [Terminal(alias)], MakeMatchTree(origin.name, [NonTerminal(alias)]))

            yield Rule(origin, [Terminal(origin.name)], MakeMatchTree(origin.name, [origin]))



    def _match(self, term, token):
        if isinstance(token, Tree):
            return Terminal(token.data) == term
        elif isinstance(token, Token):
            return term == Terminal(token.type)
        assert False

    def _reconstruct(self, tree):
        # TODO: ambiguity?
        parser = earley.Parser(ParserConf(self.rules, None, tree.data), self._match, resolve_ambiguity=resolve_ambig.standard_resolve_ambig)
        unreduced_tree = parser.parse(tree.children)   # find a full derivation
        assert unreduced_tree.data == tree.data
        res = self.write_tokens.transform(unreduced_tree)
        for item in res:
            if isinstance(item, Tree):
                for x in self._reconstruct(item):
                    yield x
            else:
                yield item

    def reconstruct(self, tree):
        return ''.join(self._reconstruct(tree))
