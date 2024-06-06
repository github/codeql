"Parses and creates Grammar objects"

import os.path
import sys
from itertools import chain
import re
from ast import literal_eval
from copy import deepcopy
import pkgutil

from .lexer import Token


from .parse_tree_builder import ParseTreeBuilder
from .parser_frontends import LALR_TraditionalLexer
from .common import LexerConf, ParserConf, PatternStr, PatternRE, TokenDef
from .grammar import RuleOptions, Rule, Terminal, NonTerminal, Symbol
from .utils import classify, suppress
from .exceptions import GrammarError, UnexpectedCharacters, UnexpectedToken

from .tree import Tree, SlottedTree as ST
from .visitors import Transformer, Visitor, v_args, Transformer_InPlace
inline_args = v_args(inline=True)

__path__ = os.path.dirname(__file__)

GRAMMAR_PACKAGES = ['lark.grammars']

EXT = '.lark'

_RE_FLAGS = 'imslux'

def is_terminal(sym):
    return sym.isupper()

_TERMINAL_NAMES = {
    '.' : 'DOT',
    ',' : 'COMMA',
    ':' : 'COLON',
    ';' : 'SEMICOLON',
    '+' : 'PLUS',
    '-' : 'MINUS',
    '*' : 'STAR',
    '/' : 'SLASH',
    '\\' : 'BACKSLASH',
    '|' : 'VBAR',
    '?' : 'QMARK',
    '!' : 'BANG',
    '@' : 'AT',
    '#' : 'HASH',
    '$' : 'DOLLAR',
    '%' : 'PERCENT',
    '^' : 'CIRCUMFLEX',
    '&' : 'AMPERSAND',
    '_' : 'UNDERSCORE',
    '<' : 'LESSTHAN',
    '>' : 'MORETHAN',
    '=' : 'EQUAL',
    '"' : 'DBLQUOTE',
    '\'' : 'QUOTE',
    '`' : 'BACKQUOTE',
    '~' : 'TILDE',
    '(' : 'LPAR',
    ')' : 'RPAR',
    '{' : 'LBRACE',
    '}' : 'RBRACE',
    '[' : 'LSQB',
    ']' : 'RSQB',
    '\n' : 'NEWLINE',
    '\r\n' : 'CRLF',
    '\t' : 'TAB',
    ' ' : 'SPACE',
}

# Grammar Parser
TERMINALS = {
    '_LPAR': r'\(',
    '_RPAR': r'\)',
    '_LBRA': r'\[',
    '_RBRA': r'\]',
    'OP': '[+*][?]?|[?](?![a-z])',
    '_COLON': ':',
    '_COMMA': ',',
    '_OR': r'\|',
    '_DOT': r'\.',
    'TILDE': '~',
    'RULE': '!?[_?]?[a-z][_a-z0-9]*',
    'TERMINAL': '_?[A-Z][_A-Z0-9]*',
    'STRING': r'"(\\"|\\\\|[^"\n])*?"i?',
    'REGEXP': r'/(?!/)(\\/|\\\\|[^/\n])*?/[%s]*' % _RE_FLAGS,
    '_NL': r'(\r?\n)+\s*',
    'WS': r'[ \t]+',
    'COMMENT': r'//[^\n]*',
    '_TO': '->',
    '_IGNORE': r'%ignore',
    '_DECLARE': r'%declare',
    '_IMPORT': r'%import',
    'NUMBER': r'\d+',
}

