/**
 * This file contains the class that implements the _debug_ version of
 * `toString` for `Instruction` and `Operand` dataflow nodes.
 */

private import semmle.code.cpp.ir.IR
private import codeql.util.Unit
private import Node0ToString
private import DataFlowUtil

private class DebugNode0ToString extends Node0ToString {
  DebugNode0ToString() {
    // Silence warning about `this` not being bound.
    exists(this)
  }

  override string instructionToString(Instruction i) { result = i.getDumpString() }

  override string operandToString(Operand op) {
    result = op.getDumpString() + " @ " + op.getUse().getResultId()
  }

  override string toExprString(Node n) { none() }
}
