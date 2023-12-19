/**
 * This file contains the class that implements the non-debug version of
 * `toString` for `Instruction` and `Operand` dataflow nodes.
 */

private import semmle.code.cpp.ir.IR
private import codeql.util.Unit
private import Node0ToString
private import DataFlowUtil
private import DataFlowPrivate

private class NormalNode0ToString extends Node0ToString {
  NormalNode0ToString() {
    // Silence warning about `this` not being bound.
    exists(this)
  }

  override string instructionToString(Instruction i) {
    if i.(InitializeParameterInstruction).getIRVariable() instanceof IRThisVariable
    then result = "this"
    else result = i.getAst().toString()
  }

  override string operandToString(Operand op) {
    if op.getDef().(InitializeParameterInstruction).getIRVariable() instanceof IRThisVariable
    then result = "this"
    else result = op.getDef().getAst().toString()
  }

  override string toExprString(Node n) {
    result = n.asExpr(0).toString()
    or
    not exists(n.asExpr()) and
    result = stars(n) + n.asIndirectExpr(0, 1).toString()
  }
}