RULES = {
    'start': ['_list'],
    '_list':  ['_item', '_list _item'],
    '_item':  ['rule', 'token', 'statement', '_NL'],

    'rule': ['RULE _COLON expansions _NL',
             'RULE _DOT NUMBER _COLON expansions _NL'],
    'expansions': ['alias',
                   'expansions _OR alias',
                   'expansions _NL _OR alias'],

    '?alias':     ['expansion _TO RULE', 'expansion'],
    'expansion': ['_expansion'],

    '_expansion': ['', '_expansion expr'],

    '?expr': ['atom',
              'atom OP',
              'atom TILDE NUMBER',
              'atom TILDE NUMBER _DOT _DOT NUMBER',
              ],

    '?atom': ['_LPAR expansions _RPAR',
              'maybe',
              'value'],

    'value': ['terminal',
              'nonterminal',
              'literal',
              'range'],

    'terminal': ['TERMINAL'],
    'nonterminal': ['RULE'],

    '?name': ['RULE', 'TERMINAL'],

    'maybe': ['_LBRA expansions _RBRA'],
    'range': ['STRING _DOT _DOT STRING'],

    'token': ['TERMINAL _COLON expansions _NL',
              'TERMINAL _DOT NUMBER _COLON expansions _NL'],
    'statement': ['ignore', 'import', 'declare'],
    'ignore': ['_IGNORE expansions _NL'],
    'declare': ['_DECLARE _declare_args _NL'],
    'import': ['_IMPORT _import_path _NL',
               '_IMPORT _import_path _LPAR name_list _RPAR _NL',
               '_IMPORT _import_path _TO TERMINAL _NL'],

    '_import_path': ['import_lib', 'import_rel'],
    'import_lib': ['_import_args'],
    'import_rel': ['_DOT _import_args'],
    '_import_args': ['name', '_import_args _DOT name'],

    'name_list': ['_name_list'],
    '_name_list': ['name', '_name_list _COMMA name'],

    '_declare_args': ['name', '_declare_args name'],
    'literal': ['REGEXP', 'STRING'],
}


@inline_args
class EBNF_to_BNF(Transformer_InPlace):
    def __init__(self):
        self.new_rules = []
        self.rules_by_expr = {}
        self.prefix = 'anon'
        self.i = 0
        self.rule_options = None

    def _add_recurse_rule(self, type_, expr):
        if expr in self.rules_by_expr:
            return self.rules_by_expr[expr]

        new_name = '__%s_%s_%d' % (self.prefix, type_, self.i)
        self.i += 1
        t = NonTerminal(Token('RULE', new_name, -1))
        tree = ST('expansions', [ST('expansion', [expr]), ST('expansion', [t, expr])])
        self.new_rules.append((new_name, tree, self.rule_options))
        self.rules_by_expr[expr] = t
        return t

    def expr(self, rule, op, *args):
        if op.value == '?':
            return ST('expansions', [rule, ST('expansion', [])])
        elif op.value == '+':
            # a : b c+ d
            #   -->
            # a : b _c d
            # _c : _c c | c;
            return self._add_recurse_rule('plus', rule)
        elif op.value == '*':
            # a : b c* d
            #   -->
            # a : b _c? d
            # _c : _c c | c;
            new_name = self._add_recurse_rule('star', rule)
            return ST('expansions', [new_name, ST('expansion', [])])
        elif op.value == '~':
            if len(args) == 1:
                mn = mx = int(args[0])
            else:
                mn, mx = map(int, args)
                if mx < mn:
                    raise GrammarError("Bad Range for %s (%d..%d isn't allowed)" % (rule, mn, mx))
            return ST('expansions', [ST('expansion', [rule] * n) for n in range(mn, mx+1)])
        assert False, op


class SimplifyRule_Visitor(Visitor):

    @staticmethod
    def _flatten(tree):
        while True:
            to_expand = [i for i, child in enumerate(tree.children)
                         if isinstance(child, Tree) and child.data == tree.data]
            if not to_expand:
                break
            tree.expand_kids_by_index(*to_expand)

    def expansion(self, tree):
        # rules_list unpacking
        # a : b (c|d) e
        #  -->
        # a : b c e | b d e
        #
        # In AST terms:
        # expansion(b, expansions(c, d), e)
        #   -->
        # expansions( expansion(b, c, e), expansion(b, d, e) )

        self._flatten(tree)

        for i, child in enumerate(tree.children):
            if isinstance(child, Tree) and child.data == 'expansions':
                tree.data = 'expansions'
                tree.children = [self.visit(ST('expansion', [option if i==j else other
                                                            for j, other in enumerate(tree.children)]))
                                    for option in set(child.children)]
                self._flatten(tree)
                break

    def alias(self, tree):
        rule, alias_name = tree.children
        if rule.data == 'expansions':
            aliases = []
            for child in tree.children[0].children:
                aliases.append(ST('alias', [child, alias_name]))
            tree.data = 'expansions'
            tree.children = aliases

    def expansions(self, tree):
        self._flatten(tree)
        tree.children = list(set(tree.children))


