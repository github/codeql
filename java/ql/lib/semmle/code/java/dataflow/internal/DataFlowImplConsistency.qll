/**
 * Provides consistency queries for checking invariants in the language-specific
 * data-flow classes and predicates.
 */

private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Public
private import tainttracking1.TaintTrackingParameter::Private
private import tainttracking1.TaintTrackingParameter::Public

module Consistency {
  private newtype TConsistencyConfiguration = MkConsistencyConfiguration()

  /** A class for configuring the consistency queries. */
  class ConsistencyConfiguration extends TConsistencyConfiguration {
    string toString() { none() }

    /** Holds if `n` should be excluded from the consistency test `uniqueEnclosingCallable`. */
    predicate uniqueEnclosingCallableExclude(Node n) { none() }

    /** Holds if `n` should be excluded from the consistency test `uniqueNodeLocation`. */
    predicate uniqueNodeLocationExclude(Node n) { none() }

    /** Holds if `n` should be excluded from the consistency test `missingLocation`. */
    predicate missingLocationExclude(Node n) { none() }

    /** Holds if `n` should be excluded from the consistency test `postWithInFlow`. */
    predicate postWithInFlowExclude(Node n) { none() }

    /** Holds if `n` should be excluded from the consistency test `argHasPostUpdate`. */
    predicate argHasPostUpdateExclude(ArgumentNode n) { none() }

    /** Holds if `n` should be excluded from the consistency test `reverseRead`. */
    predicate reverseReadExclude(Node n) { none() }
  }

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
      c = count(nodeGetEnclosingCallable(n)) and
      c != 1 and
      not any(ConsistencyConfiguration conf).uniqueEnclosingCallableExclude(n) and
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
      not any(ConsistencyConfiguration conf).uniqueNodeLocationExclude(n) and
      msg = "Node should have one location but has " + c + "."
    )
  }

  query predicate missingLocation(string msg) {
    exists(int c |
      c =
        strictcount(Node n |
          not exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
            n.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
          ) and
          not any(ConsistencyConfiguration conf).missingLocationExclude(n)
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
    exists(DataFlowCallable c | isParameterNode(p, c, _) and c != nodeGetEnclosingCallable(p)) and
    msg = "Callable mismatch for parameter."
  }

  query predicate localFlowIsLocal(Node n1, Node n2, string msg) {
    simpleLocalFlowStep(n1, n2) and
    nodeGetEnclosingCallable(n1) != nodeGetEnclosingCallable(n2) and
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
      c = nodeGetEnclosingCallable(n) and
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
    nodeGetEnclosingCallable(n) != call.getEnclosingCallable()
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
    nodeGetEnclosingCallable(n) != nodeGetEnclosingCallable(n.getPreUpdateNode()) and
    msg = "PostUpdateNode does not share callable with its pre-update node."
  }

  private predicate hasPost(Node n) { exists(PostUpdateNode post | post.getPreUpdateNode() = n) }

  query predicate reverseRead(Node n, string msg) {
    exists(Node n2 | readStep(n, _, n2) and hasPost(n2) and not hasPost(n)) and
    not any(ConsistencyConfiguration conf).reverseReadExclude(n) and
    msg = "Origin of readStep is missing a PostUpdateNode."
  }

  query predicate argHasPostUpdate(ArgumentNode n, string msg) {
    not hasPost(n) and
    not any(ConsistencyConfiguration c).argHasPostUpdateExclude(n) and
    msg = "ArgumentNode is missing PostUpdateNode."
  }

  // This predicate helps the compiler forget that in some languages
  // it is impossible for a `PostUpdateNode` to be the target of
  // `simpleLocalFlowStep`.
  private predicate isPostUpdateNode(Node n) { n instanceof PostUpdateNode or none() }

  query predicate postWithInFlow(Node n, string msg) {
    isPostUpdateNode(n) and
    not clearsContent(n, _) and
    simpleLocalFlowStep(_, n) and
    not any(ConsistencyConfiguration c).postWithInFlowExclude(n) and
    msg = "PostUpdateNode should not be the target of local flow."
  }
}
