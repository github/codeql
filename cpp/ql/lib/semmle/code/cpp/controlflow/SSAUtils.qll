/**
 * Provides classes and predicates for use in the SSA library.
 */

import cpp
import semmle.code.cpp.controlflow.Dominance
import semmle.code.cpp.controlflow.SSA // must be imported for proper caching of SSAHelper
import semmle.code.cpp.rangeanalysis.RangeSSA // must be imported for proper caching of SSAHelper

/**
 * The dominance frontier of a block `x` is the set of all blocks `w` such that
 * `x` dominates a predecessor of `w` but does not strictly dominate `w`.
 *
 * This implementation is equivalent to:
 *
 *     bbDominates(x, w.getAPredecessor()) and not bbStrictlyDominates(x, w)
 */
private predicate dominanceFrontier(BasicBlock x, BasicBlock w) {
  x = w.getAPredecessor() and not bbIDominates(x, w)
  or
  exists(BasicBlock prev | dominanceFrontier(prev, w) |
    bbIDominates(x, prev) and
    not bbIDominates(x, w)
  )
}

/**
 * Extended version of `definition` that also includes parameters.
 */
predicate var_definition(StackVariable v, ControlFlowNode node) {
  not addressTakenVariable(v) and
  not unreachable(node) and
  (
    if isReferenceVar(v)
    then
      // Assignments to reference variables modify the referenced
      // value, not the reference itself. So reference variables only
      // have two kinds of definition: initializers and parameters.
      node = v.getInitializer().getExpr()
    else definition(v, node)
  )
  or
  v instanceof Parameter and
  exists(BasicBlock b |
    b.getStart() = node and
    not exists(b.getAPredecessor()) and
    b = v.(Parameter).getFunction().getEntryPoint()
  )
}

/**
 * Stack variables that have their address taken are excluded from the
 * analysis because the pointer could be used to change the value at
 * any moment.
 */
private predicate addressTakenVariable(StackVariable var) {
  // If the type of the variable is a reference type, then it is safe (as
  // far as SSA is concerned) to take its address, because this does not
  // enable the variable to be modified indirectly. Obviously the
  // referenced value can change, but that is not the same thing as
  // changing which value the reference points to. SSA tracks the latter,
  // but the target of a reference is immutable so reference variables
  // always have exactly one definition.
  not isReferenceVar(var) and
  // Find a VariableAccess that takes the address of `var`.
  exists(VariableAccess va |
    va = var.getAnAccess() and
    va.isAddressOfAccessNonConst() and
    // If the address is passed to a function then we will trust that it
    // is only used to modify the variable for the duration of the
    // function call.
    not exists(Call call | call.passesByReferenceNonConst(_, va))
  )
}

/**
 * Holds if `v` is a stack-allocated reference-typed local variable. We don't
 * build SSA for such variables since they are likely to change values even
 * when not syntactically mentioned. For the same reason,
 * `addressTakenVariable` is used to prevent tracking variables that may be
 * aliased by such a reference.
 *
 * Reference-typed parameters are treated as if they weren't references.
 * That's because it's in practice highly unlikely that they alias other data
 * accessible from the function body.
 */
private predicate isReferenceVar(StackVariable v) {
  v.getUnspecifiedType() instanceof ReferenceType and
  not v instanceof Parameter
}

/**
 * This predicate is the same as `var_definition`, but annotated with
 * the basic block and index of the control flow node.
 */
private predicate variableUpdate(StackVariable v, ControlFlowNode n, BasicBlock b, int i) {
  var_definition(v, n) and n = b.getNode(i)
}

private predicate ssa_use(StackVariable v, VariableAccess node, BasicBlock b, int index) {
  useOfVar(v, node) and b.getNode(index) = node
}

private predicate live_at_start_of_bb(StackVariable v, BasicBlock b) {
  exists(int i | ssa_use(v, _, b, i) | not exists(int j | variableUpdate(v, _, b, j) | j < i))
  or
  live_at_exit_of_bb(v, b) and not variableUpdate(v, _, b, _)
}

