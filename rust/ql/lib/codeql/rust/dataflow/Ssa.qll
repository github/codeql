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
  private import codeql.rust.controlflow.CfgNodes
  private import codeql.rust.controlflow.internal.ControlFlowGraphImpl as CfgImpl
  private import internal.SsaImpl as SsaImpl

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
     * Gets a control flow node that reads the value of this SSA definition.
     *
     * Example:
     *
     * ```rust
     * fn phi(b : bool) {              // defines b_0
     *      let mut x = 1;             // defines x_0
     *      println!("{}", x);         // reads x_0
     *      println!("{}", x + 1);     // reads x_0
     *
     *      if b {                     // reads b_0
     *          x = 2;                 // defines x_1
     *          println!("{}", x);     // reads x_1
     *          println!("{}", x + 1); // reads x_1
     *      } else {
     *          x = 3;                 // defines x_2
     *          println!("{}", x);     // reads x_2
     *          println!("{}", x + 1); // reads x_2
     *      }
     *                                 // defines x_3 = phi(x_1, x_2)
     *      println!("{}", x);         // reads x_3
     * }
     * ```
     */
    final CfgNode getARead() { result = SsaImpl::getARead(this) }

    /**
     * Gets a first control flow node that reads the value of this SSA definition.
     * That is, a read that can be reached from this definition without passing
     * through other reads.
     *
     * Example:
     *
     * ```rust
     * fn phi(b : bool) {              // defines b_0
     *      let mut x = 1;             // defines x_0
     *      println!("{}", x);         // first read of x_0
     *      println!("{}", x + 1);
     *
     *      if b {                     // first read of b_0
     *          x = 2;                 // defines x_1
     *          println!("{}", x);     // first read of x_1
     *          println!("{}", x + 1);
     *      } else {
     *          x = 3;                 // defines x_2
     *          println!("{}", x);     // first read of x_2
     *          println!("{}", x + 1);
     *      }
     *                                 // defines x_3 = phi(x_1, x_2)
     *      println!("{}", x);         // first read of x_3
     * }
     * ```
     */
    final CfgNode getAFirstRead() { SsaImpl::firstRead(this, result) }

    /**
     * Gets a last control flow node that reads the value of this SSA definition.
     * That is, a read that can reach the end of the enclosing CFG scope, or another
     * SSA definition for the source variable, without passing through any other read.
     *
     * Example:
     *
     * ```rust
     * fn phi(b : bool) {              // defines b_0
     *      let mut x = 1;             // defines x_0
     *      println!("{}", x);
     *      println!("{}", x + 1);     // last read of x_0
     *
     *      if b {                     // last read of b_0
     *          x = 2;                 // defines x_1
     *          println!("{}", x);
     *          println!("{}", x + 1); // last read of x_1
     *      } else {
     *          x = 3;                 // defines x_2
     *          println!("{}", x);
     *          println!("{}", x + 1); // last read of x_2
     *      }
     *                                 // defines x_3 = phi(x_1, x_2)
     *      println!("{}", x);         // last read of x_3
     * }
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
     * ```rust
     * fn phi(b : bool) {
     *      let mut x = 1;             // defines x_0
     *      println!("{}", x);         // reads x_0 (read1)
     *      println!("{}", x + 1);     // reads x_0 (read2)
     *
     *      if b {
     *          x = 2;                 // defines x_1
     *          println!("{}", x);     // reads x_1 (read1)
     *          println!("{}", x + 1); // reads x_1 (read2)
     *      } else {
     *          x = 3;                 // defines x_2
     *          println!("{}", x);     // reads x_2 (read1)
     *          println!("{}", x + 1); // reads x_2 (read2)
     *      }
     *      println!("{}", x);
     * }
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
     * ```rust
     * fn phi(b : bool) {
     *      let mut x = 1;             // defines x_0
     *      println!("{}", x);
     *      println!("{}", x + 1);
     *
     *      if b {
     *          x = 2;                 // defines x_1
     *          println!("{}", x);
     *          println!("{}", x + 1);
     *      } else {
     *          x = 3;                 // defines x_2
     *          println!("{}", x);
     *          println!("{}", x + 1);
     *      }
     *                                 // defines x_3 = phi(x_1, x_2); ultimate definitions are x_1 and x_2
     *      println!("{}", x);
     * }
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
   * An SSA definition that corresponds to a write. Example:
   *
   * ```rust
   * fn m(i : i64) {     // writes `i`
   *     let mut x = i;  // writes `x`
   *     x = 11;         // writes `x`
   * }
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
     * Holds if this SSA definition assigns `value` to the underlying
     * variable.
     *
     * This is either the value in a direct assignment, `x = value`, or in a
     * `let` statement, `let x = value`. Note that patterns on the lhs. are
     * currently not supported.
     */
    predicate assigns(ExprCfgNode value) {
      exists(AssignmentExprCfgNode ae |
        ae.getLhs() = write and
        ae.getRhs() = value
      )
      or
      exists(LetStmtCfgNode ls |
        ls.getPat() = write and
        ls.getInitializer() = value
      )
    }

    final override string toString() { result = write.toString() }

    final override Location getLocation() { result = write.getLocation() }
  }

  /**
   * A phi definition. For example, in
   *
   * ```rust
   * if b {
   *   x = 0
   * } else {
   *   x = 1
   * }
   * println!("{}", x);
   * ```
   *
   * a phi definition for `x` is inserted just before the call to `println!`.
   */
  class PhiDefinition extends Definition, SsaImpl::PhiDefinition {
    /**
     * Gets an input of this phi definition.
     *
     * Example:
     *
     * ```rust
     * fn phi(b : bool) {
     *      let mut x = 1;             // defines x_0
     *      println!("{}", x);
     *      println!("{}", x + 1);
     *
     *      if b {
     *          x = 2;                 // defines x_1
     *          println!("{}", x);
     *          println!("{}", x + 1);
     *      } else {
     *          x = 3;                 // defines x_2
     *          println!("{}", x);
     *          println!("{}", x + 1);
     *      }
     *                                 // defines x_3 = phi(x_1, x_2); inputs are x_1 and x_2
     *      println!("{}", x);
     * }
     * ```
     */
    final Definition getAnInput() { this.hasInputFromBlock(result, _) }

    /** Holds if `inp` is an input to this phi definition along the edge originating in `bb`. */
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
     * The location of a phi definition is the same as the location of the first node
     * in the basic block in which it is defined.
     *
     * Strictly speaking, the node is *before* the first node, but such a location
     * does not exist in the source program.
     */

    final override Location getLocation() {
      result = this.getBasicBlock().getFirstNode().getLocation()
    }
  }

  /**
   * An SSA definition inserted at the beginning of a scope to represent a
   * captured local variable. For example, in
   *
   * ```rust
   * fn capture_immut() {
   *     let x = 100;
   *     let mut cap = || {
   *         println!("{}", x);
   *     };
   *     cap();
   * }
   * ```
   *
   * an entry definition for `x` is inserted at the start of the CFG for `cap`.
   */
  class CapturedEntryDefinition extends Definition, SsaImpl::WriteDefinition {
    CapturedEntryDefinition() {
      exists(BasicBlock bb, int i, Variable v |
        this.definesAt(v, bb, i) and
        SsaImpl::capturedEntryWrite(bb, i, v)
      )
    }

    final override string toString() { result = "<captured entry> " + this.getSourceVariable() }

    override Location getLocation() { result = this.getBasicBlock().getLocation() }
  }

  /**
   * An SSA definition inserted at a call that may update the value of a captured
   * variable. For example, in
   *
   * ```rust
   * fn capture_mut() {
   *   let mut y = 0;
   *   (0..5).for_each(|x| {
   *     y += x
   *   });
   *   y
   * }
   * ```
   *
   * a definition for `y` is inserted at the call to `for_each`.
   */
  private class CapturedCallDefinition extends Definition, SsaImpl::UncertainWriteDefinition {
    CapturedCallDefinition() {
      exists(Variable v, BasicBlock bb, int i |
        this.definesAt(v, bb, i) and
        SsaImpl::capturedCallWrite(_, bb, i, v)
      )
    }

    /**
     * Gets the immediately preceding definition. Since this update is uncertain,
     * the value from the preceding definition might still be valid.
     */
    final Definition getPriorDefinition() { result = SsaImpl::uncertainWriteDefinitionInput(this) }

    override string toString() { result = "<captured exit> " + this.getSourceVariable() }
  }
}
