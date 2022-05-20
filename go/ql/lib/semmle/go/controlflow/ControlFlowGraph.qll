/**
 * Provides classes for working with a CFG-based program representation.
 */

import go
private import ControlFlowGraphImpl

/** Provides helper predicates for mapping btween CFG nodes and the AST. */
module ControlFlow {
  /** A file or function with which a CFG is associated. */
  class Root extends AstNode {
    Root() { exists(this.(File).getADecl()) or exists(this.(FuncDef).getBody()) }

    /** Holds if `nd` belongs to this file or function. */
    predicate isRootOf(AstNode nd) {
      this = nd.getEnclosingFunction()
      or
      not exists(nd.getEnclosingFunction()) and
      this = nd.getFile()
    }

    /** Gets the synthetic entry node of the CFG for this file or function. */
    EntryNode getEntryNode() { result = ControlFlow::entryNode(this) }

    /** Gets the synthetic exit node of the CFG for this file or function. */
    ExitNode getExitNode() { result = ControlFlow::exitNode(this) }
  }

  /**
   * A node in the intra-procedural control-flow graph of a Go function or file.
   *
   * Nodes correspond to expressions and statements that compute a value or perform
   * an operation (as opposed to providing syntactic structure or type information).
   *
   * There are also synthetic entry and exit nodes for each Go function and file
   * that mark the beginning and the end, respectively, of the execution of the
   * function and the loading of the file.
   */
  class Node extends TControlFlowNode {
    /** Gets a node that directly follows this one in the control-flow graph. */
    Node getASuccessor() { result = CFG::succ(this) }

    /** Gets a node that directly precedes this one in the control-flow graph. */
    Node getAPredecessor() { this = result.getASuccessor() }

    /** Holds if this is a node with more than one successor. */
    predicate isBranch() { strictcount(getASuccessor()) > 1 }

    /** Holds if this is a node with more than one predecessor. */
    predicate isJoin() { strictcount(getAPredecessor()) > 1 }

    /** Holds if this is the first control-flow node in `subtree`. */
    predicate isFirstNodeOf(AstNode subtree) { CFG::firstNode(subtree, this) }

    /** Holds if this node is the (unique) entry node of a function or file. */
    predicate isEntryNode() { this instanceof MkEntryNode }

    /** Holds if this node is the (unique) exit node of a function or file. */
    predicate isExitNode() { this instanceof MkExitNode }

    /** Gets the basic block to which this node belongs. */
    BasicBlock getBasicBlock() { result.getANode() = this }

    /** Holds if this node dominates `dominee` in the control-flow graph. */
    pragma[inline]
    predicate dominatesNode(ControlFlow::Node dominee) {
      exists(ReachableBasicBlock thisbb, ReachableBasicBlock dbb, int i, int j |
        this = thisbb.getNode(i) and dominee = dbb.getNode(j)
      |
        thisbb.strictlyDominates(dbb)
        or
        thisbb = dbb and i <= j
      )
    }

    /** Gets the innermost function or file to which this node belongs. */
    Root getRoot() { none() }

    /** Gets the file to which this node belongs. */
    File getFile() { hasLocationInfo(result.getAbsolutePath(), _, _, _, _) }

