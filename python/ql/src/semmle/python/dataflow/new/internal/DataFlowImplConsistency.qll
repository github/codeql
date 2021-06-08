/**
 * Provides consistency queries for checking invariants in the language-specific
 * data-flow classes and predicates.
 */

private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Public
private import tainttracking1.TaintTrackingParameter::Private
private import tainttracking1.TaintTrackingParameter::Public

module Consistency {
  private class RelevantNode extends Node {
    RelevantNode() {
      this instanceof ArgumentNode or
      this instanceof ParameterNode or
      this instanceof ReturnNode or
      this = getAnOutNode(_, _) or
      simpleLocalFlowStep(this, _) or
      simpleLocalFlowStep(_, this) or
      jumpStep(this, _) or
      jumpStep(_, this) or
      storeStep(this, _, _) or
      storeStep(_, _, this) or
      readStep(this, _, _) or
      readStep(_, _, this) or
      defaultAdditionalTaintStep(this, _) or
      defaultAdditionalTaintStep(_, this)
    }
  }

  query predicate uniqueEnclosingCallable(Node n, string msg) {
    exists(int c |
      n instanceof RelevantNode and
      c = count(n.getEnclosingCallable()) and
      c != 1 and
      msg = "Node should have one enclosing callable but has " + c + "."
    )
  }

  query predicate uniqueType(Node n, string msg) {
    exists(int c |
      n instanceof RelevantNode and
      c = count(getNodeType(n)) and
      c != 1 and
      msg = "Node should have one type but has " + c + "."
    )
  }

  query predicate uniqueNodeLocation(Node n, string msg) {
    exists(int c |
      c =
        count(string filepath, int startline, int startcolumn, int endline, int endcolumn |
          n.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
        ) and
      c != 1 and
      msg = "Node should have one location but has " + c + "."
    )
  }

  query predicate missingLocation(string msg) {
    exists(int c |
      c =
        strictcount(Node n |
          not exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
            n.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
          )
        ) and
      msg = "Nodes without location: " + c
    )
  }

  query predicate uniqueNodeToString(Node n, string msg) {
    exists(int c |
      c = count(n.toString()) and
      c != 1 and
      msg = "Node should have one toString but has " + c + "."
    )
  }

  query predicate missingToString(string msg) {
    exists(int c |
      c = strictcount(Node n | not exists(n.toString())) and
      msg = "Nodes without toString: " + c
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

  private DataFlowType typeRepr() { result = getNodeType(_) }

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

  // This predicate helps the compiler forget that in some languages
  // it is impossible for a result of `getPreUpdateNode` to be an
  // instance of `PostUpdateNode`.
  private Node getPre(PostUpdateNode n) {
    result = n.getPreUpdateNode()
    or
    none()
  }

  query predicate postIsNotPre(PostUpdateNode n, string msg) {
    getPre(n) = n and
    msg = "PostUpdateNode should not equal its pre-update node."
  }

  query predicate postHasUniquePre(PostUpdateNode n, string msg) {
    exists(int c |
      c = count(n.getPreUpdateNode()) and
      c != 1 and
      msg = "PostUpdateNode should have one pre-update node but has " + c + "."
    )
  }

  query predicate uniquePostUpdate(Node n, string msg) {
    1 < strictcount(PostUpdateNode post | post.getPreUpdateNode() = n) and
    msg = "Node has multiple PostUpdateNodes."
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

  query predicate argHasPostUpdate(ArgumentNode n, string msg) {
    not hasPost(n) and
    not isImmutableOrUnobservable(n) and
    msg = "ArgumentNode is missing PostUpdateNode."
  }

  query predicate postWithInFlow(PostUpdateNode n, string msg) {
    simpleLocalFlowStep(_, n) and
    msg = "PostUpdateNode should not be the target of local flow."
  }
}
