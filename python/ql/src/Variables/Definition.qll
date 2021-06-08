import python

/**
 * A control-flow node that defines a variable
 */
class Definition extends NameNode, DefinitionNode {
  /**
   * The variable defined by this control-flow node.
   */
  Variable getVariable() { this.defines(result) }

  /**
   * The SSA variable corresponding to the current definition. Since SSA variables
   * are only generated for definitions with at least one use, not all definitions
   * will have an SSA variable.
   */
  SsaVariable getSsaVariable() { result.getDefinition() = this }

  /**
   * The index of this definition in its basic block.
   */
  private int indexInBB(BasicBlock bb, Variable v) {
    v = this.getVariable() and
    this = bb.getNode(result)
  }

  /**
   * The rank of this definition among other definitions of the same variable
   * in its basic block. The first definition will have rank 1, and subsequent
   * definitions will have sequentially increasing ranks.
   */
  private int rankInBB(BasicBlock bb, Variable v) {
    exists(int defIdx | defIdx = this.indexInBB(bb, v) |
      defIdx = rank[result](int idx, Definition def | idx = def.indexInBB(bb, v) | idx)
    )
  }

  /** Is this definition the first in its basic block for its variable? */
  predicate isFirst() { this.rankInBB(_, _) = 1 }

  /** Is this definition the last in its basic block for its variable? */
  predicate isLast() {
    exists(BasicBlock b, Variable v |
      this.rankInBB(b, v) = max(Definition other | any() | other.rankInBB(b, v))
    )
  }

  /**
   * Is this definition unused? A definition is unused if the value it provides
   * is not read anywhere.
   */
  predicate isUnused() {
    // SSA variables only exist for definitions that have at least one use.
    not exists(this.getSsaVariable()) and
    // If a variable is used in a foreign scope, all bets are off.
    not this.getVariable().escapes() and
    // Global variables don't have SSA variables unless the scope is global.
    this.getVariable().getScope() = this.getScope() and
    // A call to locals() or vars() in the variable scope counts as a use
    not exists(Function f, Call c, string locals_or_vars |
      c.getScope() = f and
      this.getScope() = f and
      c.getFunc().(Name).getId() = locals_or_vars
    |
      locals_or_vars = "locals" or locals_or_vars = "vars"
    )
  }

  /**
   * An immediate re-definition of this definition's variable.
   */
  Definition getARedef() {
    result != this and
    exists(Variable var | var = this.getVariable() and var = result.getVariable() |
      // Definitions in different basic blocks.
      this.isLast() and
      reaches_without_redef(var, this.getBasicBlock(), result.getBasicBlock()) and
      result.isFirst()
    )
    or
    // Definitions in the same basic block.
    exists(BasicBlock common, Variable var |
      this.rankInBB(common, var) + 1 = result.rankInBB(common, var)
    )
  }

  /**
   * We only consider assignments as potential alert targets, not parameters
   * and imports and other name-defining constructs.
   * We also ignore anything named "_", "empty", "unused" or "dummy"
   */
  predicate isRelevant() {
    exists(AstNode p | p = this.getNode().getParentNode() |
      p instanceof Assign or p instanceof AugAssign or p instanceof Tuple
    ) and
    not name_acceptable_for_unused_variable(this.getVariable()) and
    /* Decorated classes and functions are used */
    not exists(this.getNode().getParentNode().(FunctionDef).getDefinedFunction().getADecorator()) and
    not exists(this.getNode().getParentNode().(ClassDef).getDefinedClass().getADecorator())
  }
}

/**
 * Check whether basic block `a` reaches basic block `b` without an intervening
 * definition of variable `v`. The relation is not transitive by default, so any
 * observed transitivity will be caused by loops in the control-flow graph.
 */
private predicate reaches_without_redef(Variable v, BasicBlock a, BasicBlock b) {
  exists(Definition def | a.getASuccessor() = b |
    def.getBasicBlock() = a and def.getVariable() = v and maybe_redefined(v)
  )
  or
  exists(BasicBlock mid | reaches_without_redef(v, a, mid) |
    not exists(NameNode cfn | cfn.defines(v) | cfn.getBasicBlock() = mid) and
    mid.getASuccessor() = b
  )
}

private predicate maybe_redefined(Variable v) { strictcount(Definition d | d.defines(v)) > 1 }

predicate name_acceptable_for_unused_variable(Variable var) {
  exists(string name | var.getId() = name |
    name.regexpMatch("_+") or
    name = "empty" or
    name.matches("%unused%") or
    name = "dummy" or
    name.regexpMatch("__.*")
  )
}

class ListComprehensionDeclaration extends ListComp {
  Name getALeakedVariableUse() {
    major_version() = 2 and
    this.getIterationVariable(_).getId() = result.getId() and
    result.getScope() = this.getScope() and
    this.getAFlowNode().strictlyReaches(result.getAFlowNode()) and
    result.isUse()
  }

  Name getDefinition() { result = this.getIterationVariable(0).getAStore() }
}