    /**
     * Gets a textual representation of this control flow node.
     */
    string toString() { result = "control-flow node" }

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      filepath = "" and
      startline = 0 and
      startcolumn = 0 and
      endline = 0 and
      endcolumn = 0
    }
  }

  /**
   * A control-flow node that initializes or updates the value of a constant, a variable,
   * a field, or an (array, slice, or map) element.
   */
  class WriteNode extends Node {
    IR::WriteInstruction self;

    WriteNode() { this = self }

    /** Gets the left-hand side of this write. */
    IR::WriteTarget getLhs() { result = self.getLhs() }

    /** Gets the right-hand side of this write. */
    DataFlow::Node getRhs() { self.getRhs() = result.asInstruction() }

    /** Holds if this node sets variable or constant `v` to `rhs`. */
    predicate writes(ValueEntity v, DataFlow::Node rhs) { self.writes(v, rhs.asInstruction()) }

    /** Holds if this node defines SSA variable `v` to be `rhs`. */
    predicate definesSsaVariable(SsaVariable v, DataFlow::Node rhs) {
      self.getLhs().asSsaVariable() = v and
      self.getRhs() = rhs.asInstruction()
    }

    /**
     * Holds if this node sets the value of field `f` on `base` (or its implicit dereference) to
     * `rhs`.
     *
     * For example, for the assignment `x.width = newWidth`, `base` is either the data-flow node
     * corresponding to `x` or (if `x` is a pointer) the data-flow node corresponding to the
     * implicit dereference `*x`, `f` is the field referenced by `width`, and `rhs` is the data-flow
     * node corresponding to `newWidth`.
     */
    predicate writesField(DataFlow::Node base, Field f, DataFlow::Node rhs) {
      exists(IR::FieldTarget trg | trg = self.getLhs() |
        (
          trg.getBase() = base.asInstruction() or
          trg.getBase() = MkImplicitDeref(base.asExpr())
        ) and
        trg.getField() = f and
        self.getRhs() = rhs.asInstruction()
      )
    }

    /**
     * Holds if this node sets the value of element `index` on `base` (or its implicit dereference)
     * to `rhs`.
     *
     * For example, for the assignment `xs[i] = v`, `base` is either the data-flow node
     * corresponding to `xs` or (if `xs` is a pointer) the data-flow node corresponding to the
     * implicit dereference `*xs`, `index` is the data-flow node corresponding to `i`, and `rhs`
     * is the data-flow node corresponding to `base`.
     */
    predicate writesElement(DataFlow::Node base, DataFlow::Node index, DataFlow::Node rhs) {
      exists(IR::ElementTarget trg | trg = self.getLhs() |
        (
          trg.getBase() = base.asInstruction() or
          trg.getBase() = MkImplicitDeref(base.asExpr())
        ) and
        trg.getIndex() = index.asInstruction() and
        self.getRhs() = rhs.asInstruction()
      )
    }

    /**
     * Holds if this node sets any field or element of `base` to `rhs`.
     */
    predicate writesComponent(DataFlow::Node base, DataFlow::Node rhs) {
      writesElement(base, _, rhs) or writesField(base, _, rhs)
    }
  }

  /**
   * A control-flow node recording the fact that a certain expression has a known
   * Boolean value at this point in the program.
   */
  class ConditionGuardNode extends IR::Instruction, MkConditionGuardNode {
    Expr cond;
    boolean outcome;

    ConditionGuardNode() { this = MkConditionGuardNode(cond, outcome) }

    private predicate ensuresAux(Expr expr, boolean b) {
      expr = cond and b = outcome
      or
      expr = any(ParenExpr par | ensuresAux(par, b)).getExpr()
      or
      expr = any(NotExpr ne | ensuresAux(ne, b.booleanNot())).getOperand()
      or
      expr = any(LandExpr land | ensuresAux(land, true)).getAnOperand() and
      b = true
      or
      expr = any(LorExpr lor | ensuresAux(lor, false)).getAnOperand() and
      b = false
    }

    /** Holds if this guard ensures that the result of `nd` is `b`. */
    predicate ensures(DataFlow::Node nd, boolean b) {
      ensuresAux(any(Expr e | nd = DataFlow::exprNode(e)), b)
    }

    /** Holds if this guard ensures that `lesser <= greater + bias` holds. */
    predicate ensuresLeq(DataFlow::Node lesser, DataFlow::Node greater, int bias) {
      exists(DataFlow::RelationalComparisonNode rel, boolean b |
        ensures(rel, b) and
        rel.leq(b, lesser, greater, bias)
      )
      or
      ensuresEq(lesser, greater) and
      bias = 0
    }

    /** Holds if this guard ensures that `i = j` holds. */
    predicate ensuresEq(DataFlow::Node i, DataFlow::Node j) {
      exists(DataFlow::EqualityTestNode eq, boolean b |
        ensures(eq, b) and
        eq.eq(b, i, j)
      )
    }

    /** Holds if this guard ensures that `i != j` holds. */
    predicate ensuresNeq(DataFlow::Node i, DataFlow::Node j) {
      exists(DataFlow::EqualityTestNode eq, boolean b |
        ensures(eq, b.booleanNot()) and
        eq.eq(b, i, j)
      )
    }

    /**
     * Holds if this guard dominates basic block `bb`, that is, the guard
     * is known to hold at `bb`.
     */
    predicate dominates(ReachableBasicBlock bb) {
      this = bb.getANode() or
      dominates(bb.getImmediateDominator())
    }

    /**
     * Gets the condition whose outcome the guard concerns.
     */
    Expr getCondition() { result = cond }

    override Root getRoot() { result.isRootOf(cond) }

    override string toString() { result = cond + " is " + outcome }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      cond.hasLocationInfo(filepath, _, _, startline, startcolumn) and
      endline = startline and
      endcolumn = startcolumn
    }
  }

  /**
   * Gets the entry node of function or file `root`.
   */
  Node entryNode(Root root) { result = MkEntryNode(root) }

  /**
   * Gets the exit node of function or file `root`.
   */
  Node exitNode(Root root) { result = MkExitNode(root) }

  /**
   * Holds if the function `f` may return without panicking, exiting the process, or looping forever.
   *
   * This is defined conservatively, and so may also hold of a function that in fact
   * cannot return normally, but never fails to hold of a function that can return normally.
   */
  predicate mayReturnNormally(FuncDecl f) { CFG::mayReturnNormally(f.getBody()) }

  /**
   * Holds if `pred` is the node for the case `testExpr` in an expression
   * switch statement which is switching on `switchExpr`, and `succ` is the
   * node to be executed next if the case test succeeds.
   */
  predicate isSwitchCaseTestPassingEdge(
    ControlFlow::Node pred, ControlFlow::Node succ, Expr switchExpr, Expr testExpr
  ) {
    CFG::isSwitchCaseTestPassingEdge(pred, succ, switchExpr, testExpr)
  }
}

class Write = ControlFlow::WriteNode;
