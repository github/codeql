import sys
import os.path
import traceback
from typing import Optional

from semmle.python import ast
from semmle import util
from semmle.python.passes.ast_pass import iter_fields
from semmle.python.passes._pass import Pass
from semmle.python.passes import pruner
from semmle.python.passes import splitter
from semmle.python.passes import unroller
from semmle.python import modules
import semmle.graph as graph
from semmle.logging import Logger

__all__ = [ 'FlowPass' ]

class ConsistencyError(util.SemmleError):
    pass

def error(node, _):
    raise ConsistencyError("Unexpected node type " + type(node).__name__)


class FlowNode(object):
    __slots__ = [ 'node' ]

    def __init__(self, node):
        self.node = node

    def __repr__(self):
        if hasattr(self.node, "lineno"):
            return 'FlowNode(%s at %d)' % (type(self.node), self.node.lineno)
        else:
            return 'FlowNode(%r)' % self.node

    def copy(self):
        return FlowNode(self.node)

#Kinds of node sets.
NORMAL = util.NORMAL_EDGE
TRUE = util.TRUE_EDGE
FALSE =  util.FALSE_EDGE
EXCEPTION = util.EXCEPTIONAL_EDGE
EXHAUSTED = util.EXHAUSTED_EDGE

TRUE_OR_FALSE = TRUE | FALSE

#Set of names of modules that are guaranteed to be in the interpreter regardless of platform
GUARANTEED_MODULES = {
    "_ast",
    "_bisect",
    "_codecs",
    "_collections",
    "_functools",
    "_heapq",
    "_io",
    "_locale",
    "_md5",
    "_operator",
    "_random",
    "_sha256",
    "_sha512",
    "_socket",
    "_sre",
    "_struct",
    "_symtable",
    "_warnings",
    "_weakref",
    "array",
    "binascii",
    "cmath",
    "errno",
    "gc",
    "itertools",
    "marshal",
    "math",
    "sys",
    "syslog",
    "time",
    "unicodedata",
    "zipimport",
    "zlib",
}


_py3_names = {
    "ArithmeticError",
    "AssertionError",
    "AttributeError",
    "BaseException",
    "BlockingIOError",
    "BrokenPipeError",
    "BufferError",
    "BytesWarning",
    "ChildProcessError",
    "ConnectionAbortedError",
    "ConnectionError",
    "ConnectionRefusedError",
    "ConnectionResetError",
    "DeprecationWarning",
    "EOFError",
    "Ellipsis",
    "EnvironmentError",
    "Exception",
    "False",
    "FileExistsError",
    "FileNotFoundError",
    "FloatingPointError",
    "FutureWarning",
    "GeneratorExit",
    "IOError",
    "ImportError",
    "ImportWarning",
    "IndentationError",
    "IndexError",
    "InterruptedError",
    "IsADirectoryError",
    "KeyError",
    "KeyboardInterrupt",
    "LookupError",
    "MemoryError",
    "NameError",
    "None",
    "NotADirectoryError",
    "NotImplemented",
    "NotImplementedError",
    "OSError",
    "OverflowError",
    "PendingDeprecationWarning",
    "PermissionError",
    "ProcessLookupError",
    "ReferenceError",
    "ResourceWarning",
    "RuntimeError",
    "RuntimeWarning",
    "StopIteration",
    "SyntaxError",
    "SyntaxWarning",
    "SystemError",
    "SystemExit",
    "TabError",
    "TimeoutError",
    "True",
    "TypeError",
    "UnboundLocalError",
    "UnicodeDecodeError",
    "UnicodeEncodeError",
    "UnicodeError",
    "UnicodeTranslateError",
    "UnicodeWarning",
    "UserWarning",
    "ValueError",
    "Warning",
    "ZeroDivisionError",
    "__build_class__",
    "__debug__",
    "__doc__",
    "__import__",
    "__loader__",
    "__name__",
    "__package__",
    "__spec__",
    "abs",
    "all",
    "any",
    "ascii",
    "bin",
    "bool",
    "bytearray",
    "bytes",
    # "callable", only 3.2+
    "chr",
    "classmethod",
    "compile",
    "complex",
    "copyright",
    "credits",
    "delattr",
    "dict",
    "dir",
    "divmod",
    "enumerate",
    "eval",
    "exec",
    "exit",
    "filter",
    "float",
    "format",
    "frozenset",
    "getattr",
    "globals",
    "hasattr",
    "hash",
    "help",
    "hex",
    "id",
    "input",
    "int",
    "isinstance",
    "issubclass",
    "iter",
    "len",
    "license",
    "list",
    "locals",
    "map",
    "max",
    "memoryview",
    "min",
    "next",
    "object",
    "oct",
    "open",
    "ord",
    "pow",
    "print",
    "property",
    "quit",
    "range",
    "repr",
    "reversed",
    "round",
    "set",
    "setattr",
    "slice",
    "sorted",
    "staticmethod",
    "str",
    "sum",
    "super",
    "tuple",
    "type",
    "vars",
    "zip",
}

_py2_names = {
    "ArithmeticError",
    "AssertionError",
    "AttributeError",
    "BaseException",
    "BufferError",
    "BytesWarning",
    "DeprecationWarning",
    "EOFError",
    "Ellipsis",
    "EnvironmentError",
    "Exception",
    "False",
    "FloatingPointError",
    "FutureWarning",
    "GeneratorExit",
    "IOError",
    "ImportError",
    "ImportWarning",
    "IndentationError",
    "IndexError",
    "KeyError",
    "KeyboardInterrupt",
    "LookupError",
    "MemoryError",
    "NameError",
    "None",
    "NotImplemented",
    "NotImplementedError",
    "OSError",
    "OverflowError",
    "PendingDeprecationWarning",
    "ReferenceError",
    "RuntimeError",
    "RuntimeWarning",
    "StandardError",
    "StopIteration",
    "SyntaxError",
    "SyntaxWarning",
    "SystemError",
    "SystemExit",
    "TabError",
    "True",
    "TypeError",
    "UnboundLocalError",
    "UnicodeDecodeError",
    "UnicodeEncodeError",
    "UnicodeError",
    "UnicodeTranslateError",
    "UnicodeWarning",
    "UserWarning",
    "ValueError",
    "Warning",
    "ZeroDivisionError",
    "__debug__",
    "__doc__",
    "__import__",
    "__name__",
    "__package__",
    "abs",
    "all",
    "any",
    "apply",
    "basestring",
    "bin",
    "bool",
    "buffer",
    "bytearray",
    "bytes",
    "callable",
    "chr",
    "classmethod",
    "cmp",
    "coerce",
    "compile",
    "complex",
    "copyright",
    "credits",
    "delattr",
    "dict",
    "dir",
    "divmod",
    "enumerate",
    "eval",
    "execfile",
    "exit",
    "file",
    "filter",
    "float",
    "format",
    "frozenset",
    "getattr",
    "globals",
    "hasattr",
    "hash",
    "help",
    "hex",
    "id",
    "input",
    "int",
    "intern",
    "isinstance",
    "issubclass",
    "iter",
    "len",
    "license",
    "list",
    "locals",
    "long",
    "map",
    "max",
    "memoryview",
    "min",
    "next",
    "object",
    "oct",
    "open",
    "ord",
    "pow",
    "print",
    "property",
    "quit",
    "range",
    "raw_input",
    "reduce",
    "reload",
    "repr",
    "reversed",
    "round",
    "set",
    "setattr",
    "slice",
    "sorted",
    "staticmethod",
    "str",
    "sum",
    "super",
    "tuple",
    "type",
    "unichr",
    "unicode",
    "vars",
    "xrange",
    "zip",
}

#Set of names that always exist (for both Python 2 and 3)
BUILTIN_NAME_ALWAYS_EXISTS = _py2_names.intersection(_py3_names)

