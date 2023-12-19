/**
 * This file contains the signature module for controlling the behavior of `Node.toString`.
 */

private import semmle.code.cpp.ir.IR
private import codeql.util.Unit
private import DataFlowUtil

/** A signature for a module to control the behavior of `Node.toString`. */
abstract class Node0ToString extends Unit {
  /**
   * Gets the string that should be used by `OperandNode.toString`.
   */
  abstract string operandToString(Operand op);

  /**
   * Gets the string that should be used by `InstructionNode.toString`.
   */
  abstract string instructionToString(Instruction i);

  /**
   * Gets the string representation of the `Expr` associated with `n`, if any.
   */
  abstract string toExprString(Node n);
}

string operandToString(Operand op) { result = any(Node0ToString s).operandToString(op) }

string instructionToString(Instruction instr) {
  result = any(Node0ToString s).instructionToString(instr)
}

string toExprString(Node n) { result = any(Node0ToString s).toExprString(n) }
