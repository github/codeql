/**
 * Provides the module `Ssa` for working with static single assignment (SSA) form.
 */

/**
 * Provides classes for working with static single assignment (SSA) form.
 */
module Ssa {
  private import rust
  private import codeql.rust.controlflow.BasicBlocks
  private import codeql.rust.controlflow.ControlFlowGraph
  private import codeql.rust.controlflow.internal.ControlFlowGraphImpl as CfgImpl
  private import internal.SsaImpl as SsaImpl

  /** A variable amenable to SSA construction. */
  class Variable = SsaImpl::SsaInput::SourceVariable;

  /** A static single assignment (SSA) definition. */
  class Definition extends SsaImpl::Definition {
    /**
     * Gets the control flow node of this SSA definition, if any. Phi nodes are
     * examples of SSA definitions without a control flow node, as they are
     * modeled at index `-1` in the relevant basic block.
     */
    final CfgNode getControlFlowNode() {
      exists(BasicBlock bb, int i | this.definesAt(_, bb, i) | result = bb.getNode(i))
    }

    /**
     * Gets a control-flow node that reads the value of this SSA definition.
     *
     * Example:
     *
     * ```rb
     * def m b        # defines b_0
     *   i = 0        # defines i_0
     *   puts i       # reads i_0
     *   puts i + 1   # reads i_0
     *   if b         # reads b_0
     *     i = 1      # defines i_1
     *     puts i     # reads i_1
     *     puts i + 1 # reads i_1
     *   else
     *     i = 2      # defines i_2
     *     puts i     # reads i_2
     *     puts i + 1 # reads i_2
     *   end
     *                # defines i_3 = phi(i_1, i_2)
     *   puts i       # reads i3
     * end
     * ```
     */
    final CfgNode getARead() { result = SsaImpl::getARead(this) }

    /**
     * Gets a first control-flow node that reads the value of this SSA definition.
     * That is, a read that can be reached from this definition without passing
     * through other reads.
     *
     * Example:
     *
     * ```rb
     * def m b        # defines b_0
     *   i = 0        # defines i_0
     *   puts i       # first read of i_0
     *   puts i + 1
     *   if b         # first read of b_0
     *     i = 1      # defines i_1
     *     puts i     # first read of i_1
     *     puts i + 1
     *   else
     *     i = 2      # defines i_2
     *     puts i     # first read of i_2
     *     puts i + 1
     *   end
     *                # defines i_3 = phi(i_1, i_2)
     *   puts i       # first read of i3
     * end
     * ```
     */
    final CfgNode getAFirstRead() { SsaImpl::firstRead(this, result) }

    /**
     * Gets a last control-flow node that reads the value of this SSA definition.
     * That is, a read that can reach the end of the enclosing CFG scope, or another
     * SSA definition for the source variable, without passing through any other read.
     *
     * Example:
     *
     * ```rb
     * def m b        # defines b_0
     *   i = 0        # defines i_0
     *   puts i
     *   puts i + 1   # last read of i_0
     *   if b         # last read of b_0
     *     i = 1      # defines i_1
     *     puts i
     *     puts i + 1 # last read of i_1
     *   else
     *     i = 2      # defines i_2
     *     puts i
     *     puts i + 1 # last read of i_2
     *   end
     *                # defines i_3 = phi(i_1, i_2)
     *   puts i       # last read of i3
     * end
     * ```
     */
    final CfgNode getALastRead() { SsaImpl::lastRead(this, result) }

    /**
     * Holds if `read1` and `read2` are adjacent reads of this SSA definition.
     * That is, `read2` can be reached from `read1` without passing through
     * another read.
     *
     * Example:
     *
     * ```rb
     * def m b
     *   i = 0        # defines i_0
     *   puts i       # reads i_0 (read1)
     *   puts i + 1   # reads i_0 (read2)
     *   if b
     *     i = 1      # defines i_1
     *     puts i     # reads i_1 (read1)
     *     puts i + 1 # reads i_1 (read2)
     *   else
     *     i = 2      # defines i_2
     *     puts i     # reads i_2 (read1)
     *     puts i + 1 # reads i_2 (read2)
     *   end
     *   puts i
     * end
     * ```
     */
    final predicate hasAdjacentReads(CfgNode read1, CfgNode read2) {
      SsaImpl::adjacentReadPair(this, read1, read2)
    }

