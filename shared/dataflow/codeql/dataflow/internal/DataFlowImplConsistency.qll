/**
 * Provides consistency queries for checking invariants in the language-specific
 * data-flow classes and predicates.
 */

private import codeql.dataflow.DataFlow as DF
private import codeql.dataflow.TaintTracking as TT

signature module InputSig<DF::InputSig DataFlowLang> {
  /** Holds if `n` should be excluded from the consistency test `uniqueEnclosingCallable`. */
  default predicate uniqueEnclosingCallableExclude(DataFlowLang::Node n) { none() }

  /** Holds if `call` should be excluded from the consistency test `uniqueCallEnclosingCallable`. */
  default predicate uniqueCallEnclosingCallableExclude(DataFlowLang::DataFlowCall call) { none() }

  /** Holds if `n` should be excluded from the consistency test `uniqueNodeLocation`. */
  default predicate uniqueNodeLocationExclude(DataFlowLang::Node n) { none() }

  /** Holds if `n` should be excluded from the consistency test `missingLocation`. */
  default predicate missingLocationExclude(DataFlowLang::Node n) { none() }

  /** Holds if `n` should be excluded from the consistency test `postWithInFlow`. */
  default predicate postWithInFlowExclude(DataFlowLang::Node n) { none() }

  /** Holds if `n` should be excluded from the consistency test `argHasPostUpdate`. */
  default predicate argHasPostUpdateExclude(DataFlowLang::ArgumentNode n) { none() }

  /** Holds if `n` should be excluded from the consistency test `reverseRead`. */
  default predicate reverseReadExclude(DataFlowLang::Node n) { none() }

  /** Holds if `n` should be excluded from the consistency test `postHasUniquePre`. */
  default predicate postHasUniquePreExclude(DataFlowLang::PostUpdateNode n) { none() }

  /** Holds if `n` should be excluded from the consistency test `uniquePostUpdate`. */
  default predicate uniquePostUpdateExclude(DataFlowLang::Node n) { none() }

  /** Holds if `(call, ctx)` should be excluded from the consistency test `viableImplInCallContextTooLargeExclude`. */
  default predicate viableImplInCallContextTooLargeExclude(
    DataFlowLang::DataFlowCall call, DataFlowLang::DataFlowCall ctx,
    DataFlowLang::DataFlowCallable callable
  ) {
    none()
  }

  /** Holds if `(c, pos, p)` should be excluded from the consistency test `uniqueParameterNodeAtPosition`. */
  default predicate uniqueParameterNodeAtPositionExclude(
    DataFlowLang::DataFlowCallable c, DataFlowLang::ParameterPosition pos, DataFlowLang::Node p
  ) {
    none()
  }

  /** Holds if `(c, pos, p)` should be excluded from the consistency test `uniqueParameterNodePosition`. */
  default predicate uniqueParameterNodePositionExclude(
    DataFlowLang::DataFlowCallable c, DataFlowLang::ParameterPosition pos, DataFlowLang::Node p
  ) {
    none()
  }

  /** Holds if `n` should be excluded from the consistency test `identityLocalStep`. */
  default predicate identityLocalStepExclude(DataFlowLang::Node n) { none() }

  /** Holds if `arg` should be excluded from the consistency test `missingArgumentCall`. */
  default predicate missingArgumentCallExclude(DataFlowLang::ArgumentNode arg) { none() }

  /** Holds if `(arg, call)` should be excluded from the consistency test `multipleArgumentCall`. */
  default predicate multipleArgumentCallExclude(
    DataFlowLang::ArgumentNode arg, DataFlowLang::DataFlowCall call
  ) {
    none()
  }
}