class RuleTreeToText(Transformer):
    def expansions(self, x):
        return x
    def expansion(self, symbols):
        return symbols, None
    def alias(self, x):
        (expansion, _alias), alias = x
        assert _alias is None, (alias, expansion, '-', _alias)  # Double alias not allowed
        return expansion, alias.value


@inline_args
class CanonizeTree(Transformer_InPlace):
    def maybe(self, expr):
        return ST('expr', [expr, Token('OP', '?', -1)])

    def tokenmods(self, *args):
        if len(args) == 1:
            return list(args)
        tokenmods, value = args
        return tokenmods + [value]

class PrepareAnonTerminals(Transformer_InPlace):
    "Create a unique list of anonymous tokens. Attempt to give meaningful names to them when we add them"

    def __init__(self, tokens):
        self.tokens = tokens
        self.token_set = {td.name for td in self.tokens}
        self.token_reverse = {td.pattern: td for td in tokens}
        self.i = 0


    @inline_args
    def pattern(self, p):
        value = p.value
        if p in self.token_reverse and p.flags != self.token_reverse[p].pattern.flags:
            raise GrammarError(u'Conflicting flags for the same terminal: %s' % p)

        token_name = None

        if isinstance(p, PatternStr):
            try:
                # If already defined, use the user-defined token name
                token_name = self.token_reverse[p].name
            except KeyError:
                # Try to assign an indicative anon-token name
                try:
                    token_name = _TERMINAL_NAMES[value]
                except KeyError:
                    if value.isalnum() and value[0].isalpha() and value.upper() not in self.token_set:
                        with suppress(UnicodeEncodeError):
                            value.upper().encode('ascii') # Make sure we don't have unicode in our token names
                            token_name = value.upper()

        elif isinstance(p, PatternRE):
            if p in self.token_reverse: # Kind of a wierd placement.name
                token_name = self.token_reverse[p].name
        else:
            assert False, p

        if token_name is None:
            token_name = '__ANON_%d' % self.i
            self.i += 1

        if token_name not in self.token_set:
            assert p not in self.token_reverse
            self.token_set.add(token_name)
            tokendef = TokenDef(token_name, p)
            self.token_reverse[p] = tokendef
            self.tokens.append(tokendef)

        return Terminal(token_name, filter_out=isinstance(p, PatternStr))


def _rfind(s, choices):
    return max(s.rfind(c) for c in choices)



def _fix_escaping(s):
    w = ''
    i = iter(s)
    for n in i:
        w += n
        if n == '\\':
            n2 = next(i)
            if n2 == '\\':
                w += '\\\\'
            elif n2 not in 'unftr':
                w += '\\'
            w += n2
    w = w.replace('\\"', '"').replace("'", "\\'")

    to_eval = "u'''%s'''" % w
    try:
        s = literal_eval(to_eval)
    except SyntaxError as e:
        raise ValueError(s, e)

    return s


def _literal_to_pattern(literal):
    v = literal.value
    flag_start = _rfind(v, '/"')+1
    assert flag_start > 0
    flags = v[flag_start:]
    assert all(f in _RE_FLAGS for f in flags), flags

    v = v[:flag_start]
    assert v[0] == v[-1] and v[0] in '"/'
    x = v[1:-1]

    s = _fix_escaping(x)

    if literal.type == 'STRING':
        s = s.replace('\\\\', '\\')

    return { 'STRING': PatternStr,
             'REGEXP': PatternRE }[literal.type](s, flags)


@inline_args
class PrepareLiterals(Transformer_InPlace):
    def literal(self, literal):
        return ST('pattern', [_literal_to_pattern(literal)])

    def range(self, start, end):
        assert start.type == end.type == 'STRING'
        start = start.value[1:-1]
        end = end.value[1:-1]
        assert len(start) == len(end) == 1, (start, end, len(start), len(end))
        regexp = '[%s-%s]' % (start, end)
        return ST('pattern', [PatternRE(regexp)])


