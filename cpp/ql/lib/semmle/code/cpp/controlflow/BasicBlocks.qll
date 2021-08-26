/**
 * Provides a library for reasoning about control flow at the granularity of basic blocks.
 * This is usually much more efficient than reasoning directly at the level of `ControlFlowNode`s.
 */

import cpp
private import internal.PrimitiveBasicBlocks
private import internal.ConstantExprs
/*
 * `BasicBlock`s are refinements of `PrimitiveBasicBlock`s, taking
 * impossible CFG edges into account (using the `successors_adapted`
 * relation). The refinement manifests itself in two changes:
 *
 * - The successor relation on `BasicBlock`s uses `successors_adapted`
 * (instead of `successors_extended` used by `PrimtiveBasicBlock`s). Consequently,
 * some edges between `BasicBlock`s may be removed. Example:
 * ```
 * x = 1;      // s1
 * if (true) { // s2
 *   x = 2;    // s3
 * } else {
 *   x = 3;    // s4
 * }
 * ```
 * The `BasicBlock` successor edge from the basic block containing `s1`
 * and `s2` to the basic block containing `s4` is removed.
 *
 * - `PrimitiveBasicBlock`s may be split up into two or more
 * `BasicBlock`s: Internal nodes of `PrimitiveBasicBlock`s whose
 * predecessor edges have been removed (unreachable code) will be entry
 * points of new `BasicBlock`s. Consequently, each entry point of a
 * `PrimitiveBasicBlock` will also be an entry point of a `BasicBlock`,
 * but the converse does not necessarily hold. Example:
 * ```
 * x = 1;   // s5
 * abort(); // s6
 * x = 2;   // s7
 * ```
 * `s5`-`s7` belong to the same `PrimitiveBasicBlock`, but the CFG edge
 * from `s6` to `s7` is impossible, so `s7` will be the entry point of
 * its own (unreachable) `BasicBlock`.
 *
 * Note that, although possible, two or more `PrimitiveBasicBlock`s are
 * never merged to one `BasicBlock`: Consider the first example above;
 * it would be possible to define a single `BasicBlock` consisting of
 * `s1`-`s3`, however, the result would be counter-intuitive.
 */

private import Cached

cached
private module Cached {
  /**
   * Any node that is the entry point of a primitive basic block is
   * also the entry point of a basic block. In addition, all nodes
   * with a primitive successor, where the predecessor has been pruned
   * (that is, `getAPredecessor()` does not exist while a predecessor
   * using the primitive `successors_extended` relation does exist), is also
   * considered a basic block entry node.
   */
  cached
  predicate basic_block_entry_node(ControlFlowNode node) {
    primitive_basic_block_entry_node(node) or
    non_primitive_basic_block_entry_node(node)
  }

  private predicate non_primitive_basic_block_entry_node(ControlFlowNode node) {
    not primitive_basic_block_entry_node(node) and
    not exists(node.getAPredecessor()) and
    successors_extended(node, _)
  }

  /**
   * Holds if basic block `bb` equals a primitive basic block.
   *
   * There are two situations in which this is *not* the case:
   *
   * - Either the entry node of `bb` does not correspond to an
   *   entry node of a primitive basic block, or
   * - The primitive basic block with the same entry node contains
   *   a (non-entry) node which is the entry node of a non-primitive
   *   basic block (that is, the primitive basic block has been split
   *   up).
   *
   * This predicate is used for performance optimization only:
   * Whenever a `BasicBlock` equals a `PrimitiveBasicBlock`, we can
   * reuse predicates already computed for `PrimitiveBasicBlocks`.
   */
  private predicate equalsPrimitiveBasicBlock(BasicBlock bb) {
    primitive_basic_block_entry_node(bb) and
    not exists(int i |
      i > 0 and
      non_primitive_basic_block_entry_node(bb.(PrimitiveBasicBlock).getNode(i))
    )
  }

  /** Holds if `node` is the `pos`th control-flow node in basic block `bb`. */
  cached
  predicate basic_block_member(ControlFlowNode node, BasicBlock bb, int pos) {
    equalsPrimitiveBasicBlock(bb) and primitive_basic_block_member(node, bb, pos) // reuse already computed relation
    or
    non_primitive_basic_block_member(node, bb, pos)
  }

  private predicate non_primitive_basic_block_member(ControlFlowNode node, BasicBlock bb, int pos) {
    not equalsPrimitiveBasicBlock(bb) and node = bb and pos = 0
    or
    not node instanceof BasicBlock and
    exists(ControlFlowNode pred | successors_extended(pred, node) |
      non_primitive_basic_block_member(pred, bb, pos - 1)
    )
  }

  /** Gets the number of control-flow nodes in the basic block `bb`. */
  cached
  int bb_length(BasicBlock bb) {
    if equalsPrimitiveBasicBlock(bb)
    then result = bb.(PrimitiveBasicBlock).length() // reuse already computed relation
    else result = strictcount(ControlFlowNode node | basic_block_member(node, bb, _))
  }

  /** Successor relation for basic blocks. */
  cached
  predicate bb_successor_cached(BasicBlock pred, BasicBlock succ) {
    exists(ControlFlowNode last |
      basic_block_member(last, pred, bb_length(pred) - 1) and
      last.getASuccessor() = succ
    )
  }
}

