'''
Split the flow-graph to allow tests to dominate all parts of the code that depends on them.
We split on `if`s and `try`s. Either because of several tests on the same condition or
subsequent tests on a constant determined by the first condition.
E.g.

if a:
   A
B
if a:
   C
becomes
if a:
    A
    B
    C
else:
    B
ensuring that A dominates C.

or...

try:
    import foo
except:
    foo = None
X
if foo:
    Y
becomes
try:
    import foo
    X
    Y
except:
    foo = None
    X

To split on CFG node N we require that there exists nodes H1..Hn and N2 such that:
    N and N2 are tests or conditional assignments to the same variable.
    N dominates H1 .. Hn and N2
    There is no assignment to the variable between N and N2
    H1..Hn are the "split heads" of N, that is:
        if N is a test, H1 and H2 are its true and false successors (there is no H3).
        if N is a `try` then H1 .. Hn-1 are exists from the try body and Hn is the CFG node for the first (and only) `except` statement.
    Within the region strictly dominated by N, N2 must reachable from all of H1..Hn

    For simplicity we limit n (as in Hn) to 2, but that is not required for correctness.
'''

from collections import defaultdict

from semmle.python import ast
from semmle.python.passes.ast_pass import iter_fields
from operator import itemgetter
from semmle.graph import FlowGraph

MAX_SPLITS = 2

def do_split(ast_root, graph: FlowGraph):
    '''Split the flow graph, using the AST to determine split points.'''
    ast_labels = label_ast(ast_root)
    cfg_labels = label_cfg(graph, ast_labels)
    split_points = choose_split_points(graph, cfg_labels)
    graph.split(split_points)

class ScopedAstLabellingVisitor(object):
    '''Visitor for labelling AST nodes in scope.
        Does not visit nodes belonging to inner scopes (methods, etc)
    '''

    def __init__(self, labels):
        self.labels = labels
        self.priority = 0

    def visit(self, node):
        """Visit a node."""
        method = 'visit_' + node.__class__.__name__
        getattr(self, method, self.generic_visit)(node)

    def generic_visit(self, node):
        if isinstance(node, ast.AstBase):
            for _, _, value in iter_fields(node):
                self.visit(value)

    def visit_Class(self, node):
        #Do not visit sub-scopes
        return

    visit_Function = visit_Class

    def visit_list(self, the_list):
        for item in the_list:
            method = 'visit_' + item.__class__.__name__
            getattr(self, method, self.generic_visit)(item)

    #Helper methods

    @staticmethod
    def get_variable(expr):
        '''Returns the variable of this expr. Returns None if no variable.'''
        if hasattr(expr, "variable"):
            return expr.variable
        else:
            return None

    @staticmethod
    def is_const(expr):
        if isinstance(expr, ast.Name):
            return expr.variable.id in ("None", "True", "False")
        elif isinstance(expr, ast.UnaryOp):
            return ScopedAstLabellingVisitor.is_const(expr.operand)
        return isinstance(expr, (ast.Num, ast.Str))



