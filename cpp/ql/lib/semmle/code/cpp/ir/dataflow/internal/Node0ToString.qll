/**
 * This file imports the class that is used to construct the strings used by
 * `Node.ToString`.
 *
 * Normally, this file should just import `NormalNode0ToString` to compute the
 * efficient `toString`, but for debugging purposes one can import
 * `DebugPrinting.qll` to better correlate the dataflow nodes with their
 * underlying instructions and operands.
 */

private import semmle.code.cpp.ir.IR
private import codeql.util.Unit
private import DataFlowUtil
import NormalNode0ToString // Change this import to control which version should be used.

/** An abstract class to control the behavior of `Node.toString`. */
abstract class Node0ToString extends Unit {
  /**
   * Gets the string that should be used by `OperandNode.toString` to print the
   * dataflow node whose underlying operand is `op.`
   */
  abstract string operandToString(Operand op);

  /**
   * Gets the string that should be used by `InstructionNode.toString` to print
   * the dataflow node whose underlying instruction is `instr`.
   */
  abstract string instructionToString(Instruction i);

  /**
   * Gets the string representation of the `Expr` associated with `n`, if any.
   */
  abstract string toExprString(Node n);
}

/**
 * Gets the string that should be used by `OperandNode.toString` to print the
 * dataflow node whose underlying operand is `op.`
 */
string operandToString(Operand op) { result = any(Node0ToString s).operandToString(op) }

/**
 * Gets the string that should be used by `InstructionNode.toString` to print
 * the dataflow node whose underlying instruction is `instr`.
 */
string instructionToString(Instruction instr) {
  result = any(Node0ToString s).instructionToString(instr)
}

/**
 * Gets the string representation of the `Expr` associated with `n`, if any.
 */
string toExprString(Node n) { result = any(Node0ToString s).toExprString(n) }
