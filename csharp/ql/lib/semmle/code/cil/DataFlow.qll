/**
 * Provides a collection of building blocks and utilities for data flow.
 */

private import CIL

/**
 * A node in the data flow graph.
 *
 * Either an instruction (`Instruction`), a method return (`Method`), or a variable (`Variable`).
 */
class DataFlowNode extends @cil_dataflow_node {
  /** Gets a textual representation of this data flow node. */
  abstract string toString();

  /** Gets the type of this data flow node. */
  Type getType() { none() }

  /**
   * Holds if this node flows to `sink` in one step.
   * `tt` is the tainting that occurs during this step.
   */
  deprecated predicate getALocalFlowSucc(DataFlowNode sink, TaintType tt) {
    localExactStep(this, sink) and tt = TExactValue()
    or
    localTaintStep(this, sink) and tt = TTaintedValue()
  }

  deprecated private predicate flowsToStep(DataFlowNode sink) {
    this.getALocalFlowSucc(sink, TExactValue())
  }

  /** Holds if this node flows to `sink` in zero or more steps. */
  deprecated predicate flowsTo(DataFlowNode sink) { this.flowsToStep*(sink) }

  /** Gets the method that contains this dataflow node. */
  Method getMethod() { none() }

  /** Gets the location of this dataflow node. */
  Location getLocation() { none() }
}

deprecated private newtype TTaintType =
  TExactValue() or
  TTaintedValue()

/** Describes how data is tainted. */
deprecated class TaintType extends TTaintType {
  string toString() {
    this = TExactValue() and result = "exact"
    or
    this = TTaintedValue() and result = "tainted"
  }
}

/** A taint type where the data is untainted. */
deprecated class Untainted extends TaintType, TExactValue { }

/** A taint type where the data is tainted. */
deprecated class Tainted extends TaintType, TTaintedValue { }

deprecated private predicate localFlowPhiInput(DataFlowNode input, Ssa::PhiNode phi) {
  exists(Ssa::Definition def, BasicBlock bb, int i | phi.hasLastInputRef(def, bb, i) |
    def.definesAt(_, bb, i) and
    input = def.getVariableUpdate().getSource()
    or
    input =
      any(ReadAccess ra |
        bb.getNode(i) = ra and
        ra.getTarget() = def.getSourceVariable()
      )
  )
  or
  exists(Ssa::PhiNode mid, BasicBlock bb, int i |
    localFlowPhiInput(input, mid) and
    phi.hasLastInputRef(mid, bb, i) and
    mid.definesAt(_, bb, i)
  )
}

deprecated private predicate localExactStep(DataFlowNode src, DataFlowNode sink) {
  src = sink.(Opcodes::Dup).getAnOperand()
  or
  exists(Ssa::Definition def, VariableUpdate vu |
    vu = def.getVariableUpdate() and
    src = vu.getSource() and
    sink = def.getAFirstRead()
  )
  or
  any(Ssa::Definition def).hasAdjacentReads(src, sink)
  or
  exists(Ssa::PhiNode phi |
    localFlowPhiInput(src, phi) and
    sink = phi.getAFirstRead()
  )
  or
  src = sink.(Conversion).getExpr()
  or
  src = sink.(WriteAccess).getExpr()
  or
  src = sink.(Method).getAnImplementation().getAnInstruction().(Return)
  or
  src = sink.(Return).getExpr()
  or
  src = sink.(ConditionalBranch).getAnOperand()
}

deprecated private predicate localTaintStep(DataFlowNode src, DataFlowNode sink) {
  src = sink.(BinaryArithmeticExpr).getAnOperand() or
  src = sink.(Opcodes::Neg).getOperand() or
  src = sink.(UnaryBitwiseOperation).getOperand()
}

/** A node that updates a variable. */
abstract class VariableUpdate extends DataFlowNode {
  /** Gets the value assigned, if any. */
  abstract DataFlowNode getSource();

  /** Gets the variable that is updated. */
  abstract Variable getVariable();

  /** Holds if this variable update happens at index `i` in basic block `bb`. */
  abstract predicate updatesAt(BasicBlock bb, int i);
}

private class MethodParameterDef extends VariableUpdate, MethodParameter {
  override MethodParameter getSource() { result = this }

  override MethodParameter getVariable() { result = this }

  override predicate updatesAt(BasicBlock bb, int i) {
    bb.(EntryBasicBlock).getANode().getImplementation().getMethod() = this.getMethod() and
    i = -1
  }
}

private class VariableWrite extends VariableUpdate, WriteAccess {
  override Expr getSource() { result = this.getExpr() }

  override Variable getVariable() { result = this.getTarget() }

  override predicate updatesAt(BasicBlock bb, int i) { this = bb.getNode(i) }
}

private class MethodOutOrRefTarget extends VariableUpdate, Call {
  int parameterIndex;

  MethodOutOrRefTarget() { this.getTarget().getRawParameter(parameterIndex).hasOutFlag() }

  override Variable getVariable() {
    result = this.getRawArgument(parameterIndex).(ReadAccess).getTarget()
  }

  override Expr getSource() { none() }

  override predicate updatesAt(BasicBlock bb, int i) { this = bb.getNode(i) }
}