# A NodeSet is a conceptually a set of (FlowNode, kind) pairs.
#This class exists to document the interface.
class ExampleNodeSet(object):
    '''This class exists for documentation purposes only.'''

    def branch(self):
        '''Branch into (true, false) pair of nodesets.'''

    def __add__(self, other):
        '''Add this node set to another, returning the union'''

    def normalise(self):
        '''Return normalise form of this node set, turning all kinds into NORMAL'''

    def exception(self):
        '''Return exception form of this node set, turning all kinds into EXCEPTION'''

    def merge_true_false_pairs(self):
        '''Return copy of this node set with all pairs of TRUE and FALSE kinds for the same node turned into NORMAL'''

    def add_node(self, node, kind):
        '''Return a new node set with (node, kind) pair added.'''

    def invert(self):
        '''Return copy of this node set with all TRUE kinds set to FALSE and vice versa.'''

class EmptyNodeSet(object):

    def branch(self):
        return self, self

    def __add__(self, other):
        return other

    def normalise(self):
        return self

    def exception(self):
        return self

    def merge_true_false_pairs(self):
        return self

    def add_node(self, node, kind):
        return SingletonNodeSet(node, kind)

    def __iter__(self):
        return iter(())

    def __len__(self):
        return 0

    def __str__(self):
        return "{}"

    def invert(self):
        return self

EMPTY = EmptyNodeSet()

class SingletonNodeSet(object):

    __slots__ = [ 'node', 'kind']

    def __init__(self, node, kind):
        self.node = node
        self.kind = kind

    def branch(self):
        if self.kind == TRUE:
            return self, EMPTY
        elif self.kind == FALSE:
            return EMPTY, self
        elif self.kind == NORMAL:
            return SingletonNodeSet(self.node, TRUE), SingletonNodeSet(self.node, FALSE)
        else:
            return self, self

    def __add__(self, other):
        if other is EMPTY:
            return self
        else:
            return other.add_node(self.node, self.kind)

    def normalise(self):
        return SingletonNodeSet(self.node, NORMAL)

    def exception(self):
        return SingletonNodeSet(self.node, EXCEPTION)

    def merge_true_false_pairs(self):
        return self

    def add_node(self, node, kind):
        if node == self.node and kind == self.kind:
            return self
        other = MultiNodeSet()
        other.append((self.node, self.kind))
        other.append((node, kind))
        return other

    def __iter__(self):
        yield self.node, self.kind

    def __len__(self):
        return 1

    def invert(self):
        if self.kind & TRUE_OR_FALSE:
            return SingletonNodeSet(self.node, self.kind ^ TRUE_OR_FALSE)
        else:
            return self

    def unique_node(self):
        return self.node

    def __str__(self):
        return "{(%s, %d)}" % (self.node, self.kind)

class MultiNodeSet(list):

    __slots__ = []

    def branch(self):
        '''Branch into (true, false) pair of nodesets.'''
        l = EMPTY
        for node, kind in self:
            if kind != FALSE:
                l = l.add_node(node, kind)
        r = EMPTY
        for node, kind in self:
            if kind != TRUE:
                r = r.add_node(node, kind)
        return l, r

    def __add__(self, other):
        if other is EMPTY:
            return self
        res = MultiNodeSet(self)
        if isinstance(other, SingletonNodeSet):
            res.insert_node(other.node, other.kind)
            return res
        for node, kind in other:
            res.insert_node(node, kind)
        return res

    def convert(self, the_kind):
        the_node = self[0][0]
        for node, kind in self:
            if node != the_node:
                break
        else:
            return SingletonNodeSet(node, the_kind)
        res = MultiNodeSet()
        for node, kind in self:
            res.insert_node(node, the_kind)
        return res

    def normalise(self):
        return self.convert(NORMAL)

    def exception(self):
        return self.convert(EXCEPTION)

    def merge_true_false_pairs(self):
        #Common case len() == 2
        if len(self) == 2:
            if (self[0][1] | self[0][1]) == TRUE_OR_FALSE and self[0][0] == self[1][0]:
                return SingletonNodeSet(self[0][0], NORMAL)
            else:
                return self
        #Either no true, or no false edges.
        all_kinds = 0
        for node, kind in self:
            all_kinds |= kind
        if (all_kinds & TRUE_OR_FALSE) != TRUE_OR_FALSE:
            return self

        #General, slow and hopefully rare case.
        nodes = {}
        for node, kind in self:
            if node in nodes:
                nodes[node] |= kind
            else:
                nodes[node] = kind
        res = MultiNodeSet()
        for node, kind in nodes.items():
            if (kind  & TRUE_OR_FALSE)== TRUE_OR_FALSE:
                kind =  (kind | NORMAL) & (NORMAL | EXCEPTION)
            for K in (NORMAL, TRUE, FALSE, EXCEPTION):
                if kind & K:
                    res.insert_node(node, K)
        return res

    def add_node(self, *t):
        res = MultiNodeSet(self)
        res.insert_node(*t)
        return res

    def insert_node(self, *t):
        if t not in self:
            self.append(t)

    def __str__(self):
        return "{" + ",".join(self) + "}"

    def invert(self):
        res = MultiNodeSet()
        for node, kind in self:
            if kind & TRUE_OR_FALSE:
                res.insert_node(node, kind ^ TRUE_OR_FALSE)
            else:
                res.insert_node(node, kind)
        return res

class BlockStack(list):
    '''A stack of blocks (loops or tries).'''


    def push_block(self):
        self.append(EMPTY)

    def pop_block(self):
        return self.pop()

    def add(self, node_set):
        self[-1] = self[-1] + node_set

class FlowScope(object):

    def __init__(self, depth, ast_scope):
        self.entry = FlowNode(ast_scope)
        self.graph = graph.FlowGraph(self.entry)
        self.exceptional_exit = FlowNode(ast_scope)
        self.graph.add_node(self.exceptional_exit)
        self.graph.annotate_node(self.exceptional_exit, EXCEPTION_EXIT)
        self.depth = depth
        self.exception_stack = BlockStack()
        self.exception_stack.push_block()
        self.breaking_stack = BlockStack()
        self.continuing_stack = BlockStack()
        self.return_stack = BlockStack()
        self.return_stack.push_block()
        self.ast_scope = ast_scope

    def inner(self, ast_scope):
        return FlowScope(self.depth+1, ast_scope)

    def pop_exceptions(self):
        return self.exception_stack.pop_block()

    def split(self):
        splitter.do_split(self.ast_scope, self.graph)

    def prune(self):
        #Remove the always false condition edges.
        pruner.do_pruning(self.ast_scope, self.graph)

    def unroll(self):
        unroller.do_unrolling(self.ast_scope, self.graph)

    def write_graph(self, writer):
        self.graph.delete_unreachable_nodes()
        #Emit flow graph
        self._write_flow_nodes(writer)
        for pred, succ, kind in self.graph.edges():
            write_successors(writer, pred, succ, kind)
            if kind != NORMAL and kind != EXHAUSTED:
                write_successors(writer, pred, succ, NORMAL)
        #Emit idoms
        for node, idom in self.graph.idoms():
            write_idoms(writer, node, idom)
        #Emit SSA variables
        for var in self.graph.ssa_variables():
            write_ssa_var(writer, var)
        for node, var in self.graph.ssa_definitions():
            write_ssa_defn(writer, var, node)
        for node, var in self.graph.ssa_uses():
            write_ssa_use(writer, node, var)
        for var, arg in self.graph.ssa_phis():
            write_ssa_phi(writer, var, arg)

    def _write_flow_nodes(self, writer):
        blocks = self.graph.get_basic_blocks()
        for flow, note in self.graph.nodes():
            if note is not None:
                write_scope_node(writer, flow, self.ast_scope, note)
            if flow in blocks:
                head, index = blocks[flow]
                write_flow_node(writer, flow, head, index)


#Codes for scope entry/exit nodes.
#These are hardcoded in QL. Do not change them.
FALL_THROUGH_EXIT = 0
EXCEPTION_EXIT = 1
RETURN_EXIT = 2
ENTRY = -1