predicate bb_successor = bb_successor_cached/2;

/**
 * A basic block in the C/C++ control-flow graph.
 *
 * A basic block is a simple sequence of control-flow nodes,
 * connected to each other and nothing else:
 *
 * ```
 *    A - B - C - D  ABCD is a basic block
 * ```
 *
 * Any incoming or outgoing edges break the block into two:
 *
 * ```
 *    A - B > C - D  AB is a basic block and CD is a basic block (C has two incoming edges)
 *
 *
 *    A - B < C - D  AB is a basic block and CD is a basic block (B has two outgoing edges)
 * ```
 */
class BasicBlock extends ControlFlowNodeBase {
  BasicBlock() { basic_block_entry_node(this) }

  /** Holds if this basic block contains `node`. */
  predicate contains(ControlFlowNode node) { basic_block_member(node, this, _) }

  /** Gets the `ControlFlowNode` at position `pos` in this basic block. */
  ControlFlowNode getNode(int pos) { basic_block_member(result, this, pos) }

  /** Gets a `ControlFlowNode` in this basic block. */
  ControlFlowNode getANode() { basic_block_member(result, this, _) }

  /** Gets a `BasicBlock` that is a direct successor of this basic block. */
  BasicBlock getASuccessor() { bb_successor(this, result) }

  /** Gets a `BasicBlock` that is a direct predecessor of this basic block. */
  BasicBlock getAPredecessor() { bb_successor(result, this) }

  /**
   * Gets a `BasicBlock` such that the control-flow edge `(this, result)` may be taken
   * when the outgoing edge of this basic block is an expression that is true.
   */
  BasicBlock getATrueSuccessor() { result.getStart() = this.getEnd().getATrueSuccessor() }

  /**
   * Gets a `BasicBlock` such that the control-flow edge `(this, result)` may be taken
   * when the outgoing edge of this basic block is an expression that is false.
   */
  BasicBlock getAFalseSuccessor() { result.getStart() = this.getEnd().getAFalseSuccessor() }

  /** Gets the final `ControlFlowNode` of this basic block. */
  ControlFlowNode getEnd() { basic_block_member(result, this, bb_length(this) - 1) }

  /** Gets the first `ControlFlowNode` of this basic block. */
  ControlFlowNode getStart() { result = this }

  /** Gets the number of `ControlFlowNode`s in this basic block. */
  int length() { result = bb_length(this) }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   *
   * Yields no result if this basic block spans multiple source files.
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    hasLocationInfoInternal(filepath, startline, startcolumn, filepath, endline, endcolumn)
  }

  pragma[noinline]
  private predicate hasLocationInfoInternal(
    string file, int line, int col, string endf, int endl, int endc
  ) {
    this.getStart().getLocation().hasLocationInfo(file, line, col, _, _) and
    this.getEnd().getLocation().hasLocationInfo(endf, _, _, endl, endc)
  }

  /** Gets the function containing this basic block. */
  Function getEnclosingFunction() { result = this.getStart().getControlFlowScope() }

  /**
   * Holds if this basic block is in a loop of the control-flow graph. This
   * includes loops created by `goto` statements. This predicate may not hold
   * even if this basic block is syntactically inside a `while` loop if the
   * necessary back edges are unreachable.
   */
  predicate inLoop() { this.getASuccessor+() = this }

  /**
   * DEPRECATED since version 1.11: this predicate does not match the standard
   * definition of _loop header_.
   *
   * Holds if this basic block is in a loop of the control-flow graph and
   * additionally has an incoming edge that is not part of any loop containing
   * this basic block. A typical example would be the basic block that computes
   * `x > 0` in an outermost loop `while (x > 0) { ... }`.
   */
  deprecated predicate isLoopHeader() {
    this.inLoop() and
    exists(BasicBlock pred | pred = this.getAPredecessor() and not pred = this.getASuccessor+())
  }

  /**
   * Holds if control flow may reach this basic block from a function entry
   * point or any handler of a reachable `try` statement.
   */
  predicate isReachable() {
    exists(Function f | f.getBlock() = this)
    or
    exists(TryStmt t, BasicBlock tryblock |
      // a `Handler` preceeds the `CatchBlock`, and is always the beginning
      // of a new `BasicBlock` (see `primitive_basic_block_entry_node`).
      this.(Handler).getTryStmt() = t and
      tryblock.isReachable() and
      tryblock.contains(t)
    )
    or
    exists(BasicBlock pred | pred.getASuccessor() = this and pred.isReachable())
  }

  /** Means `not isReachable()`. */
  predicate isUnreachable() { not this.isReachable() }
}

/** Correct relation for reachability of ControlFlowNodes. */
predicate unreachable(ControlFlowNode n) {
  exists(BasicBlock bb | bb.contains(n) and bb.isUnreachable())
}

/**
 * An entry point of a function.
 */
class EntryBasicBlock extends BasicBlock {
  EntryBasicBlock() { exists(Function f | this = f.getEntryPoint()) }
}

/**
 * A basic block whose last node is the exit point of a function.
 */
class ExitBasicBlock extends BasicBlock {
  ExitBasicBlock() {
    getEnd() instanceof Function or
    aborting(getEnd())
  }
}