class AstLabeller(ScopedAstLabellingVisitor):
    '''Visitor to label tests and assignments
    for later scanning to determine split points.
    '''

    def __init__(self, *args):
        ScopedAstLabellingVisitor.__init__(self, *args)
        self.in_test = 0

    def _label_for_compare(self, cmp):
        if len(cmp.ops) != 1:
            return None
        var = self.get_variable(cmp.left)
        if var is None:
            var = self.get_variable(cmp.comparators[0])
            k = cmp.left
        else:
            k = cmp.comparators[0]
        if var is not None and self.is_const(k):
            self.priority += 1
            return (var, k, self.priority)
        return None

    def visit_Compare(self, cmp):
        label = self._label_for_compare(cmp)
        if label:
            self.labels[cmp].append(label)

    def visit_Name(self, name):
        self.priority += 1
        if isinstance(name.ctx, ast.Store):
            self.labels[name].append((name.variable, "assign", self.priority))
        elif self.in_test:
            self.labels[name].append((name.variable, None, self.priority))

    def _label_for_unary_operand(self, op):
        if not isinstance(op.op, ast.Not):
            return None
        if isinstance(op.operand, ast.UnaryOp):
            return self._label_for_unary_operand(op.operand)
        elif isinstance(op.operand, ast.Name):
            self.priority += 1
            return (op.operand.variable, None, self.priority)
        elif isinstance(op.operand, ast.Compare):
            return self._label_for_compare(op.operand)
        return None

    def visit_UnaryOp(self, op):
        if not self.in_test:
            return
        label = self._label_for_unary_operand(op)
        if label:
            self.labels[op].append(label)
        else:
            self.visit(op.operand)

    def visit_If(self, ifstmt):
        # Looking for the pattern:
        # if x: k = K0 else: k = K1
        # the test is the split point, but the variable is `k`
        self.in_test += 1
        self.visit(ifstmt.test)
        self.in_test -= 1
        self.visit(ifstmt.body)
        self.visit(ifstmt.orelse)
        k1 = {}
        ConstantAssignmentVisitor(k1).visit(ifstmt.body)
        k2 = {}
        ConstantAssignmentVisitor(k2).visit(ifstmt.orelse)
        k = set(k1.keys()).union(k2.keys())
        self.priority += 1
        for var in k:
            val = k1[var] if var in k1 else k2[var]
            self.labels[ifstmt.test].append((var, val, self.priority))

    def visit_Try(self, stmt):
        # Looking for the pattern:
        # if try: k = K0 except: k = K1
        # the try is the split point, and the variable is `k`
        self.generic_visit(stmt)
        if not stmt.handlers or len(stmt.handlers) > 1:
            return
        k1 = {}
        ConstantAssignmentVisitor(k1).visit(stmt.body)
        k2 = {}
        ConstantAssignmentVisitor(k2).visit(stmt.handlers[0])
        k = set(k1.keys()).union(k2.keys())
        self.priority += 1
        for var in k:
            val = k1[var] if var in k1 else k2[var]
            self.labels[stmt].append((var, val, self.priority))

    def visit_ClassExpr(self, node):
        # Don't split over class definitions,
        # as the presence of multiple ClassObjects for a
        # single class can be confusing.
        # The same applies to function definitions.
        self.priority += 1
        self.labels[node].append((None, "define", self.priority))

    visit_FunctionExpr = visit_ClassExpr


class TryBodyAndHandlerVisitor(ScopedAstLabellingVisitor):
    '''Visitor to gather all AST nodes under visited node
    including, but not under `ExceptStmt`s.'''

    def generic_visit(self, node):
        if isinstance(node, ast.AstBase):
            self.labels.add(node)
            for _, _, value in iter_fields(node):
                self.visit(value)

    def visit_ExceptStmt(self, node):
        #Do not visit node below this.
        self.labels.add(node)
        return


class ConstantAssignmentVisitor(ScopedAstLabellingVisitor):
    '''Visitor to label assignments where RHS is a constant'''

    def visit_Assign(self, asgn):
        if not self.is_const(asgn.value):
            return
        for target in asgn.targets:
            if hasattr(target, "variable"):
                self.labels[target.variable] = asgn.value

def label_ast(ast_root):
    '''Visits the AST, returning the labels'''
    labels = defaultdict(list)
    labeller = AstLabeller(labels)
    labeller.generic_visit(ast_root)
    return labels

def _is_branch(node, graph: FlowGraph):
    '''Holds if `node` (in `graph`) is a branch point.'''
    if len(graph.succ[node]) == 2 or isinstance(node.node, ast.Try):
        return True
    if len(graph.succ[node]) != 1:
        return False
    succ = graph.succ[node][0]
    if not isinstance(succ.node, ast.UnaryOp):
        return False
    return _is_branch(succ, graph)


def label_cfg(graph: FlowGraph, ast_labels):
    '''Copies labels from AST to CFG for branches and assignments.'''
    cfg_labels = {}
    for node, _ in graph.nodes():
        if node.node not in ast_labels:
            continue
        labels = ast_labels[node.node]
        if not labels:
            continue
        if _is_branch(node, graph) or labels[0][1] in ("assign", "define", "loop"):
            cfg_labels[node] = labels
    return cfg_labels

