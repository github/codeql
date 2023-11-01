/**
 * Shared utilities used when printing dataflow annotations in IR dumps.
 */

private import cpp
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil
private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate

private string stars(int k) {
  k =
    [0 .. max([
            any(RawIndirectInstruction n).getIndirectionIndex(),
            any(RawIndirectOperand n).getIndirectionIndex()
          ]
      )] and
  (if k = 0 then result = "" else result = "*" + stars(k - 1))
}

string starsForNode(Node node) {
  exists(int indirectionIndex |
    node.(IndirectInstruction).hasInstructionAndIndirectionIndex(_, indirectionIndex) or
    node.(IndirectOperand).hasOperandAndIndirectionIndex(_, indirectionIndex)
  |
    result = stars(indirectionIndex)
  )
  or
  not node instanceof IndirectInstruction and
  not node instanceof IndirectOperand and
  result = ""
}

private Instruction getInstruction(Node n, string stars) {
  result = [n.asInstruction(), n.(RawIndirectInstruction).getInstruction()] and
  stars = starsForNode(n)
}

private Operand getOperand(Node n, string stars) {
  result = [n.asOperand(), n.(RawIndirectOperand).getOperand()] and
  stars = starsForNode(n)
}

/**
 * Gets a short ID for an IR dataflow node.
 * - For `Instruction`s, this is just the result ID of the instruction (e.g. `m128`).
 * - For `Operand`s, this is the label of the operand, prefixed with the result ID of the
 *   instruction and a dot (e.g. `m128.left`).
 */
string nodeId(Node node, int order1, int order2) {
  exists(Instruction instruction, string stars | instruction = getInstruction(node, stars) |
    result = stars + instruction.getResultId() and
    order1 = instruction.getBlock().getDisplayIndex() and
    order2 = instruction.getDisplayIndexInBlock()
  )
  or
  exists(Operand operand, Instruction instruction, string stars |
    operand = getOperand(node, stars) and
    instruction = operand.getUse()
  |
    result = stars + instruction.getResultId() + "." + operand.getDumpId() and
    order1 = instruction.getBlock().getDisplayIndex() and
    order2 = instruction.getDisplayIndexInBlock()
  )
}
