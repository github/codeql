/**
 * @name Missing return-value check for a scanf-like function
 * @description TODO
 * @kind problem
 * @problem.severity warning
 * @security-severity TODO
 * @precision TODO
 * @id cpp/missing-check-scanf
 * @tags security
 */

import cpp
import semmle.code.cpp.commons.Scanf
import semmle.code.cpp.controlflow.Guards
import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.ValueNumbering

/** An expression appearing as an output argument to a `scanf`-like call */
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
   * but before it gets reset or reused in another `scanf` call.
   */
  Access getAnAccess() {
    exists(Instruction j | result = j.getAst() |
      j = getASubsequentSameValuedInstruction() and
      forall(Instruction k |
        k = [getAResetInstruction(), getAReuseInstruction()] implies j.getASuccessor+() = k
      )
    )
  }

  private Instruction getAResetInstruction() {
    result = getASubsequentSameValuedInstruction() and
    result = any(StoreInstruction s).getDestinationAddress()
  }

  private Instruction getAReuseInstruction() {
    result = getASubsequentSameValuedInstruction() and
    exists(Expr e | result.getAst() = e |
      e instanceof ScanfOutput
      or
      e.getParent().(AddressOfExpr) instanceof ScanfOutput
    )
  }

  private Instruction getASubsequentSameValuedInstruction() {
    exists(Instruction i |
      i.getUnconvertedResultExpression() = this and
      result = valueNumber(i).getAnInstruction() and
      i.getASuccessor+() = result
    )
  }

  private predicate foo(Instruction i, Instruction j, boolean sameValueNum, boolean sameAst) {
    i.getUnconvertedResultExpression() = this and
    i.getASuccessor+() = j and
    (if valueNumber(i) = valueNumber(j) then sameValueNum = true else sameValueNum = false) and
    (if i.getAst() = j.getAst() then sameAst = true else sameAst = false) and
    (sameValueNum = true and sameAst = true)
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
  "$@ is read here, but may not have been written. " +
    "It should be guarded by a check that $@() returns at least " + output.getNumber() + ".",
  access, access.toString(), call, fun.getName()
