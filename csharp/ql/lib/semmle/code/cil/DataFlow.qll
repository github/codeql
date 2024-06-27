/**
 * Provides a collection of building blocks and utilities for data flow.
 */

private import CIL

/**
 * A node in the data flow graph.
 *
 * Either an instruction (`Instruction`), a method return (`Method`), or a variable (`Variable`).
 */
deprecated class DataFlowNode extends @cil_dataflow_node {
  /** Gets a textual representation of this data flow node. */
  abstract string toString();

  /** Gets the type of this data flow node. */
  Type getType() { none() }

  /** Gets the method that contains this dataflow node. */
  Method getMethod() { none() }

  /** Gets the location of this dataflow node. */
  Location getLocation() { none() }
}

/** A node that updates a variable. */
abstract deprecated class VariableUpdate extends DataFlowNode {
  /** Gets the value assigned, if any. */
  abstract DataFlowNode getSource();

  /** Gets the variable that is updated. */
  abstract Variable getVariable();

  /** Holds if this variable update happens at index `i` in basic block `bb`. */
  abstract predicate updatesAt(BasicBlock bb, int i);
}

deprecated private class MethodParameterDef extends VariableUpdate, MethodParameter {
  override MethodParameter getSource() { result = this }

  override MethodParameter getVariable() { result = this }

  override predicate updatesAt(BasicBlock bb, int i) {
    bb.(EntryBasicBlock).getANode().getImplementation().getMethod() = this.getMethod() and
    i = -1
  }
}

deprecated private class VariableWrite extends VariableUpdate, WriteAccess {
  override Expr getSource() { result = this.getExpr() }

  override Variable getVariable() { result = this.getTarget() }

  override predicate updatesAt(BasicBlock bb, int i) { this = bb.getNode(i) }
}

deprecated private class MethodOutOrRefTarget extends VariableUpdate, Call {
  int parameterIndex;

  MethodOutOrRefTarget() { this.getTarget().getRawParameter(parameterIndex).hasOutFlag() }

  override Variable getVariable() {
    result = this.getRawArgument(parameterIndex).(ReadAccess).getTarget()
  }

  override Expr getSource() { none() }

  override predicate updatesAt(BasicBlock bb, int i) { this = bb.getNode(i) }
}