def usefully_comparable_types(o1, o2):
    '''Holds if a test against object o1 can provide any
    meaningful information w.r.t. to a test against o2.
    '''
    if o1 is None or o2 is None:
        return True
    return type(o1) is type(o2)

def exits_from_subtree(head, subtree, graph: FlowGraph):
    '''Returns all nodes in `subtree`, that exit
       the subtree and are reachable from `head`
    '''
    exits = set()
    seen = set()
    todo = set([head])
    while todo:
        node = todo.pop()
        if node in seen:
            continue
        seen.add(node)
        if not graph.succ[node]:
            continue
        is_exit = True
        for succ in graph.succ[node]:
            if succ.node in subtree:
                todo.add(succ)
                is_exit = False
        if is_exit:
            exits.add(node)
    return exits

def get_split_heads(head, graph: FlowGraph):
    '''Compute the split tails for the node `head`
        That is, the set of nodes from which splitting should commence.
    '''
    if isinstance(head.node, ast.Try):
        try_body = set()
        TryBodyAndHandlerVisitor(try_body).visit(head.node)
        if head.node.handlers:
            try_body.add(head.node.handlers[0])
        try_split_tails = exits_from_subtree(head, try_body, graph)
        return try_split_tails
    else:
        return graph.succ[head]


def choose_split_points(graph: FlowGraph, cfg_labels):
    '''Select the set of nodes to be the split heads for the graph,
    from the given labels. A maximum of two points are chosen to avoid
    excessive blow up.
    '''
    candidates = []
    #Find pairs -- N1, N2 where N1 and N2 are tests on the same variable and the tests are similar.
    labels = []
    for node, label_list in cfg_labels.items():
        for label in label_list:
            labels.append((node, label[0], label[1], label[2]))
    labels.sort(key=itemgetter(3))
    for first_node, first_var, first_type, first_priority in labels:
        if first_type in ("assign", "define"):
            continue
        #Avoid splitting if any class or function is defined later in scope.
        if 'define' in [type for (_, _, type, priority) in labels if priority > first_priority]:
            break
        for second_node, second_var, second_type, second_priority in labels:
            if second_var != first_var:
                continue
            # First node must dominate second node to be a viable splitting candidate.
            # Quick check to avoid doing pointless dominance checks.
            if first_priority >= second_priority:
                continue
            #Avoid splitting if variable is reassigned
            if second_type == "assign":
                break
            if not graph.strictly_dominates(first_node, second_node):
                continue
            if not usefully_comparable_types(first_type, second_type):
                continue
            split_heads = get_split_heads(first_node, graph)
            if len(split_heads) != 2:
                continue
            # Unless both of the split heads reach the second node,
            # then there is no benefit to splitting.
            for head in split_heads:
                if not graph.strictly_dominates(first_node, head):
                    break
                if not graph.reaches_while_dominated(head, second_node, first_node):
                    break
            else:
                candidates.append((first_node, split_heads, first_var, first_priority))
    #Candidates is a list of (node, split-heads, variable, priority) tuples.
    #Remove any duplicate nodes
    candidates = deduplicate(candidates, 0, 3)
    #Remove repeated splits on the same variable if more than MAX_SPLITS split and more than one variable.
    if len(candidates) > MAX_SPLITS and len({c[2] for c in candidates}) > 1:
        candidates = deduplicate(candidates, 2, 3)
    # Return best two results, but must return in reverse priority order,
    # so that splitting on one node does not remove a later one.
    return [c[:2] for c in candidates[MAX_SPLITS-1::-1]]

def deduplicate(lst, col, sort_col):
    '''De-duplicate list `lst` of tuples removing all but the first tuple containing
    duplicates of `col`. Sort the result on `sort_col'''
    dedupped = {}
    for t in reversed(lst):
        dedupped[t[col]] = t
    return sorted(dedupped.values(), key=itemgetter(sort_col))