class FlowPass(Pass):
    '''Extracts flow-control information. Currently generates a flow control
    graph. There is a many-to-one relation between flow-nodes and ast nodes.
    This enables precise flow control for 'try' statements.
    Each flow node also has a number. If there are several flow nodes for
    one ast node, they will all have different numbers.
    For flow nodes representing a scope (class, function or module) then
    the numbers are as follows: entry=-1, exceptional exit=1,
    fallthrough exit=0, explicit return=2
    '''

    name = "flow"

    def __init__(self, split, prune=True, unroll=False, logger:Optional[Logger] = None):
        'Initialize all the tree walkers'
        self._walkers = {
            list : self._walk_list,
            bool : self.skip,
            int : self.skip,
            float : self.skip,
            bytes : self.skip,
            str : self.skip,
            complex : self.skip,
            type(None) : self.skip,
            ast.Lambda : self._walk_scope_defn,
            ast.ClassExpr : self._walk_class_expr,
            ast.FunctionExpr : self._walk_scope_defn,
            ast.For : self._walk_for_loop,
            ast.Pass : self._walk_stmt_only,
            ast.Global : self._walk_stmt_only,
            ast.Break : self._walk_break,
            ast.BinOp : self._walk_binop,
            ast.Compare : self._walk_compare,
            ast.Continue : self._walk_continue,
            ast.Raise : self._walk_raise,
            ast.Return : self._walk_return,
            ast.Delete : self._walk_delete,
            ast.While : self._walk_while,
            ast.If : self._walk_if_stmt,
            ast.IfExp : self._walk_if_expr,
            ast.expr_context : self.skip,
            ast.Slice : self._walk_slice,
            ast.ExceptStmt : error,
            ast.comprehension : error,
            ast.ListComp: self._walk_generator,
            ast.SetComp: self._walk_generator,
            ast.DictComp: self._walk_generator,
            ast.Dict : self._walk_dict,
            ast.keyword : self._walk_expr_no_raise,
            ast.KeyValuePair : self._walk_keyword,
            ast.DictUnpacking : self._walk_yield,
            ast.Starred : self._walk_yield,
            ast.arguments : self._walk_arguments,
            ast.Name : self._walk_name,
            ast.PlaceHolder : self._walk_name,
            ast.Num : self._walk_atom,
            ast.Str : self._walk_atom,
            ast.Try : self._walk_try,
            ast.List : self._walk_sequence,
            ast.Tuple : self._walk_sequence,
            ast.UnaryOp : self._walk_expr_no_raise,
            ast.UnaryOp : self._walk_unary_op,
            ast.Assign : self._walk_assign,
            ast.ImportExpr : self._walk_import_expr,
            ast.ImportMember : self._walk_expr,
            ast.Ellipsis : self._walk_atom,
            ast.Print : self._walk_post_stmt,
            ast.alias : self._walk_alias,
            ast.GeneratorExp: self._walk_generator,
            ast.Assert: self._walk_assert,
            ast.AssignExpr: self._walk_assignexpr,
            ast.AugAssign : self._walk_augassign,
            ast.Attribute : self._walk_attribute,
            ast.Subscript : self._walk_subscript,
            ast.BoolOp : self._walk_bool_expr,
            ast.TemplateWrite : self._walk_post_stmt,
            ast.Filter : self._walk_expr_no_raise,
            ast.Yield : self._walk_yield,
            ast.YieldFrom : self._walk_yield,
            ast.Expr : self._walk_skip_stmt,
            ast.Import : self._walk_skip_stmt,
            ast.ImportFrom : self._walk_post_stmt,
            ast.With: self._walk_with,
            ast.Match: self._walk_match,
            ast.Case: self._walk_case,
            ast.Repr : self._walk_expr_no_raise,
            ast.Nonlocal : self._walk_stmt_only,
            ast.Exec : self._walk_exec,
            ast.AnnAssign : self._walk_ann_assign,
            ast.TypeAlias : self._walk_stmt_only,
            ast.TypeVar: self.skip,
            ast.TypeVarTuple: self.skip,
            ast.ParamSpec: self.skip,
            ast.SpecialOperation: self._walk_expr_no_raise,
            ast.Module : error,
            ast.expr : error,
            ast.stmt : error,
            ast.cmpop : error,
            ast.boolop : error,
            ast.operator : error,
            ast.expr_context : error,
            ast.unaryop : error,
            ast.AstBase : error,
        }
        for t in ast.__dict__.values():
            if isinstance(t, type) and ast.AstBase in t.__mro__:
                #Setup walkers
                expr_walker = self._walk_expr
                if t.__mro__[1] is ast.expr:
                    if t not in self._walkers:
                        self._walkers[t] = expr_walker
                elif t.__mro__[1] in (ast.cmpop, ast.boolop, ast.operator,
                                      ast.expr_context, ast.unaryop):
                    self._walkers[t] = self.skip
        self._walkers[ast.TemplateDottedNotation] = self._walkers[ast.Attribute]

        # Initialize walkers for patterns,
        # These return both a tree and a list of nodes:
        # - the tree represents the computation needed to evaluate whether the pattern matches,
        # - the list of nodes represents the bindings resulting from a successful match.
        self._pattern_walkers = {
            ast.MatchAsPattern: self._walk_as_pattern,
            ast.MatchOrPattern: self._walk_or_pattern,
            ast.MatchLiteralPattern: self._walk_literal_pattern,
            ast.MatchCapturePattern: self._walk_capture_pattern,
            ast.MatchWildcardPattern: self._walk_wildcard_pattern,
            ast.MatchValuePattern: self._walk_value_pattern,
            ast.MatchSequencePattern: self._walk_sequence_pattern,
            ast.MatchStarPattern: self._walk_star_pattern,
            ast.MatchMappingPattern: self._walk_mapping_pattern,
            ast.MatchDoubleStarPattern: self._walk_double_star_pattern,
            ast.MatchKeyValuePattern: self._walk_key_value_pattern,
            ast.MatchClassPattern: self._walk_class_pattern,
            ast.MatchKeywordPattern: self._walk_keyword_pattern,
        }

        self.scope = None
        self.in_try = 0
        self.in_try_name = 0
        self.split = split
        self.prune = prune
        self.unroll = unroll
        self.logger = logger or Logger()
        self.filename = "<unknown>"

    #Entry point to the tree walker
    def extract(self, ast, writer):
        if ast is None:
            return
        self.writer = writer
        self._walk_scope(ast)

    def set_filename(self, filename):
        self.filename = filename

    #Walkers

    def _walk_arguments(self, node, predecessors):
        for _, _, child_node in iter_fields(node):
            predecessors = self._walk(child_node, predecessors)
        return predecessors

    def _walk_generator(self, node, predecessors):
        res = self._walk(node.iterable, predecessors)
        res = self.add_successor(res, node)
        raises = self._walk_scope(node.function)
        if raises:
            self._raise_exception(res)
        return res

    def _walk_comprehension(self, node, predecessors):
        return self._walk_generators(node, node.generators, predecessors)

    def _walk_generators(self, node, generators, predecessors):
        if not generators:
            if isinstance(node, ast.DictComp):
                predecessors = self.add_successor(predecessors, node.value)
                predecessors = self.add_successor(predecessors, node.key)
            else:
                predecessors = self.add_successor(predecessors, node.elt)
            return predecessors
        else:
            gen = generators[0]
            predecessors = self._walk(gen.iter, predecessors)
            predecessors = self.add_successor(predecessors, gen)
            loop_node = predecessors.unique_node()
            predecessors = self._walk(gen.target, predecessors)
            skip = EMPTY
            for test in gen.ifs:
                predecessors = self._walk(test, predecessors)
                true_nodes, false_nodes = predecessors.branch()
                predecessors += true_nodes
                skip += false_nodes
            predecessors = self._walk_generators(node, generators[1:], predecessors)
            predecessors += skip
            self.add_successor_node(predecessors, loop_node)
            return predecessors

    def _walk_if_expr(self, node, predecessors):
        test_successors = self._walk(node.test, predecessors)
        true_successors, false_successors = test_successors.branch()
        body_successors = self._walk(node.body, true_successors)
        orelse_successors = self._walk(node.orelse, false_successors)
        predecessors = body_successors + orelse_successors
        predecessors = self.add_successor(predecessors, node)
        return predecessors

    def _walk_dict(self, node, predecessors):
        for item in node.items:
            predecessors = self._walk(item, predecessors)
        return self.add_successor(predecessors, node)

    def _walk_alias(self, node, predecessors):
        predecessors = self._walk(node.value, predecessors)
        return self._walk(node.asname , predecessors)

    def _walk_slice(self, node, predecessors):
        predecessors = self._walk(node.start, predecessors)
        predecessors = self._walk(node.stop, predecessors)
        predecessors = self._walk(node.step, predecessors)
        return self.add_successor(predecessors, node)

    def _walk_break(self, node, predecessors):
        #A break statement counts as an exit to the enclosing loop statement
        predecessors = self.add_successor(predecessors, node)
        self.scope.breaking_stack.add(predecessors)
        #Provide no predecessors to following statement
        return EMPTY

    def _walk_continue(self, node, predecessors):
        #A continue statement counts as an exit to the following orelse
        predecessors = self.add_successor(predecessors, node)
        self.scope.continuing_stack.add(predecessors)
        #Provide no predecessors to following statement
        return EMPTY

    def _raise_exception(self, predecessors):
        predecessors = predecessors.exception()
        self.scope.exception_stack.add(predecessors)

    def _walk_raise(self, node, predecessors):
        for _, _, child_node in iter_fields(node):
            predecessors = self._walk(child_node, predecessors)
        predecessors = self.add_successor(predecessors, node)
        self._raise_exception(predecessors)
        return EMPTY

    def _walk_return(self, node, predecessors):
        for _, _, child_node in iter_fields(node):
            predecessors = self._walk(child_node, predecessors)
        predecessors = self.add_successor(predecessors, node)
        self.scope.return_stack.add(predecessors)
        return EMPTY

    def _walk_delete(self, node, predecessors):
        '''The CFG for the delete statement `del a, b`
        looks like `a -> del -> b -> del` to ensure that
        the implied use occurs before the deletion and that
        `del x, x` has the correct semantics.'''
        for item in node.targets:
            predecessors = self._walk(item, predecessors)
            predecessors = self.add_successor(predecessors, node)
        return predecessors

    def _walk_stmt_only(self, node, predecessors):
        return self.add_successor(predecessors, node)

    def _walk_scope(self, scope_node):
        '''Returns: whether this scope raises an exception (or not)'''
        prev_flow_scope = self.scope
        if prev_flow_scope is None:
            self.scope = FlowScope(0, scope_node)
        else:
            self.scope = prev_flow_scope.inner(scope_node)
        predecessors = SingletonNodeSet(self.scope.entry, NORMAL)
        for _, _, child_node in iter_fields(scope_node):
            predecessors = self._walk(child_node, predecessors)
        implicit_exit = self.add_successor(predecessors, scope_node).unique_node()
        self.scope.graph.annotate_node(implicit_exit, FALL_THROUGH_EXIT)
        if isinstance(scope_node, (ast.Module, ast.Class)):
            self.scope.graph.use_all_defined_variables(implicit_exit)
        #Mark all nodes that raise unhandled exceptions.
        exceptions = self.scope.pop_exceptions()
        for node, kind in exceptions:
            if kind == NORMAL or kind == EXCEPTION:
                self.scope.graph.annotate_node(node, EXCEPTION_EXIT)
            else:
                self.scope.graph.add_edge(node, self.scope.exceptional_exit)
                self.scope.graph.annotate_edge(node, self.scope.exceptional_exit, kind)
        self.scope.graph.annotate_node(self.scope.entry, ENTRY)
        if not isinstance(scope_node, ast.Module):
            returns = self.scope.return_stack.pop_block()
            return_exit = self.add_successor(returns, scope_node).unique_node()
            self.scope.graph.annotate_node(return_exit, RETURN_EXIT)
        if self.split:
            try:
                self.scope.split()
            # we found a regression in the split logic, where in some scenarios a split head would not be in the subgraph.
            # Instead of aborting extracting the whole file, we can continue and just not split the graph.
            # see semmlecode-python-tests/extractor-tests/splitter-regression/failure.py
            except AssertionError:
                self.logger.warning("Failed to split in " + self.filename + ", continuing anyway")
        if self.prune:
            self.scope.prune()
        if self.unroll:
            self.scope.unroll()
        self.scope.write_graph(self.writer)
        self.scope = prev_flow_scope
        return bool(exceptions)

    def _walk_scope_defn(self, node, predecessors):
        for field_name, _, child_node in iter_fields(node):
            if field_name == 'inner_scope':
                continue
            predecessors = self._walk(child_node, predecessors)
        predecessors = self.add_successor(predecessors, node)
        sub_node = node.inner_scope
        self._walk_scope(sub_node)
        return predecessors

    def _walk_class_expr(self, node, predecessors):
        predecessors = self._walk_scope_defn(node, predecessors)
        self._raise_exception(predecessors)
        return predecessors

    def _walk_post_stmt(self, node, predecessors):
        for _, _, child_node in iter_fields(node):
            predecessors = self._walk(child_node, predecessors)
        return self.add_successor(predecessors, node)

    def _walk_skip_stmt(self, node, predecessors):
        for _, _, child_node in iter_fields(node):
            predecessors = self._walk(child_node, predecessors)
        return predecessors

    def _walk_with(self, node, predecessors):
        nodes = self._walk(node.context_expr, predecessors)
        #The with statement has side effects which occur after the context manager has been computed
        nodes = self.add_successor(nodes, node)
        nodes = self._walk(node.optional_vars, nodes)
        return self._walk(node.body, nodes)

    def _walk_match(self, node, predecessors):
        pre_subject = self.add_successor(predecessors, node)
        subject_successors = self._walk(node.subject, pre_subject)
        final_successors = EMPTY
        case_predecessors = subject_successors
        for case in node.cases:
            case_match_successors, case_nomatch_successors = self._walk_case(case, case_predecessors)
            case_predecessors = case_nomatch_successors
            final_successors += case_match_successors
        return final_successors + case_nomatch_successors

    def _walk_case(self, node, predecessors):
        """Returns: (match_successors, nomatch_successors)"""

        pre_test = self.add_successor(predecessors, node)
        pattern_successors, pattern_captures = self._walk_pattern(node.pattern, pre_test)

        pattern_match_successors, pattern_nomatch_successors = pattern_successors.branch()

        for capture in pattern_captures:
            pattern_match_successors = self._walk(capture, pattern_match_successors)

        if node.guard:
            guard_successors = self._walk_guard(node.guard, pattern_match_successors)
            guard_true_successors, guard_false_successors = guard_successors.branch()
            pattern_match_successors = guard_true_successors
            pattern_nomatch_successors += guard_false_successors

        body_successors = self._walk(node.body, pattern_match_successors)
        return body_successors, pattern_nomatch_successors

    def _walk_pattern(self, node, predecessors):
        """Walking a pattern results in a tree and a list of nodes:
        - the tree represents the computation needed to evaluate whether the pattern matches,
        - the list of nodes represents the bindings resulting from a successful match."""

        return self._pattern_walkers[type(node)](node, predecessors)

    def _walk_patterns_in_sequence(self, patterns, predecessors):
        bindings = []
        for pattern in patterns:
            predecessors, new_bindings = self._walk_pattern(pattern, predecessors)
            bindings += new_bindings
        return predecessors, bindings

    def _walk_as_pattern(self, node, predecessors):
        predecessors = self.add_successor(predecessors, node)
        pattern_successors, bindings = self._walk_pattern(node.pattern, predecessors)
        return pattern_successors, bindings + [node.alias]

    def _walk_or_pattern(self, node, predecessors):
        predecessors = self.add_successor(predecessors, node)
        # We cannot use `self._walk_patterns_in_sequence` as we only want
        # to capture the bindings of the first pattern in the sequence
        # (the bindings of the subsequent patterns are simply repetitions)
        bindings = []
        first = True
        for pattern in node.patterns:
            predecessors, new_bindings = self._walk_pattern(pattern, predecessors)
            if first:
                bindings += new_bindings
            first = False
        return predecessors, bindings

    def _walk_literal_pattern(self, node, predecessors):
        predecessors = self.add_successor(predecessors, node)
        predecessors = self._walk(node.literal, predecessors)
        return predecessors, []

    def _walk_capture_pattern(self, node, predecessors):
        predecessors = self.add_successor(predecessors, node)
        return predecessors, [node.variable]

    def _walk_wildcard_pattern(self, node, predecessors):
        predecessors = self.add_successor(predecessors, node)
        return predecessors, []

    def _walk_value_pattern(self, node, predecessors):
        predecessors = self.add_successor(predecessors, node)
        predecessors = self._walk(node.value, predecessors)
        return predecessors, []

    def _walk_sequence_pattern(self, node, predecessors):
        predecessors = self.add_successor(predecessors, node)
        return self._walk_patterns_in_sequence(node.patterns, predecessors)

    def _walk_star_pattern(self, node, predecessors):
        predecessors = self.add_successor(predecessors, node)
        return self._walk_pattern(node.target, predecessors)

    def _walk_mapping_pattern(self, node, predecessors):
        predecessors = self.add_successor(predecessors, node)
        return self._walk_patterns_in_sequence(node.mappings, predecessors)

    def _walk_double_star_pattern(self, node, predecessors):
        predecessors = self.add_successor(predecessors, node)
        return self._walk_pattern(node.target, predecessors)

    def _walk_key_value_pattern(self, node, predecessors):
        predecessors = self.add_successor(predecessors, node)
        key_successors, bindings = self._walk_pattern(node.key, predecessors)
        # The key should have no bindings
        assert not bindings, "Unexpected bindings in key pattern: %s" % bindings
        return self._walk_pattern(node.value, key_successors)

    def _walk_class_pattern(self, node, predecessors):
        predecessors = self.add_successor(predecessors, node)
        class_name_successors = self._walk(node.class_name, predecessors)
        bindings = EMPTY
        positional_successors = class_name_successors
        if node.positional:
            for positional in node.positional:
                positional_successors, new_bindings = self._walk_pattern(positional, positional_successors)
                bindings += new_bindings
        keyword_successors = positional_successors
        if node.keyword:
            for keyword in node.keyword:
                keyword_successors, new_bindings = self._walk_pattern(keyword, keyword_successors)
                bindings += new_bindings
        return keyword_successors, bindings

    def _walk_keyword_pattern(self, node, predecessors):
        predecessors = self.add_successor(predecessors, node)
        attribute_successors = self._walk(node.attribute, predecessors)
        return self._walk_pattern(node.value, attribute_successors)

    def _walk_guard(self, node, predecessors):
        pre_test = self.add_successor(predecessors, node)
        return self._walk(node.test, pre_test)

    def _walk_exec(self, node, predecessors):
        for _, _, child_node in iter_fields(node):
            predecessors = self._walk(child_node, predecessors)
        exit = self.add_successor(predecessors, node)
        self._raise_exception(exit)
        if isinstance(node.body, ast.Str) and node.body.s.startswith("raise "):
            #Due to syntactic differences between Python 2 and Python 3
            #`exec("raise ...")` can sometimes be used instead of `raise ...`
            return EMPTY
        return exit

    def _walk_assert(self, node, predecessors):
        predecessors = self._walk(node.test, predecessors)
        if is_false_constant(node.test):
            msg = self._walk(node.msg, predecessors)
            assert_ = self.add_successor(msg, node)
            self._raise_exception(assert_)
            return EMPTY
        if is_true_constant(node.test):
            return self.add_successor(predecessors, node)
        true_succ, false_succ = predecessors.branch()
        assert_ok = self.add_successor(true_succ, node)
        msg = self._walk(node.msg, false_succ)
        assert_fail = self.add_successor(msg, node)
        self._raise_exception(assert_fail)
        return assert_ok

    def _walk_assign(self, node, predecessors):
        value = self._walk(node.value, predecessors)
        rhs_count = self._count_items(node.value)
        if rhs_count > 0:
            for target in node.targets:
                if rhs_count != self._count_items(target):
                    break
            else:
                #All targets and rhs are sequences of the same length
                for target in node.targets:
                    value = self._walk_sequence(target, value, True)
                return value
        #All other cases
        for target in node.targets:
            value = self._walk(target, value)
        return value

    def _count_items(self, node):
        if isinstance(node, (ast.Tuple, ast.List)):
            return len(node.elts)
        return 0

    def _walk_expr_no_raise(self, node, predecessors):
        for _, _, child_node in iter_fields(node):
            predecessors = self._walk(child_node, predecessors)
        res = self.add_successor(predecessors, node)
        return res

    def _walk_arg(self, node, predecessors):
        return self._walk(node.arg, predecessors)

    def _walk_keyword(self, node, predecessors):
        predecessors = self._walk(node.key, predecessors)
        predecessors = self._walk(node.value, predecessors)
        return self.add_successor(predecessors, node)

    def _walk_yield(self, node, predecessors):
        predecessors = self._walk(node.value, predecessors)
        res = self.add_successor(predecessors, node)
        if self.in_try:
            self._raise_exception(res)
        return res

    def _walk_sequence(self, node, predecessors, safe=False):
        #In the case of a store the list/tuple is "evaluated" first,
        #i.e. it is exploded before the parts are stored.
        #This operation may raise an exception, unless the
        #corresponding tuple of exactly the same size exists on the rhs
        #of the assignment.
        if isinstance(node.ctx, (ast.Store, ast.Param)):
            predecessors = self.add_successor(predecessors, node)
            if self.in_try and not safe:
                self._raise_exception(predecessors)
            for child_node in node.elts:
                predecessors = self._walk(child_node, predecessors)
        else:
            for child_node in node.elts:
                predecessors = self._walk(child_node, predecessors)
            predecessors = self.add_successor(predecessors, node)
        return predecessors

    def _walk_unary_op(self, node, predecessors):
        predecessors = self._walk(node.operand, predecessors)
        if not isinstance(node.op, ast.Not):
            return self.add_successor(predecessors, node)
        if len(predecessors) <= 1:
            successors = self.add_successor(predecessors, node)
        else:
            #Avoid merging true/false branches.
            successors = EMPTY
            flownodes = {}
            for pred, kind in predecessors:
                if kind not in flownodes:
                    flownodes[kind] = FlowNode(node)
                    successors = successors.add_node(flownodes[kind], kind)
                    self.scope.graph.add_node(flownodes[kind])
                self.scope.graph.add_edge(pred, flownodes[kind])
                self.scope.graph.annotate_edge(pred, flownodes[kind], kind)
        return successors.invert()

    def _walk_import_expr(self, node, predecessors):
        for _, _, child_node in iter_fields(node):
            predecessors = self._walk(child_node, predecessors)
        res = self.add_successor(predecessors, node)
        if node.name not in GUARANTEED_MODULES:
            #Can raise an exception
            self._raise_exception(res)
        return res

    def _walk_expr(self, node, predecessors):
        for _, _, child_node in iter_fields(node):
            predecessors = self._walk(child_node, predecessors)
        res = self.add_successor(predecessors, node)
        #Many expressions can raise an exception
        self._raise_exception(res)
        return res

    def _walk_bool_expr(self, node, predecessors):
        other = self.add_successor(predecessors, node)
        short_circuit = EMPTY
        for operand in node.values:
            predecessors = self._walk(operand, other)
            true_pred, false_pred = predecessors.branch()
            if isinstance(node.op, ast.And):
                short_circuit += false_pred
                other = true_pred
            else:
                short_circuit += true_pred
                other = false_pred
        return other + short_circuit

    def _walk_name(self, node, predecessors, ctx_type = None):
        # Too many exception edges make analysis slower and adds almost no accuracy
        # Assume that Name may only raise an exception if global in scope and
        # not a store
        res = self.add_successor(predecessors, node)
        if ctx_type is None:
            ctx_type = type(node.ctx)
            assert ctx_type not in (ast.AugAssign, ast.AugLoad)
        #Only generate SSA variables for variables local to scope
        if node.variable.scope == self.scope.ast_scope:
            if ctx_type in (ast.Store, ast.Param, ast.AugStore):
                for flow_node, kind in res:
                    self.scope.graph.add_definition(flow_node, node.variable)
            elif ctx_type is ast.Del:
                for flow_node, kind in res:
                    self.scope.graph.add_deletion(flow_node, node.variable)
            elif ctx_type in (ast.Load, ast.AugLoad):
                for flow_node, kind in res:
                    self.scope.graph.add_use(flow_node, node.variable)
        if self.in_try and ctx_type is not ast.Store:
            if self.scope.depth == 0 or node.variable.is_global():
                # Use the common subset of Py2/3 names when determining which Name node can never raise.
                # Ensures that code is not marked as unreachable by the Python 2 extractor,
                # when it could be reached in Python 3 (and vice verse).
                if node.variable.id not in BUILTIN_NAME_ALWAYS_EXISTS:
                    self._raise_exception(res)
            elif self.in_try_name:
                #If code explicitly catches NameError we need to raise from names.
                self._raise_exception(res)
        return res

    def _walk_subscript(self, node, predecessors, ctx_type = None):
        if ctx_type is not ast.AugStore:
            predecessors = self._walk(node.value, predecessors)
            predecessors = self._walk(node.index, predecessors)
        res = self.add_successor(predecessors, node)
        self._raise_exception(res)
        return res

    def _walk_attribute(self, node, predecessors, ctx_type = None):
        if ctx_type is not ast.AugStore:
            predecessors = self._walk(node.value, predecessors)
        res = self.add_successor(predecessors, node)
        if self.in_try:
            self._raise_exception(res)
        return res

    def _walk_atom(self, node, predecessors):
        #Do not raise exception. Should have queries for undefined values.
        return self.add_successor(predecessors, node)

    def _walk_if_stmt(self, node, predecessors):
        test_successors = self._walk(node.test, predecessors)
        true_successors, false_successors = test_successors.branch()
        body_successors = self._walk(node.body, true_successors)
        orelse_successors = self._walk(node.orelse, false_successors)
        return body_successors + orelse_successors

    def _walk_compare(self, node, predecessors):
        #TO DO -- Handle the (rare) case of multiple comparators;
        #a < b < c is equivalent to a < b and b < c (without reevaluating b)
        predecessors = self._walk(node.left, predecessors)
        for comp in node.comparators:
            predecessors = self._walk(comp, predecessors)
        res = self.add_successor(predecessors, node)
        #All comparisons except 'is' can (theoretically) raise an exception
        #However == and != should never do so.
        if self.in_try and node.ops[0].__class__ not in NON_RAISING_COMPARISON_OPS:
            self._raise_exception(res)
        return res

    def _walk_binop(self, node, predecessors, ctx_type = None):
        left = node.left
        if ctx_type is not None:
            predecessors = self._walkers[type(left)](left, predecessors, ctx_type)
        else:
            predecessors = self._walk(left, predecessors)
        predecessors = self._walk(node.right, predecessors)
        res = self.add_successor(predecessors, node)
        if self.in_try:
            self._raise_exception(res)
        return res

    def _walk_assignexpr(self, node, predecessors):
        flow = self._walk(node.value, predecessors)
        flow = self._walk_name(node.target, flow, ast.Store)
        flow = self.add_successor(flow, node)
        return flow

    def _walk_augassign(self, node, predecessors):
        predecessors = self.add_successor(predecessors, node)
        predecessors = self._walk_binop(node.operation, predecessors, ast.AugLoad)
        target = node.operation.left
        return self._walkers[type(target)](target, predecessors, ast.AugStore)

    def _walk_for_loop(self, node, predecessors):
        loop_entry = self._walk(node.iter,  predecessors)
        pre_target = self.add_successor(loop_entry, node)
        #Getting the iterator from the iterable may raise
        if self.in_try:
            self._raise_exception(pre_target)
        body_entry = self._walk(node.target, pre_target)
        return self._walk_loop_body(node, pre_target, body_entry, SingletonNodeSet(pre_target.node, EXHAUSTED))

    def _walk_while(self, node, predecessors):
        #return self._walk_loop(None, node.test, node, predecessors)
        pre_test = self.add_successor(predecessors, node)
        test_out = self._walk(node.test, pre_test)
        body_entry, loop_exit = test_out.branch()
        return self._walk_loop_body(node, pre_test, body_entry, loop_exit, is_true_constant(node.test))

    def _walk_loop_body(self, node, top, body_entry, loop_exit, infinite = False):
        self.scope.breaking_stack.push_block()
        self.scope.continuing_stack.push_block()
        body_exit = self._walk(node.body, body_entry)
        breaks = self.scope.breaking_stack.pop_block()
        continues = self.scope.continuing_stack.pop_block()
        top_node = top.unique_node()
        self.add_successor_node(continues, top_node)
        self.add_successor_node(body_exit, top_node)
        if infinite:
            return breaks
        if node.orelse:
            loop_exit = self._walk(node.orelse, loop_exit)
        return loop_exit + breaks

    def _walk_try_finally(self, node, predecessors):
        assert node.finalbody

        self.scope.exception_stack.push_block()
        self.scope.return_stack.push_block()
        self.scope.continuing_stack.push_block()
        self.scope.breaking_stack.push_block()
        self.in_try += 1
        body_exit = self._walk_try_except(node, predecessors)
        self.in_try -= 1
        continuing = self.scope.continuing_stack.pop_block()
        returning = self.scope.return_stack.pop_block()
        breaking = self.scope.breaking_stack.pop_block()
        exceptions = self.scope.pop_exceptions()
        if exceptions:
            self.scope.exception_stack.add(self._walk(node.finalbody, exceptions))
        if continuing:
            assert self.scope.continuing_stack, continuing
            self.scope.continuing_stack.add(self._walk(node.finalbody, continuing))
        if breaking:
            self.scope.breaking_stack.add(self._walk(node.finalbody, breaking))
        if returning:
            self.scope.return_stack.add(self._walk(node.finalbody, returning))
        finally_exit = self._walk(node.finalbody, body_exit)
        return finally_exit

    def _walk_try(self, node, predecessors):
        predecessors = self.add_successor(predecessors, node)
        if node.finalbody:
            return self._walk_try_finally(node, predecessors)
        else:
            return self._walk_try_except(node, predecessors)

    def _walk_try_except(self, node, predecessors):
        if not node.handlers:
            self.in_try += 1
            body_exit = self._walk(node.body, predecessors)
            res = self._walk(node.orelse, body_exit)
            self.in_try -= 1
            return res
        # check if there is a handler for exception groups (PEP 654)
        handles_grouped = [h for h in node.handlers if isinstance(h, ast.ExceptGroupStmt)]
        if handles_grouped:
            return self._walk_try_except_groups(node, predecessors)
        else:
            return self._walk_try_except_no_groups(node, predecessors)

    def _walk_try_body(self, node, predecessors):
        self.in_try += 1
        in_try_name = 0
        for handler in node.handlers:
            if hasattr(handler.type, "variable") and handler.type.variable.id == "NameError":
                in_try_name = 1
        self.in_try_name += in_try_name
        self.scope.exception_stack.push_block()
        body_exit = self._walk(node.body, predecessors)
        self.in_try -= 1
        self.in_try_name -= in_try_name
        exceptions = self.scope.pop_exceptions()
        return body_exit, exceptions

    def _walk_try_except_groups(self, node, predecessors):
        body_exit, exceptions = self._walk_try_body(node, predecessors)

        for handler in node.handlers:
            # the handler test might fail, meaning the handler does not match the
            # exception group. In this case, the exception is propagated, so the
            # test node gets its own variable.
            handler_test = self.add_successor(exceptions, handler)
            handler_test = self._walk(handler.type, handler_test)

            # Assuming the handler does match, the handler body is executed.
            handled = handler_test
            if handler.name is not None:
                handled = self._walk(handler.name, handled)

            handled = self._walk(handler.body, handled)

            # The next handler only sees unhandled exceptions from this handler
            # _not_ exceptions raised from the body of the handler.
            # If this handler did not match, there is an exceptional transition from the test
            # otherwise, there is one from the body exit.
            exceptions = handler_test.exception() + handled.exception()

        body_exit = self._walk(node.orelse, body_exit)

        # When we run out of handlers, there might still be unhandled exceptions.
        # We add them to the current stack, so they can be picked up by the finally block
        # or the scope exit.
        self.scope.exception_stack.add(exceptions)

        # normal exit includes the last handler in case it handled all remaining exceptions
        return handled + body_exit

    def _walk_try_except_no_groups(self, node, predecessors):
        body_exit, exceptions = self._walk_try_body(node, predecessors)

        handler_exit = EMPTY
        catch_all = False
        for handler in node.handlers:
            handled = self.add_successor(exceptions, handler).normalise()
            if handler.type is None:
                catch_all = True
            else:
                handled = self._walk(handler.type, handled)
                if handler.name is not None:
                    handled = self._walk(handler.name, handled)
            handler_exit += self._walk(handler.body, handled)
        if not catch_all:
            self.scope.exception_stack.add(exceptions)
        body_exit = self._walk(node.orelse, body_exit)
        return handler_exit + body_exit

    def _walk_ann_assign(self, node, predecessors):
        flow = self._walk(node.value, predecessors)
        flow = self._walk(node.target, flow)
        # PEP 526 specifies that only annotations outside functions will be evaluated
        if not isinstance(self.scope.ast_scope, ast.Function):
            flow = self._walk(node.annotation, flow)
        flow = self.add_successor(flow, node)
        return flow

    def _walk(self, node, predecessors):
        res = self._walkers[type(node)](node, predecessors)
        return res

    def _walk_list(self, node, predecessors):
        for child in node:
            predecessors = self._walkers[type(child)](child, predecessors)
        return predecessors

    def skip(self, _, predecessors):
        return predecessors

    def add_successor_node(self, predecessors, flow_node):
        for n, kind in predecessors:
            self.scope.graph.add_edge(n, flow_node)
            self.scope.graph.annotate_edge(n, flow_node, kind)

    def add_successor(self, predecessors, node, kind=NORMAL):
        '''Add successor relations between all nodes
        in the iterable predecessors and node.'''
        assert isinstance(node, ast.AstBase)
        flow_node = FlowNode(node)
        predecessors = predecessors.merge_true_false_pairs()
        #Ensure node is in graph, even if unreachable, so it can be annotated.
        self.scope.graph.add_node(flow_node)
        self.add_successor_node(predecessors, flow_node)
        return SingletonNodeSet(flow_node, kind)

