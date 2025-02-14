'''
Prune the flow-graph, eliminating edges with impossible constraints.
For example:
1. if x:
2.     if x == 0:
3.         pass
The edge from `x == 0` to pass (line 2 to line 3) is impossible as `x` cannot be zero to
reach line 2.

While code like the above is unlikely in source code, it is quite common after splitting.

'''

from semmle.python import ast
import cmath
from collections import defaultdict

from semmle.python.passes.ast_pass import ASTVisitor
import semmle.util as util
from semmle.python.ast import Lt, LtE, Eq, NotEq, Gt, GtE, Is, IsNot

__all__ = [ 'do_pruning' ]

INT_TYPES = int

# Classes representing constraint on branches, for pruning.
# For example, the constraint `x` allows pruning and edge with the constraint `x == 0`
# since if `x` is True it cannot be zero.

class Truthy(object):
    '''A test of the form `x` or `not x`'''

    def __init__(self, sense):
        self.sense = sense

    def invert(self):
        return (VAR_IS_TRUE, VAR_IS_FALSE)[self.sense]

    def contradicts(self, other):
        '''Holds if self and other are contradictory.'''
        if self.sense:
            return other.constrainsVariableToBeFalse()
        else:
            return other.constrainsVariableToBeTrue()

    def constrainsVariableToBeTrue(self):
        '''Holds if this constrains the variable such that `bool(var) is True`'''
        return self.sense

    def constrainsVariableToBeFalse(self):
        '''Holds if this constrains the variable such that `bool(var) is False`'''
        return not self.sense

    def __repr__(self):
        return "True" if self.sense else "False"

class IsNone(object):
    '''A test of the form `x is None` or `x is not None`'''

    def __init__(self, sense):
        self.sense = sense

    def contradicts(self, other):
        if self is VAR_IS_NONE:
            return other is VAR_IS_NOT_NONE or other is VAR_IS_TRUE
        else:
            return other is VAR_IS_NONE

    def invert(self):
        return (VAR_IS_NONE, VAR_IS_NOT_NONE)[self.sense]

    def constrainsVariableToBeTrue(self):
        return False

    def constrainsVariableToBeFalse(self):
        return self is VAR_IS_NONE

    def __repr__(self):
        return "Is None" if self.sense else "Is Not None"

class ComparedToConst(object):
    '''A test of the form `x == k`, `x < k`, etc.'''

    def __init__(self, op, k):
        #We can treat is/is not as ==/!= as we only
        #compare with simple literals which are always interned.
        if op is Is:
            op = Eq
        elif op is IsNot:
            op = NotEq
        self.op = op
        self.k = k

    def invert(self):
        return ComparedToConst(INVERT_OP[self.op], self.k)

    def constrainsVariableToBeTrue(self):
        if self.op == Eq:
            return self.k != 0
        if self.op == NotEq:
            return self.k == 0
        if self.op == GtE:
            return self.k > 0
        if self.op == Gt:
            return self.k >= 0
        if self.op == LtE:
            return self.k < 0
        if self.op == Lt:
            return self.k <= 0
        return False

    def constrainsVariableToBeFalse(self):
        return self.op == Eq and self.k == 0

    def contradicts(self, other):
        if self.constrainsVariableToBeTrue() and other is VAR_IS_FALSE:
            return True
        if self.constrainsVariableToBeFalse() and other is VAR_IS_TRUE:
            return True
        if self.op == Eq and other is VAR_IS_NONE:
            return True
        if not isinstance(other, ComparedToConst):
            return False
        if self.op == Eq:
            if other.op == NotEq:
                return self.k == other.k
            if other.op == Eq:
                return self.k != other.k
            if other.op == Lt:
                return self.k >= other.k
            if other.op == LtE:
                return self.k > other.k
            if other.op == Gt:
                return self.k <= other.k
            if other.op == GtE:
                return self.k < other.k
            return False
        if self.op == Lt:
            if other.op == Eq or other.op == Gt or other.op == GtE:
                return self.k <= other.k
            return False
        if self.op == LtE:
            if other.op == Eq or other.op == GtE:
                return self.k < other.k
            if other.op == Gt:
                return self.k <= other.k
            return False
        if other.op in (NotEq, Gt, GtE):
            return False
        return other.contradicts(self)

    def __repr__(self):
        return "%s %d" % (OP_NAME[self.op], self.k)


INVERT_OP = {
        Eq: NotEq,
        NotEq: Eq,
        Lt: GtE,
        LtE: Gt,
        Gt: LtE,
        GtE: Lt
    }

OP_NAME = {
    Eq: "==",
    NotEq: "!=",
    Lt: "<",
    LtE: "<=",
    Gt: ">",
    GtE: ">=",
}

VAR_IS_TRUE = Truthy(True)
VAR_IS_FALSE = Truthy(False)

