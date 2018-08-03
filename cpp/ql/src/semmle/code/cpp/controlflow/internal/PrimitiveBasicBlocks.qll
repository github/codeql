/**
 * INTERNAL: use the `BasicBlocks` library instead.
 * This library defines `PrimitiveBasicBlock`s, an intermediate stage in the
 * computation of `BasicBlock`s.
 */
/*
 * Unlike `BasicBlock`s, `PrimitiveBasicBlock`s are constructed using
 * the primitive `successors_extended` relation only. That is, impossible
 * edges removed in `successors_adapted` are still taken into account.
 *
 * `PrimitiveBasicBlock`s are used as helper entities for actually
 * constructing `successors_adapted`, hence the need for two "layers"
 * of basic blocks. In addition to being used to construct
 * `successors_adapted`, the relations for `BasicBlocks` (e.g.,
 * `basic_block_entry_node`) can reuse the relations computed here
 * (e.g, `primitive_basic_block_entry_node`), as most `BasicBlock`s
 * will coincide with `PrimitiveBasicBlock`s.
 */
import cpp

import Cached
private cached module Cached {
  /** Holds if `node` is the entry node of a primitive basic block. */
  cached
  predicate primitive_basic_block_entry_node(ControlFlowNode node) {
    // The entry point of the CFG is the start of a BB.
    exists (Function f | f.getEntryPoint() = node)

    // If the node has more than one predecessor,
    // or the node's predecessor has more than one successor,
    // then the node is the start of a new primitive basic block.
    or
    strictcount (ControlFlowNode pred, ControlFlowNode other
    | successors_extended(unresolveElement(pred),unresolveElement(node)) and successors_extended(unresolveElement(pred),unresolveElement(other))) > 1

    // If the node has zero predecessors then it is the start of
    // a BB. However, the C++ AST contains many nodes with zero
    // predecessors and zero successors, which are not members of
    // the CFG. So we exclude all of those trivial BBs by requiring
    // that the node have at least one successor.
    or
    (not successors_extended(_, unresolveElement(node)) and successors_extended(unresolveElement(node), _))
  }

  /** Holds if `node` is the `pos`th control-flow node in primitive basic block `bb`. */
  cached
  predicate primitive_basic_block_member(ControlFlowNode node, PrimitiveBasicBlock bb, int pos) {
    (node = mkElement(bb) and pos = 0)
    or
    (not (unresolveElement(node) instanceof PrimitiveBasicBlock) and
     exists (ControlFlowNode pred
     | successors_extended(unresolveElement(pred),unresolveElement(node))
     | primitive_basic_block_member(pred, bb, pos - 1)))
  }

  /** Gets the number of control-flow nodes in the primitive basic block `bb`. */
  cached
  int primitive_bb_length(PrimitiveBasicBlock bb) {
    result = strictcount(ControlFlowNode node | primitive_basic_block_member(node, bb, _))
  }

  /** Successor relation for primitive basic blocks. */
  cached
  predicate primitive_bb_successor(PrimitiveBasicBlock pred, PrimitiveBasicBlock succ) {
    exists(ControlFlowNode last |
      primitive_basic_block_member(last, pred, primitive_bb_length(pred)-1) and
      successors_extended(unresolveElement(last), succ)
    )
  }
}

/**
 * A primitive basic block in the C/C++ control-flow graph constructed using
 * the primitive `successors_extended` relation only.
 */
class PrimitiveBasicBlock extends @cfgnode {

  PrimitiveBasicBlock() {
    primitive_basic_block_entry_node(mkElement(this))
  }

  /** Gets a textual representation of this element. */
  string toString() {
    result = "PrimitiveBasicBlock"
  }

  predicate contains(ControlFlowNode node) {
    primitive_basic_block_member(node, this, _)
  }

  ControlFlowNode getNode(int pos) {
    primitive_basic_block_member(result, this, pos)
  }

  ControlFlowNode getANode() {
    primitive_basic_block_member(result, this, _)
  }

  PrimitiveBasicBlock getASuccessor() {
    primitive_bb_successor(this, result)
  }

  PrimitiveBasicBlock getAPredecessor() {
    primitive_bb_successor(result, this)
  }

  int length() {
    result = primitive_bb_length(this)
  }
}