pragma[noinline]
private predicate live_at_exit_of_bb(StackVariable v, BasicBlock b) {
  live_at_start_of_bb(v, b.getASuccessor())
}

/** Common SSA logic for standard SSA and range-analysis SSA. */
cached
library class SSAHelper extends int {
  /* 0 = StandardSSA, 1 = RangeSSA */
  cached
  SSAHelper() { this in [0 .. 1] }

  /**
   * Override to insert a custom phi node for variable `v` at the start of
   * basic block `b`.
   */
  cached
  predicate custom_phi_node(StackVariable v, BasicBlock b) { none() }

  /**
   * Remove any custom phi nodes that are invalid.
   */
  private predicate sanitized_custom_phi_node(StackVariable v, BasicBlock b) {
    custom_phi_node(v, b) and
    not addressTakenVariable(v) and
    not isReferenceVar(v) and
    b.isReachable()
  }

  /**
   * Holds if there is a phi node for variable `v` at the start of basic block
   * `b`.
   */
  cached
  predicate phi_node(StackVariable v, BasicBlock b) {
    frontier_phi_node(v, b) or sanitized_custom_phi_node(v, b)
  }

  /**
   * A phi node is required for variable `v` at the start of basic block `b`
   * if there exists a basic block `x` such that `b` is in the dominance
   * frontier of `x` and `v` is defined in `x` (including phi-nodes as
   * definitions).  This is known as the iterated dominance frontier.  See
   * Modern Compiler Implementation by Andrew Appel.
   */
  private predicate frontier_phi_node(StackVariable v, BasicBlock b) {
    exists(BasicBlock x | dominanceFrontier(x, b) and ssa_defn_rec(v, x)) and
    /* We can also eliminate those nodes where the variable is not live on any incoming edge */
    live_at_start_of_bb(v, b)
  }

  private predicate ssa_defn_rec(StackVariable v, BasicBlock b) {
    phi_node(v, b)
    or
    variableUpdate(v, _, b, _)
  }

  /**
   * Holds if `v` is defined, for the purpose of SSA, at `node`, which is at
   * position `index` in block `b`. This includes definitions from phi nodes.
   */
  cached
  predicate ssa_defn(StackVariable v, ControlFlowNode node, BasicBlock b, int index) {
    phi_node(v, b) and b.getStart() = node and index = -1
    or
    variableUpdate(v, node, b, index)
  }

  /*
   * The construction of SSA form ensures that each use of a variable is
   * dominated by its definition. A definition of an SSA variable therefore
   * reaches a `ControlFlowNode` if it is the _closest_ SSA variable definition
   * that dominates the node. If two definitions dominate a node then one must
   * dominate the other, so therefore the definition of _closest_ is given by the
   * dominator tree. Thus, reaching definitions can be calculated in terms of
   * dominance.
   */

  /**
   * A ranking of the indices `i` at which there is an SSA definition or use of
   * `v` in the basic block `b`.
   *
   * Basic block indices are translated to rank indices in order to skip
   * irrelevant indices at which there is no definition or use when traversing
   * basic blocks.
   */
  private predicate defUseRank(StackVariable v, BasicBlock b, int rankix, int i) {
    i = rank[rankix](int j | ssa_defn(v, _, b, j) or ssa_use(v, _, b, j))
  }

  /**
   * Gets the maximum rank index for the given variable `v` and basic block
   * `b`. This will be the number of defs/uses of `v` in `b` plus one, where
   * the extra rank at the end represents a position past the last node in
   * the block.
   */
  private int lastRank(StackVariable v, BasicBlock b) {
    result = max(int rankix | defUseRank(v, b, rankix, _)) + 1
  }

  /**
   * Holds if SSA variable `(v, def)` is defined at rank index `rankix` in
   * basic block `b`.
   */
  private predicate ssaDefRank(StackVariable v, ControlFlowNode def, BasicBlock b, int rankix) {
    exists(int i |
      ssa_defn(v, def, b, i) and
      defUseRank(v, b, rankix, i)
    )
  }

  /**
   * Holds if SSA variable `(v, def)` reaches the rank index `rankix` in its
   * own basic block `b` before being overwritten by another definition of
   * `v` that comes _at or after_ the reached node. Reaching a node means
   * that the definition is visible to any _use_ at that node.
   */
  private predicate ssaDefReachesRank(StackVariable v, ControlFlowNode def, BasicBlock b, int rankix) {
    // A definition should not reach its own node unless a loop allows it.
    // When nodes are both definitions and uses for the same variable, the
    // use is understood to happen _before_ the definition. Phi nodes are
    // at rankidx -1 and will therefore always reach the first node in the
    // basic block.
    ssaDefRank(v, def, b, rankix - 1)
    or
    ssaDefReachesRank(v, def, b, rankix - 1) and
    rankix <= lastRank(v, b) and // Without this, the predicate would be infinite.
    not ssaDefRank(v, _, b, rankix - 1) // Range is inclusive of but not past next def.
  }

  /** Holds if SSA variable `(v, def)` reaches the end of block `b`. */
  cached
  predicate ssaDefinitionReachesEndOfBB(StackVariable v, ControlFlowNode def, BasicBlock b) {
    live_at_exit_of_bb(v, b) and ssaDefReachesRank(v, def, b, lastRank(v, b))
    or
    exists(BasicBlock idom |
      ssaDefinitionReachesEndOfBB(v, def, idom) and
      noDefinitionsSinceIDominator(v, idom, b)
    )
  }

  /**
   * Helper predicate for ssaDefinitionReachesEndOfBB. If there is no
   * definition of `v` in basic block `b`, then any definition of `v`
   * that reaches the end of `idom` (the immediate dominator of `b`) also
   * reaches the end of `b`.
   */
  pragma[noinline]
  private predicate noDefinitionsSinceIDominator(StackVariable v, BasicBlock idom, BasicBlock b) {
    bbIDominates(idom, b) and // It is sufficient to traverse the dominator graph, cf. discussion above.
    live_at_exit_of_bb(v, b) and
    not ssa_defn(v, _, b, _)
  }

  /**
   * Holds if SSA variable `(v, def)` reaches `use` within the same basic
   * block, where `use` is a `VariableAccess` of `v`.
   */
  private predicate ssaDefinitionReachesUseWithinBB(StackVariable v, ControlFlowNode def, Expr use) {
    exists(BasicBlock b, int rankix, int i |
      ssaDefReachesRank(v, def, b, rankix) and
      defUseRank(v, b, rankix, i) and
      ssa_use(v, use, b, i)
    )
  }

  /**
   * Holds if SSA variable `(v, def)` reaches the control-flow node `use`.
   */
  private predicate ssaDefinitionReaches(StackVariable v, ControlFlowNode def, Expr use) {
    ssaDefinitionReachesUseWithinBB(v, def, use)
    or
    exists(BasicBlock b |
      ssa_use(v, use, b, _) and
      ssaDefinitionReachesEndOfBB(v, def, b.getAPredecessor()) and
      not ssaDefinitionReachesUseWithinBB(v, _, use)
    )
  }

  /**
   * Gets a string representation of the SSA variable represented by the pair
   * `(node, v)`.
   */
  cached
  string toString(ControlFlowNode node, StackVariable v) {
    if phi_node(v, node.(BasicBlock))
    then result = "SSA phi(" + v.getName() + ")"
    else (
      ssa_defn(v, node, _, _) and result = "SSA def(" + v.getName() + ")"
    )
  }

  /**
   * Holds if SSA variable `(v, def)` reaches `result`, where `result` is an
   * access of `v`.
   */
  cached
  VariableAccess getAUse(ControlFlowNode def, StackVariable v) {
    ssaDefinitionReaches(v, def, result) and
    ssa_use(v, result, _, _)
  }
}
