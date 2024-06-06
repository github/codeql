/**
 * Provides Go-specific definitions for use in the taint-tracking library.
 */

private import go
private import FlowSummaryImpl as FlowSummaryImpl
private import codeql.util.Unit
private import DataFlowPrivate as DataFlowPrivate

/**
 * Holds if taint can flow from `src` to `sink` in zero or more
 * local (intra-procedural) steps.
 */
pragma[inline]
predicate localTaint(DataFlow::Node src, DataFlow::Node sink) { localTaintStep*(src, sink) }

/**
 * Holds if taint can flow from `src` to `sink` in zero or more
 * local (intra-procedural) steps.
 */
pragma[inline]
predicate localExprTaint(Expr src, Expr sink) {
  localTaint(DataFlow::exprNode(src), DataFlow::exprNode(sink))
}

/**
 * Holds if taint can flow in one local step from `src` to `sink`.
 */
predicate localTaintStep(DataFlow::Node src, DataFlow::Node sink) {
  DataFlow::localFlowStep(src, sink) or
  localAdditionalTaintStep(src, sink, _) or
  // Simple flow through library code is included in the exposed local
  // step relation, even though flow is technically inter-procedural
  FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(src, sink, _)
}

private Type getElementType(Type containerType) {
  result = containerType.(ArrayType).getElementType() or
  result = containerType.(SliceType).getElementType() or
  result = containerType.(ChanType).getElementType() or
  result = containerType.(MapType).getValueType() or
  result = containerType.(PointerType).getPointerType()
}

/**
 * Holds if default `TaintTracking::Configuration`s should allow implicit reads
 * of `c` at sinks and inputs to additional taint steps.
 */
bindingset[node]
predicate defaultImplicitTaintRead(DataFlow::Node node, DataFlow::ContentSet c) {
  exists(Type containerType |
    node instanceof DataFlow::ArgumentNode and
    getElementType*(node.getType()) = containerType
  |
    containerType instanceof ArrayType and
    c instanceof DataFlow::ArrayContent
    or
    containerType instanceof SliceType and
    c instanceof DataFlow::ArrayContent
    or
    containerType instanceof ChanType and
    c instanceof DataFlow::CollectionContent
    or
    containerType instanceof MapType and
    c instanceof DataFlow::MapValueContent
    or
    c.(DataFlow::PointerContent).getPointerType() = containerType
  )
}

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to all
 * taint configurations.
 */
class AdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for all configurations.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/**
 * Holds if the additional step from `pred` to `succ` should be included in all
 * global taint flow configurations.
 */
predicate localAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ, string model) {
  (
    referenceStep(pred, succ) or
    elementWriteStep(pred, succ) or
    fieldReadStep(pred, succ) or
    elementStep(pred, succ) or
    tupleStep(pred, succ) or
    stringConcatStep(pred, succ) or
    sliceStep(pred, succ)
  ) and
  model = ""
  or
  any(FunctionModel fm).taintStep(pred, succ) and model = "FunctionModel"
  or
  any(AdditionalTaintStep a).step(pred, succ) and model = "AdditionalTaintStep"
  or
  FlowSummaryImpl::Private::Steps::summaryLocalStep(pred.(DataFlowPrivate::FlowSummaryNode)
        .getSummaryNode(), succ.(DataFlowPrivate::FlowSummaryNode).getSummaryNode(), false, model)
}

/**
 * Holds if taint flows from `pred` to `succ` via a reference or dereference.
 *
 * The taint-tracking library does not distinguish between a reference and its referent,
 * treating one as tainted if the other is.
 */
predicate referenceStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(DataFlow::AddressOperationNode addr |
    // from `x` to `&x`
    pred = addr.getOperand() and
    succ = addr
    or
    // from `&x` to `x`
    pred = addr and
    succ.(DataFlow::PostUpdateNode).getPreUpdateNode() = addr.getOperand()
  )
  or
  exists(DataFlow::PointerDereferenceNode deref |
    // from `x` to `*x`
    pred = deref.getOperand() and
    succ = deref
    or
    // from `*x` to `x`
    pred = deref and
    succ.(DataFlow::PostUpdateNode).getPreUpdateNode() = deref.getOperand()
  )
}

