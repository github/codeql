private signature module MySig {
  predicate foo();
}

private module MyImpl implements MySig {
  predicate foo() { none() }
}

private module MkThing<MySig Impl> {
  signature module SubMod {
    predicate bar();
  }
}

module SimpleMod { }

import SimpleMod

private module SecondImpl implements MkThing<MyImpl>::SubMod {
  predicate bar() { none() }
}

class Node extends int {
  Node() { this = [0 .. 10] }
}

predicate sccEdge(Node a, Node b) { a = b % 2 }

private module Scc = QlBuiltins::EquivalenceRelation<Node, sccEdge/2>;

private class TypeFlowScc = Scc::EquivalenceClass;

/** Holds if `n` is part of an SCC of size 2 or more represented by `scc`. */
predicate sccRepr(Node n, TypeFlowScc scc) { scc = Scc::getEquivalenceClass(n) }

predicate sccJoinStep(Node n, TypeFlowScc scc) { none() }