NON_RAISING_COMPARISON_OPS = (ast.Is, ast.IsNot, ast.Eq, ast.NotEq)


SUCCESSOR_RELATIONS = {
    TRUE:  u'py_true_successors',
    FALSE:  u'py_false_successors',
    NORMAL:  u'py_successors',
    EXCEPTION:  u'py_exception_successors',
    EXHAUSTED: u'py_successors',
}

def write_successors(writer, from_node, to_node, kind):
    writer.write_tuple(SUCCESSOR_RELATIONS[kind], 'nn', from_node, to_node)

def write_flow_node(writer, flow, bb, index):
    writer.write_tuple(u'py_flow_bb_node', 'nnnd', flow, flow.node, bb, index)

def write_idoms(writer, node, idom):
    writer.write_tuple(u'py_idoms', 'nn', node, idom)

def write_ssa_var(writer, var):
    writer.write_tuple(u'py_ssa_var', 'nn', var, var.variable)

def write_ssa_defn(writer, var, node):
    writer.write_tuple(u'py_ssa_defn', 'nn', var, node)

def write_ssa_use(writer, node, var):
    writer.write_tuple(u'py_ssa_use', 'nn', node, var)

def write_ssa_phi(writer, var, arg):
    writer.write_tuple(u'py_ssa_phi', 'nn', var, arg)