/**
 * Holds if there is an assignment of the form `succ[idx] = pred`, meaning that `pred` may taint
 * `succ`.
 */
predicate elementWriteStep(DataFlow::Node pred, DataFlow::Node succ) {
  any(DataFlow::Write w).writesElement(succ.(DataFlow::PostUpdateNode).getPreUpdateNode(), _, pred)
  or
  FlowSummaryImpl::Private::Steps::summaryStoreStep(pred.(DataFlowPrivate::FlowSummaryNode)
        .getSummaryNode(), any(DataFlow::Content c | c instanceof DataFlow::ArrayContent),
    succ.(DataFlowPrivate::FlowSummaryNode).getSummaryNode())
}

/** Holds if taint flows from `pred` to `succ` via a field read. */
predicate fieldReadStep(DataFlow::Node pred, DataFlow::Node succ) {
  succ.(DataFlow::FieldReadNode).getBase() = pred
}

/**
 * Holds if taint flows from `pred` to `succ` via an array, map, slice, or string
 * index operation.
 */
predicate elementStep(DataFlow::Node pred, DataFlow::Node succ) {
  succ.(DataFlow::ElementReadNode).getBase() = pred
  or
  exists(IR::GetNextEntryInstruction nextEntry |
    pred.asInstruction() = nextEntry.getDomain() and
    // only step into the value, not the index
    succ.asInstruction() = IR::extractTupleElement(nextEntry, 1)
  )
}

/** Holds if taint flows from `pred` to `succ` via an extract tuple operation. */
predicate tupleStep(DataFlow::Node pred, DataFlow::Node succ) {
  succ = DataFlow::extractTupleElement(pred, _)
}

/** Holds if taint flows from `pred` to `succ` via string concatenation. */
predicate stringConcatStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(DataFlow::BinaryOperationNode conc |
    conc.getOperator() = "+" and conc.getType() instanceof StringType
  |
    succ = conc and conc.getAnOperand() = pred
  )
}

/** Holds if taint flows from `pred` to `succ` via a slice operation. */
predicate sliceStep(DataFlow::Node pred, DataFlow::Node succ) {
  succ.(DataFlow::SliceNode).getBase() = pred
}

/**
 * A model of a function specifying that the function propagates taint from
 * a parameter or qualifier to a result.
 */
abstract class FunctionModel extends Function {
  /** Holds if taint propagates through this function from `input` to `output`. */
  abstract predicate hasTaintFlow(FunctionInput input, FunctionOutput output);

  /** Gets an input node for this model for the call `c`. */
  DataFlow::Node getAnInputNode(DataFlow::CallNode c) { this.taintStepForCall(result, _, c) }

  /** Gets an output node for this model for the call `c`. */
  DataFlow::Node getAnOutputNode(DataFlow::CallNode c) { this.taintStepForCall(_, result, c) }

  /** Holds if this function model causes taint to flow from `pred` to `succ` for the call `c`. */
  predicate taintStepForCall(DataFlow::Node pred, DataFlow::Node succ, DataFlow::CallNode c) {
    c = this.getACall() and
    exists(FunctionInput inp, FunctionOutput outp | this.hasTaintFlow(inp, outp) |
      pred = inp.getNode(c) and
      succ = outp.getNode(c)
    )
  }

  /** Holds if this function model causes taint to flow from `pred` to `succ`. */
  predicate taintStep(DataFlow::Node pred, DataFlow::Node succ) {
    this.taintStepForCall(pred, succ, _)
  }
}

/**
 * Holds if the additional step from `node1` to `node2` should be included in all
 * global taint flow configurations.
 */
predicate defaultAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2, string model) {
  localAdditionalTaintStep(node1, node2, model)
}

/**
 * A sanitizer in all global taint flow configurations but not in local taint.
 */
abstract class DefaultTaintSanitizer extends DataFlow::Node { }

