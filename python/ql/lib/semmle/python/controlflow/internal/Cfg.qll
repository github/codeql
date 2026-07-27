/**
 * Provides a Python control flow graph facade backed by the shared
 * `codeql.controlflow.ControlFlowGraph` library (via `AstNodeImpl.qll`).
 *
 * This module re-exposes the same API surface as `semmle/python/Flow.qll`
 * (the legacy CFG), but is implemented on the new shared CFG. It is
 * intended as a drop-in replacement for use by the Python dataflow library
 * and other downstream code.
 *
 * Layering follows the Java pattern (`java/ql/lib/semmle/code/java/Expr.qll`
 * and `SsaImpl.qll`): variable identity and similar AST-level semantics
 * live on the Python AST classes (`Name.defines(v)`, `Name.uses(v)`, ...);
 * the CFG layer is purely positional, with `toAst` / `getNode` bridging
 * back to the AST. The shared SSA library can then be parameterized on
 * (`BasicBlock`, `int`) directly, with no CFG-level variable predicates.
 */
overlay[local?]
module;

private import python as Py
private import semmle.python.controlflow.internal.AstNodeImpl as CfgImpl
private import codeql.controlflow.SuccessorType

/**
 * A control flow node.
 *
 * This is the full set of CFG nodes from the shared library — it includes
 * before-nodes, in-order/post-order nodes, after-value-split nodes, and
 * entry/exit nodes. This enables full control-flow-level reasoning and
 * compatibility with the shared control-flow reachability library.
 *
 * AST-level semantics (`getNode()`, `isLoad()`, typed wrappers, etc.)
 * are available only on the `injects` (canonical) node for each AST node.
 * Non-injects nodes are purely positional CFG nodes with no AST mapping.
 */
class ControlFlowNode extends CfgImpl::ControlFlowNode {
  /** Gets the syntactic element corresponding to this flow node, if any. */
  Py::AstNode getNode() {
    exists(CfgImpl::Ast::AstNode n | this.injects(n) | result = CfgImpl::astNodeToPyNode(n))
  }

  Py::Expr asPyExpr() { result = this.getNode() }

  /** Gets a predecessor of this flow node. */
  ControlFlowNode getAPredecessor() { this = result.getASuccessor() }

  /** Gets a successor of this flow node. */
  ControlFlowNode getASuccessor() { result = super.getASuccessor() }

  /** Gets a successor for this node if the relevant condition is True. */
  ControlFlowNode getATrueSuccessor() {
    result = super.getASuccessor(any(BooleanSuccessor t | t.getValue() = true))
  }

  /** Gets a successor for this node if the relevant condition is False. */
  ControlFlowNode getAFalseSuccessor() {
    result = super.getASuccessor(any(BooleanSuccessor t | t.getValue() = false))
  }

  /** Gets a successor for this node if an exception is raised. */
  ControlFlowNode getAnExceptionalSuccessor() { result = super.getAnExceptionSuccessor() }

  /** Gets a successor for this node if no exception is raised. */
  ControlFlowNode getANormalSuccessor() { result = super.getANormalSuccessor() }

  /** Gets the basic block containing this flow node. */
  BasicBlock getBasicBlock() { result = super.getBasicBlock() }

  /** Gets the scope containing this flow node. */
  Py::Scope getScope() { result = super.getEnclosingCallable().asScope() }

  /** Gets the enclosing module. */
  Py::Module getEnclosingModule() { result = this.getScope().getEnclosingModule() }

  /** Gets the immediate dominator of this flow node. */
  ControlFlowNode getImmediateDominator() {
    // Defined positionally via the basic-block dominance tree.
    exists(BasicBlock bb, int i | bb.getNode(i) = this |
      // Predecessor within the same basic block.
      i > 0 and result = bb.getNode(i - 1)
      or
      // First node of `bb`: dominator is the last node of the immediate dominator block.
      i = 0 and result = bb.getImmediateDominator().getLastNode()
    )
  }

  /** Holds if this strictly dominates `other`. */
  overlay[caller?]
  pragma[inline]
  predicate strictlyDominates(ControlFlowNode other) { super.strictlyDominates(other) }

  /** Holds if this dominates `other` (reflexively). */
  overlay[caller?]
  pragma[inline]
  predicate dominates(ControlFlowNode other) { super.dominates(other) }

