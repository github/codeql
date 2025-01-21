/**
 * Provides consistency queries for checking invariants in the language-specific
 * data-flow classes and predicates.
 */

private import codeql.dataflow.DataFlow as DF
private import codeql.dataflow.TaintTracking as TT
private import codeql.util.Location

signature module InputSig<LocationSig Location, DF::InputSig<Location> DataFlowLang> {
  /** Holds if `n` should be excluded from the consistency test `uniqueEnclosingCallable`. */
  default predicate uniqueEnclosingCallableExclude(DataFlowLang::Node n) { none() }

  /** Holds if `call` should be excluded from the consistency test `uniqueCallEnclosingCallable`. */
  default predicate uniqueCallEnclosingCallableExclude(DataFlowLang::DataFlowCall call) { none() }

  /** Holds if `n` should be excluded from the consistency test `uniqueType`. */
  default predicate uniqueTypeExclude(DataFlowLang::Node n) { none() }

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
  LocationSig Location, DF::InputSig<Location> DataFlowLang,
  TT::InputSig<Location, DataFlowLang> TaintTrackingLang, InputSig<Location, DataFlowLang> Input>
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
      simpleLocalFlowStep(this, _, _) or
      simpleLocalFlowStep(_, this, _) or
      jumpStep(this, _) or
      jumpStep(_, this) or
      storeStep(this, _, _) or
      storeStep(_, _, this) or
      readStep(this, _, _) or
      readStep(_, _, this) or
      defaultAdditionalTaintStep(this, _, _) or
      defaultAdditionalTaintStep(_, this, _)
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
      not Input::uniqueTypeExclude(n) and
      msg = "Node should have one type but has " + c + "."
    )
  }

  query predicate uniqueNodeLocation(Node n, string msg) {
    exists(int c |
      c = count(n.getLocation()) and
      c != 1 and
      not Input::uniqueNodeLocationExclude(n) and
      msg = "Node should have one location but has " + c + "."
    )
  }

  query predicate missingLocation(string msg) {
    exists(int c |
      c =
        strictcount(Node n |
          not exists(n.getLocation()) and
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
    simpleLocalFlowStep(n1, n2, _) and
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
    exists(DataFlowCallable c, NodeRegion nr |
      isUnreachableInCall(nr, call) and
      nr.contains(n) and
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
    simpleLocalFlowStep(_, n, _) and
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
    simpleLocalFlowStep(n, n, _) and
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

  query predicate lambdaCallEnclosingCallableMismatch(DataFlowCall call, Node receiver) {
    lambdaCall(call, _, receiver) and
    not nodeGetEnclosingCallable(receiver) = call.getEnclosingCallable()
  }

  query predicate speculativeStepAlreadyHasModel(Node n1, Node n2, string model) {
    speculativeTaintStep(n1, n2) and
    not defaultAdditionalTaintStep(n1, n2, _) and
    (
      simpleLocalFlowStep(n1, n2, _) and model = "SimpleLocalFlowStep"
      or
      exists(DataFlowCall call |
        exists(viableCallable(call)) and
        isArgumentNode(n1, call, _) and
        model = "dispatch"
      )
    )
  }

  /**
   * Gets counts of inconsistencies of each type.
   */
  int getInconsistencyCounts(string type) {
    // total results from all the AST consistency query predicates.
    type = "Node should have one enclosing callable" and
    result = count(Node n | uniqueEnclosingCallable(n, _))
    or
    type = "Call should have one enclosing callable" and
    result = count(DataFlowCall c | uniqueCallEnclosingCallable(c, _))
    or
    type = "Node should have one type" and
    result = count(Node n | uniqueType(n, _))
    or
    type = "Node should have one location" and
    result = count(Node n | uniqueNodeLocation(n, _))
    or
    type = "Nodes without location" and
    result = count( | missingLocation(_) | 1)
    or
    type = "Node should have one toString" and
    result = count(Node n | uniqueNodeToString(n, _))
    or
    type = "Callable mismatch for parameter" and
    result = count(ParameterNode p | parameterCallable(p, _))
    or
    type = "Local flow step does not preserve enclosing callable" and
    result = count(Node n1, Node n2 | localFlowIsLocal(n1, n2, _))
    or
    type = "Read step does not preserve enclosing callable" and
    result = count(Node n1, Node n2 | readStepIsLocal(n1, n2, _))
    or
    type = "Store step does not preserve enclosing callable" and
    result = count(Node n1, Node n2 | storeStepIsLocal(n1, n2, _))
    or
    type = "Type compatibility predicate is not reflexive" and
    result = count(DataFlowType t | compatibleTypesReflexive(t, _))
    or
    type = "Call context for isUnreachableInCall is inconsistent with call graph" and
    result = count(Node n, DataFlowCall call | unreachableNodeCCtx(n, call, _))
    or
    type = "Node and call does not share enclosing callable" and
    result = count(DataFlowCall call, Node n | localCallNodes(call, n, _))
    or
    type = "PostUpdateNode should not equal its pre-update node" and
    result = count(PostUpdateNode n | postIsNotPre(n, _))
    or
    type = "PostUpdateNode should have one pre-update node" and
    result = count(PostUpdateNode n | postHasUniquePre(n, _))
    or
    type = "Node has multiple PostUpdateNodes" and
    result = count(Node n | uniquePostUpdate(n, _))
    or
    type = "PostUpdateNode does not share callable with its pre-update node" and
    result = count(PostUpdateNode n | postIsInSameCallable(n, _))
    or
    type = "Origin of readStep is missing a PostUpdateNode" and
    result = count(Node n | reverseRead(n, _))
    or
    type = "ArgumentNode is missing PostUpdateNode" and
    result = count(ArgumentNode n | argHasPostUpdate(n, _))
    or
    type = "PostUpdateNode should not be the target of local flow" and
    result = count(PostUpdateNode n | postWithInFlow(n, _))
    or
    type = "Call context too large" and
    result =
      count(DataFlowCall call, DataFlowCall ctx, DataFlowCallable callable |
        viableImplInCallContextTooLarge(call, ctx, callable)
      )
    or
    type = "Parameters with overlapping positions" and
    result =
      count(DataFlowCallable c, ParameterPosition pos, Node p |
        uniqueParameterNodeAtPosition(c, pos, p, _)
      )
    or
    type = "Parameter node with multiple positions" and
    result =
      count(DataFlowCallable c, ParameterPosition pos, Node p |
        uniqueParameterNodePosition(c, pos, p, _)
      )
    or
    type = "Non-unique content approximation" and
    result = count(Content c | uniqueContentApprox(c, _))
    or
    type = "Node steps to itself" and
    result = count(Node n | identityLocalStep(n, _))
    or
    type = "Missing call for argument node" and
    result = count(ArgumentNode n | missingArgumentCall(n, _))
    or
    type = "Multiple calls for argument node" and
    result = count(ArgumentNode arg, DataFlowCall call | multipleArgumentCall(arg, call, _))
    or
    type = "Lambda call enclosing callable mismatch" and
    result =
      count(DataFlowCall call, Node receiver | lambdaCallEnclosingCallableMismatch(call, receiver))
    or
    type = "Speculative step already hasM Model" and
    result = count(Node n1, Node n2 | speculativeStepAlreadyHasModel(n1, n2, _))
  }
}
