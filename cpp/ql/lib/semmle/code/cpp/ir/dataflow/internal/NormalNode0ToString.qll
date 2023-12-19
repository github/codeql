/**
 * This file contains module that implements the non-debug version of
 * `toString` for `Instruction` and `Operand` dataflow nodes.
 */

private import semmle.code.cpp.ir.IR
private import codeql.util.Unit
private import Node0ToStringSig
private import DataFlowUtil
private import DataFlowPrivate

private module NormalNode0ToStringImpl implements Node0ToStringSig {
  string instructionToString(Instruction i) {
    if i.(InitializeParameterInstruction).getIRVariable() instanceof IRThisVariable
    then result = "this"
    else result = i.getAst().toString()
  }

  string operandToString(Operand op) {
    if op.getDef().(InitializeParameterInstruction).getIRVariable() instanceof IRThisVariable
    then result = "this"
    else result = op.getDef().getAst().toString()
  }

  string toExprString(Node n) {
    result = n.asExpr(0).toString()
    or
    not exists(n.asExpr()) and
    result = stars(n) + n.asIndirectExpr(0, 1).toString()
  }
}

import NormalNode0ToStringImpl