VAR_IS_NONE = IsNone(True)
VAR_IS_NOT_NONE = IsNone(False)

NAME_CONSTS = {
    "True" : VAR_IS_TRUE,
    "False": VAR_IS_FALSE,
    "None": VAR_IS_NONE,
}

class SkippedVisitor(ASTVisitor):

    def __init__(self):
        self.nodes = set()

    def visit_Subscript(self, node):
        if isinstance(node.value, ast.Name):
            self.nodes.add(node.value)

    def visit_Attribute(self, node):
        if isinstance(node.value, ast.Name):
            self.nodes.add(node.value)

class NotBooleanTestVisitor(ASTVisitor):
    """Visitor that checks if a test is not a boolean test."""

    def __init__(self):
        self.nodes = set()

    def visit_MatchLiteralPattern(self, node):
        # MatchLiteralPatterns _look_ like boolean tests, but are not.
        # Thus, without this check, we would interpret
        #
        # match x:
        #    case False:
        #        pass
        #
        # (and similarly for True) as if it was a boolean test. This would cause the true edge
        # (leading to pass) to be pruned later on.
        if isinstance(node.literal, ast.Name) and node.literal.id in ('True', 'False'):
            self.nodes.add(node.literal)

class NonlocalVisitor(ASTVisitor):
    def __init__(self):
        self.names = set()

    def visit_Nonlocal(self, node):
        for name in node.names:
            self.names.add(name)

class GlobalVisitor(ASTVisitor):
    def __init__(self):
        self.names = set()

    def visit_Global(self, node):
        for name in node.names:
            self.names.add(name)

class KeptVisitor(ASTVisitor):

    def __init__(self):
        self.nodes = set()

    #Keep imports
    def visit_alias(self, node):
        bool_const = const_value(node.value)
        if bool_const is None:
            return
        defn = node.asname
        if hasattr(defn, 'variable'):
            self.nodes.add(defn)

def skipped_variables(tree, graph, use_map):
    '''Returns a collection of SsaVariables that
    are skipped as possibly mutated.

    Variables are skipped if their values may be mutated
    in such a way that it might alter their boolean value.
    This means that they have an attribute accessed, or are subscripted.
    However, modules are always true, so are never skipped.
    '''
    variables = use_map.values()
    skiplist = set()
    v = SkippedVisitor()
    v.visit(tree)
    ast_skiplist = v.nodes
    for node, var in use_map.items():
        if node.node in ast_skiplist:
            skiplist.add(var)
    v = KeptVisitor()
    v.visit(tree)
    ast_keeplist = v.nodes
    keeplist = set()
    for var in variables:
        defn = graph.get_ssa_definition(var)
        if defn and defn.node in ast_keeplist:
            keeplist.add(var)
    return skiplist - keeplist

def get_branching_edges(tree, graph, use_map):
    ''''Returns an iterator of pred, succ, var, bool tuples
    representing edges and the boolean value or None-ness that
    the ssa variable holds on that edge.
    '''
    for pred, succ, ann in graph.edges():
        if ann not in (util.TRUE_EDGE, util.FALSE_EDGE):
            continue
        #Handle 'not' expressions.
        invert = ann == util.FALSE_EDGE
        test = pred
        while isinstance(test.node, ast.UnaryOp):
            if not isinstance(test.node.op, ast.Not):
                break
            preds = graph.pred[test]
            if len(preds) != 1:
                    break
            test = preds[0]
            invert = not invert
        t = comparison_kind(graph, test)
        if t is None:
            continue
        val, use = t
        if invert:
            val = val.invert()
        if use in use_map:
            yield pred, succ, use_map[use], val

def effective_constants_definitions(bool_const_defns, graph, branching_edges):
    '''Returns a mapping of var -> list of (node, effective-constant)
     representing the effective boolean constant definitions.
     A constant definition is an assignment to a
     SSA variable 'var' such that bool(var) is a constant
     for all uses of that variable dominated by the definition.

     A (SSA) variable is effectively constant if it assigned
     a constant, or it is guarded by a test.
    '''
    consts = defaultdict(list)
    for var in graph.ssa_variables():
        defn = graph.get_ssa_definition(var)
        if not defn or defn.node not in bool_const_defns:
            continue
        consts[var].append((defn, bool_const_defns[defn.node]))
    for pred, succ, var, bval in branching_edges:
        if len(graph.pred[succ]) != 1:
            continue
        consts[var].append((succ, bval))
    return consts

