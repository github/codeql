/**
 * Provides classes for control flow.
 */

private import CIL

/** A node in the control flow graph. */
class ControlFlowNode extends @cil_controlflow_node {
  /** Gets a textual representation of this control flow node. */
  string toString() { none() }

  /**
   * Gets the number of items this node pushes onto the stack.
   * This value is either 0 or 1, except for the instruction `dup`
   * which pushes 2 values onto the stack.
   */
  int getPushCount() { result = 0 }

  /** Gets the number of items this node pops from the stack. */
  int getPopCount() { result = 0 }

  /** Gets a successor of this node, if any. */
  final Instruction getASuccessor() { result = getASuccessorType(_) }

  /** Gets a true successor of this node, if any. */
  final Instruction getTrueSuccessor() { result = getASuccessorType(any(TrueFlow f)) }

  /** Gets a false successor of this node, if any. */
  final Instruction getFalseSuccessor() { result = getASuccessorType(any(FalseFlow f)) }

  /** Gets a successor to this node, of type `type`, if any. */
  cached
  Instruction getASuccessorType(FlowType t) { none() }

  /** Gets a predecessor of this node, if any. */
  ControlFlowNode getAPredecessor() { result.getASuccessor() = this }

  /**
   * Gets an instruction that supplies the `i`th operand to this instruction.
   * Note that this can be multi-valued.
   */
  cached
  ControlFlowNode getOperand(int i) {
    // Immediate predecessor pushes the operand
    i in [0 .. this.getPopCount() - 1] and
    result = this.getAPredecessor() and
    i < result.getPushCount()
    or
    // Transitive predecessor pushes the operand
    exists(ControlFlowNode mid, int pushes | this.getOperandRec(mid, i, pushes) |
      pushes - mid.getStackDelta() < result.getPushCount() and
      result = mid.getAPredecessor()
    )
  }

  /** Gets an operand of this instruction, if any. */
  ControlFlowNode getAnOperand() { result = getOperand(_) }

  /** Gets an expression that consumes the output of this instruction on the stack. */
  Instruction getParentExpr() { this = result.getAnOperand() }

  /**
   * Holds if `pred` is a transitive predecessor of this instruction, this
   * instruction pops operand `i`, `pushes` additional pushes are required
   * for operand `i` at node `pred`, and no instruction between (and including)
   * `pred` and this instruction is a push for operand `i`.
   */
  private predicate getOperandRec(ControlFlowNode pred, int i, int pushes) {
    // Invariant: no node is a push for operand `i`
    pushes >= pred.getPushCount() and
    (
      i in [0 .. this.getPopCount() - 1] and
      pred = this.getAPredecessor() and
      pushes = i
      or
      exists(ControlFlowNode mid, int pushes0 | this.getOperandRec(mid, i, pushes0) |
        pushes = pushes0 - mid.getStackDelta() and
        // This is a guard to prevent ill formed programs
        // and other logic errors going into an infinite loop.
        pushes <= this.getImplementation().getStackSize() and
        pred = mid.getAPredecessor()
      )
    )
  }

  private int getStackDelta() { result = getPushCount() - getPopCount() }

  /** Gets the stack size before this instruction. */
  int getStackSizeBefore() { result = getAPredecessor().getStackSizeAfter() }

  /** Gets the stack size after this instruction. */
  final int getStackSizeAfter() {
    // This is a guard to prevent ill formed programs
    // and other logic errors going into an infinite loop.
    result in [0 .. getImplementation().getStackSize()] and
    result = getStackSizeBefore() + getStackDelta()
  }

  /** Gets the method containing this control flow node. */
  MethodImplementation getImplementation() { none() }

  /** Gets the type of the item pushed onto the stack, if any. */
  cached
  Type getType() { none() }

  /** Holds if this control flow node has more than one predecessor. */
  predicate isJoin() { strictcount(this.getAPredecessor()) > 1 }

  /** Holds if this control flow node has more than one successor. */
  predicate isBranch() { strictcount(this.getASuccessor()) > 1 }
}

/**
 * A control flow entry point. Either a method (`MethodImplementation`) or a handler (`Handler`).
 *
 * Handlers are control flow nodes because they push the handled exception onto the stack.
 */
class EntryPoint extends ControlFlowNode, @cil_entry_point {
  override int getStackSizeBefore() { result = 0 }
}

private newtype TFlowType =
  TNormalFlow() or
  TTrueFlow() or
  TFalseFlow()

/** A type of control flow. Either normal flow (`NormalFlow`), true flow (`TrueFlow`) or false flow (`FalseFlow`). */
abstract class FlowType extends TFlowType {
  abstract string toString();
}

/** Normal control flow. */
class NormalFlow extends FlowType, TNormalFlow {
  override string toString() { result = "" }
}

/** True control flow. */
class TrueFlow extends FlowType, TTrueFlow {
  override string toString() { result = "true" }
}

/** False control flow. */
class FalseFlow extends FlowType, TFalseFlow {
  override string toString() { result = "false" }
}
