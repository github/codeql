/**
 * @name Missing return-value check for a 'scanf'-like function
 * @description Without checking that a call to 'scanf' actually wrote to an
 *              output variable, reading from it can lead to unexpected behavior.
 * @kind problem
 * @problem.severity recommendation
 * @security-severity 4.5
 * @precision medium
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
  int varargIndex;
  Instruction instr;
  ValueNumber valNum;

  ScanfOutput() {
    this = call.getOutputArgument(varargIndex) and
    instr.getUnconvertedResultExpression() = this and
    valueNumber(instr) = valNum and
    // The following line is a kludge to prohibit more than one associated `instr` field,
    // as would occur, for example, when `this` is an access to an array variable.
    not instr instanceof ConvertInstruction
  }

  ScanfFunctionCall getCall() { result = call }

  /**
   * Any subsequent use of this argument should be surrounded by a
   * check ensuring that the `scanf`-like function has returned a value
   * equal to at least `getMinimumGuardConstant()`.
   */
  int getMinimumGuardConstant() {
    result =
      varargIndex + 1 -
        count(ScanfFormatLiteral f, int n |
          n <= varargIndex and f.getUse() = call and f.parseConvSpec(n, _, _, _, "n")
        )
  }

  predicate hasGuardedAccess(Access e, boolean isGuarded) {
    e = this.getAnAccess() and
    if
      exists(int value, int minGuard | minGuard = this.getMinimumGuardConstant() |
        e.getBasicBlock() = blockGuardedBy(value, "==", call) and minGuard <= value
        or
        e.getBasicBlock() = blockGuardedBy(value, "<", call) and minGuard - 1 <= value
        or
        e.getBasicBlock() = blockGuardedBy(value, "<=", call) and minGuard <= value
      )
    then isGuarded = true
    else isGuarded = false
  }

  /**
   * Get a subsequent access of the same underlying storage,
   * but before it gets reset or reused in another `scanf` call.
   */
  Access getAnAccess() {
    exists(Instruction dst |
      this.bigStep(instr) = dst and
      dst.getAst() = result and
      valueNumber(dst) = valNum
    )
  }

  private Instruction bigStep(Instruction i) {
    result = this.smallStep(i)
    or
    exists(Instruction j | j = this.bigStep(i) | result = this.smallStep(j))
  }

  private Instruction smallStep(Instruction i) {
    instr.getASuccessor*() = i and
    i.getASuccessor() = result and
    not this.isBarrier(result)
  }

  private predicate isBarrier(Instruction i) {
    valueNumber(i) = valNum and
    exists(Expr e | i.getAst() = e |
      i = any(StoreInstruction s).getDestinationAddress()
      or
      [e, e.getParent().(AddressOfExpr)] instanceof ScanfOutput
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
  "$@ is read here, but may not have been written. " +
    "It should be guarded by a check that $@() returns at least " + output.getMinimumGuardConstant()
    + ".", access, access.toString(), call, fun.getName()