class TokenTreeToPattern(Transformer):
    def pattern(self, ps):
        p ,= ps
        return p

    def expansion(self, items):
        assert items
        if len(items) == 1:
            return items[0]
        if len({i.flags for i in items}) > 1:
            raise GrammarError("Lark doesn't support joining tokens with conflicting flags!")
        return PatternRE(''.join(i.to_regexp() for i in items), items[0].flags if items else ())

    def expansions(self, exps):
        if len(exps) == 1:
            return exps[0]
        if len({i.flags for i in exps}) > 1:
            raise GrammarError("Lark doesn't support joining tokens with conflicting flags!")
        return PatternRE('(?:%s)' % ('|'.join(i.to_regexp() for i in exps)), exps[0].flags)

    def expr(self, args):
        inner, op = args[:2]
        if op == '~':
            if len(args) == 3:
                op = "{%d}" % int(args[2])
            else:
                mn, mx = map(int, args[2:])
                if mx < mn:
                    raise GrammarError("Bad Range for %s (%d..%d isn't allowed)" % (inner, mn, mx))
                op = "{%d,%d}" % (mn, mx)
        else:
            assert len(args) == 2
        return PatternRE('(?:%s)%s' % (inner.to_regexp(), op), inner.flags)

    def alias(self, t):
        raise GrammarError("Aliasing not allowed in terminals (You used -> in the wrong place)")

    def value(self, v):
        return v[0]

class PrepareSymbols(Transformer_InPlace):
    def value(self, v):
        v ,= v
        if isinstance(v, Tree):
            return v
        elif v.type == 'RULE':
            return NonTerminal(v.value)
        elif v.type == 'TERMINAL':
            return Terminal(v.value, filter_out=v.startswith('_'))
        assert False

def _choice_of_rules(rules):
    return ST('expansions', [ST('expansion', [Token('RULE', name)]) for name in rules])

class Grammar:
    def __init__(self, rule_defs, token_defs, ignore):
        self.token_defs = token_defs
        self.rule_defs = rule_defs
        self.ignore = ignore

    def compile(self):
        # We change the trees in-place (to support huge grammars)
        # So deepcopy allows calling compile more than once.
        token_defs = deepcopy(list(self.token_defs))
        rule_defs = deepcopy(self.rule_defs)

        # =================
        #  Compile Tokens
        # =================

        # Convert token-trees to strings/regexps
        transformer = PrepareLiterals() * TokenTreeToPattern()
        for name, (token_tree, priority) in token_defs:
            if token_tree is None:  # Terminal added through %declare
                continue
            expansions = list(token_tree.find_data('expansion'))
            if len(expansions) == 1 and not expansions[0].children:
                raise GrammarError("Terminals cannot be empty (%s)" % name)

        tokens = [TokenDef(name, transformer.transform(token_tree), priority)
                  for name, (token_tree, priority) in token_defs if token_tree]

        # =================
        #  Compile Rules
        # =================

        # 1. Pre-process terminals
        transformer = PrepareLiterals() * PrepareSymbols() * PrepareAnonTerminals(tokens)   # Adds to tokens

        # 2. Convert EBNF to BNF (and apply step 1)
        ebnf_to_bnf = EBNF_to_BNF()
        rules = []
        for name, rule_tree, options in rule_defs:
            ebnf_to_bnf.rule_options = RuleOptions(keep_all_tokens=True) if options and options.keep_all_tokens else None
            tree = transformer.transform(rule_tree)
            rules.append((name, ebnf_to_bnf.transform(tree), options))
        rules += ebnf_to_bnf.new_rules

        assert len(rules) == len({name for name, _t, _o in rules}), "Whoops, name collision"

        # 3. Compile tree to Rule objects
        rule_tree_to_text = RuleTreeToText()

        simplify_rule = SimplifyRule_Visitor()
        compiled_rules = []
        for name, tree, options in rules:
            simplify_rule.visit(tree)
            expansions = rule_tree_to_text.transform(tree)

            for expansion, alias in expansions:
                if alias and name.startswith('_'):
                    raise GrammarError("Rule %s is marked for expansion (it starts with an underscore) and isn't allowed to have aliases (alias=%s)" % (name, alias))

                assert all(isinstance(x, Symbol) for x in expansion), expansion

                rule = Rule(NonTerminal(name), expansion, alias, options)
                compiled_rules.append(rule)

        return tokens, compiled_rules, self.ignore


_imported_grammars = {}
def import_grammar(grammar_path):
    if grammar_path not in _imported_grammars:
        for package in GRAMMAR_PACKAGES:
            text = pkgutil.get_data(package, grammar_path).decode("utf-8")
            grammar = load_grammar(text, grammar_path)
            _imported_grammars[grammar_path] = grammar

    return _imported_grammars[grammar_path]


