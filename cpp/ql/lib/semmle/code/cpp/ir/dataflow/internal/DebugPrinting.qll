/**
 * This file contains module that implements the _debug_ version of
 * `toString` for `Instruction` and `Operand` dataflow nodes.
 */

private import semmle.code.cpp.ir.IR
private import codeql.util.Unit
private import Node0ToStringSig
private import DataFlowUtil

private module DebugNode0ToString implements Node0ToStringSig {
  string instructionToString(Instruction i) { result = i.getDumpString() }

  string operandToString(Operand op) {
    result = op.getDumpString() + " @ " + op.getUse().getResultId()
  }

  string toExprString(Node n) { none() }
}

import DebugNode0ToString