/**
 * Holds if `node` should be a sanitizer in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintSanitizer(DataFlow::Node node) { node instanceof DefaultTaintSanitizer }

private predicate equalityTestGuard(DataFlow::Node g, Expr e, boolean outcome) {
  exists(DataFlow::EqualityTestNode eq, DataFlow::Node nonConstNode |
    eq = g and
    eq.getAnOperand().isConst() and
    nonConstNode = eq.getAnOperand() and
    not nonConstNode.isConst() and
    not eq.getAnOperand() = Builtin::nil().getARead() and
    e = nonConstNode.asExpr() and
    outcome = eq.getPolarity()
  )
}

/**
 * An equality test acting as a sanitizer guard for `nonConstNode` by
 * restricting it to a known value.
 *
 * Note that comparisons to `nil` are excluded. This is needed for performance
 * reasons.
 */
class EqualityTestBarrier extends DefaultTaintSanitizer {
  EqualityTestBarrier() { this = DataFlow::BarrierGuard<equalityTestGuard/3>::getABarrierNode() }
}

/**
 * Holds if data flows from `node` to `switchExprNode`, which is the expression
 * of a switch statement.
 */
private predicate flowsToSwitchExpression(DataFlow::Node node, DataFlow::Node switchExprNode) {
  switchExprNode.asExpr() = any(ExpressionSwitchStmt ess).getExpr() and
  DataFlow::localFlow(node, switchExprNode)
}

/**
 * Holds if `inputNode` is the exit node of a parameter to `fd` and data flows
 * from `inputNode` to the expression of a switch statement.
 */
private predicate isPossibleInputNode(DataFlow::Node inputNode, FuncDef fd) {
  inputNode = any(FunctionInput inp | inp.isParameter(_)).getExitNode(fd) and
  flowsToSwitchExpression(inputNode, _)
}

/**
 * Gets a predecessor of `succ` without following edges corresponding to
 * passing a constant case test in a switch statement which is switching on
 * an expression which data flows to from `inputNode`.
 */
private ControlFlow::Node getANonTestPassingPredecessor(
  ControlFlow::Node succ, DataFlow::Node inputNode
) {
  isPossibleInputNode(inputNode, succ.getRoot()) and
  result = succ.getAPredecessor() and
  not exists(Expr testExpr, DataFlow::Node switchExprNode |
    flowsToSwitchExpression(inputNode, switchExprNode) and
    ControlFlow::isSwitchCaseTestPassingEdge(result, succ, switchExprNode.asExpr(), testExpr) and
    testExpr.isConst()
  )
}

private ControlFlow::Node getANonTestPassingReachingNodeRecursive(
  ControlFlow::Node n, DataFlow::Node inputNode
) {
  isPossibleInputNode(inputNode, n.getRoot()) and
  (
    result = n or
    result =
      getANonTestPassingReachingNodeRecursive(getANonTestPassingPredecessor(n, inputNode), inputNode)
  )
}

/**
 * Gets a node by following predecessors from `ret` without following edges
 * corresponding to passing a constant case test in a switch statement which is
 * switching on an expression which data flows to from `inputNode`.
 */
private ControlFlow::Node getANonTestPassingReachingNodeBase(
  IR::ReturnInstruction ret, DataFlow::Node inputNode
) {
  result = getANonTestPassingReachingNodeRecursive(ret, inputNode)
}

/**
 * Holds if every way to get from the entry node of the function to `ret`
 * involves passing a constant test case in a switch statement which is
 * switching on an expression which data flows to from `inputNode`.
 */
private predicate mustPassConstantCaseTestToReach(
  IR::ReturnInstruction ret, DataFlow::Node inputNode
) {
  isPossibleInputNode(inputNode, ret.getRoot()) and
  not exists(ControlFlow::Node entry | entry = ret.getRoot().getEntryNode() |
    entry = getANonTestPassingReachingNodeBase(ret, inputNode)
  )
}

