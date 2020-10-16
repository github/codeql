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
  exists(VariableUpdate vu | src = vu.getSource() | variableUpdateAdjacentUse(_, vu, sink))
  or
  adjacentUseUse(src, sink)
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

  /** Gets the maximum rank index for the given variable and basic block. */
  private int lastRank(StackVariable v, BasicBlock bb) { result = max(refRank(bb, _, v, _)) }

  /**
   * Holds if stack variable `v` is live at the beginning of basic block `bb`.
   */
  private predicate liveAtEntry(BasicBlock bb, StackVariable v) {
    // The first reference to `v` inside `bb` is a read
    refRank(bb, _, v, Read()) = 1
    or
    // There is no reference to `v` inside `bb`, but `v` is live at entry
    // to a successor basic block of `bb`
    not ref(bb, _, v, _) and
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

  /** Holds if `v` is defined or used in `bb`. */
  private predicate varOccursInBlock(StackVariable v, BasicBlock bb) {
    exists(refRank(bb, _, v, _))
  }

  /** Holds if `v` occurs in `bb` or one of `bb`'s transitive successors. */
  private predicate blockPrecedesVar(StackVariable v, BasicBlock bb) {
    varOccursInBlock(v, bb)
    or
    liveAtExit(bb, v)
  }

  /**
   * Holds if `bb2` is a transitive successor of `bb1` and `v` occurs in `bb1` and
   * in `bb2` or one of its transitive successors but not in any block on the path
   * between `bb1` and `bb2`.
   */
  private predicate varBlockReaches(StackVariable v, BasicBlock bb1, BasicBlock bb2) {
    varOccursInBlock(v, bb1) and
    bb2 = bb1.getASuccessor() and
    blockPrecedesVar(v, bb2)
    or
    exists(BasicBlock mid |
      varBlockReaches(v, bb1, mid) and
      bb2 = mid.getASuccessor() and
      not varOccursInBlock(v, mid) and
      blockPrecedesVar(v, bb2)
    )
  }

  /**
   * Holds if `bb2` is a transitive successor of `bb1` and `v` occurs in `bb1` and
   * `bb2` but not in any block on the path between `bb1` and `bb2`.
   */
  private predicate varBlockStep(StackVariable v, BasicBlock bb1, BasicBlock bb2) {
    varBlockReaches(v, bb1, bb2) and
    varOccursInBlock(v, bb2)
  }

  /**
   * Holds if `v` occurs at index `i1` in `bb1` and at index `i2` in `bb2` and
   * there is a path between them without any occurrence of `v`.
   */
  private predicate adjacentVarRefs(StackVariable v, BasicBlock bb1, int i1, BasicBlock bb2, int i2) {
    exists(int rankix |
      bb1 = bb2 and
      rankix = refRank(bb1, i1, v, _) and
      rankix + 1 = refRank(bb2, i2, v, _)
    )
    or
    lastRank(v, bb1) = refRank(bb1, i1, v, _) and
    varBlockStep(v, bb1, bb2) and
    1 = refRank(bb2, i2, v, _)
  }

  cached
  private module Cached {
    /** Holds if the variable update `vu` can be used at the adjacent read `use`. */
    cached
    predicate variableUpdateAdjacentUse(StackVariable v, VariableUpdate vu, ReadAccess use) {
      exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
        adjacentVarRefs(v, bb1, i1, bb2, i2) and
        vu = bb1.getNode(i1) and
        use = bb2.getNode(i2)
      )
    }

    /** Holds if `use1` and `use2` are adjacent reads of the same variable. */
    cached
    predicate adjacentUseUse(ReadAccess use1, ReadAccess use2) {
      exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
        adjacentVarRefs(_, bb1, i1, bb2, i2) and
        use1 = bb1.getNode(i1) and
        use2 = bb2.getNode(i2)
      )
    }
  }

  import Cached

  /** Holds if the variable update `vu` can be used at the read `use`. */
  deprecated predicate variableUpdateUse(StackVariable target, VariableUpdate vu, ReadAccess use) {
    exists(ReadAccess ra |
      variableUpdateAdjacentUse(target, vu, ra) and
      adjacentUseUse*(ra, use)
    )
  }

  /** Holds if the update `def` can be used at the read `use`. */
  deprecated predicate defUse(StackVariable target, Expr def, ReadAccess use) {
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