def write_scope_node(writer, node, scope, index):
    writer.write_tuple(u'py_scope_flow', 'nnd', node, scope, index)

def is_true_constant(condition):
    'Determine if (AST node) condition is both constant and evaluates to True'
    if isinstance(condition, ast.Num):
        return condition.n
    elif isinstance(condition, ast.Name):
        return condition.variable.id == "True"
    elif isinstance(condition, ast.Str):
        return condition.s
    return False

def is_false_constant(condition):
    'Determine if (AST node) condition is both constant and evaluates to False'
    if isinstance(condition, ast.Num):
        return not condition.n
    elif isinstance(condition, ast.Name):
        return condition.variable.id == "False" or condition.variable.id == "None"
    elif isinstance(condition, ast.Str):
        return not condition.s
    return False


TEMPLATE = '''"%s" [
label = "%s"
color = "%s"
shape = "%s"
];
'''

class GraphVizIdPool(object):
    '''This class provides the same interface as IDPool.
       It outputs nodes in graphviz format'''

    def __init__(self, out, options):
        self.out = out
        self.pool = {}
        self.next_id = 1000
        self.ranks = {}
        self.node_colours = {}
        self.options = options

    def get(self, node, name=None):
        'Return an id (in this pool) for node'
        assert node is not None
        #Use id() except for strings.
        col = "black"
        if isinstance(node, str):
            node_id = node
        else:
            node_id = id(node)
        if node_id in self.pool:
            return self.pool[node_id]
        next_id = 'ID_%d' % self.next_id
        show = isinstance(node, FlowNode) or self.options.ast
        if isinstance(node, FlowNode) and not self.options.ast:
            col = self.node_colours.get(node, "black")
            node = node.node
        if name is None:
            if hasattr(node, "is_async") and node.is_async:
                name = "Async " + type(node).__name__
            else:
                name = type(node).__name__
            if isinstance(node, FlowNode):
                col = self.node_colours.get(node, "black")
                name = type(node.node).__name__[:6]
                if node.node not in self.ranks:
                    self.ranks[node.node] = set()
                self.ranks[node.node].add(node)
            else:
                if name in ('Name', 'PlaceHolder'):
                    ctx_name = node.ctx.__class__.__name__
                    name += ' (%s) id=%s' % (ctx_name, node.variable.id)
                elif hasattr(node, "op"):
                    name = type(node.op).__name__
                else:
                    for field_name, _, child_node in iter_fields(node):
                        if field_name == "is_async":
                            continue
                        if type(child_node) in (str, int, float, bool):
                            txt = str(child_node)
                            if len(txt) > 16:
                                txt = txt[:13] + '...'
                            txt = txt.replace('\n', '\\n').replace('"', '\\"')
                            name += ' ' + field_name + '=' + txt
        if isinstance(node, ast.stmt):
            shape = 'rectangle'
        elif type(node) in (ast.Function, ast.Module, ast.Class):
            shape = 'octagon'
        elif isinstance(node, FlowNode):
            shape = "diamond"
        else:
            shape = 'oval'
        if show:
            util.fprintf(self.out, TEMPLATE, next_id, name, col, shape)
        self.pool[node_id] = next_id
        self.next_id += 1
        return next_id

    def print_ranks(self):
        for node, flows in self.ranks.items():
            if not self.options.ast:
                continue
            node_id = self.get(node)
            ids = [ node_id ]
            for flow in flows:
                flow_id = self.get(flow)
                ids.append(flow_id)
            util.fprintf(self.out, "{rank=same; %s;}\n", ' '.join(ids))