/**
 * Holds if whenever `outp` of function `f` satisfies `p`, the input `inp` of
 * `f` matched a constant in a case clause of a switch statement.
 *
 * We check this by looking for guards on `inp` that collectively dominate all
 * the `return` statements in `f` that can return `true`. This means that if
 * `f` returns `true`, one of the guards must have been satisfied. (Similar
 * reasoning is applied for statements returning `false`, `nil` or a non-`nil`
 * value.)
 */
predicate functionEnsuresInputIsConstant(
  Function f, FunctionInput inp, FunctionOutput outp, DataFlow::Property p
) {
  exists(FuncDecl fd | fd.getFunction() = f |
    exists(boolean b |
      p.isBoolean(b) and
      forex(DataFlow::Node ret, IR::ReturnInstruction ri |
        ret = outp.getEntryNode(fd) and
        ri.getReturnStmt().getAnExpr() = ret.asExpr() and
        DataFlow::possiblyReturnsBool(fd, outp, ret, b)
      |
        mustPassConstantCaseTestToReach(ri, inp.getExitNode(fd))
      )
    )
    or
    p.isNonNil() and
    forex(DataFlow::Node ret, IR::ReturnInstruction ri |
      ret = outp.getEntryNode(fd) and
      ri.getReturnStmt().getAnExpr() = ret.asExpr() and
      DataFlow::possiblyReturnsNonNil(fd, outp, ret)
    |
      mustPassConstantCaseTestToReach(ri, inp.getExitNode(fd))
    )
    or
    p.isNil() and
    forex(DataFlow::Node ret, IR::ReturnInstruction ri |
      ret = outp.getEntryNode(fd) and
      ri.getReturnStmt().getAnExpr() = ret.asExpr() and
      ret.asExpr() = Builtin::nil().getAReference()
    |
      DataFlow::localFlow(inp.getExitNode(fd), _) and
      mustPassConstantCaseTestToReach(ri, inp.getExitNode(fd))
    )
  )
}

/**
 * Holds if whenever `outputNode` satisfies `p`, `inputNode` matched a constant
 * in a case clause of a switch statement.
 */
pragma[noinline]
predicate inputIsConstantIfOutputHasProperty(
  DataFlow::Node inputNode, DataFlow::Node outputNode, DataFlow::Property p
) {
  exists(Function f, FunctionInput inp, FunctionOutput outp, DataFlow::CallNode call |
    functionEnsuresInputIsConstant(f, inp, outp, p) and
    call = f.getACall() and
    inputNode = inp.getNode(call) and
    DataFlow::localFlow(outp.getNode(call), outputNode)
  )
}

private predicate listOfConstantsComparisonSanitizerGuard(DataFlow::Node g, Expr e, boolean outcome) {
  exists(DataFlow::Node guardedExpr |
    exists(DataFlow::Node outputNode, DataFlow::Property p |
      inputIsConstantIfOutputHasProperty(guardedExpr, outputNode, p) and
      p.checkOn(g, outcome, outputNode)
    ) and
    e = guardedExpr.asExpr()
  )
}

/**
 * A comparison against a list of constants, acting as a sanitizer guard for
 * `guardedExpr` by restricting it to a known value.
 *
 * Currently this only looks for functions containing a switch statement, but
 * it could equally look for a check for membership of a constant map or
 * constant array, which does not need to be in its own function.
 */
class ListOfConstantsComparisonSanitizerGuard extends TaintTracking::DefaultTaintSanitizer {
  ListOfConstantsComparisonSanitizerGuard() {
    this = DataFlow::BarrierGuard<listOfConstantsComparisonSanitizerGuard/3>::getABarrierNode()
  }
}

/**
 * The `clear` built-in function deletes or zeroes out all elements of a map or slice
 * and therefore acts as a general sanitizer for taint flow to any uses dominated by it.
 */
private class ClearSanitizer extends DefaultTaintSanitizer {
  ClearSanitizer() {
    exists(SsaWithFields var, DataFlow::CallNode call, DataFlow::Node arg | this = var.getAUse() |
      call = Builtin::clear().getACall() and
      arg = call.getAnArgument() and
      arg = var.getAUse() and
      arg != this and
      this.getBasicBlock().(ReachableBasicBlock).dominates(this.getBasicBlock())
    )
  }
}
