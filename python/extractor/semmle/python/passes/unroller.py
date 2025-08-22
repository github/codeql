'''
Unroll loops in the flow-graph once if we know that the iterator is not empty.
E.g.

if seq:
    for x in seq:
        y = x
    y  # y is defined here

or
if not seq:
    raise
for x in seq:
    y = x
y  # y is defined here

This is broadly analagous to splitting.
If the edge leaving the test that signifies a non-empty container dominates the loop, then we want to unroll the loop once.

Loop unrolling  will transform
A (loop header), B (loop body)  -->  A(first loop header), B(first loop body), C(second loop header), D(second loop body)
and is done as follows:

Make a copy of A as C and make a copy of B as D.
Convert all edges from B to A into edges from B to C.
Convert edge from C to B to an edge from C to D.
Convert all edges from D to A into edges from D to C.

Subsequent pruning will then remove any dead edges for iterables known to be empty or non-empty.
'''
from collections import defaultdict, namedtuple
from operator import itemgetter

from semmle.python import ast
from semmle.python.passes.splitter import ScopedAstLabellingVisitor, label_cfg
from semmle.util import EXHAUSTED_EDGE

class HasDefinitionInLoop(ScopedAstLabellingVisitor):
    '''Check to see if a class or function definition occurs
    in a loop. Note that this will prevent unrolling of a loop
    if a definition occurs in any loop in scope, not just the one
    to be unrolled.
    '''

    def __init__(self):
        ScopedAstLabellingVisitor.__init__(self, None)
        self.has_definition = False
        self.in_loopbody = False

    def visit_For(self, loop):
        self.visit(loop.iter)
        self.in_loopbody = True
        self.visit(loop.body)
        self.in_loopbody = False

    def visit_ClassExpr(self, node):
        # Don't split over class definitions,
        # as the presence of multiple ClassObjects for a
        # single class can be confusing.
        # The same applies to function definitions.
        if self.in_loopbody:
            self.has_definition = True

    visit_FunctionExpr = visit_ClassExpr

    def __bool__(self):
        return self.has_definition

AstLabel = namedtuple("AstLabel", "variable type priority")
CfgLabel = namedtuple("CfgLabel", "node variable type priority")

class Labeller(ScopedAstLabellingVisitor):

    def __init__(self, *args):
        ScopedAstLabellingVisitor.__init__(self, *args)
        self.in_test = 0
        self.in_loop = False

    def visit_If(self, ifstmt):
        # Looking for tests for empty sequences.
        self.in_test += 1
        self.visit(ifstmt.test)
        self.in_test -= 1
        self.visit(ifstmt.body)
        self.visit(ifstmt.orelse)

    def visit_UnaryOp(self, op):
        if not self.in_test:
            return
        label = self._label_for_unary_operand(op)
        if label:
            self.labels[op].append(label)
        else:
            self.visit(op.operand)

    def _label_for_unary_operand(self, op):
        if not isinstance(op.op, ast.Not):
            return None
        if isinstance(op.operand, ast.UnaryOp):
            return self._label_for_unary_operand(op.operand)
        elif isinstance(op.operand, ast.Name):
            self.priority += 1
            return AstLabel(op.operand.variable, "test", self.priority)
        elif isinstance(op.operand, ast.Call):
            return self._label_for_call(op.operand)
        return None

    def visit_Call(self, call):
        if not self.in_test:
            return
        label = self._label_for_call(call)
        if label:
            self.labels[call].append(label)
        return

    def _label_for_call(self, call):
        #TO DO -- Check for calls to len()
        pass

    def visit_For(self, loop):
        self.in_loop = True
        self.visit(loop.iter)
        self.in_loop = False
        self.visit(loop.body)

    def visit_Name(self, name):
        self.priority += 1
        if self.in_test:
            self.labels[name].append(AstLabel(name.variable, "test", self.priority))
        elif self.in_loop:
            self.labels[name].append(AstLabel(name.variable, "loop", self.priority))

def do_unrolling(ast_root, graph):
    #Avoid unrolling if any class or function is defined in a loop.
    hasdef = HasDefinitionInLoop()
    hasdef.generic_visit(ast_root)
    if hasdef:
        return
    ast_labels = defaultdict(list)
    labeller = Labeller(ast_labels)
    labeller.generic_visit(ast_root)
    cfg_labels = label_cfg(graph, ast_labels)
    unrolls = choose_loops_to_unroll(graph, cfg_labels)
    for head, body in unrolls:
        graph.unroll(head, body)


def choose_loops_to_unroll(graph, cfg_labels):
    '''Select the set of nodes to unroll.'''
    candidates = []
    #Find pairs -- N1, N2 where N1 is a test on the variable and N2 is a loop over it.
    labels = []
    for node, label_list in cfg_labels.items():
        for label in label_list:
            labels.append(CfgLabel(node, label.variable, label.type, label.priority))
    labels.sort(key=itemgetter(3))
    for first_node, first_var, first_type, first_priority in labels:
        if first_type == "loop":
            continue
        for second_node, second_var, second_type, second_priority in labels:
            if second_var != first_var:
                continue
            # First node must dominate second node to be a viable unrolling candidate.
            # Quick check to avoid doing pointless dominance checks.
            if first_priority >= second_priority:
                continue
            #Avoid if second use is not a loop
            if second_type != "loop":
                continue
            if not graph.strictly_dominates(first_node, second_node):
                continue
            candidates.append((second_node, second_priority))
    iters = reversed([c for c, p in sorted(candidates, key=itemgetter(1))])
    result = []
    for iter in iters:
        head = graph.succ[iter][0]
        for body in graph.succ[head]:
            if graph.edge_annotations[head, body] != EXHAUSTED_EDGE:
                result.append((head, body))
                break
    return result