class GraphVizTrapWriter(object):

    def __init__(self, options):
        if options.out is None:
            self.out = sys.stdout
        else:
            self.out = open(options.out, 'w')
        self.pool = GraphVizIdPool(self.out, options)
        util.fprintf(self.out, HEADER)

    def close(self):
        self.pool.print_ranks()
        util.fprintf(self.out,  FOOTER)
        if self.out != sys.stdout:
            self.out.close()
        self.out = None

    def __del__(self):
        if self.out and self.out != sys.stdout:
            self.out.close()

HEADER = '''digraph g {
graph [
rankdir = "TB"
];
'''

FOOTER = '''}
'''

FORMAT = '%s -> %s [color="%s"];\n'

EDGE_COLOURS = {TRUE: "green", FALSE: "blue", NORMAL: "black", EXCEPTION: "red", EXHAUSTED: "brown" }
NODE_COLOURS = {EXCEPTION_EXIT: "red", ENTRY: "orange", FALL_THROUGH_EXIT: "grey", RETURN_EXIT: "blue" }

EXTENDED_HELP = """Edge types:

- Green, solid :: True successor of branching node.
- Blue, solid :: False successor of branching node.
- Brown, solid:: Exhausted successor of for node.
- Brown, dashed :: Target is corresponding AST node.

- option -s (--ssa) ::
  - Green, dashed :: Source is a place where the variable is used, target is the place
                     where the variable is defined. Edge marked with variable
                     name.
  - Blue, dashed :: Target is phi node, source is where the variable comes from.
                    Edge marked with variable name.
- option -b (--basic_blocks) ::
     - Purple, dashed :: Points from a node to the first node in its basic
                         block. Labelled with index of node within its basic block.
- option -i (--idoms) ::
     - Yellow, solid :: Shows the immediate dominator (source) of a node (target).

Node shapes:

- Rectangle :: Statement.
- Octagon :: Function / module / class.
- Diamond :: Flow node.
- Oval :: Everything else.

Node colours:
- Red :: Exception exit.
- Orange :: Entry.
- Grey :: Fall-through exit.
- Blue :: Return exit.
- Black :: Everything else.
"""