module MakeConsistency<
  DF::InputSig DataFlowLang, TT::InputSig<DataFlowLang> TaintTrackingLang,
  InputSig<DataFlowLang> Input>
{
  private import DataFlowLang
  private import TaintTrackingLang

  final private class NodeFinal = Node;

  private class RelevantNode extends NodeFinal {
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
      not Input::uniqueEnclosingCallableExclude(n) and
      msg = "Node should have one enclosing callable but has " + c + "."
    )
  }

  query predicate uniqueCallEnclosingCallable(DataFlowCall call, string msg) {
    exists(int c |
      c = count(call.getEnclosingCallable()) and
      c != 1 and
      not Input::uniqueCallEnclosingCallableExclude(call) and
      msg = "Call should have one enclosing callable but has " + c + "."
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
      not Input::uniqueNodeLocationExclude(n) and
      msg = "Node should have one location but has " + c + "."
    )
  }

  query predicate missingLocation(string msg) {
    exists(int c |
      c =
        strictcount(Node n |
          not n.hasLocationInfo(_, _, _, _, _) and
          not Input::missingLocationExclude(n)
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

  query predicate parameterCallable(ParameterNode p, string msg) {
    exists(DataFlowCallable c | isParameterNode(p, c, _) and c != nodeGetEnclosingCallable(p)) and
    msg = "Callable mismatch for parameter."
  }

  query predicate localFlowIsLocal(Node n1, Node n2, string msg) {
    simpleLocalFlowStep(n1, n2) and
    nodeGetEnclosingCallable(n1) != nodeGetEnclosingCallable(n2) and
    msg = "Local flow step does not preserve enclosing callable."
  }

  query predicate readStepIsLocal(Node n1, Node n2, string msg) {
    readStep(n1, _, n2) and
    nodeGetEnclosingCallable(n1) != nodeGetEnclosingCallable(n2) and
    msg = "Read step does not preserve enclosing callable."
  }

  query predicate storeStepIsLocal(Node n1, Node n2, string msg) {
    storeStep(n1, _, n2) and
    nodeGetEnclosingCallable(n1) != nodeGetEnclosingCallable(n2) and
    msg = "Store step does not preserve enclosing callable."
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
      isArgumentNode(n, call, _) and
      msg = "ArgumentNode and call does not share enclosing callable."
    ) and
    nodeGetEnclosingCallable(n) != call.getEnclosingCallable()
  }

  query predicate postIsNotPre(PostUpdateNode n, string msg) {
    n = n.getPreUpdateNode() and
    msg = "PostUpdateNode should not equal its pre-update node."
  }

  query predicate postHasUniquePre(PostUpdateNode n, string msg) {
    not Input::postHasUniquePreExclude(n) and
    exists(int c |
      c = count(n.getPreUpdateNode()) and
      c != 1 and
      msg = "PostUpdateNode should have one pre-update node but has " + c + "."
    )
  }

  query predicate uniquePostUpdate(Node n, string msg) {
    not Input::uniquePostUpdateExclude(n) and
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
    not Input::reverseReadExclude(n) and
    msg = "Origin of readStep is missing a PostUpdateNode."
  }

  query predicate argHasPostUpdate(ArgumentNode n, string msg) {
    not hasPost(n) and
    not Input::argHasPostUpdateExclude(n) and
    msg = "ArgumentNode is missing PostUpdateNode."
  }

  query predicate postWithInFlow(PostUpdateNode n, string msg) {
    not clearsContent(n, _) and
    simpleLocalFlowStep(_, n) and
    not Input::postWithInFlowExclude(n) and
    msg = "PostUpdateNode should not be the target of local flow."
  }

  query predicate viableImplInCallContextTooLarge(
    DataFlowCall call, DataFlowCall ctx, DataFlowCallable callable
  ) {
    callable = viableImplInCallContext(call, ctx) and
    not callable = viableCallable(call) and
    not Input::viableImplInCallContextTooLargeExclude(call, ctx, callable)
  }

  private predicate uniqueParameterNodeAtPositionInclude(
    DataFlowCallable c, ParameterPosition pos, Node p
  ) {
    not Input::uniqueParameterNodeAtPositionExclude(c, pos, p) and
    isParameterNode(p, c, pos)
  }

  query predicate uniqueParameterNodeAtPosition(
    DataFlowCallable c, ParameterPosition pos, Node p, string msg
  ) {
    uniqueParameterNodeAtPositionInclude(c, pos, p) and
    not exists(unique(Node p0 | uniqueParameterNodeAtPositionInclude(c, pos, p0))) and
    msg = "Parameters with overlapping positions."
  }

  private predicate uniqueParameterNodePositionInclude(
    DataFlowCallable c, ParameterPosition pos, Node p
  ) {
    not Input::uniqueParameterNodePositionExclude(c, pos, p) and
    isParameterNode(p, c, pos)
  }

  query predicate uniqueParameterNodePosition(
    DataFlowCallable c, ParameterPosition pos, Node p, string msg
  ) {
    uniqueParameterNodePositionInclude(c, pos, p) and
    not exists(unique(ParameterPosition pos0 | uniqueParameterNodePositionInclude(c, pos0, p))) and
    msg = "Parameter node with multiple positions."
  }

  query predicate uniqueContentApprox(Content c, string msg) {
    not exists(unique(ContentApprox approx | approx = getContentApprox(c))) and
    msg = "Non-unique content approximation."
  }

  query predicate identityLocalStep(Node n, string msg) {
    simpleLocalFlowStep(n, n) and
    not Input::identityLocalStepExclude(n) and
    msg = "Node steps to itself"
  }

  query predicate missingArgumentCall(ArgumentNode arg, string msg) {
    not Input::missingArgumentCallExclude(arg) and
    not isArgumentNode(arg, _, _) and
    msg = "Missing call for argument node."
  }

  private predicate multipleArgumentCallInclude(ArgumentNode arg, DataFlowCall call) {
    isArgumentNode(arg, call, _) and
    not Input::multipleArgumentCallExclude(arg, call)
  }

  query predicate multipleArgumentCall(ArgumentNode arg, DataFlowCall call, string msg) {
    multipleArgumentCallInclude(arg, call) and
    strictcount(DataFlowCall call0 | multipleArgumentCallInclude(arg, call0)) > 1 and
    msg = "Multiple calls for argument node."
  }
}