  /** Holds if this is the first node in its enclosing scope. */
  predicate isEntryNode() { this instanceof CfgImpl::ControlFlow::EntryNode }

  /** Holds if this is the first node of a module. */
  predicate isModuleEntry() {
    this.isEntryNode() and super.getAstNode().asScope() instanceof Py::Module
  }

  /** Holds if this node may exit its scope by raising an exception. */
  predicate isExceptionalExit(Py::Scope s) {
    this instanceof CfgImpl::ControlFlow::ExceptionalExitNode and
    super.getEnclosingCallable().asScope() = s
  }

  /** Holds if this node is a normal (non-exceptional) exit. */
  predicate isNormalExit() { this instanceof CfgImpl::ControlFlow::NormalExitNode }

  // ===== AST-shape predicates (bridges to the wrapped Python AST) =====
  /**
   * Holds if this flow node is a load (including those in augmented
   * assignments).
   *
   * Note: an augmented-assignment target (`x[i]` in `x[i] += 1`) is
   * both a load and a store — `isLoad` and `isStore` both hold on the
   * canonical CFG node. This mirrors Java's `VarAccess.isVarRead`,
   * which holds on the destination of compound and unary assignments
   * even though the destination is also a write.
   */
  predicate isLoad() { py_expr_contexts(_, 3, this.asPyExpr()) }

  /** Holds if this flow node is a store (including those in augmented assignments). */
  predicate isStore() { py_expr_contexts(_, 5, this.asPyExpr()) or augstore(_, this) }

  /** Holds if this flow node is a delete. */
  predicate isDelete() { py_expr_contexts(_, 2, this.asPyExpr()) }

  /** Holds if this flow node is a parameter. */
  predicate isParameter() { py_expr_contexts(_, 4, this.asPyExpr()) }

  /** Holds if this flow node is a store in an augmented assignment. */
  predicate isAugStore() { augstore(_, this) }

  /** Holds if this flow node is a load in an augmented assignment. */
  predicate isAugLoad() { augstore(this, _) }

  /** Holds if this flow node corresponds to a literal. */
  predicate isLiteral() {
    this.getNode() instanceof Py::Bytes or
    this.getNode() instanceof Py::Dict or
    this.getNode() instanceof Py::DictComp or
    this.getNode() instanceof Py::Set or
    this.getNode() instanceof Py::SetComp or
    this.getNode() instanceof Py::Ellipsis or
    this.getNode() instanceof Py::GeneratorExp or
    this.getNode() instanceof Py::Lambda or
    this.getNode() instanceof Py::ListComp or
    this.getNode() instanceof Py::List or
    this.getNode() instanceof Py::Num or
    this.getNode() instanceof Py::Tuple or
    this.getNode() instanceof Py::Unicode or
    this.getNode() instanceof Py::NameConstant
  }

  /** Holds if this flow node corresponds to an attribute expression. */
  predicate isAttribute() { this.getNode() instanceof Py::Attribute }

  /** Holds if this flow node corresponds to a subscript expression. */
  predicate isSubscript() { this.getNode() instanceof Py::Subscript }

  /** Holds if this flow node corresponds to an import member. */
  predicate isImportMember() { this.getNode() instanceof Py::ImportMember }

  /** Holds if this flow node corresponds to a call. */
  predicate isCall() { this.getNode() instanceof Py::Call }

  /** Holds if this flow node corresponds to an import. */
  predicate isImport() { this.getNode() instanceof Py::ImportExpr }

  /** Holds if this flow node corresponds to a conditional expression. */
  predicate isIfExp() { this.getNode() instanceof Py::IfExp }

  /** Holds if this flow node corresponds to a function definition expression. */
  predicate isFunction() { this.getNode() instanceof Py::FunctionExpr }

  /** Holds if this flow node corresponds to a class definition expression. */
  predicate isClass() { this.getNode() instanceof Py::ClassExpr }

  /**
   * Holds if this flow node is a branch (i.e. has both a true and a
   * false successor).
   */
  predicate isBranch() { exists(this.getATrueSuccessor()) or exists(this.getAFalseSuccessor()) }