def print_extended_help(option, opt_str, value, parser):
    print(EXTENDED_HELP)
    sys.exit(0)

def args_parser():
    'Parse command_line, returning options, arguments'
    from optparse import OptionParser
    usage = "usage: %prog [options] python-file"
    parser = OptionParser(usage=usage)
    parser.add_option("-i", "--idoms", help="Show immediate dominators", action="store_true")
    parser.add_option("-s", "--ssa", help="Show SSA phis and uses.", action="store_true")
    parser.add_option("-b", "--basic_blocks", help="Show basic-blocks.", action="store_true")
    parser.add_option("-o", "--out", dest="out",
                      help="Output directory for writing gv file")
    parser.add_option("--dont-split-graph", dest="split", default=True, action="store_false",
                      help = """Do not perform splitting on the flow graph.""")
    parser.add_option("--dont-prune-graph", dest="prune", default=True, action="store_false",
                      help = """Do not perform pruning on the flow graph.""")
    parser.add_option("--dont-unroll-graph", dest="unroll", action="store_false",
                      help = """DEPRECATED. Do not perform unrolling on the flow graph.""")
    parser.add_option("--unroll-graph", dest="unroll", default=False, action="store_true",
                      help = """Perform unrolling on the flow graph. Default false.""")
    parser.add_option("--no-ast", dest="ast", default=True, action="store_false",
                      help = """Do not output AST nodes.""")
    parser.add_option("--extended-help", help="Print extended help.", action="callback",
                      callback=print_extended_help)
    parser.add_option("--tsg", dest="tsg", default=False, action="store_true",
                      help="Use tgs based parser.")
    return parser

