/**
 * This file contains the signature module for controlling the behavior of `Node.toString`.
 */

private import semmle.code.cpp.ir.IR
private import codeql.util.Unit
private import DataFlowUtil

/** A signature for a module to control the behavior of `Node.toString`. */
signature module Node0ToStringSig {
  /**
   * Gets the string that should be used by `OperandNode.toString`.
   */
  string operandToString(Operand op);

  /**
   * Gets the string that should be used by `InstructionNode.toString`.
   */
  string instructionToString(Instruction i);

  /**
   * Gets the string representation of the `Expr` associated with `n`, if any.
   */
  string toExprString(Node n);
}