  /**
   * Gets a CFG child of this node, defined as a CFG node whose AST node
   * is a child of this CFG node's AST node, restricted to nodes that
   * dominate this one (so the child has been evaluated by the time we
   * reach this node).
   *
   * Mirrors `Flow.qll`'s `getAChild`. UnaryExprNode is excluded because
   * its operand is its CFG predecessor (handled separately).
   */
  pragma[nomagic]
  ControlFlowNode getAChild() {
    this.getNode().(Py::Expr).getAChildNode() = result.getNode() and
    result.getBasicBlock().dominates(this.getBasicBlock()) and
    not this instanceof UnaryExprNode
  }

  /** Holds if this flow node strictly reaches `other`. */
  predicate strictlyReaches(ControlFlowNode other) { this.getASuccessor+() = other }
}

/**
 * Holds if `load` is the load half of an augmented-assignment target,
 * and `store` is the corresponding store half.
 *
 * In the legacy CFG (`Flow.qll`) the same Python `Name` had two
 * distinct CFG nodes — a load node (context 3) earlier in the BB, and
 * a store node (context 5) later. The legacy `augstore` related the
 * pair via dominance.
 *
 * In the new (shared) CFG, the canonical node for an AST expression is
 * unique, so `load` and `store` collapse onto the same CFG node. The
 * predicate is therefore reflexive on the augmented-assignment
 * target's canonical node.
 */
private predicate augstore(ControlFlowNode load, ControlFlowNode store) {
  exists(Py::AugAssign aa | aa.getTarget() = load.getNode()) and
  load = store
}

/**
 * A basic block — a maximal-length sequence of control flow nodes such
 * that no node except the first has a predecessor outside the sequence,
 * and no node except the last has a successor outside the sequence.
 */
class BasicBlock extends CfgImpl::BasicBlock {
  /** Gets the `n`th node in this basic block. */
  ControlFlowNode getNode(int n) { result = super.getNode(n) }

  /** Gets a node in this basic block. */
  ControlFlowNode getANode() { result = super.getNode(_) }

  /** Gets the first node in this basic block. */
  ControlFlowNode firstNode() { result = this.getNode(0) }

  /** Gets the last node in this basic block. */
  ControlFlowNode getLastNode() { result = super.getLastNode() }

  /** Holds if this basic block contains `node`. */
  predicate contains(ControlFlowNode node) { node = this.getANode() }

  // Inherited from the shared library's `BasicBlock`:
  //   getASuccessor(), getASuccessor(SuccessorType), getAPredecessor(),
  //   strictlyDominates(), dominates(), getImmediateDominator(),
  //   length(), inLoop().
  // We shadow `getNode(int)` etc. to return `ControlFlowNode` (this
  // facade's type) and add Python-style helpers below.
  /** Gets a true successor to this basic block. */
  BasicBlock getATrueSuccessor() {
    result = super.getASuccessor(any(BooleanSuccessor t | t.getValue() = true))
  }

  /** Gets a false successor to this basic block. */
  BasicBlock getAFalseSuccessor() {
    result = super.getASuccessor(any(BooleanSuccessor t | t.getValue() = false))
  }

  /** Gets an unconditional successor to this basic block. */
  BasicBlock getAnUnconditionalSuccessor() {
    result = super.getASuccessor() and
    not result = this.getATrueSuccessor() and
    not result = this.getAFalseSuccessor()
  }

  /** Gets an exceptional successor to this basic block. */
  BasicBlock getAnExceptionalSuccessor() { result = super.getASuccessor(any(ExceptionSuccessor t)) }

  /**
   * Holds if this basic block is in the dominance frontier of `df`.
   *
   * Note: implemented locally rather than via the shared lib, which
   * doesn't currently expose a `dominanceFrontier` predicate at this
   * level.
   */
  predicate inDominanceFrontier(BasicBlock df) {
    this = df.getAPredecessor() and not this = df.getImmediateDominator()
    or
    exists(BasicBlock prev | prev.inDominanceFrontier(df) |
      this = prev.getImmediateDominator() and
      not this = df.getImmediateDominator()
    )
  }

  /** Holds if this basic block strictly reaches `other`. */
  predicate strictlyReaches(BasicBlock other) { super.getASuccessor+() = other }

  /** Holds if this basic block reaches `other` (reflexively). */
  predicate reaches(BasicBlock other) { this = other or this.strictlyReaches(other) }

  /** Holds if flow from this basic block reaches a normal exit from its scope. */
  predicate reachesExit() {
    this.getANode() instanceof CfgImpl::ControlFlow::NormalExitNode
    or
    exists(BasicBlock succ | succ = super.getASuccessor() and succ.reachesExit())
  }

