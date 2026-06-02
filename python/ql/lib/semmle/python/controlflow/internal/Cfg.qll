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
private import codeql.controlflow.BasicBlock as BB

/**
 * A nested sub-module that explicitly implements `BB::CfgSig`, so this
 * `Cfg` facade can be passed to parameterised shared modules such as
 * `codeql.dataflow.VariableCapture::Flow<L, Cfg, ...>`. The sub-module
 * exposes the *raw* shared-CFG types from `AstNodeImpl.qll` (where the
 * signature is satisfied natively), not the facade's wrapped types.
 */
module CfgSigImpl implements BB::CfgSig<Py::Location> {
  class ControlFlowNode = CfgImpl::ControlFlowNode;

  class BasicBlock = CfgImpl::BasicBlock;

  class EntryBasicBlock = CfgImpl::Cfg::EntryBasicBlock;

  predicate dominatingEdge = CfgImpl::Cfg::dominatingEdge/2;
}

/**
 * Gets the Python AST node corresponding to CFG node `n`, if any.
 *
 * Multiple CFG nodes may map to the same AST node (e.g. `TBeforeNode(Call)`
 * and `TAstNode(Call)` both map to `Py::Call`). This is a pure translation;
 * uniqueness constraints are enforced at the dataflow layer where needed.
 */
private Py::AstNode toAst(CfgImpl::ControlFlowNode n) {
  result = CfgImpl::astNodeToPyNode(n.getAstNode())
}

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
  Py::AstNode getNode() { result = toAst(this) }

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
  pragma[inline]
  predicate strictlyDominates(ControlFlowNode other) { super.strictlyDominates(other) }

  /** Holds if this dominates `other` (reflexively). */
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
  predicate isLoad() { exists(Py::Expr e | e = toAst(this) | py_expr_contexts(_, 3, e)) }

  /** Holds if this flow node is a store (including those in augmented assignments). */
  predicate isStore() {
    exists(Py::Expr e | e = toAst(this) | py_expr_contexts(_, 5, e) or augstore(_, this))
  }

  /** Holds if this flow node is a delete. */
  predicate isDelete() { exists(Py::Expr e | e = toAst(this) | py_expr_contexts(_, 2, e)) }

  /** Holds if this flow node is a parameter. */
  predicate isParameter() { exists(Py::Expr e | e = toAst(this) | py_expr_contexts(_, 4, e)) }

  /** Holds if this flow node is a store in an augmented assignment. */
  predicate isAugStore() { augstore(_, this) }

  /** Holds if this flow node is a load in an augmented assignment. */
  predicate isAugLoad() { augstore(this, _) }

  /** Holds if this flow node corresponds to a literal. */
  predicate isLiteral() {
    toAst(this) instanceof Py::Bytes or
    toAst(this) instanceof Py::Dict or
    toAst(this) instanceof Py::DictComp or
    toAst(this) instanceof Py::Set or
    toAst(this) instanceof Py::SetComp or
    toAst(this) instanceof Py::Ellipsis or
    toAst(this) instanceof Py::GeneratorExp or
    toAst(this) instanceof Py::Lambda or
    toAst(this) instanceof Py::ListComp or
    toAst(this) instanceof Py::List or
    toAst(this) instanceof Py::Num or
    toAst(this) instanceof Py::Tuple or
    toAst(this) instanceof Py::Unicode or
    toAst(this) instanceof Py::NameConstant
  }

  /** Holds if this flow node corresponds to an attribute expression. */
  predicate isAttribute() { toAst(this) instanceof Py::Attribute }

  /** Holds if this flow node corresponds to a subscript expression. */
  predicate isSubscript() { toAst(this) instanceof Py::Subscript }

  /** Holds if this flow node corresponds to an import member. */
  predicate isImportMember() { toAst(this) instanceof Py::ImportMember }

  /** Holds if this flow node corresponds to a call. */
  predicate isCall() { toAst(this) instanceof Py::Call }

  /** Holds if this flow node corresponds to an import. */
  predicate isImport() { toAst(this) instanceof Py::ImportExpr }

  /** Holds if this flow node corresponds to a conditional expression. */
  predicate isIfExp() { toAst(this) instanceof Py::IfExp }

  /** Holds if this flow node corresponds to a function definition expression. */
  predicate isFunction() { toAst(this) instanceof Py::FunctionExpr }

  /** Holds if this flow node corresponds to a class definition expression. */
  predicate isClass() { toAst(this) instanceof Py::ClassExpr }

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
    toAst(this).(Py::Expr).getAChildNode() = toAst(result) and
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
  exists(Py::AugAssign aa | aa.getTarget() = toAst(load)) and
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
    toAst(this) instanceof Py::Name
    or
    toAst(this) instanceof Py::PlaceHolder
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
  predicate defines(Py::Variable v) { exists(Py::Name n | n = toAst(this) and n.defines(v)) }

  /** Holds if this flow node deletes the variable `v`. */
  predicate deletes(Py::Variable v) { exists(Py::Name n | n = toAst(this) and n.deletes(v)) }

  /** Holds if this flow node uses the variable `v`. */
  predicate uses(Py::Variable v) {
    this.isLoad() and
    exists(Py::Name u | u = toAst(this) and u.uses(v))
    or
    exists(Py::PlaceHolder u |
      u = toAst(this) and u.getVariable() = v and u.getCtx() instanceof Py::Load
    )
  }

  /** Gets the identifier of this name node. */
  string getId() {
    result = toAst(this).(Py::Name).getId()
    or
    result = toAst(this).(Py::PlaceHolder).getId()
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
  NameConstantNode() { toAst(this) instanceof Py::NameConstant }
}

