/**
 * Shared utilities used when printing dataflow annotations in IR dumps.
 */

private import cpp
// The `ValueNumbering` library has to be imported right after `cpp` to ensure
// that the cached IR gets the same checksum here as it does in queries that use
// `ValueNumbering` without `DataFlow`.
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.DataFlow

/**
 * Gets a short ID for an IR dataflow node.
 * - For `Instruction`s, this is just the result ID of the instruction (e.g. `m128`).
 * - For `Operand`s, this is the label of the operand, prefixed with the result ID of the
 *   instruction and a dot (e.g. `m128.left`).
 * - For `Variable`s, this is the qualified name of the variable.
 */
string nodeId(DataFlow::Node node, int order1, int order2) {
  exists(Instruction instruction | instruction = node.asInstruction() |
    result = instruction.getResultId() and
    order1 = instruction.getBlock().getDisplayIndex() and
    order2 = instruction.getDisplayIndexInBlock()
  )
  or
  exists(Operand operand, Instruction instruction |
    operand = node.asOperand() and
    instruction = operand.getUse()
  |
    result = instruction.getResultId() + "." + operand.getDumpId() and
    order1 = instruction.getBlock().getDisplayIndex() and
    order2 = instruction.getDisplayIndexInBlock()
  )
  or
  result = "var(" + node.asVariable().getQualifiedName() + ")" and
  order1 = 1000000 and
  order2 = 0
}