  /** Gets the scope of this basic block. */
  Py::Scope getScope() { exists(ControlFlowNode n | n = this.getANode() | result = n.getScope()) }

  /** Holds if flow from this BasicBlock always reaches `succ`. */
  predicate alwaysReaches(BasicBlock succ) {
    succ = this
    or
    strictcount(BasicBlock s | s = super.getASuccessor()) = 1 and
    succ = super.getASuccessor()
    or
    forex(BasicBlock immsucc | immsucc = super.getASuccessor() | immsucc.alwaysReaches(succ))
  }

  /**
   * Holds if this basic block ends in a node that branches on a boolean
   * outcome, and `other` is dominated by the corresponding successor
   * for `branch` while not being reachable from the other branch
   * without going through this BB.
   *
   * In other words: any execution that reaches `other` must have just
   * evaluated the last node of this BB and taken the `branch` outcome.
   * This mirrors the legacy `ConditionBlock.controls(BB, branch)`.
   */
  predicate controls(BasicBlock other, boolean branch) {
    exists(BasicBlock succ |
      branch = true and succ = this.getATrueSuccessor()
      or
      branch = false and succ = this.getAFalseSuccessor()
    |
      succ.dominates(other) and
      // The other branch must not also reach `other` — otherwise
      // `other` is not actually controlled by `branch`.
      not exists(BasicBlock otherSucc |
        branch = true and otherSucc = this.getAFalseSuccessor()
        or
        branch = false and otherSucc = this.getATrueSuccessor()
      |
        otherSucc.reaches(other)
      )
    )
  }
}

// ===========================================================================
// Re-exports for SSA / dominance consumers
//
// The shared `BB::CfgSig` requires `EntryBasicBlock` and `dominatingEdge` in
// addition to the BasicBlock class we already expose. They are provided by
// the shared CFG library on the `BB::Make` instantiation produced by
// `AstNodeImpl.qll`.
// ===========================================================================
/** An entry basic block, that is, a basic block whose first node is an entry node. */
class EntryBasicBlock = CfgImpl::Cfg::EntryBasicBlock;

/**
 * Holds if `bb1` has `bb2` as a direct successor and the edge between `bb1`
 * and `bb2` is a dominating edge.
 */
predicate dominatingEdge = CfgImpl::Cfg::dominatingEdge/2;

// ===========================================================================
// AST-shape subclasses of ControlFlowNode
//
// Each class is a thin wrapper around the canonical CFG node for a given
// kind of Python AST node. Methods that take/return CFG nodes look up
// related CFG nodes by AST identity (via `getNode()`), and the dominance
// constraint from the old CFG (`result.getBasicBlock().dominates(this.getBasicBlock())`)
// is preserved.
// ===========================================================================
/** Gets the canonical `ControlFlowNode` for AST expression `e`. */
ControlFlowNode astExprToCfg(Py::Expr e) { result.getNode() = e }

/** A control flow node corresponding to a `Name` or `PlaceHolder` expression. */
class NameNode extends ControlFlowNode {
  NameNode() {
    this.getNode() instanceof Py::Name
    or
    this.getNode() instanceof Py::PlaceHolder
  }

  /**
   * Holds if this flow node defines the variable `v`.
   *
   * This includes augmented-assignment targets — `n += 1` is both a
   * read and a write of `n`, so `defines(n)` and `uses(n)` both hold
   * on the same canonical CFG node. Mirrors Java's `VariableUpdate`
   * semantics where compound assignments register both a write
   * (`VarWrite`) and a read (`VarRead`) on the destination.
   */
  predicate defines(Py::Variable v) { exists(Py::Name n | n = this.getNode() and n.defines(v)) }

  /** Holds if this flow node deletes the variable `v`. */
  predicate deletes(Py::Variable v) { exists(Py::Name n | n = this.getNode() and n.deletes(v)) }

  /** Holds if this flow node uses the variable `v`. */
  predicate uses(Py::Variable v) {
    this.isLoad() and
    exists(Py::Name u | u = this.getNode() and u.uses(v))
    or
    exists(Py::PlaceHolder u |
      u = this.getNode() and u.getVariable() = v and u.getCtx() instanceof Py::Load
    )
  }

  /** Gets the identifier of this name node. */
  string getId() {
    result = this.getNode().(Py::Name).getId()
    or
    result = this.getNode().(Py::PlaceHolder).getId()
  }

