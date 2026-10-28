private import unified
private import AllDataFlow
private import codeql.unified.internal.ExprPositions
private import codeql.unified.internal.NameBinding as N

private newtype TDataFlowCall =
  TExplicitCall(CallExpr call) {
    not isInBindingContext(call, _) // ignore constructor patterns
  } or
  TGetterCall(Expr expr) {
    hasResultValue(expr) and
    (
      N::getStaticBindingTargetFromRef(expr) = any(GetterDeclaration g).getNameNode()
      or
      expr instanceof MemberAccess
    )
  } or
  TSetterCall(Expr expr) {
    (
      isInAssignmentContext(expr, _)
      or
      // Write back a value that was mutated in-place, such as `x.p` in `x.p.f = y`
      hasPostUpdateAfterCallOrAssign(expr, _) and
      mayWriteBackViaSetterCall(expr)
    ) and
    (
      N::getStaticBindingTargetFromRef(expr) = any(SetterDeclaration g).getNameNode()
      or
      expr instanceof MemberAccess
    )
  } or
  TSummaryCall(SummarizedCallable callable, SummaryNode callee) {
    FlowSummaryOutput::summaryCallbackRange(callable, callee)
  }

/**
 * A call site, covering explicit calls such as `foo(1,2)`, as well as implicit
 * calls and calls derived from library models.
 *
 * Currently only explicit calls are implemented.
 */
class DataFlowCall extends TDataFlowCall {
  /** Gets the `CallExpr` wrapped by this dataflow call, if any. */
  CallExpr asExplicitCall() { this = TExplicitCall(result) }

  /** Gets the member/variable access for which this represents the call to a getter. */
  Expr asGetterCall() { this = TGetterCall(result) }

  /** Gets the member/variable access for which this represents the call to a setter. */
  Expr asSetterCall() { this = TSetterCall(result) }

  /** Holds if this is a synthesized call to `callee` in `callable`. */
  predicate isSummaryCall(SummarizedCallable callable, SummaryNode callee) {
    this = TSummaryCall(callable, callee)
  }

  /** Gets a textual representation of this call. */
  string toString() {
    result = this.asExplicitCall().toString()
    or
    result = "[getter call] " + this.asGetterCall().toString()
    or
    result = "[setter call] " + this.asSetterCall().toString()
    or
    exists(SummarizedCallable callable, SummaryNode callee |
      this.isSummaryCall(callable, callee) and
      result = "[summary] call to " + callee.toString() + " in " + callable.toString()
    )
  }

  /** Gets the location of this call, if any. */
  Location getLocation() {
    result = this.asExplicitCall().getLocation()
    or
    result = this.asGetterCall().getLocation()
    or
    result = this.asSetterCall().getLocation()
    or
    this.isSummaryCall(_, _) and result instanceof EmptyLocation
  }

  /** Gets the callable containing this call. */
  DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = this.asExplicitCall().getEnclosingCallable()
    or
    result.asSourceCallable() = this.asGetterCall().getEnclosingCallable()
    or
    result.asSourceCallable() = this.asSetterCall().getEnclosingCallable()
    or
    this.isSummaryCall(result.asSummarizedCallable(), _)
  }
}

DataFlowCall toDataFlowCall(CallExpr call) { result.asExplicitCall() = call }
