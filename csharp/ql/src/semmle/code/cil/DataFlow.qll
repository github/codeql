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
  predicate getALocalFlowSucc(DataFlowNode sink, TaintType tt) {
    localExactStep(this, sink) and tt = TExactValue()
    or
    localTaintStep(this, sink) and tt = TTaintedValue()
  }

  private predicate flowsToStep(DataFlowNode sink) { this.getALocalFlowSucc(sink, TExactValue()) }

  /** Holds if this node flows to `sink` in zero or more steps. */
  predicate flowsTo(DataFlowNode sink) { this.flowsToStep*(sink) }

  /** Gets the method that contains this dataflow node. */
  Method getMethod() { none() }

  /** Gets the location of this dataflow node. */
  Location getLocation() { none() }
}

private newtype TTaintType =
  TExactValue() or
  TTaintedValue()

/** Describes how data is tainted. */
class TaintType extends TTaintType {
  string toString() {
    this = TExactValue() and result = "exact"
    or
    this = TTaintedValue() and result = "tainted"
  }
}

/** A taint type where the data is untainted. */
class Untainted extends TaintType, TExactValue { }

/** A taint type where the data is tainted. */
class Tainted extends TaintType, TTaintedValue { }

private predicate localExactStep(DataFlowNode src, DataFlowNode sink) {
  src = sink.(Opcodes::Dup).getAnOperand()
  or
  defUse(_, src, sink)
  or
  src = sink.(ParameterReadAccess).getTarget()
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
  or
  src = sink.(Parameter).getAWrite()
  or
  exists(VariableUpdate update |
    update.getVariable().(Parameter) = sink and src = update.getSource()
  )
}

private predicate localTaintStep(DataFlowNode src, DataFlowNode sink) {
  src = sink.(BinaryArithmeticExpr).getAnOperand() or
  src = sink.(Opcodes::Neg).getOperand() or
  src = sink.(UnaryBitwiseOperation).getOperand()
}

cached
module DefUse {
  /**
   * A classification of variable references into reads and writes.
   */
  private newtype RefKind =
    Read() or
    Write()

  /**
   * Holds if the `i`th node of basic block `bb` is a reference to `v`,
   * either a read (when `k` is `Read()`) or a write (when `k` is `Write()`).
   */
  private predicate ref(BasicBlock bb, int i, StackVariable v, RefKind k) {
    exists(ReadAccess ra | bb.getNode(i) = ra |
      ra.getTarget() = v and
      k = Read()
    )
    or
    exists(VariableUpdate vu | bb.getNode(i) = vu |
      vu.getVariable() = v and
      k = Write()
    )
  }

  /**
   * Gets the (1-based) rank of the reference to `v` at the `i`th node of
   * basic block `bb`, which has the given reference kind `k`.
   */
  private int refRank(BasicBlock bb, int i, StackVariable v, RefKind k) {
    i = rank[result](int j | ref(bb, j, v, _)) and
    ref(bb, i, v, k)
  }

  /**
   * Holds if stack variable `v` is live at the beginning of basic block `bb`.
   */
  private predicate liveAtEntry(BasicBlock bb, StackVariable v) {
    // The first reference to `v` inside `bb` is a read
    refRank(bb, _, v, Read()) = 1
    or
    // There is no reference to `v` inside `bb`, but `v` is live at entry
    // to a successor basic block of `bb`
    not exists(refRank(bb, _, v, _)) and
    liveAtExit(bb, v)
  }

  /**
   * Holds if stack variable `v` is live at the end of basic block `bb`.
   */
  private predicate liveAtExit(BasicBlock bb, StackVariable v) {
    liveAtEntry(bb.getASuccessor(), v)
  }

  /**
   * Holds if the variable update `vu` reaches rank index `rankix`
   * in its own basic block `bb`.
   */
  private predicate defReachesRank(BasicBlock bb, VariableUpdate vu, int rankix, StackVariable v) {
    exists(int i |
      rankix = refRank(bb, i, v, Write()) and
      vu = bb.getNode(i)
    )
    or
    defReachesRank(bb, vu, rankix - 1, v) and
    rankix = refRank(bb, _, v, Read())
  }

  /**
   * Holds if the variable update `vu` of stack variable `v` reaches the
   * end of a basic block `bb`, at which point it is still live, without
   * crossing another update.
   */
  private predicate defReachesEndOfBlock(BasicBlock bb, VariableUpdate vu, StackVariable v) {
    liveAtExit(bb, v) and
    (
      exists(int last | last = max(refRank(bb, _, v, _)) | defReachesRank(bb, vu, last, v))
      or
      defReachesStartOfBlock(bb, vu, v) and
      not exists(refRank(bb, _, v, Write()))
    )
  }

  pragma[noinline]
  private predicate defReachesStartOfBlock(BasicBlock bb, VariableUpdate vu, StackVariable v) {
    defReachesEndOfBlock(bb.getAPredecessor(), vu, v)
  }

  /**
   * Holds if the variable update `vu` of stack variable `v` reaches `read` in the
   * same basic block without crossing another update of `v`.
   */
  private predicate defReachesReadWithinBlock(StackVariable v, VariableUpdate vu, ReadAccess read) {
    exists(BasicBlock bb, int rankix, int i |
      defReachesRank(bb, vu, rankix, v) and
      rankix = refRank(bb, i, v, Read()) and
      read = bb.getNode(i)
    )
  }

  /** Holds if the variable update `vu` can be used at the read `use`. */
  cached
  predicate variableUpdateUse(StackVariable target, VariableUpdate vu, ReadAccess use) {
    defReachesReadWithinBlock(target, vu, use)
    or
    exists(BasicBlock bb, int i |
      exists(refRank(bb, i, target, Read())) and
      use = bb.getNode(i) and
      defReachesEndOfBlock(bb.getAPredecessor(), vu, target) and
      not defReachesReadWithinBlock(target, _, use)
    )
  }

  /** Holds if the update `def` can be used at the read `use`. */
  cached
  predicate defUse(StackVariable target, Expr def, ReadAccess use) {
    exists(VariableUpdate vu | def = vu.getSource() | variableUpdateUse(target, vu, use))
  }
}

private import DefUse

abstract library class VariableUpdate extends Instruction {
  abstract Expr getSource();

  abstract Variable getVariable();
}

private class VariableWrite extends VariableUpdate, WriteAccess {
  override Expr getSource() { result = getExpr() }

  override Variable getVariable() { result = getTarget() }
}

private class MethodOutOrRefTarget extends VariableUpdate, Call {
  int parameterIndex;

  MethodOutOrRefTarget() { this.getTarget().getRawParameter(parameterIndex).hasOutFlag() }

  override Variable getVariable() {
    result = this.getRawArgument(parameterIndex).(ReadAccess).getTarget()
  }

  override Expr getSource() { result = this }
}