  /** Holds if this is a use of a local variable. */
  predicate isLocal() { exists(Py::Variable v | this.uses(v) and v instanceof Py::LocalVariable) }

  /** Holds if this is a use of a non-local variable. */
  predicate isNonLocal() {
    exists(Py::Variable v | this.uses(v) and v.getScope() != this.getScope())
  }

  /** Holds if this is a use of a global (including builtin) variable. */
  predicate isGlobal() { exists(Py::Variable v | this.uses(v) and v instanceof Py::GlobalVariable) }

  /**
   * Holds if this is a use of `self` — the first parameter of an
   * enclosing method.
   *
   * AST-level approximation: matches when the Name uses a `Variable`
   * that is the first parameter of an enclosing `Function` defined
   * inside a `Class`.
   */
  predicate isSelf() {
    exists(Py::Variable v, Py::Function f, Py::Class c |
      this.uses(v) and
      f = c.getAMethod() and
      v.getScope() = f and
      v = f.getArg(0).(Py::Name).getVariable()
    )
  }
}

/** A control flow node corresponding to a named constant (`None`, `True`, `False`). */
class NameConstantNode extends NameNode {
  NameConstantNode() { this.getNode() instanceof Py::NameConstant }
}

/** A control flow node corresponding to a call. */
class CallNode extends ControlFlowNode {
  CallNode() { super.getNode() instanceof Py::Call }

  override Py::Call getNode() { result = super.getNode() }

  /** Gets the underlying Python `Call`. */
  Py::Call getCall() { result = this.getNode() }

  /** Gets the flow node for the function component of this call. */
  ControlFlowNode getFunction() {
    this.getCall().getFunc() = result.getNode() and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }

  /** Gets the flow node for the `n`th positional argument. */
  ControlFlowNode getArg(int n) {
    this.getCall().getArg(n) = result.getNode() and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }

