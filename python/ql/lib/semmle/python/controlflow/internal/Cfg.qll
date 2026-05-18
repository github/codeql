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
 * Gets the Python AST node corresponding to CFG node `n`, if any.
 *
 * Entry/exit/synthetic CFG nodes have no Python AST node, so this is
 * partial.
 */
private Py::AstNode toAst(CfgImpl::ControlFlowNode n) {
  result = CfgImpl::astNodeToPyNode(n.getAstNode())
}

/**
 * Holds if `n` is a CFG node representing the canonical position for an
 * AST node from the dataflow library's perspective.
 *
 * For most expressions this is the "after"-evaluation point (post-order
 * representative). For statements it is the post-order node when one
 * exists. We additionally include the synthetic entry/exit nodes for the
 * benefit of API consumers that ask "is this the entry node of a scope?".
 *
 * In conditional contexts the after-position of a boolean expression
 * splits into separate `isAfterTrue` and `isAfterFalse` nodes; both are
 * canonical, so a single AST expression may correspond to more than one
 * `ControlFlowNode`.
 */
private predicate isCanonical(CfgImpl::ControlFlowNode n) {
  n.isAfter(_)
  or
  n instanceof CfgImpl::ControlFlow::EntryNode
  or
  n instanceof CfgImpl::ControlFlow::ExitNode
}

/**
 * A control flow node. Control flow nodes have a many-to-one relation
 * with syntactic nodes, although most syntactic nodes have only one
 * corresponding control flow node.
 *
 * Edges between control flow nodes include exceptional as well as normal
 * control flow.
 */
class ControlFlowNode extends CfgImpl::ControlFlowNode {
  ControlFlowNode() { isCanonical(this) }

  /** Gets the syntactic element corresponding to this flow node, if any. */
  Py::AstNode getNode() { result = toAst(this) }

  /** Gets a predecessor of this flow node. */
  ControlFlowNode getAPredecessor() { this = result.getASuccessor() }

  /** Gets a successor of this flow node. */
  pragma[inline]
  ControlFlowNode getASuccessor() { result = nextCanonical(this) }

  /** Gets a successor for this node if the relevant condition is True. */
  ControlFlowNode getATrueSuccessor() {
    super.isAfterTrue(_) and
    exists(CfgImpl::ControlFlowNode other | other.isAfterFalse(super.getAstNode())) and
    result = nextCanonical(this)
  }

  /** Gets a successor for this node if the relevant condition is False. */
  ControlFlowNode getAFalseSuccessor() {
    super.isAfterFalse(_) and
    exists(CfgImpl::ControlFlowNode other | other.isAfterTrue(super.getAstNode())) and
    result = nextCanonical(this)
  }

  /** Gets a successor for this node if an exception is raised. */
  ControlFlowNode getAnExceptionalSuccessor() {
    exists(CfgImpl::ControlFlowNode mid |
      mid = super.getAnExceptionSuccessor() and
      result = nextCanonicalFrom(mid)
    )
  }

  /** Gets a successor for this node if no exception is raised. */
  ControlFlowNode getANormalSuccessor() {
    result = this.getASuccessor() and
    not result = this.getAnExceptionalSuccessor()
  }

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
  /** Holds if this flow node is a load (including those in augmented assignments). */
  predicate isLoad() {
    exists(Py::Expr e | e = toAst(this) | py_expr_contexts(_, 3, e) and not augstore(_, this))
  }

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

  /** Internal: raw successor predicate that does NOT skip non-canonical nodes. */
  CfgImpl::ControlFlowNode getASuccessorRaw() { result = super.getASuccessor() }
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
 * Gets the nearest canonical CFG node reachable from `n` via one or more
 * raw CFG edges (skipping non-canonical intermediaries).
 */
private CfgImpl::ControlFlowNode nextCanonicalFrom(CfgImpl::ControlFlowNode n) {
  result = n.getASuccessor() and isCanonical(result)
  or
  exists(CfgImpl::ControlFlowNode mid |
    mid = n.getASuccessor() and
    not isCanonical(mid) and
    result = nextCanonicalFrom(mid)
  )
}

/** Gets the nearest canonical CFG successor of canonical node `n`. */
private ControlFlowNode nextCanonical(ControlFlowNode n) { result = nextCanonicalFrom(n) }

/**
 * A basic block — a maximal-length sequence of control flow nodes such
 * that no node except the first has a predecessor outside the sequence,
 * and no node except the last has a successor outside the sequence.
 */
class BasicBlock extends CfgImpl::BasicBlock {
  /** Gets the `n`th node in this basic block, restricted to canonical nodes. */
  ControlFlowNode getNode(int n) {
    result = rank[n + 1](ControlFlowNode node, int i | super.getNode(i) = node | node order by i)
  }