def resolve_token_references(token_defs):
    # TODO Cycles detection
    # TODO Solve with transitive closure (maybe)

    token_dict = {k:t for k, (t,_p) in token_defs}
    assert len(token_dict) == len(token_defs), "Same name defined twice?"

    while True:
        changed = False
        for name, (token_tree, _p) in token_defs:
            if token_tree is None:  # Terminal added through %declare
                continue
            for exp in token_tree.find_data('value'):
                item ,= exp.children
                if isinstance(item, Token):
                    if item.type == 'RULE':
                        raise GrammarError("Rules aren't allowed inside terminals (%s in %s)" % (item, name))
                    if item.type == 'TERMINAL':
                        exp.children[0] = token_dict[item]
                        changed = True
        if not changed:
            break

def options_from_rule(name, *x):
    if len(x) > 1:
        priority, expansions = x
        priority = int(priority)
    else:
        expansions ,= x
        priority = None

    keep_all_tokens = name.startswith('!')
    name = name.lstrip('!')
    expand1 = name.startswith('?')
    name = name.lstrip('?')

    return name, expansions, RuleOptions(keep_all_tokens, expand1, priority=priority)


def symbols_from_strcase(expansion):
    return [Terminal(x, filter_out=x.startswith('_')) if is_terminal(x) else NonTerminal(x) for x in expansion]

@inline_args
class PrepareGrammar(Transformer_InPlace):
    def terminal(self, name):
        return name
    def nonterminal(self, name):
        return name