def main():
    'Write out flow graph (as computed by FlowPass) in graphviz format'
    import re
    definitions = {}

    _UNDEFINED_NAME = ast.Name("Not defined", ast.Load())
    _UNDEFINED_NAME.variable = ast.Variable("Not defined", None)
    UNDEFINED_NODE = FlowNode(_UNDEFINED_NAME)

    global write_successors, write_flow_node, write_idoms, write_special_successors
    global write_ssa_var, write_ssa_use, write_ssa_phi, write_ssa_defn, write_scope_node

    parser = args_parser()
    options, args = parser.parse_args(sys.argv[1:])

    if len(args) != 1:
        sys.stderr.write("Error: wrong number of arguments.\n")
        parser.print_help()
        return

    inputfile = args[0]

    if not os.path.isfile(inputfile):
        sys.stderr.write("Error: input file does not exist.\n")
        return

    writer = GraphVizTrapWriter(options)
    def write(*args):
        util.fprintf(writer.out, *args)

    successors = set()
    def write_successors(writer, from_node, to_node, kind):
        from_id = writer.pool.get(from_node)
        to_id = writer.pool.get(to_node)
        if (from_node, to_node) not in successors:
            write(FORMAT, from_id, to_id, EDGE_COLOURS[kind])
            successors.add((from_node, to_node))

    def write_flow_node(out, flow, bb, index):
        flow_id = writer.pool.get(flow)
        if options.ast:
            node_id = writer.pool.get(flow.node)
            write('%s->%s [ style = "dashed" color = "brown" ];\n', flow_id, node_id)
        if options.basic_blocks:
            bb_id = writer.pool.get(bb)
            write('%s->%s [ style = "dashed" color = "purple" label = "%d" ];\n',
                flow_id, bb_id, index)

    if options.idoms:
        def write_idoms(out, node, idom):
            node_id = writer.pool.get(node)
            idom_id = writer.pool.get(idom)
            write('%s->%s [ color = "yellow" ];\n', idom_id, node_id)
    else:
        def write_idoms(out, node, idom):
            pass

    def write_scope_node(writer, node, scope, index):
        writer.pool.node_colours[node] = NODE_COLOURS[index]

    def write_ssa_var(out, ssa_var):
        pass

    def write_ssa_defn(out, ssa_var, node):
        definitions[ssa_var] = node

    def get_ssa_node(var):
        '''If SSA_Var node is undefined, then FlowGraph inserts a None -
           Change to UNDEFINED'''
        if var in definitions:
            return definitions[var]
        else:
            return UNDEFINED_NODE

    if options.ssa:
        def write_ssa_use(out, node, var):
            var_id = writer.pool.get(get_ssa_node(var))
            node_id = writer.pool.get(node)
            write('%s->%s [ color = "green", style="dashed", label="use(%s)" ]\n'
                                % (node_id, var_id, var.variable.id))

        def write_ssa_phi(out, phi, arg):
            phi_id = writer.pool.get(get_ssa_node(phi))
            arg_id = writer.pool.get(get_ssa_node(arg))
            write('%s->%s [ color = "blue", style="dashed", label="phi(%s)" ]\n'
                                % (arg_id, phi_id, arg.variable.id))
    else:
        def write_ssa_use(out, node, var):
            pass

        def write_ssa_phi(out, phi, arg):
            pass
    if options.tsg:
        import semmle.python.parser.tsg_parser
        parsed_ast = semmle.python.parser.tsg_parser.parse(inputfile, FakeLogger())
    else:
        module = modules.PythonSourceModule("__main__", inputfile, FakeLogger())
        parsed_ast = module.ast
    FlowPass(options.split, options.prune, options.unroll).extract(parsed_ast, writer)
    writer.close()

class FakeLogger(object):

    def debug(self, fmt, *args):
        print(fmt % args)

    def traceback(self):
        print(traceback.format_exc())

    info = warning = error = trace = debug

if __name__ == '__main__':
    main()