    /**
     * Gets an SSA definition whose value can flow to this one in one step. This
     * includes inputs to phi nodes and the prior definitions of uncertain writes.
     */
    private Definition getAPhiInputOrPriorDefinition() {
      result = this.(PhiDefinition).getAnInput()
    }

    /**
     * Gets a definition that ultimately defines this SSA definition and is
     * not itself a phi node.
     *
     * Example:
     *
     * ```rb
     * def m b
     *   i = 0        # defines i_0
     *   puts i
     *   puts i + 1
     *   if b
     *     i = 1      # defines i_1
     *     puts i
     *     puts i + 1
     *   else
     *     i = 2      # defines i_2
     *     puts i
     *     puts i + 1
     *   end
     *                # defines i_3 = phi(i_1, i_2); ultimate definitions are i_1 and i_2
     *   puts i
     * end
     * ```
     */
    final Definition getAnUltimateDefinition() {
      result = this.getAPhiInputOrPriorDefinition*() and
      not result instanceof PhiDefinition
    }

    override string toString() { result = this.getControlFlowNode().toString() }

    /** Gets the scope of this SSA definition. */
    CfgScope getScope() { result = this.getBasicBlock().getScope() }
  }

  /**
   * An SSA definition that corresponds to a write. For example `x = 10` in
   *
   * ```rb
   * x = 10
   * puts x
   * ```
   */
  class WriteDefinition extends Definition, SsaImpl::WriteDefinition {
    private CfgNode write;

    WriteDefinition() {
      exists(BasicBlock bb, int i, Variable v |
        this.definesAt(v, bb, i) and
        SsaImpl::variableWriteActual(bb, i, v, write)
      )
    }

    /** Gets the underlying write access. */
    final CfgNode getWriteAccess() { result = write }

    /**
     * Holds if this SSA definition assigns `value` to the underlying variable.
     *
     * This is either a direct assignment, `x = value`, or an assignment via
     * simple pattern matching
     *
     * ```rb
     * case value
     *  in Foo => x then ...
     *  in y => then ...
     * end
     * ```
     */
    predicate assigns(CfgNode value) {
      exists(AssignmentExpr ae, BasicBlock bb, int i |
        this.definesAt(_, bb, i) and
        ae.getLhs() = bb.getNode(i).getAstNode() and
        value.getAstNode() = ae.getRhs()
      )
    }

    final override string toString() { result = write.toString() }

    final override Location getLocation() { result = write.getLocation() }
  }

  /**
   * A phi node. For example, in
   *
   * ```rb
   * if b
   *   x = 0
   * else
   *   x = 1
   * end
   * puts x
   * ```
   *
   * a phi node for `x` is inserted just before the call `puts x`.
   */
  class PhiDefinition extends Definition, SsaImpl::PhiDefinition {
    /**
     * Gets an input of this phi node.
     *
     * Example:
     *
     * ```rb
     * def m b
     *   i = 0        # defines i_0
     *   puts i
     *   puts i + 1
     *   if b
     *     i = 1      # defines i_1
     *     puts i
     *     puts i + 1
     *   else
     *     i = 2      # defines i_2
     *     puts i
     *     puts i + 1
     *   end
     *                # defines i_3 = phi(i_1, i_2); inputs are i_1 and i_2
     *   puts i
     * end
     * ```
     */
    final Definition getAnInput() { this.hasInputFromBlock(result, _) }

    /** Holds if `inp` is an input to this phi node along the edge originating in `bb`. */
    predicate hasInputFromBlock(Definition inp, BasicBlock bb) {
      inp = SsaImpl::phiHasInputFromBlock(this, bb)
    }

    private string getSplitString() {
      result = this.getBasicBlock().getFirstNode().(CfgImpl::AstCfgNode).getSplitsString()
    }

    override string toString() {
      exists(string prefix |
        prefix = "[" + this.getSplitString() + "] "
        or
        not exists(this.getSplitString()) and
        prefix = ""
      |
        result = prefix + "phi"
      )
    }

    /*
     * The location of a phi node is the same as the location of the first node
     * in the basic block in which it is defined.
     *
     * Strictly speaking, the node is *before* the first node, but such a location
     * does not exist in the source program.
     */

    final override Location getLocation() {
      result = this.getBasicBlock().getFirstNode().getLocation()
    }
  }
}
