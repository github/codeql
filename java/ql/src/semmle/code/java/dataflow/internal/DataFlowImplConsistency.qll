/**
 * Provides consistency queries for checking invariants in the language-specific
 * data-flow classes and predicates.
 */

private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Public
private import TaintTrackingUtil

module Consistency {
  private predicate relevantNode(Node n) {
    n instanceof ArgumentNode or
    n instanceof ParameterNode or
    n instanceof ReturnNode or
    n = getAnOutNode(_, _) or
    simpleLocalFlowStep(n, _) or
    simpleLocalFlowStep(_, n) or
    jumpStep(n, _) or
    jumpStep(_, n) or
    storeStep(n, _, _) or
    storeStep(_, _, n) or
    readStep(n, _, _) or
    readStep(_, _, n) or
    defaultAdditionalTaintStep(n, _) or
    defaultAdditionalTaintStep(_, n)
  }

  query predicate uniqueEnclosingCallable(Node n, string msg) {
    exists(int c |
      relevantNode(n) and
      c = count(n.getEnclosingCallable()) and
      c != 1 and
      if c > 1
      then msg = "Node does not have unique enclosing callable."
      else msg = "Node is missing an enclosing callable."
    )
  }

  query predicate uniqueTypeBound(Node n, string msg) {
    exists(int c |
      relevantNode(n) and
      c = count(n.getTypeBound()) and
      c != 1 and
      if c > 1
      then msg = "Node does not have unique type bound."
      else msg = "Node is missing a type bound."
    )
  }

  query predicate uniqueTypeRepr(Node n, string msg) {
    exists(int c |
      relevantNode(n) and
      c = count(getErasedRepr(n.getTypeBound())) and
      c != 1 and
      if c > 1
      then msg = "Node does not have unique type representation."
      else msg = "Node is missing a type representation."
    )
  }

  query predicate parameterCallable(ParameterNode p, string msg) {
    exists(DataFlowCallable c | p.isParameterOf(c, _) and c != p.getEnclosingCallable()) and
    msg = "Callable mismatch for parameter."
  }

  query predicate localFlowIsLocal(Node n1, Node n2, string msg) {
    simpleLocalFlowStep(n1, n2) and
    n1.getEnclosingCallable() != n2.getEnclosingCallable() and
    msg = "Local flow step does not preserve enclosing callable."
  }

  private DataFlowType typeRepr() { result = getErasedRepr(any(Node n).getTypeBound()) }

  query predicate compatibleTypesReflexive(DataFlowType t, string msg) {
    t = typeRepr() and
    not compatibleTypes(t, t) and
    msg = "Type compatibility predicate is not reflexive."
  }

  query predicate unreachableNodeCCtx(Node n, DataFlowCall call, string msg) {
    isUnreachableInCall(n, call) and
    exists(DataFlowCallable c |
      c = n.getEnclosingCallable() and
      not viableCallable(call) = c
    ) and
    msg = "Call context for isUnreachableInCall is inconsistent with call graph."
  }

  query predicate localCallNodes(DataFlowCall call, Node n, string msg) {
    (
      n = getAnOutNode(call, _) and
      msg = "OutNode and call does not share enclosing callable."
      or
      n.(ArgumentNode).argumentOf(call, _) and
      msg = "ArgumentNode and call does not share enclosing callable."
    ) and
    n.getEnclosingCallable() != call.getEnclosingCallable()
  }

  query predicate postIsNotPre(PostUpdateNode n, string msg) {
    n.getPreUpdateNode() = n and msg = "PostUpdateNode should not equal its pre-update node."
  }

  query predicate postIsInSameCallable(PostUpdateNode n, string msg) {
    n.getEnclosingCallable() != n.getPreUpdateNode().getEnclosingCallable() and
    msg = "PostUpdateNode does not share callable with its pre-update node."
  }

  private predicate hasPost(Node n) { exists(PostUpdateNode post | post.getPreUpdateNode() = n) }

  query predicate reverseRead(Node n, string msg) {
    exists(Node n2 | readStep(n, _, n2) and hasPost(n2) and not hasPost(n)) and
    msg = "Origin of readStep is missing a PostUpdateNode."
  }

  query predicate storeIsPostUpdate(Node n, string msg) {
    storeStep(_, _, n) and
    not n instanceof PostUpdateNode and
    msg = "Store targets should be PostUpdateNodes."
  }

  query predicate argHasPostUpdate(ArgumentNode n, string msg) {
    not hasPost(n) and
    not isImmutableOrUnobservable(n) and
    msg = "ArgumentNode is missing PostUpdateNode."
  }
}
