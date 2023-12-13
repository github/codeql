/**
 * This file contains the abstract class that serves as the base class for
 * dataflow node printing.
 *
 * By default, a non-debug string is produced. However, a debug-friendly
 * string can be produced by importing `DebugPrinting.qll`.
 */

private import semmle.code.cpp.ir.IR
private import codeql.util.Unit

/**
 * A class to control whether a debugging version of instructions and operands
 * should be printed as part of the `toString` output of dataflow nodes.
 *
 * To enable debug printing import the `DebugPrinting.ql` file. By default,
 * non-debug output will be used.
 */
class Node0ToString extends Unit {
  abstract predicate isDebugMode();

  private string normalInstructionToString(Instruction i) {
    not this.isDebugMode() and
    if i.(InitializeParameterInstruction).getIRVariable() instanceof IRThisVariable
    then result = "this"
    else result = i.getAst().toString()
  }

  private string normalOperandToString(Operand op) {
    not this.isDebugMode() and
    if op.getDef().(InitializeParameterInstruction).getIRVariable() instanceof IRThisVariable
    then result = "this"
    else result = op.getDef().getAst().toString()
  }

  /**
   * Gets the string that should be used by `InstructionNode.toString`
   */
  string instructionToString(Instruction i) {
    if this.isDebugMode()
    then result = i.getDumpString()
    else result = this.normalInstructionToString(i)
  }

  /**
   * Gets the string that should be used by `OperandNode.toString`.
   */
  string operandToString(Operand op) {
    if this.isDebugMode()
    then result = op.getDumpString() + " @ " + op.getUse().getResultId()
    else result = this.normalOperandToString(op)
  }
}

private class NoDebugNode0ToString extends Node0ToString {
  final override predicate isDebugMode() { none() }
}

/**
 * Gets the string that should be used by `OperandNode.toString`.
 */
string operandToString(Operand op) { result = any(Node0ToString nts).operandToString(op) }

/**
 * Gets the string that should be used by `InstructionNode.toString`
 */
string instructionToString(Instruction i) { result = any(Node0ToString nts).instructionToString(i) }

/**
 * Holds if debugging mode is enabled.
 *
 * In debug mode the `toString` on dataflow nodes is more expensive to compute,
 * but gives more precise information about the different dataflow nodes.
 */
predicate isDebugMode() { any(Node0ToString nts).isDebugMode() }