class GrammarLoader:
    def __init__(self):
        tokens = [TokenDef(name, PatternRE(value)) for name, value in TERMINALS.items()]

        rules = [options_from_rule(name, x) for name, x in  RULES.items()]
        rules = [Rule(NonTerminal(r), symbols_from_strcase(x.split()), None, o) for r, xs, o in rules for x in xs]
        callback = ParseTreeBuilder(rules, ST).create_callback()
        lexer_conf = LexerConf(tokens, ['WS', 'COMMENT'])

        parser_conf = ParserConf(rules, callback, 'start')
        self.parser = LALR_TraditionalLexer(lexer_conf, parser_conf)

        self.canonize_tree = CanonizeTree()

    def load_grammar(self, grammar_text, grammar_name='<?>'):
        "Parse grammar_text, verify, and create Grammar object. Display nice messages on error."

        try:
            tree = self.canonize_tree.transform( self.parser.parse(grammar_text+'\n') )
        except UnexpectedCharacters as e:
            context = e.get_context(grammar_text)
            raise GrammarError("Unexpected input at line %d column %d in %s: \n\n%s" %
                               (e.line, e.column, grammar_name, context))
        except UnexpectedToken as e:
            context = e.get_context(grammar_text)
            error = e.match_examples(self.parser.parse, {
                'Unclosed parenthesis': ['a: (\n'],
                'Umatched closing parenthesis': ['a: )\n', 'a: [)\n', 'a: (]\n'],
                'Expecting rule or token definition (missing colon)': ['a\n', 'a->\n', 'A->\n', 'a A\n'],
                'Alias expects lowercase name': ['a: -> "a"\n'],
                'Unexpected colon': ['a::\n', 'a: b:\n', 'a: B:\n', 'a: "a":\n'],
                'Misplaced operator': ['a: b??', 'a: b(?)', 'a:+\n', 'a:?\n', 'a:*\n', 'a:|*\n'],
                'Expecting option ("|") or a new rule or token definition': ['a:a\n()\n'],
                '%import expects a name': ['%import "a"\n'],
                '%ignore expects a value': ['%ignore %import\n'],
            })
            if error:
                raise GrammarError("%s at line %s column %s\n\n%s" % (error, e.line, e.column, context))
            elif 'STRING' in e.expected:
                raise GrammarError("Expecting a value at line %s column %s\n\n%s" % (e.line, e.column, context))
            raise

        tree = PrepareGrammar().transform(tree)

        # Extract grammar items
        defs = classify(tree.children, lambda c: c.data, lambda c: c.children)
        token_defs = defs.pop('token', [])
        rule_defs = defs.pop('rule', [])
        statements = defs.pop('statement', [])
        assert not defs

        token_defs = [td if len(td)==3 else (td[0], 1, td[1]) for td in token_defs]
        token_defs = [(name.value, (t, int(p))) for name, p, t in token_defs]

        # Execute statements
        ignore = []
        declared = []
        for (stmt,) in statements:
            if stmt.data == 'ignore':
                t ,= stmt.children
                ignore.append(t)
            elif stmt.data == 'import':
                if len(stmt.children) > 1:
                    path_node, arg1 = stmt.children
                else:
                    path_node ,= stmt.children
                    arg1 = None

                dotted_path = path_node.children

                if isinstance(arg1, Tree):  # Multi import
                    names = arg1.children
                    aliases = names  # Can't have aliased multi import, so all aliases will be the same as names
                else:  # Single import
                    names = [dotted_path[-1]]  # Get name from dotted path
                    aliases = [arg1] if arg1 else names  # Aliases if exist
                    dotted_path = dotted_path[:-1]

                grammar_path = os.path.join(*dotted_path) + EXT

                if path_node.data == 'import_lib':  # Import from library
                    g = import_grammar(grammar_path)
                else:  # Relative import
                    if grammar_name == '<string>':  # Import relative to script file path if grammar is coded in script
                        base_file = os.path.abspath(sys.modules['__main__'].__file__)
                    else:
                        base_file = grammar_name  # Import relative to grammar file path if external grammar file
                    base_path = os.path.split(base_file)[0]
                    g = import_grammar(grammar_path, base_paths=[base_path])

                for name, alias in zip(names, aliases):
                    token_options = dict(g.token_defs)[name]
                    assert isinstance(token_options, tuple) and len(token_options)==2
                    token_defs.append([alias.value, token_options])

            elif stmt.data == 'declare':
                for t in stmt.children:
                    token_defs.append([t.value, (None, None)])
            else:
                assert False, stmt


        # Verify correctness 1
        for name, _ in token_defs:
            if name.startswith('__'):
                raise GrammarError('Names starting with double-underscore are reserved (Error at %s)' % name)

        # Handle ignore tokens
        # XXX A slightly hacky solution. Recognition of %ignore TERMINAL as separate comes from the lexer's
        #     inability to handle duplicate tokens (two names, one value)
        ignore_names = []
        for t in ignore:
            if t.data=='expansions' and len(t.children) == 1:
                t2 ,= t.children
                if t2.data=='expansion' and len(t2.children) == 1:
                    item ,= t2.children
                    if item.data == 'value':
                        item ,= item.children
                        if isinstance(item, Token) and item.type == 'TERMINAL':
                            ignore_names.append(item.value)
                            continue

            name = '__IGNORE_%d'% len(ignore_names)
            ignore_names.append(name)
            token_defs.append((name, (t, 0)))

        # Verify correctness 2
        token_names = set()
        for name, _ in token_defs:
            if name in token_names:
                raise GrammarError("Token '%s' defined more than once" % name)
            token_names.add(name)

        if set(ignore_names) > token_names:
            raise GrammarError("Tokens %s were marked to ignore but were not defined!" % (set(ignore_names) - token_names))

        # Resolve token references
        resolve_token_references(token_defs)

        rules = [options_from_rule(*x) for x in rule_defs]

        rule_names = set()
        for name, _x, _o in rules:
            if name.startswith('__'):
                raise GrammarError('Names starting with double-underscore are reserved (Error at %s)' % name)
            if name in rule_names:
                raise GrammarError("Rule '%s' defined more than once" % name)
            rule_names.add(name)

        for name, expansions, _o in rules:
            used_symbols = {t for x in expansions.find_data('expansion')
                              for t in x.scan_values(lambda t: t.type in ('RULE', 'TERMINAL'))}
            for sym in used_symbols:
                if is_terminal(sym):
                    if sym not in token_names:
                        raise GrammarError("Token '%s' used but not defined (in rule %s)" % (sym, name))
                else:
                    if sym not in rule_names:
                        raise GrammarError("Rule '%s' used but not defined (in rule %s)" % (sym, name))

        # TODO don't include unused tokens, they can only cause trouble!

        return Grammar(rules, token_defs, ignore_names)



load_grammar = GrammarLoader().load_grammar
