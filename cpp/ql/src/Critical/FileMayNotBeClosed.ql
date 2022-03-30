/**
 * @name Open file may not be closed
 * @description A function may return before closing a file that was opened in the function. Closing resources in the same function that opened them ties the lifetime of the resource to that of the function call, making it easier to avoid and detect resource leaks.
 * @kind problem
 * @id cpp/file-may-not-be-closed
 * @problem.severity warning
 * @security-severity 7.8
 * @tags efficiency
 *       security
 *       external/cwe/cwe-775
 */

import FileClosed
import semmle.code.cpp.controlflow.StackVariableReachability

/**
 * Extend the NullValue class used by Nullness.qll to include simple -1 as a 'null' value
 * (for example 'open' returns -1 if there was an error)
 */
class MinusOne extends NullValue {
  MinusOne() { this.(UnaryMinusExpr).getOperand().(Literal).getValue() = "1" }
}

/**
 * 'call' is either a direct call to f, or a possible call to f
 * via a function pointer.
 */
predicate mayCallFunction(Expr call, Function f) {
  call.(FunctionCall).getTarget() = f or
  call.(VariableCall).getVariable().getAnAssignedValue().getAChild*().(FunctionAccess).getTarget() =
    f
}

predicate fopenCallOrIndirect(Expr e) {
  // direct fopen call
  fopenCall(e) and
  // We are only interested in fopen calls that are
  // actually closed somehow, as FileNeverClosed
  // will catch those that aren't.
  fopenCallMayBeClosed(e)
  or
  exists(ReturnStmt rtn |
    // indirect fopen call
    mayCallFunction(e, rtn.getEnclosingFunction()) and
    (
      // return fopen
      fopenCallOrIndirect(rtn.getExpr())
      or
      // return variable assigned with fopen
      exists(Variable v |
        v = rtn.getExpr().(VariableAccess).getTarget() and
        fopenCallOrIndirect(v.getAnAssignedValue()) and
        not assignedToFieldOrGlobal(v, _)
      )
    )
  )
}

predicate fcloseCallOrIndirect(FunctionCall fc, Variable v) {
  // direct fclose call
  fcloseCall(fc, v.getAnAccess())
  or
  // indirect fclose call
  exists(FunctionCall midcall, Function mid, int arg |
    fc.getArgument(arg) = v.getAnAccess() and
    mayCallFunction(fc, mid) and
    midcall.getEnclosingFunction() = mid and
    fcloseCallOrIndirect(midcall, mid.getParameter(arg))
  )
}

predicate fopenDefinition(StackVariable v, ControlFlowNode def) {
  exists(Expr expr | exprDefinition(v, def, expr) and fopenCallOrIndirect(expr))
}

class FOpenVariableReachability extends StackVariableReachabilityWithReassignment {
  FOpenVariableReachability() { this = "FOpenVariableReachability" }

  override predicate isSourceActual(ControlFlowNode node, StackVariable v) {
    fopenDefinition(v, node)
  }

  override predicate isSinkActual(ControlFlowNode node, StackVariable v) {
    // node may be used in fopenReaches
    exists(node.(AnalysedExpr).getNullSuccessor(v)) or
    fcloseCallOrIndirect(node, v) or
    assignedToFieldOrGlobal(v, node) or
    // node may be used directly in query
    v.getFunction() = node.(ReturnStmt).getEnclosingFunction()
  }

  override predicate isBarrier(ControlFlowNode node, StackVariable v) { definitionBarrier(v, node) }
}

/**
 * The value from fopen at `def` is still held in Variable `v` upon entering `node`.
 */
predicate fopenVariableReaches(StackVariable v, ControlFlowNode def, ControlFlowNode node) {
  exists(FOpenVariableReachability r |
    // reachability
    r.reachesTo(def, _, node, v)
    or
    // accept def node itself
    r.isSource(def, v) and
    node = def
  )
}

class FOpenReachability extends StackVariableReachabilityExt {
  FOpenReachability() { this = "FOpenReachability" }

  override predicate isSource(ControlFlowNode node, StackVariable v) { fopenDefinition(v, node) }

  override predicate isSink(ControlFlowNode node, StackVariable v) {
    v.getFunction() = node.(ReturnStmt).getEnclosingFunction()
  }

  override predicate isBarrier(
    ControlFlowNode source, ControlFlowNode node, ControlFlowNode next, StackVariable v
  ) {
    isSource(source, v) and
    next = node.getASuccessor() and
    // the file (stored in any variable `v0`) opened at `source` is closed or
    // assigned to a global at node, or NULL checked on the edge node -> next.
    exists(StackVariable v0 | fopenVariableReaches(v0, source, node) |
      node.(AnalysedExpr).getNullSuccessor(v0) = next or
      fcloseCallOrIndirect(node, v0) or
      assignedToFieldOrGlobal(v0, node)
    )
  }
}

/**
 * The value returned by fopen `def` has not been closed, confirmed to be null,
 * or potentially leaked globally upon reaching `node` (regardless of what variable
 * it's still held in, if any).
 */
predicate fopenReaches(ControlFlowNode def, ControlFlowNode node) {
  exists(FOpenReachability r | r.reaches(def, _, node))
}

predicate assignedToFieldOrGlobal(StackVariable v, Expr e) {
  // assigned to anything except a StackVariable
  // (typically a field or global, but for example also *ptr = v)
  e.(Assignment).getRValue() = v.getAnAccess() and
  not e.(Assignment).getLValue().(VariableAccess).getTarget() instanceof StackVariable
  or
  exists(Expr midExpr, Function mid, int arg |
    // indirect assignment
    e.(FunctionCall).getArgument(arg) = v.getAnAccess() and
    mayCallFunction(e, mid) and
    midExpr.getEnclosingFunction() = mid and
    assignedToFieldOrGlobal(mid.getParameter(arg), midExpr)
  )
  or
  // assigned to a field via constructor field initializer
  e.(ConstructorFieldInit).getExpr() = v.getAnAccess()
}

from ControlFlowNode def, ReturnStmt ret
where
  fopenReaches(def, ret) and
  not exists(StackVariable v |
    fopenVariableReaches(v, def, ret) and
    ret.getAChild*() = v.getAnAccess()
  )
select def, "The file opened here may not be closed at $@.", ret, "this exit point"