  /** Gets the flow node for the named argument with name `name`. */
  ControlFlowNode getArgByName(string name) {
    exists(Py::Keyword k |
      k = this.getCall().getANamedArg() and
      k.getValue() = result.getNode() and
      k.getArg() = name and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets a flow node corresponding to any argument. */
  ControlFlowNode getAnArg() { result = this.getArg(_) or result = this.getArgByName(_) }

  /** Gets the first tuple (`*args`) argument, if any. */
  ControlFlowNode getStarArg() {
    this.getCall().getStarArg() = result.getNode() and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }

  /** Gets a dictionary (`**kwargs`) argument, if any. */
  ControlFlowNode getKwargs() {
    this.getCall().getKwargs() = result.getNode() and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }

  /** Holds if this call is a decorator call applied to a class or a function. */
  predicate isDecoratorCall() { this.isClassDecoratorCall() or this.isFunctionDecoratorCall() }

  /** Holds if this call is a decorator call applied to a class. */
  predicate isClassDecoratorCall() {
    exists(Py::ClassExpr cls | this.getNode() = cls.getADecoratorCall())
  }

  /** Holds if this call is a decorator call applied to a function. */
  predicate isFunctionDecoratorCall() {
    exists(Py::FunctionExpr func | this.getNode() = func.getADecoratorCall())
  }
}

/** A control flow node corresponding to an attribute expression. */
class AttrNode extends ControlFlowNode {
  AttrNode() { super.getNode() instanceof Py::Attribute }

  override Py::Attribute getNode() { result = super.getNode() }

  /** Gets the flow node for the object of the attribute expression. */
  ControlFlowNode getObject() {
    this.getNode().getObject() = result.getNode() and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }

  /** Gets the flow node for the object of this attribute expression, with the matching name. */
  ControlFlowNode getObject(string name) {
    this.getName() = name and
    result = this.getObject()
  }

  /** Gets the attribute name. */
  string getName() { result = this.getNode().getName() }
}

/** A control flow node corresponding to an import statement (`import x`). */
class ImportExprNode extends ControlFlowNode {
  ImportExprNode() { super.getNode() instanceof Py::ImportExpr }

  override Py::ImportExpr getNode() { result = super.getNode() }
}

/** A control flow node corresponding to a `from ... import name` expression. */
class ImportMemberNode extends ControlFlowNode {
  ImportMemberNode() { super.getNode() instanceof Py::ImportMember }

  override Py::ImportMember getNode() { result = super.getNode() }

  /** Gets the flow node for the module being imported from, with the matching name. */
  ControlFlowNode getModule(string name) {
    exists(Py::ImportMember i |
      i = this.getNode() and
      i.getModule() = result.getNode() and
      i.getName() = name and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to a `from ... import *` statement. */
class ImportStarNode extends ControlFlowNode {
  ImportStarNode() { super.getNode() instanceof Py::ImportStar }

  override Py::ImportStar getNode() { result = super.getNode() }

  /** Gets the flow node for the module being imported from. */
  ControlFlowNode getModule() {
    this.getNode().getModuleExpr() = result.getNode() and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }
}

/** A control flow node corresponding to a subscript expression. */
class SubscriptNode extends ControlFlowNode {
  SubscriptNode() { super.getNode() instanceof Py::Subscript }

  override Py::Subscript getNode() { result = super.getNode() }

  /** Gets the flow node for the value being subscripted. */
  ControlFlowNode getObject() {
    this.getNode().getObject() = result.getNode() and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }

  /** Gets the flow node for the index expression. */
  ControlFlowNode getIndex() {
    this.getNode().getIndex() = result.getNode() and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }
}

/** A control flow node corresponding to a comparison operation. */
class CompareNode extends ControlFlowNode {
  CompareNode() { super.getNode() instanceof Py::Compare }

  override Py::Compare getNode() { result = super.getNode() }

  /** Holds if `left` and `right` are a pair of operands for this comparison. */
  predicate operands(ControlFlowNode left, Py::Cmpop op, ControlFlowNode right) {
    exists(Py::Compare c, Py::Expr eleft, Py::Expr eright |
      c = this.getNode() and eleft = left.getNode() and eright = right.getNode()
    |
      eleft = c.getLeft() and eright = c.getComparator(0) and op = c.getOp(0)
      or
      exists(int i |
        eleft = c.getComparator(i - 1) and eright = c.getComparator(i) and op = c.getOp(i)
      )
    ) and
    left.getBasicBlock().dominates(this.getBasicBlock()) and
    right.getBasicBlock().dominates(this.getBasicBlock())
  }
}

/** A control flow node corresponding to a conditional expression (`x if c else y`). */
class IfExprNode extends ControlFlowNode {
  IfExprNode() { super.getNode() instanceof Py::IfExp }

  override Py::IfExp getNode() { result = super.getNode() }

  /** Gets the flow node for one of the value operands (true-branch or false-branch). */
  ControlFlowNode getAnOperand() {
    exists(Py::IfExp ie |
      ie = this.getNode() and
      (result.getNode() = ie.getBody() or result.getNode() = ie.getOrelse())
    )
  }
}

/** A control flow node corresponding to an assignment expression (walrus `:=`). */
class AssignmentExprNode extends ControlFlowNode {
  AssignmentExprNode() { super.getNode() instanceof Py::AssignExpr }

  override Py::AssignExpr getNode() { result = super.getNode() }

  /** Gets the flow node for the left-hand side. */
  ControlFlowNode getTarget() {
    this.getNode().getTarget() = result.getNode() and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }

  /** Gets the flow node for the right-hand side. */
  ControlFlowNode getValue() {
    this.getNode().getValue() = result.getNode() and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }
}

/** A control flow node corresponding to a binary expression (`a + b` etc.). */
class BinaryExprNode extends ControlFlowNode {
  BinaryExprNode() { super.getNode() instanceof Py::BinaryExpr }

  override Py::BinaryExpr getNode() { result = super.getNode() }

  ControlFlowNode getLeft() {
    this.getNode().getLeft() = result.getNode() and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }

  ControlFlowNode getRight() {
    this.getNode().getRight() = result.getNode() and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }

  Py::Operator getOp() { result = this.getNode().(Py::BinaryExpr).getOp() }

  /** Holds if `left` and `right` are the operands and `op` is the operator. */
  predicate operands(ControlFlowNode left, Py::Operator op, ControlFlowNode right) {
    left = this.getLeft() and right = this.getRight() and op = this.getOp()
  }

  /** Gets either operand. */
  ControlFlowNode getAnOperand() { result = this.getLeft() or result = this.getRight() }
}

/** A control flow node corresponding to a boolean expression (`a and b`, `a or b`). */
class BoolExprNode extends ControlFlowNode {
  BoolExprNode() { super.getNode() instanceof Py::BoolExpr }

  override Py::BoolExpr getNode() { result = super.getNode() }

  Py::Boolop getOp() { result = this.getNode().(Py::BoolExpr).getOp() }

  /** Gets any operand of this boolean expression. */
  ControlFlowNode getAnOperand() { this.getNode().getAValue() = result.getNode() }
}

/** A control flow node corresponding to a unary expression (`-x`, `not x`, etc.). */
class UnaryExprNode extends ControlFlowNode {
  UnaryExprNode() { super.getNode() instanceof Py::UnaryExpr }

  override Py::UnaryExpr getNode() { result = super.getNode() }

  ControlFlowNode getOperand() {
    this.getNode().getOperand() = result.getNode() and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }

  Py::Unaryop getOp() { result = this.getNode().(Py::UnaryExpr).getOp() }
}

/**
 * A control flow node that is a definition: it appears in a context that
 * binds a variable (assignment target, parameter, etc.).
 */
class DefinitionNode extends ControlFlowNode {
  DefinitionNode() { this.isStore() or this.isParameter() }

  /** Gets the value assigned, if any. */
  ControlFlowNode getValue() {
    // For-target: the value is the for-loop's iter expression (which
    // is also where `Cfg::ForNode` lives — its `getNode()` returns the
    // enclosing `Py::For` statement). Treated specially because there
    // is no AST node holding the result of `iter(next(seq))`; we use
    // the iter expression's CFG node as the stand-in.
    exists(Py::For f |
      f.getTarget() = this.getNode() and
      result.getNode() = f.getIter()
    )
    or
    exists(Py::AstNode value | value = assignedValue(this.getNode()) |
      result.getNode() = value and
      (
        result.getBasicBlock().dominates(this.getBasicBlock())
        or
        result.isImport()
        or
        // The default value for a parameter is evaluated in the same basic block as
        // the function definition, but the parameter belongs to the basic block of the
        // function, so there is no dominance relationship between the two.
        exists(Py::Parameter param | this.getNode() = param.asName())
      )
    )
  }
}

/**
 * Gets the AST node that holds the value assigned to `lhs` in a binding
 * context. Mirrors `Flow.qll::assigned_value`.
 */
private Py::AstNode assignedValue(Py::Expr lhs) {
  // lhs = result
  exists(Py::Assign a | a.getATarget() = lhs and result = a.getValue())
  or
  // lhs := result
  exists(Py::AssignExpr a | a.getTarget() = lhs and result = a.getValue())
  or
  // lhs: annotation = result
  exists(Py::AnnAssign a | a.getTarget() = lhs and result = a.getValue())
  or
  // import result as lhs  (also covers plain `import lhs`, where alias.getAsname() = lhs)
  exists(Py::Alias a | a.getAsname() = lhs and result = a.getValue())
  or
  // lhs += x  -> result is the (lhs + x) binary expression
  exists(Py::AugAssign a, Py::BinaryExpr b |
    b = a.getOperation() and result = b and lhs = b.getLeft()
  )
  or
  // Nested sequence assign: ..., lhs, ... = ..., result, ...
  exists(Py::Assign a | nestedSequenceAssign(a.getATarget(), a.getValue(), lhs, result))
  or
  // Parameter default
  exists(Py::Parameter param | lhs = param.asName() and result = param.getDefault())
}

/**
 * Helper for nested sequence assignments such as `(a, b), c = (1, 2), 3`.
 */
private predicate nestedSequenceAssign(
  Py::Expr leftParent, Py::Expr rightParent, Py::Expr left, Py::Expr right
) {
  exists(int i |
    leftParent.(Py::Tuple).getElt(i) = left and rightParent.(Py::Tuple).getElt(i) = right
    or
    leftParent.(Py::List).getElt(i) = left and rightParent.(Py::List).getElt(i) = right
  )
  or
  exists(Py::Expr leftMid, Py::Expr rightMid |
    nestedSequenceAssign(leftParent, rightParent, leftMid, rightMid) and
    nestedSequenceAssign(leftMid, rightMid, left, right)
  )
}

/** A control flow node corresponding to a deletion (`del x`). */
class DeletionNode extends ControlFlowNode {
  DeletionNode() { this.isDelete() }
}

/** A control flow node corresponding to a `for` loop target. */
class ForNode extends ControlFlowNode {
  ForNode() { exists(Py::For f | this.getNode() = f.getIter()) }

  /** Gets the iterable expression. */
  ControlFlowNode getIter() {
    result = this and result = result // canonical "after" of the iterable
  }

  /** Gets the sequence expression (alias for `getIter()`, matches legacy Flow naming). */
  ControlFlowNode getSequence() { result = this.getIter() }

  /** Gets the target (loop variable) of the `for` loop. */
  ControlFlowNode getTarget() {
    exists(Py::For f |
      f.getIter() = this.getNode() and
      f.getTarget() = result.getNode()
    )
  }

  /** Holds if `target` is the loop variable and `sequence` is the iterable. */
  predicate iterates(ControlFlowNode target, ControlFlowNode sequence) {
    target = this.getTarget() and sequence = this.getSequence()
  }
}

/** A control flow node corresponding to a `raise` statement. */
class RaiseStmtNode extends ControlFlowNode {
  RaiseStmtNode() { super.getNode() instanceof Py::Raise }

  override Py::Raise getNode() { result = super.getNode() }

  /** Gets the exception expression, if any. */
  ControlFlowNode getException() {
    this.getNode().getException() = result.getNode() and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }
}

/** A control flow node corresponding to a starred expression (`*x`). */
class StarredNode extends ControlFlowNode {
  StarredNode() { this.getNode() instanceof Py::Starred }

  /** Gets the value being starred. */
  ControlFlowNode getValue() {
    exists(Py::Starred s |
      s = this.getNode() and
      s.getValue() = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to an `except` clause's name binding. */
class ExceptFlowNode extends ControlFlowNode {
  ExceptFlowNode() { exists(Py::ExceptStmt e | this.getNode() = e.getName()) }

  /** Gets the CFG node for the bound `as`-name itself. */
  ControlFlowNode getName() { result = this }

  /** Gets the type expression of this exception handler. */
  ControlFlowNode getType() {
    exists(Py::ExceptStmt e |
      e.getName() = this.getNode() and
      e.getType() = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to an `except*` clause's name binding. */
class ExceptGroupFlowNode extends ControlFlowNode {
  ExceptGroupFlowNode() { exists(Py::ExceptGroupStmt e | this.getNode() = e.getName()) }

  /** Gets the CFG node for the bound `as`-name itself. */
  ControlFlowNode getName() { result = this }
}

/** Abstract base class for sequence nodes (tuple, list). */
abstract class SequenceNode extends ControlFlowNode {
  /** Gets the `n`th element of this sequence. */
  abstract ControlFlowNode getElement(int n);

  /** Gets any element of this sequence. */
  ControlFlowNode getAnElement() { result = this.getElement(_) }
}

/** A control flow node corresponding to a tuple literal. */
class TupleNode extends SequenceNode {
  TupleNode() { this.getNode() instanceof Py::Tuple }

  override ControlFlowNode getElement(int n) {
    exists(Py::Tuple t |
      t = this.getNode() and
      t.getElt(n) = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to a list literal. */
class ListNode extends SequenceNode {
  ListNode() { this.getNode() instanceof Py::List }

  override ControlFlowNode getElement(int n) {
    exists(Py::List l |
      l = this.getNode() and
      l.getElt(n) = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to a set literal. */
class SetNode extends ControlFlowNode {
  SetNode() { this.getNode() instanceof Py::Set }

  /** Gets the flow node for an element of the set. */
  ControlFlowNode getAnElement() {
    exists(Py::Set s |
      s = this.getNode() and
      s.getAnElt() = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to a dict literal. */
class DictNode extends ControlFlowNode {
  DictNode() { this.getNode() instanceof Py::Dict }

  /** Gets the flow node for a key of the dict. */
  ControlFlowNode getAKey() {
    exists(Py::Dict d |
      d = this.getNode() and
      d.getAKey() = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the flow node for a value of the dict. */
  ControlFlowNode getAValue() {
    exists(Py::Dict d |
      d = this.getNode() and
      d.getAValue() = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to an iterable in a `for` loop. */
class IterableNode extends ControlFlowNode {
  IterableNode() {
    this instanceof SequenceNode
    or
    this instanceof SetNode
  }

  /** Gets the control flow node for an element of this iterable. */
  ControlFlowNode getAnElement() {
    result = this.(SequenceNode).getAnElement()
    or
    result = this.(SetNode).getAnElement()
  }
}
