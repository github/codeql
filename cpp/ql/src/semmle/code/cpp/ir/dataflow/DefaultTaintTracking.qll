import cpp
import semmle.code.cpp.security.Security
private import semmle.code.cpp.ir.dataflow.DataFlow
private import semmle.code.cpp.ir.IR

/**
 * A predictable instruction is one where an external user can predict
 * the value. For example, a literal in the source code is considered
 * predictable.
 */
private predicate predictableInstruction(Instruction instr) {
  instr instanceof ConstantInstruction
  or
  instr instanceof StringConstantInstruction
  or
  // This could be a conversion on a string literal
  predictableInstruction(instr.(UnaryInstruction).getUnary())
}

private class DefaultTaintTrackingCfg extends DataFlow::Configuration {
  DefaultTaintTrackingCfg() { this = "DefaultTaintTrackingCfg" }

  override predicate isSource(DataFlow::Node source) { isUserInput(source.asExpr(), _) }

  override predicate isSink(DataFlow::Node sink) { any() }

  override predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    instructionTaintStep(n1.asInstruction(), n2.asInstruction())
  }

  override predicate isBarrier(DataFlow::Node node) {
    exists(Variable checkedVar |
      accessesVariable(node.asInstruction(), checkedVar) and
      hasUpperBoundsCheck(checkedVar)
    )
  }
}

private predicate accessesVariable(CopyInstruction copy, Variable var) {
  exists(VariableAddressInstruction va | va.getASTVariable() = var |
    copy.(StoreInstruction).getDestinationAddress() = va
    or
    copy.(LoadInstruction).getSourceAddress() = va
  )
}

/**
 * A variable that has any kind of upper-bound check anywhere in the program
 */
// TODO: This coarse overapproximation, ported from the old taint tracking
// library, could be replaced with an actual semantic check that a particular
// variable _access_ is guarded by an upper-bound check. We probably don't want
// to do this right away since it could expose a lot of FPs that were
// previously suppressed by this predicate by coincidence.
private predicate hasUpperBoundsCheck(Variable var) {
  exists(RelationalOperation oper, VariableAccess access |
    oper.getLeftOperand() = access and
    access.getTarget() = var and
    // Comparing to 0 is not an upper bound check
    not oper.getRightOperand().getValue() = "0"
  )
}

private predicate instructionTaintStep(Instruction i1, Instruction i2) {
  // Expressions computed from tainted data are also tainted
  i2 = any(CallInstruction call |
      isPureFunction(call.getStaticCallTarget().getName()) and
      call.getAnArgument() = i1 and
      forall(Instruction arg | arg = call.getAnArgument() | arg = i1 or predictableInstruction(arg)) and
      // flow through `strlen` tends to cause dubious results, if the length is
      // bounded.
      not call.getStaticCallTarget().getName() = "strlen"
    )
  or
  // Flow through pointer dereference
  i2.(LoadInstruction).getSourceAddress() = i1
  or
  i2.(UnaryInstruction).getUnary() = i1
  or
  exists(BinaryInstruction bin |
    bin = i2 and
    predictableInstruction(i2.getAnOperand().getDef()) and
    i1 = i2.getAnOperand().getDef()
  )
  or
  // This is part of the translation of `a[i]`, where we want taint to flow
  // from `a`.
  i2.(PointerAddInstruction).getLeft() = i1
  // TODO: Flow from argument to return of known functions: Port missing parts
  // of `returnArgument` to the `interfaces.Taint` and `interfaces.DataFlow`
  // libraries.
  //
  // TODO: Flow from input argument to output argument of known functions: Port
  // missing parts of `copyValueBetweenArguments` to the `interfaces.Taint` and
  // `interfaces.DataFlow` libraries and implement call side-effect nodes. This
  // will help with the test for `ExecTainted.ql`. The test for
  // `TaintedPath.ql` is more tricky because the output arg is a pointer
  // addition expression.
}

predicate tainted(Expr source, Element tainted) {
  exists(DefaultTaintTrackingCfg cfg, DataFlow::Node sink |
    cfg.hasFlow(DataFlow::exprNode(source), sink)
  |
    // TODO: is it more appropriate to use asConvertedExpr here and avoid
    // `getConversion*`? Or will that cause us to miss some cases where there's
    // flow to a conversion (like a `ReferenceDereferenceExpr`) and we want to
    // pretend there was flow to the converted `Expr` for the sake of
    // compatibility.
    sink.asExpr().getConversion*() = tainted
    or
    // For compatibility, send flow from arguments to parameters, even for
    // functions with no body.
    exists(FunctionCall call, int i |
      sink.asExpr() = call.getArgument(i) and
      tainted = resolveCall(call).getParameter(i)
    )
    or
    // For compatibility, send flow into a `Variable` if there is flow to any
    // Load or Store of that variable.
    exists(CopyInstruction copy |
      copy.getSourceValue() = sink.asInstruction() and
      accessesVariable(copy, tainted) and
      not hasUpperBoundsCheck(tainted)
    )
    or
    // For compatibility, send flow into a `NotExpr` even if it's part of a
    // short-circuiting condition and thus might get skipped.
    tainted.(NotExpr).getOperand() = sink.asExpr()
  )
}

predicate taintedIncludingGlobalVars(Expr source, Element tainted, string globalVar) {
  tainted(source, tainted) and
  // TODO: Find a way to emulate how `security.TaintTracking` reports the last
  // global variable that taint has passed through. Also make sure we emulate
  // its behavior for interprocedural flow through globals.
  globalVar = ""
}

GlobalOrNamespaceVariable globalVarFromId(string id) {
  // TODO: Implement this when `taintedIncludingGlobalVars` has support for
  // global variables.
  none()
}

Function resolveCall(Call call) {
  // TODO: improve virtual dispatch. This will help in the test for
  // `UncontrolledProcessOperation.ql`.
  result = call.getTarget()
}
