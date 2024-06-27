import re
from functools import partial

from .utils import get_regexp_width
from .parsers.grammar_analysis import GrammarAnalyzer
from .lexer import TraditionalLexer, ContextualLexer, Lexer, Token

from .parsers import lalr_parser, earley, xearley, resolve_ambig, cyk
from .tree import Tree

class WithLexer:
    lexer = None
    parser = None
    lexer_conf = None

    def init_traditional_lexer(self, lexer_conf):
        self.lexer_conf = lexer_conf
        self.lexer = TraditionalLexer(lexer_conf.tokens, ignore=lexer_conf.ignore, user_callbacks=lexer_conf.callbacks)

    def init_contextual_lexer(self, lexer_conf):
        self.lexer_conf = lexer_conf
        states = {idx:list(t.keys()) for idx, t in self.parser._parse_table.states.items()}
        always_accept = lexer_conf.postlex.always_accept if lexer_conf.postlex else ()
        self.lexer = ContextualLexer(lexer_conf.tokens, states,
                                     ignore=lexer_conf.ignore,
                                     always_accept=always_accept,
                                     user_callbacks=lexer_conf.callbacks)

    def lex(self, text):
        stream = self.lexer.lex(text)
        if self.lexer_conf.postlex:
            return self.lexer_conf.postlex.process(stream)
        return stream

    def parse(self, text):
        token_stream = self.lex(text)
        sps = self.lexer.set_parser_state
        return self.parser.parse(token_stream, *[sps] if sps is not NotImplemented else [])

class LALR_TraditionalLexer(WithLexer):
    def __init__(self, lexer_conf, parser_conf, options=None):
        self.parser = lalr_parser.Parser(parser_conf)
        self.init_traditional_lexer(lexer_conf)

class LALR_ContextualLexer(WithLexer):
    def __init__(self, lexer_conf, parser_conf, options=None):
        self.parser = lalr_parser.Parser(parser_conf)
        self.init_contextual_lexer(lexer_conf)

class LALR_CustomLexer(WithLexer):
    def __init__(self, lexer_cls, lexer_conf, parser_conf, options=None):
        self.parser = lalr_parser.Parser(parser_conf)
        self.lexer_conf = lexer_conf
        self.lexer = lexer_cls(lexer_conf)


def get_ambiguity_resolver(options):
    if not options or options.ambiguity == 'resolve':
        return resolve_ambig.standard_resolve_ambig
    elif options.ambiguity == 'resolve__antiscore_sum':
        return resolve_ambig.antiscore_sum_resolve_ambig
    elif options.ambiguity == 'explicit':
        return None
    raise ValueError(options)

def tokenize_text(text):
    line = 1
    col_start_pos = 0
    for i, ch in enumerate(text):
        if '\n' in ch:
            line += ch.count('\n')
            col_start_pos = i + ch.rindex('\n')
        yield Token('CHAR', ch, line=line, column=i - col_start_pos)

class Earley(WithLexer):
    def __init__(self, lexer_conf, parser_conf, options=None):
        self.init_traditional_lexer(lexer_conf)

        self.parser = earley.Parser(parser_conf, self.match,
                                    resolve_ambiguity=get_ambiguity_resolver(options))

    def match(self, term, token):
        return term.name == token.type


class XEarley:
    def __init__(self, lexer_conf, parser_conf, options=None, **kw):
        self.token_by_name = {t.name:t for t in lexer_conf.tokens}

        self._prepare_match(lexer_conf)

        self.parser = xearley.Parser(parser_conf,
                                    self.match,
                                    resolve_ambiguity=get_ambiguity_resolver(options),
                                    ignore=lexer_conf.ignore,
                                    predict_all=options.earley__predict_all,
                                    **kw
                                    )

    def match(self, term, text, index=0):
        return self.regexps[term.name].match(text, index)

    def _prepare_match(self, lexer_conf):
        self.regexps = {}
        for t in lexer_conf.tokens:
            regexp = t.pattern.to_regexp()
            try:
                width = get_regexp_width(regexp)[0]
            except ValueError:
                raise ValueError("Bad regexp in token %s: %s" % (t.name, regexp))
            else:
                if width == 0:
                    raise ValueError("Dynamic Earley doesn't allow zero-width regexps", t)

            self.regexps[t.name] = re.compile(regexp)

    def parse(self, text):
        return self.parser.parse(text)

class XEarley_CompleteLex(XEarley):
    def __init__(self, *args, **kw):
        super(self).__init__(*args, complete_lex=True, **kw)



class CYK(WithLexer):

    def __init__(self, lexer_conf, parser_conf, options=None):
        self.init_traditional_lexer(lexer_conf)

        self._analysis = GrammarAnalyzer(parser_conf)
        self._parser = cyk.Parser(parser_conf.rules, parser_conf.start)

        self._postprocess = {}
        for rule in parser_conf.rules:
            a = rule.alias
            self._postprocess[a] = a if callable(a) else (a and getattr(parser_conf.callback, a))

    def parse(self, text):
        tokens = list(self.lex(text))
        parse = self._parser.parse(tokens)
        parse = self._transform(parse)
        return parse

    def _transform(self, tree):
        subtrees = list(tree.iter_subtrees())
        for subtree in subtrees:
            subtree.children = [self._apply_callback(c) if isinstance(c, Tree) else c for c in subtree.children]

        return self._apply_callback(tree)

    def _apply_callback(self, tree):
        children = tree.children
        callback = self._postprocess[tree.rule.alias]
        assert callback, tree.rule.alias
        r = callback(children)
        return r


def get_frontend(parser, lexer):
    if parser=='lalr':
        if lexer is None:
            raise ValueError('The LALR parser requires use of a lexer')
        elif lexer == 'standard':
            return LALR_TraditionalLexer
        elif lexer == 'contextual':
            return LALR_ContextualLexer
        elif issubclass(lexer, Lexer):
            return partial(LALR_CustomLexer, lexer)
        else:
            raise ValueError('Unknown lexer: %s' % lexer)
    elif parser=='earley':
        if lexer=='standard':
            return Earley
        elif lexer=='dynamic':
            return XEarley
        elif lexer=='dynamic_complete':
            return XEarley_CompleteLex
        elif lexer=='contextual':
            raise ValueError('The Earley parser does not support the contextual parser')
        else:
            raise ValueError('Unknown lexer: %s' % lexer)
    elif parser == 'cyk':
        if lexer == 'standard':
            return CYK
        else:
            raise ValueError('CYK parser requires using standard parser.')
    else:
        raise ValueError('Unknown parser: %s' % parser)
