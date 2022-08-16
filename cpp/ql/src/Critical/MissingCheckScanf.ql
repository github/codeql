/**
 * @name TODO
 * @description TODO
 * @kind problem
 * @problem.severity warning
 * @security-severity TODO
 * @precision TODO
 * @id cpp/missing-check-scanf
 * @tags TODO
 */

import cpp
import semmle.code.cpp.commons.Scanf
import semmle.code.cpp.controlflow.Guards
import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.ValueNumbering

// DataFlow::localFlow(DataFlow::parameterNode(src), DataFlow::exprNode(snk))
/*
 * Find:
 * - all scanf calls
 *   => ScanfFunctionCall
 *
 * - relate the value number of each out-arg to:
 *   1. the return value of the scanf call, and
 *   2. the arg number, post-format, of the out-arg.
 *   => scanfOutput/3
 *
 * - Find all accesses to variables with the same
 *   value number, and if applicable, the guard condition
 *   of one of their enclosing blocks that ensures
 *   that the scanf return value is at least the
 *   associated arg-number
 *
 * - Combine into data flow tracking from out-arg to use,
 *   with usage in _other_ scanf calls as barrier.
 */

class ScanfOutput extends Expr {
  ScanfFunctionCall call;
  int argNum;

  ScanfOutput() {
    this = call.getArgument(call.getFormatParameterIndex() + argNum) and
    argNum >= 1
  }

  ScanfFunctionCall getCall() { result = call }

  int getNumber() { result = argNum }

  predicate hasGuardedAccess(Access e, boolean isGuarded) {
    e = getAnAccess() and
    if
      exists(int value |
        e.getBasicBlock() = blockGuardedBy(value, "==", call) and argNum <= value
        or
        e.getBasicBlock() = blockGuardedBy(value, "<", call) and argNum - 1 <= value
        or
        e.getBasicBlock() = blockGuardedBy(value, "<=", call) and argNum <= value
      )
    then isGuarded = true
    else isGuarded = false
  }

  /**
   * Get a subsequent access of the same underlying storage,
   * but before it gets reset or reused in another scanf call.
   */
  Access getAnAccess() {
    exists(Instruction j |
      j = getNextInstruction() and
      forall(Instruction k | k = [getAReset(), getAReuse()] implies j.getASuccessor+() = k)
    |
      result = j.getAst()
    )
  }

  private Instruction getAReset() {
    result = getNextInstruction() and
    result = any(StoreInstruction s).getDestinationAddress()
  }

  private Instruction getAReuse() {
    result = getNextInstruction() and
    exists(Expr e | result.getAst() = e |
      e instanceof ScanfOutput
      or
      e.getParent().(AddressOfExpr) instanceof ScanfOutput
    )
  }

  private Instruction getNextInstruction() {
    exists(Instruction i |
      i.getUnconvertedResultExpression() = this and
      result = valueNumber(i).getAnInstruction() and
      i.getASuccessor+() = result
    )
  }
}

/** Returns a block guarded by the assertion of $value $op $call */
BasicBlock blockGuardedBy(int value, string op, ScanfFunctionCall call) {
  exists(GuardCondition g, Expr left, Expr right |
    right = g.getAChild() and
    value = left.getValue().toInt() and
    DataFlow::localExprFlow(call, right)
  |
    g.ensuresEq(left, right, 0, result, true) and op = "=="
    or
    g.ensuresLt(left, right, 0, result, true) and op = "<"
    or
    g.ensuresLt(left, right, 1, result, true) and op = "<="
  )
}

from ScanfOutput output, ScanfFunctionCall call, ScanfFunction fun, Access access
where
  call.getTarget() = fun and
  output.getCall() = call and
  output.hasGuardedAccess(access, false)
select access,
  "`$@` is read here, but may not have been written. " +
    "It should be guarded by a check that `$@()` returns at least " + output.getNumber() + ".",
  access, access.toString(), call, fun.getName()