/** A control flow node corresponding to a call. */
class CallNode extends ControlFlowNode {
  CallNode() { toAst(this) instanceof Py::Call }

  override Py::Call getNode() { result = super.getNode() }

  /** Gets the underlying Python `Call`. */
  Py::Call getCall() { result = toAst(this) }

  /** Gets the flow node for the function component of this call. */
  ControlFlowNode getFunction() {
    exists(Py::Call c |
      c = toAst(this) and
      c.getFunc() = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the flow node for the `n`th positional argument. */
  ControlFlowNode getArg(int n) {
    exists(Py::Call c |
      c = toAst(this) and
      c.getArg(n) = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the flow node for the named argument with name `name`. */
  ControlFlowNode getArgByName(string name) {
    exists(Py::Call c, Py::Keyword k |
      c = toAst(this) and
      k = c.getANamedArg() and
      k.getValue() = toAst(result) and
      k.getArg() = name and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets a flow node corresponding to any argument. */
  ControlFlowNode getAnArg() { result = this.getArg(_) or result = this.getArgByName(_) }

  /** Gets the first tuple (`*args`) argument, if any. */
  ControlFlowNode getStarArg() {
    exists(Py::Call c |
      c = toAst(this) and
      c.getStarArg() = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets a dictionary (`**kwargs`) argument, if any. */
  ControlFlowNode getKwargs() {
    exists(Py::Call c |
      c = toAst(this) and
      c.getKwargs() = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  predicate isDecoratorCall() { this.isClassDecoratorCall() or this.isFunctionDecoratorCall() }

  predicate isClassDecoratorCall() {
    exists(Py::ClassExpr cls | toAst(this) = cls.getADecoratorCall())
  }

  predicate isFunctionDecoratorCall() {
    exists(Py::FunctionExpr func | toAst(this) = func.getADecoratorCall())
  }
}

/** A control flow node corresponding to an attribute expression. */
class AttrNode extends ControlFlowNode {
  AttrNode() { toAst(this) instanceof Py::Attribute }

  override Py::Attribute getNode() { result = super.getNode() }

  /** Gets the flow node for the object of the attribute expression. */
  ControlFlowNode getObject() {
    exists(Py::Attribute a |
      a = toAst(this) and
      a.getObject() = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the flow node for the object of this attribute expression, with the matching name. */
  ControlFlowNode getObject(string name) {
    exists(Py::Attribute a |
      a = toAst(this) and
      a.getObject() = toAst(result) and
      a.getName() = name and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the attribute name. */
  string getName() { exists(Py::Attribute a | a = toAst(this) and a.getName() = result) }
}

/** A control flow node corresponding to an import statement (`import x`). */
class ImportExprNode extends ControlFlowNode {
  ImportExprNode() { toAst(this) instanceof Py::ImportExpr }

  override Py::ImportExpr getNode() { result = super.getNode() }
}

/** A control flow node corresponding to a `from ... import name` expression. */
class ImportMemberNode extends ControlFlowNode {
  ImportMemberNode() { toAst(this) instanceof Py::ImportMember }

  override Py::ImportMember getNode() { result = super.getNode() }

  /** Gets the flow node for the module being imported from, with the matching name. */
  ControlFlowNode getModule(string name) {
    exists(Py::ImportMember i |
      i = toAst(this) and
      i.getModule() = toAst(result) and
      i.getName() = name and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to a `from ... import *` statement. */
class ImportStarNode extends ControlFlowNode {
  ImportStarNode() { toAst(this) instanceof Py::ImportStar }

  override Py::ImportStar getNode() { result = super.getNode() }

  /** Gets the flow node for the module being imported from. */
  ControlFlowNode getModule() {
    exists(Py::ImportStar i |
      i = toAst(this) and
      i.getModuleExpr() = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to a subscript expression. */
class SubscriptNode extends ControlFlowNode {
  SubscriptNode() { toAst(this) instanceof Py::Subscript }

  override Py::Subscript getNode() { result = super.getNode() }

  /** Gets the flow node for the value being subscripted. */
  ControlFlowNode getObject() {
    exists(Py::Subscript s |
      s = toAst(this) and
      s.getObject() = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the flow node for the index expression. */
  ControlFlowNode getIndex() {
    exists(Py::Subscript s |
      s = toAst(this) and
      s.getIndex() = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to a comparison operation. */
class CompareNode extends ControlFlowNode {
  CompareNode() { toAst(this) instanceof Py::Compare }

  override Py::Compare getNode() { result = super.getNode() }

  /** Holds if `left` and `right` are a pair of operands for this comparison. */
  predicate operands(ControlFlowNode left, Py::Cmpop op, ControlFlowNode right) {
    exists(Py::Compare c, Py::Expr eleft, Py::Expr eright |
      c = toAst(this) and eleft = toAst(left) and eright = toAst(right)
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
  IfExprNode() { toAst(this) instanceof Py::IfExp }

  override Py::IfExp getNode() { result = super.getNode() }

  /** Gets the flow node for one of the value operands (true-branch or false-branch). */
  ControlFlowNode getAnOperand() {
    exists(Py::IfExp ie |
      ie = toAst(this) and
      (toAst(result) = ie.getBody() or toAst(result) = ie.getOrelse())
    )
  }
}

/** A control flow node corresponding to an assignment expression (walrus `:=`). */
class AssignmentExprNode extends ControlFlowNode {
  AssignmentExprNode() { toAst(this) instanceof Py::AssignExpr }

  override Py::AssignExpr getNode() { result = super.getNode() }

  /** Gets the flow node for the left-hand side. */
  ControlFlowNode getTarget() {
    exists(Py::AssignExpr a |
      a = toAst(this) and
      a.getTarget() = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the flow node for the right-hand side. */
  ControlFlowNode getValue() {
    exists(Py::AssignExpr a |
      a = toAst(this) and
      a.getValue() = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to a binary expression (`a + b` etc.). */
class BinaryExprNode extends ControlFlowNode {
  BinaryExprNode() { toAst(this) instanceof Py::BinaryExpr }

  override Py::BinaryExpr getNode() { result = super.getNode() }

  ControlFlowNode getLeft() {
    exists(Py::BinaryExpr be |
      be = toAst(this) and
      be.getLeft() = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  ControlFlowNode getRight() {
    exists(Py::BinaryExpr be |
      be = toAst(this) and
      be.getRight() = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  Py::Operator getOp() { result = toAst(this).(Py::BinaryExpr).getOp() }

  /** Holds if `left` and `right` are the operands and `op` is the operator. */
  predicate operands(ControlFlowNode left, Py::Operator op, ControlFlowNode right) {
    left = this.getLeft() and right = this.getRight() and op = this.getOp()
  }

  /** Gets either operand. */
  ControlFlowNode getAnOperand() { result = this.getLeft() or result = this.getRight() }
}

/** A control flow node corresponding to a boolean expression (`a and b`, `a or b`). */
class BoolExprNode extends ControlFlowNode {
  BoolExprNode() { toAst(this) instanceof Py::BoolExpr }

  override Py::BoolExpr getNode() { result = super.getNode() }

  Py::Boolop getOp() { result = toAst(this).(Py::BoolExpr).getOp() }

  /** Gets any operand of this boolean expression. */
  ControlFlowNode getAnOperand() {
    exists(Py::BoolExpr be |
      be = toAst(this) and
      be.getAValue() = toAst(result)
    )
  }
}

/** A control flow node corresponding to a unary expression (`-x`, `not x`, etc.). */
class UnaryExprNode extends ControlFlowNode {
  UnaryExprNode() { toAst(this) instanceof Py::UnaryExpr }

  override Py::UnaryExpr getNode() { result = super.getNode() }

  ControlFlowNode getOperand() {
    exists(Py::UnaryExpr u |
      u = toAst(this) and
      u.getOperand() = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  Py::Unaryop getOp() { result = toAst(this).(Py::UnaryExpr).getOp() }
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
      f.getTarget() = toAst(this) and
      toAst(result) = f.getIter()
    )
    or
    exists(Py::AstNode value | value = assignedValue(toAst(this)) |
      toAst(result) = value and
      (
        result.getBasicBlock().dominates(this.getBasicBlock())
        or
        result.isImport()
        or
        // The default value for a parameter is evaluated in the same basic block as
        // the function definition, but the parameter belongs to the basic block of the
        // function, so there is no dominance relationship between the two.
        exists(Py::Parameter param | toAst(this) = param.asName())
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
  ForNode() { exists(Py::For f | toAst(this) = f.getIter()) }

  /** Gets the iterable expression. */
  ControlFlowNode getIter() {
    result = this and result = result // canonical "after" of the iterable
  }

  /** Gets the sequence expression (alias for `getIter()`, matches legacy Flow naming). */
  ControlFlowNode getSequence() { result = this.getIter() }

  /** Gets the target (loop variable) of the `for` loop. */
  ControlFlowNode getTarget() {
    exists(Py::For f |
      f.getIter() = toAst(this) and
      f.getTarget() = toAst(result)
    )
  }

  /** Holds if `target` is the loop variable and `sequence` is the iterable. */
  predicate iterates(ControlFlowNode target, ControlFlowNode sequence) {
    target = this.getTarget() and sequence = this.getSequence()
  }
}

/** A control flow node corresponding to a `raise` statement. */
class RaiseStmtNode extends ControlFlowNode {
  RaiseStmtNode() { toAst(this) instanceof Py::Raise }

  override Py::Raise getNode() { result = super.getNode() }

  /** Gets the exception expression, if any. */
  ControlFlowNode getException() {
    exists(Py::Raise r |
      r = toAst(this) and
      r.getException() = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to a starred expression (`*x`). */
class StarredNode extends ControlFlowNode {
  StarredNode() { toAst(this) instanceof Py::Starred }

  /** Gets the value being starred. */
  ControlFlowNode getValue() {
    exists(Py::Starred s |
      s = toAst(this) and
      s.getValue() = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to an `except` clause's name binding. */
class ExceptFlowNode extends ControlFlowNode {
  ExceptFlowNode() { exists(Py::ExceptStmt e | toAst(this) = e.getName()) }

  /** Gets the CFG node for the bound `as`-name itself. */
  ControlFlowNode getName() { result = this }

  /** Gets the type expression of this exception handler. */
  ControlFlowNode getType() {
    exists(Py::ExceptStmt e |
      e.getName() = toAst(this) and
      e.getType() = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to an `except*` clause's name binding. */
class ExceptGroupFlowNode extends ControlFlowNode {
  ExceptGroupFlowNode() { exists(Py::ExceptGroupStmt e | toAst(this) = e.getName()) }

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
  TupleNode() { toAst(this) instanceof Py::Tuple }

  override ControlFlowNode getElement(int n) {
    exists(Py::Tuple t |
      t = toAst(this) and
      t.getElt(n) = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to a list literal. */
class ListNode extends SequenceNode {
  ListNode() { toAst(this) instanceof Py::List }

  override ControlFlowNode getElement(int n) {
    exists(Py::List l |
      l = toAst(this) and
      l.getElt(n) = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to a set literal. */
class SetNode extends ControlFlowNode {
  SetNode() { toAst(this) instanceof Py::Set }

  /** Gets the flow node for an element of the set. */
  ControlFlowNode getAnElement() {
    exists(Py::Set s |
      s = toAst(this) and
      s.getAnElt() = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to a dict literal. */
class DictNode extends ControlFlowNode {
  DictNode() { toAst(this) instanceof Py::Dict }

  /** Gets the flow node for a key of the dict. */
  ControlFlowNode getAKey() {
    exists(Py::Dict d |
      d = toAst(this) and
      d.getAKey() = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the flow node for a value of the dict. */
  ControlFlowNode getAValue() {
    exists(Py::Dict d |
      d = toAst(this) and
      d.getAValue() = toAst(result) and
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
