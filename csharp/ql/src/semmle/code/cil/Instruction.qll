/** Provides the `Instruction` class. */

private import CIL

/** An instruction. */
class Instruction extends Element, ControlFlowNode, DataFlowNode, @cil_instruction {
  override string toString() { result = getOpcodeName() }

  /** Gets a more verbose textual representation of this instruction. */
  string toStringExtra() { result = getIndex() + ": " + getOpcodeName() + getExtraStr() }

  /** Gets the method containing this instruction. */
  override MethodImplementation getImplementation() { cil_instruction(this, _, _, result) }

  override Method getMethod() { result = getImplementation().getMethod() }

  /**
   * Gets the index of this instruction.
   * Instructions are sequenced from 0.
   */
  int getIndex() { cil_instruction(this, _, result, _) }

  /** Gets the opcode of this instruction. */
  final int getOpcode() { cil_instruction(this, result, _, _) }

  /** Gets the opcode name of this instruction, for example `ldnull`. */
  string getOpcodeName() { none() }

  /** Gets an extra field to display for this instruction, if any. */
  string getExtra() { none() }

  private string getExtraStr() {
    if exists(getExtra()) then result = " " + getExtra() else result = ""
  }

  /** Gets the declaration accessed by this instruction, if any. */
  Declaration getAccess() { cil_access(this, result) }

  /** Gets a successor instruction to this instruction. */
  override Instruction getASuccessorType(FlowType t) {
    t instanceof NormalFlow and
    canFlowNext() and
    result = this.getImplementation().getInstruction(getIndex() + 1)
  }

  /** Holds if this instruction passes control flow into the next instruction. */
  predicate canFlowNext() { any() }

  /**
   * Gets the `i`th handler that applies to this instruction.
   * Indexed from 0.
   */
  Handler getHandler(int i) {
    result.isInScope(this) and
    result.getIndex() =
      rank[i + 1](int hi | exists(Handler h | h.isInScope(this) and hi = h.getIndex()))
  }

  override Type getType() { result = ControlFlowNode.super.getType() }

  override Location getALocation() {
    cil_instruction_location(this, result) // The source code, if available
    or
    result = getImplementation().getLocation() // The containing assembly
  }

  override Location getLocation() { result = Element.super.getLocation() }
}
