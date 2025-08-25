/**
 * This file contains the class that implements the non-debug version of
 * `toString` for `Instruction` and `Operand` dataflow nodes.
 */

private import cpp
private import semmle.code.cpp.ir.IR
private import codeql.util.Unit
private import Node0ToString
private import DataFlowUtil
private import DataFlowPrivate

/**
 * Gets the string representation of the unconverted expression `loc` if
 * `loc` is an `Expression`.
 *
 * Otherwise, this gets the string representation of `loc`.
 */
private string unconvertedAstToString(Locatable loc) {
  result = loc.(Expr).getUnconverted().toString()
  or
  not loc instanceof Expr and
  result = loc.toString()
}

private class NormalNode0ToString extends Node0ToString {
  NormalNode0ToString() {
    // Silence warning about `this` not being bound.
    exists(this)
  }

  override string instructionToString(Instruction i) {
    if i.(InitializeParameterInstruction).getIRVariable() instanceof IRThisVariable
    then result = "this"
    else result = unconvertedAstToString(i.getAst())
  }

  override string operandToString(Operand op) { result = this.instructionToString(op.getDef()) }

  override string toExprString(Node n) {
    result = n.asExpr(0).toString()
    or
    not exists(n.asExpr()) and
    result = stars(n) + n.asIndirectExpr(0, 1).toString()
  }
}
