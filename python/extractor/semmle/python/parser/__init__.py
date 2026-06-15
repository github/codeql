
# Black's version of lib2to3 (modified)
from blib2to3.pytree import type_repr
from blib2to3 import pygram
from blib2to3.pgen2 import driver, token
from blib2to3.pgen2.parse import ParseError, Parser
from . import ast
from blib2to3.pgen2 import tokenize, grammar
from blib2to3.pgen2.token import tok_name
from semmle.profiling import timers

pygram.initialize()
syms = pygram.python_symbols


GRAMMARS = [
    ("Python 3", pygram.python3_grammar),
    ("Python 3 without async", pygram.python3_grammar_no_async),
    ("Python 2 with print as function", pygram.python2_grammar_no_print_statement),
    ("Python 2", pygram.python2_grammar),
]


SKIP_IF_SINGLE_CHILD_NAMES = {
    'atom',
    'power',
    'test',
    'not_test',
    'and_test',
    'or_test',
    'suite',
    'testlist',
    'expr',
    'xor_expr',
    'and_expr',
    'shift_expr',
    'arith_expr',
    'term',
    'factor',
    'testlist_gexp',
    'exprlist',
    'testlist_safe',
    'old_test',
    'comparison',
}

SKIP_IF_SINGLE_CHILD = {
    val for name, val in
    syms.__dict__.items()
    if name in SKIP_IF_SINGLE_CHILD_NAMES
}


class Leaf(object):

    __slots__ = "type", "value", "start", "end"

    def __init__(self, type, value, start, end):
        self.type = type
        self.value = value
        self.start = start
        self.end = end

    def __repr__(self):
        """Return a canonical string representation."""
        return "%s(%s, %r)" % (self.__class__.__name__,
                               self.name,
                               self.value)

    @property
    def name(self):
        return tok_name.get(self.type, self.type)

class Node(object):

    __slots__ = "type", "children", "used_names"

    def __init__(self, type, children):
        self.type = type
        self.children = children

    @property
    def start(self):
        node = self
        while isinstance(node, Node):
            node = node.children[0]
        return node.start

    @property
    def end(self):
        node = self
        while isinstance(node, Node):
            node = node.children[-1]
        return node.end

    def __repr__(self):
        """Return a canonical string representation."""
        return "%s(%s, %r)" % (self.__class__.__name__,
                               self.name,
                               self.children)

    @property
    def name(self):
        return type_repr(self.type)

def convert(gr, raw_node):
    type, value, context, children = raw_node
    if children or type in gr.number2symbol:
        # If there's exactly one child, return that child instead of
        # creating a new node.
        if len(children) == 1 and type in SKIP_IF_SINGLE_CHILD:
            return children[0]
        return Node(type, children)
    else:
        start, end = context
        return Leaf(type, value, start, end)

def parse_tokens(gr, tokens):
    """Parse a series of tokens and return the syntax tree."""
    p = Parser(gr, convert)
    p.setup()
    for tkn in tokens:
        type, value, start, end = tkn
        if type in (tokenize.COMMENT, tokenize.NL):
            continue
        if type == token.OP:
            type = grammar.opmap[value]
        if type == token.INDENT:
            value = ""
        if p.addtoken(type, value, (start, end)):
            break
    else:
        # We never broke out -- EOF is too soon (how can this happen???)
        raise parse.ParseError("incomplete input",
                               type, value, ("", start))
    return p.rootnode


def parse(tokens, logger):
    """Given a string with source, return the lib2to3 Node."""
    for name, grammar in GRAMMARS:
        try:
            with timers["parse"]:
                cpt = parse_tokens(grammar, tokens)
            with timers["rewrite"]:
                return ast.convert(logger, cpt)
        except ParseError as pe:
            lineno, column = pe.context[1]
            logger.debug("%s at line %d, column %d using grammar for %s", pe, lineno, column, name)
            exc = SyntaxError("Syntax Error")
            exc.lineno = lineno
            exc.offset = column
    raise exc