def do_pruning(tree, graph):
    v = BoolConstVisitor()
    v.visit(tree)
    not_boolean_test = NotBooleanTestVisitor()
    not_boolean_test.visit(tree)
    nonlocals = NonlocalVisitor()
    nonlocals.visit(tree)
    global_vars = GlobalVisitor()
    global_vars.visit(tree)
    bool_const_defns = v.const_defns
    #Need to repeatedly do this until we reach a fixed point
    while True:
        use_map = {}
        for node, var in graph.ssa_uses():
            if isinstance(node.node, ast.Name):
                use_map[node] = var
        skiplist = skipped_variables(tree, graph, use_map)
        edges = list(get_branching_edges(tree, graph, use_map))
        consts = effective_constants_definitions(bool_const_defns, graph, edges)
        dominated_by = {}
        #Look for effectively constant definitions that dominate edges on
        #which the relative variable has the inverse sense.
        #Put edges to be removed in a set, as an edge could be removed for
        #multiple reasons.
        to_be_removed = set()
        for pred, succ, var, bval in edges:
            if var not in consts:
                continue
            if var in skiplist and bval in (VAR_IS_TRUE, VAR_IS_FALSE):
                continue
            if var.variable.id in nonlocals.names:
                continue
            if var.variable.id in global_vars.names:
                continue
            for defn, const_kind in consts[var]:
                if not const_kind.contradicts(bval):
                    continue
                if defn not in dominated_by:
                    dominated_by[defn] = graph.dominated_by(defn)
                if pred in dominated_by[defn]:
                    to_be_removed.add((pred, succ))
        #Delete simply dead edges (like `if False: ...` )
        for pred, succ, ann in graph.edges():
            if ann == util.TRUE_EDGE:
                val = VAR_IS_TRUE
            elif ann == util.FALSE_EDGE:
                val = VAR_IS_FALSE
            else:
                continue
            b = const_value(pred.node)
            if b is None:
                continue
            if pred.node in not_boolean_test.nodes:
                continue
            if b.contradicts(val):
                to_be_removed.add((pred, succ))
        if not to_be_removed:
            break
        for pred, succ in to_be_removed:
            graph.remove_edge(pred, succ)
        graph.clear_computed()

class BoolConstVisitor(ASTVisitor):
    '''Look for assignments of a boolean constant to a variable.
    self.const_defns holds a mapping from the AST node for the definition
    to the True/False value for the constant.'''

    def __init__(self):
        self.const_defns = {}


    def visit_alias(self, node):
        bool_const = const_value(node.value)
        if bool_const is None:
            return
        defn = node.asname
        if hasattr(defn, 'variable'):
            self.const_defns[defn] = bool_const

    def visit_Assign(self, node):
        bool_const = const_value(node.value)
        if bool_const is None:
            return
        for defn in node.targets:
            if hasattr(defn, 'variable'):
                self.const_defns[defn] = bool_const

def _comparison(test):
    # Comparisons to None or ints
    if isinstance(test, ast.Compare) and len(test.ops) == 1:
        left = test.left
        right = test.comparators[0]
        if not hasattr(left, "variable"):
            return None
        if isinstance(right, ast.Name) and right.id == "None":
            if isinstance(test.ops[0], ast.Is):
                return VAR_IS_NONE
            if isinstance(test.ops[0], ast.IsNot):
                return VAR_IS_NOT_NONE
        if isinstance(right, ast.Num) and isinstance(right.n, INT_TYPES):
            return ComparedToConst(type(test.ops[0]), right.n)
    return None


def comparison_kind(graph, test):
    # Comparisons to None or ints
    val = _comparison(test.node)
    if val is None:
        if hasattr(test.node, "variable"):
            return VAR_IS_TRUE, test
        return None
    use_set = graph.pred[graph.pred[test][0]]
    if len(use_set) != 1:
        return None
    use = use_set[0]
    return val, use

def const_value(ast_node):
    '''Returns the boolean value of a boolean or numeric constant AST node or None if not a constant.
    NaN is not a constant.'''
    if isinstance(ast_node, ast.Name):
        if ast_node.id in ("True", "False", "None"):
            return NAME_CONSTS[ast_node.id]
        else:
            return None
    if isinstance(ast_node, ast.ImportExpr):
        #Modules always evaluate True
        return VAR_IS_TRUE
    if isinstance(ast_node, ast.Num):
        n = ast_node.n
    elif isinstance(ast_node, ast.UnaryOp):
        if isinstance(ast_node.op, ast.USub) and isinstance(ast_node.operand, ast.Num):
            n = ast_node.operand.n
        elif isinstance(ast_node.op, ast.Not):
            not_value = const_value(ast_node.operand)
            if not_value is None:
                return None
            return not_value.invert()
        else:
            return None
    else:
        return None

    #Check for NaN, but be careful not to overflow
    #Handle integers first as they may overflow cmath.isnan()
    if not isinstance(n, INT_TYPES) and cmath.isnan(n):
        return None
    #Now have an int or a normal float or complex
    return ComparedToConst(Eq, n)
