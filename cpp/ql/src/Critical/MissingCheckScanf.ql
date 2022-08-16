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

  Access getAnAccess() {
    exists(Instruction j |
      j = getNextInstruction() and
      forall(Instruction k | k = getAReset() implies j.getASuccessor+() = k) and
      forall(Instruction k | k = getAReuse() implies j.getASuccessor+() = k)
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

//select any(CallInstruction i | i.getStaticCallTarget() instanceof ScanfFunction).toString()
from ScanfFunctionCall fc
where fc instanceof ExprInVoidContext
select fc, "This is a call to scanf."
