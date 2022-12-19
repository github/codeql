/**
 * @name Missing return-value check for a 'scanf'-like function
 * @description Failing to check that a call to 'scanf' actually writes to an
 *              output variable can lead to unexpected behavior at reading time.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id cpp/missing-check-scanf
 * @tags security
 *       correctness
 *       external/cwe/cwe-252
 *       external/cwe/cwe-253
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
    this = call.getOutputArgument(varargIndex).getFullyConverted() and
    instr.getConvertedResultExpression() = this and
    valueNumber(instr) = valNum
  }

  ScanfFunctionCall getCall() { result = call }

  /**
   * Returns the smallest possible `scanf` return value that would indicate
   * success in writing this output argument.
   */
  int getMinimumGuardConstant() {
    result =
      varargIndex + 1 -
        count(ScanfFormatLiteral f, int n |
          // Special case: %n writes to an argument without reading any input.
          // It does not increase the count returned by `scanf`.
          n <= varargIndex and f.getUse() = call and f.getConversionChar(n) = "n"
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
      this.bigStep() = dst and
      dst.getAst() = result and
      valueNumber(dst) = valNum
    )
  }

  private Instruction bigStep() {
    result = this.smallStep(instr)
    or
    exists(Instruction i | i = this.bigStep() | result = this.smallStep(i))
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

/** Returns a block guarded by the assertion of `value op call` */
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

from ScanfOutput output, ScanfFunctionCall call, Access access
where
  output.getCall() = call and
  output.hasGuardedAccess(access, false) and
  not exists(DeallocationExpr dealloc | dealloc.getFreedExpr() = access)
select access,
  "This variable is read, but may not have been written. " +
    "It should be guarded by a check that the $@ returns at least " +
    output.getMinimumGuardConstant() + ".", call, call.toString()