  /** Gets a node in this basic block. */
  ControlFlowNode getANode() { result = this.getNode(_) }

  /** Gets the first canonical node in this basic block. */
  ControlFlowNode firstNode() { result = this.getNode(0) }

  /** Gets the last canonical node in this basic block. */
  ControlFlowNode getLastNode() { result = this.getNode(max(int n | exists(this.getNode(n)))) }

  /** Holds if this basic block contains `node`. */
  predicate contains(ControlFlowNode node) { node = this.getANode() }

  // Inherited from the shared library's `BasicBlock`:
  //   getASuccessor(), getASuccessor(SuccessorType), getAPredecessor(),
  //   getNode(int) (raw, includes non-canonical), getANode() (raw),
  //   strictlyDominates(), dominates(), getImmediateDominator(),
  //   length(), inLoop().
  // We expose canonical-only positional access via `getNode(int)` below
  // (shadows the shared-lib version) and additional Python-style helpers.
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
// kind of Python AST node. Methods that take/return CFG nodes delegate to
// the AST and re-resolve back via `Expr.getAFlowNode()` from `Flow.qll`
// while we are in the migration period; once that is gone we will use a
// new-CFG-local resolution. For now, expressions navigated through these
// subclasses are looked up by AST identity, and the dominance constraint
// from the old CFG (`result.getBasicBlock().dominates(this.getBasicBlock())`)
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

  /** Holds if this flow node defines the variable `v`. */
  predicate defines(Py::Variable v) {
    exists(Py::Name n | n = toAst(this) and n.defines(v)) and
    not this.isLoad()
  }

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
}

/** A control flow node corresponding to a named constant (`None`, `True`, `False`). */
class NameConstantNode extends NameNode {
  NameConstantNode() { toAst(this) instanceof Py::NameConstant }
}

/** A control flow node corresponding to a call. */
class CallNode extends ControlFlowNode {
  CallNode() { toAst(this) instanceof Py::Call }

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
}

/** A control flow node corresponding to a `from ... import name` expression. */
class ImportMemberNode extends ControlFlowNode {
  ImportMemberNode() { toAst(this) instanceof Py::ImportMember }

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

  /** Gets the flow node for one of the operands of an if-expression. */
  ControlFlowNode getAnOperand() { result = this.getAPredecessor() }
}

/** A control flow node corresponding to an assignment expression (walrus `:=`). */
class AssignmentExprNode extends ControlFlowNode {
  AssignmentExprNode() { toAst(this) instanceof Py::AssignExpr }

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
}

/** A control flow node corresponding to a boolean expression (`a and b`, `a or b`). */
class BoolExprNode extends ControlFlowNode {
  BoolExprNode() { toAst(this) instanceof Py::BoolExpr }

  Py::Boolop getOp() { result = toAst(this).(Py::BoolExpr).getOp() }
}

/** A control flow node corresponding to a unary expression (`-x`, `not x`, etc.). */
class UnaryExprNode extends ControlFlowNode {
  UnaryExprNode() { toAst(this) instanceof Py::UnaryExpr }

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
    exists(Py::Expr target, Py::Expr value |
      target = toAst(this) and
      value = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    |
      // x = value
      exists(Py::Assign a | a.getATarget() = target and a.getValue() = value)
      or
      // x = y = value  (nested chained-assign target)
      exists(Py::Assign a | a.getATarget().(Py::Tuple).getElt(_) = target and a.getValue() = value)
    )
  }
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

  /** Gets the target (loop variable) of the `for` loop. */
  ControlFlowNode getTarget() {
    exists(Py::For f |
      f.getIter() = toAst(this) and
      f.getTarget() = toAst(result)
    )
  }
}

/** A control flow node corresponding to a `raise` statement. */
class RaiseStmtNode extends ControlFlowNode {
  RaiseStmtNode() { toAst(this) instanceof Py::Raise }

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
    exists(Py::For f | toAst(this) = f.getIter())
    or
    exists(Py::Comp c | toAst(this) = c.getIterable())
  }
}
