import python
private import semmle.python.pointsto.PointsTo

/*
 * Note about matching parent and child nodes and CFG splitting:
 *
 * As a result of CFG splitting a single AST node may have multiple CFG nodes.
 * Therefore, when matching CFG nodes to children, we need to make sure that
 * we don't match the child of one CFG node to the wrong parent.
 * We do this by checking dominance. If the CFG node for the parent precedes that of
 * the child, then he child node matches the parent node if it is dominated by it.
 * Vice versa for child nodes that precede the parent.
 */

private predicate augstore(ControlFlowNode load, ControlFlowNode store) {
  exists(Expr load_store | exists(AugAssign aa | aa.getTarget() = load_store) |
    toAst(load) = load_store and
    toAst(store) = load_store and
    load.strictlyDominates(store)
  )
}

/** A non-dispatched getNode() to avoid negative recursion issues */
private AstNode toAst(ControlFlowNode n) { py_flow_bb_node(n, result, _, _) }

/**
 * A control flow node. Control flow nodes have a many-to-one relation with syntactic nodes,
 * although most syntactic nodes have only one corresponding control flow node.
 * Edges between control flow nodes include exceptional as well as normal control flow.
 */
class ControlFlowNode extends @py_flow_node {
  /** Whether this control flow node is a load (including those in augmented assignments) */
  predicate isLoad() {
    exists(Expr e | e = toAst(this) | py_expr_contexts(_, 3, e) and not augstore(_, this))
  }

  /** Whether this control flow node is a store (including those in augmented assignments) */
  predicate isStore() {
    exists(Expr e | e = toAst(this) | py_expr_contexts(_, 5, e) or augstore(_, this))
  }

  /** Whether this control flow node is a delete */
  predicate isDelete() { exists(Expr e | e = toAst(this) | py_expr_contexts(_, 2, e)) }

  /** Whether this control flow node is a parameter */
  predicate isParameter() { exists(Expr e | e = toAst(this) | py_expr_contexts(_, 4, e)) }

  /** Whether this control flow node is a store in an augmented assignment */
  predicate isAugStore() { augstore(_, this) }

  /** Whether this control flow node is a load in an augmented assignment */
  predicate isAugLoad() { augstore(this, _) }

  /** Whether this flow node corresponds to a literal */
  predicate isLiteral() {
    toAst(this) instanceof Bytes
    or
    toAst(this) instanceof Dict
    or
    toAst(this) instanceof DictComp
    or
    toAst(this) instanceof Set
    or
    toAst(this) instanceof SetComp
    or
    toAst(this) instanceof Ellipsis
    or
    toAst(this) instanceof GeneratorExp
    or
    toAst(this) instanceof Lambda
    or
    toAst(this) instanceof ListComp
    or
    toAst(this) instanceof List
    or
    toAst(this) instanceof Num
    or
    toAst(this) instanceof Tuple
    or
    toAst(this) instanceof Unicode
    or
    toAst(this) instanceof NameConstant
  }

  /** Use NameNode.isLoad() instead */
  deprecated predicate isUse() { toAst(this) instanceof Name and this.isLoad() }

  /** Use NameNode.isStore() */
  deprecated predicate isDefinition() { toAst(this) instanceof Name and this.isStore() }

  /** Whether this flow node corresponds to an attribute expression */
  predicate isAttribute() { toAst(this) instanceof Attribute }

  /** Use AttrNode.isLoad() instead */
  deprecated predicate isAttributeLoad() { toAst(this) instanceof Attribute and this.isLoad() }

  /** Use AttrNode.isStore() instead */
  deprecated predicate isAttributeStore() { toAst(this) instanceof Attribute and this.isStore() }

  /** Whether this flow node corresponds to an subscript expression */
  predicate isSubscript() { toAst(this) instanceof Subscript }

  /** Use SubscriptNode.isLoad() instead */
  deprecated predicate isSubscriptLoad() { toAst(this) instanceof Subscript and this.isLoad() }

  /** Use SubscriptNode.isStore() instead */
  deprecated predicate isSubscriptStore() { toAst(this) instanceof Subscript and this.isStore() }

  /** Whether this flow node corresponds to an import member */
  predicate isImportMember() { toAst(this) instanceof ImportMember }

  /** Whether this flow node corresponds to a call */
  predicate isCall() { toAst(this) instanceof Call }

  /** Whether this flow node is the first in a module */
  predicate isModuleEntry() { this.isEntryNode() and toAst(this) instanceof Module }

  /** Whether this flow node corresponds to an import */
  predicate isImport() { toAst(this) instanceof ImportExpr }

  /** Whether this flow node corresponds to a conditional expression */
  predicate isIfExp() { toAst(this) instanceof IfExp }

  /** Whether this flow node corresponds to a function definition expression */
  predicate isFunction() { toAst(this) instanceof FunctionExpr }

  /** Whether this flow node corresponds to a class definition expression */
  predicate isClass() { toAst(this) instanceof ClassExpr }

  /** Gets a predecessor of this flow node */
  ControlFlowNode getAPredecessor() { this = result.getASuccessor() }

  /** Gets a successor of this flow node */
  ControlFlowNode getASuccessor() { py_successors(this, result) }

  /** Gets the immediate dominator of this flow node */
  ControlFlowNode getImmediateDominator() { py_idoms(this, result) }

  /** Gets the syntactic element corresponding to this flow node */
  AstNode getNode() { py_flow_bb_node(this, result, _, _) }

  /** Gets a textual representation of this element. */
  string toString() {
    exists(Scope s | s.getEntryNode() = this | result = "Entry node for " + s.toString())
    or
    exists(Scope s | s.getANormalExit() = this | result = "Exit node for " + s.toString())
    or
    not exists(Scope s | s.getEntryNode() = this or s.getANormalExit() = this) and
    result = "ControlFlowNode for " + this.getNode().toString()
  }

  /** Gets the location of this ControlFlowNode */
  Location getLocation() { result = this.getNode().getLocation() }

  /** Whether this flow node is the first in its scope */
  predicate isEntryNode() { py_scope_flow(this, _, -1) }

  /** The value that this ControlFlowNode points-to. */
  predicate pointsTo(Value value) { this.pointsTo(_, value, _) }

  /** Gets the value that this ControlFlowNode points-to. */
  Value pointsTo() { this.pointsTo(_, result, _) }

  /** Gets a value that this ControlFlowNode may points-to. */
  Value inferredValue() { this.pointsTo(_, result, _) }

  /** The value and origin that this ControlFlowNode points-to. */
  predicate pointsTo(Value value, ControlFlowNode origin) { this.pointsTo(_, value, origin) }

  /** The value and origin that this ControlFlowNode points-to, given the context. */
  predicate pointsTo(Context context, Value value, ControlFlowNode origin) {
    PointsTo::pointsTo(this, context, value, origin)
  }

  /**
   * Gets what this flow node might "refer-to". Performs a combination of localized (intra-procedural) points-to
   * analysis and global module-level analysis. This points-to analysis favours precision over recall. It is highly
   * precise, but may not provide information for a significant number of flow-nodes.
   * If the class is unimportant then use `refersTo(value)` or `refersTo(value, origin)` instead.
   */
  pragma[nomagic]
  predicate refersTo(Object obj, ClassObject cls, ControlFlowNode origin) {
    this.refersTo(_, obj, cls, origin)
  }

  /** Gets what this expression might "refer-to" in the given `context`. */
  pragma[nomagic]
  predicate refersTo(Context context, Object obj, ClassObject cls, ControlFlowNode origin) {
    not obj = unknownValue() and
    not cls = theUnknownType() and
    PointsTo::points_to(this, context, obj, cls, origin)
  }

  /**
   * Whether this flow node might "refer-to" to `value` which is from `origin`
   * Unlike `this.refersTo(value, _, origin)` this predicate includes results
   * where the class cannot be inferred.
   */
  pragma[nomagic]
  predicate refersTo(Object obj, ControlFlowNode origin) {
    not obj = unknownValue() and
    PointsTo::points_to(this, _, obj, _, origin)
  }

  /** Equivalent to `this.refersTo(value, _)` */
  predicate refersTo(Object obj) { this.refersTo(obj, _) }

  /** Gets the basic block containing this flow node */
  BasicBlock getBasicBlock() { result.contains(this) }

  /** Gets the scope containing this flow node */
  Scope getScope() {
    if this.getNode() instanceof Scope
    then
      /* Entry or exit node */
      result = this.getNode()
    else result = this.getNode().getScope()
  }

  /** Gets the enclosing module */
  Module getEnclosingModule() { result = this.getScope().getEnclosingModule() }

  /** Gets a successor for this node if the relevant condition is True. */
  ControlFlowNode getATrueSuccessor() {
    result = this.getASuccessor() and
    py_true_successors(this, result)
  }

  /** Gets a successor for this node if the relevant condition is False. */
  ControlFlowNode getAFalseSuccessor() {
    result = this.getASuccessor() and
    py_false_successors(this, result)
  }

  /** Gets a successor for this node if an exception is raised. */
  ControlFlowNode getAnExceptionalSuccessor() {
    result = this.getASuccessor() and
    py_exception_successors(this, result)
  }

  /** Gets a successor for this node if no exception is raised. */
  ControlFlowNode getANormalSuccessor() {
    result = this.getASuccessor() and
    not py_exception_successors(this, result)
  }

  /** Whether the scope may be exited as a result of this node raising an exception */
  predicate isExceptionalExit(Scope s) { py_scope_flow(this, s, 1) }

  /** Whether this node is a normal (non-exceptional) exit */
  predicate isNormalExit() { py_scope_flow(this, _, 0) or py_scope_flow(this, _, 2) }

  /** Whether it is unlikely that this ControlFlowNode can be reached */
  predicate unlikelyReachable() {
    not start_bb_likely_reachable(this.getBasicBlock())
    or
    exists(BasicBlock b |
      start_bb_likely_reachable(b) and
      not end_bb_likely_reachable(b) and
      // If there is an unlikely successor edge earlier in the BB
      // than this node, then this node must be unreachable.
      exists(ControlFlowNode p, int i, int j |
        p.(RaisingNode).unlikelySuccessor(_) and
        p = b.getNode(i) and
        this = b.getNode(j) and
        i < j
      )
    )
  }

  /**
   * Check whether this control-flow node has complete points-to information.
   * This would mean that the analysis managed to infer an over approximation
   * of possible values at runtime.
   */
  predicate hasCompletePointsToSet() {
    // If the tracking failed, then `this` will be its own "origin". In that
    // case, we want to exclude nodes for which there is also a different
    // origin, as that would indicate that some paths failed and some did not.
    this.refersTo(_, _, this) and
    not exists(ControlFlowNode other | other != this and this.refersTo(_, _, other))
    or
    // If `this` is a use of a variable, then we must have complete points-to
    // for that variable.
    exists(SsaVariable v | v.getAUse() = this | varHasCompletePointsToSet(v))
  }

  /** Whether this strictly dominates other. */
  pragma[inline]
  predicate strictlyDominates(ControlFlowNode other) {
    // This predicate is gigantic, so it must be inlined.
    // About 1.4 billion tuples for OpenStack Cinder.
    this.getBasicBlock().strictlyDominates(other.getBasicBlock())
    or
    exists(BasicBlock b, int i, int j | this = b.getNode(i) and other = b.getNode(j) and i < j)
  }

  /**
   * Whether this dominates other.
   * Note that all nodes dominate themselves.
   */
  pragma[inline]
  predicate dominates(ControlFlowNode other) {
    // This predicate is gigantic, so it must be inlined.
    this.getBasicBlock().strictlyDominates(other.getBasicBlock())
    or
    exists(BasicBlock b, int i, int j | this = b.getNode(i) and other = b.getNode(j) and i <= j)
  }

  /** Whether this strictly reaches other. */
  pragma[inline]
  predicate strictlyReaches(ControlFlowNode other) {
    // This predicate is gigantic, even larger than strictlyDominates,
    // so it must be inlined.
    this.getBasicBlock().strictlyReaches(other.getBasicBlock())
    or
    exists(BasicBlock b, int i, int j | this = b.getNode(i) and other = b.getNode(j) and i < j)
  }

  /* Holds if this CFG node is a branch */
  predicate isBranch() { py_true_successors(this, _) or py_false_successors(this, _) }

  ControlFlowNode getAChild() { result = this.getExprChild(this.getBasicBlock()) }

  /* join-ordering helper for `getAChild() */
  pragma[noinline]
  private ControlFlowNode getExprChild(BasicBlock dom) {
    this.getNode().(Expr).getAChildNode() = result.getNode() and
    result.getBasicBlock().dominates(dom) and
    not this instanceof UnaryExprNode
  }
}

/*
 * This class exists to provide an implementation over ControlFlowNode.getNode()
 * that subsumes all the others in an way that's obvious to the optimiser.
 * This avoids wasting time on the trivial overrides on the ControlFlowNode subclasses.
 */

private class AnyNode extends ControlFlowNode {
  override AstNode getNode() { result = super.getNode() }
}

/**
 * Check whether a SSA variable has complete points-to information.
 * This would mean that the analysis managed to infer an overapproximation
 * of possible values at runtime.
 */
private predicate varHasCompletePointsToSet(SsaVariable var) {
  // Global variables may be modified non-locally or concurrently.
  not var.getVariable() instanceof GlobalVariable and
  (
    // If we have complete points-to information on the definition of
    // this variable, then the variable has complete information.
    var.getDefinition().(DefinitionNode).getValue().hasCompletePointsToSet()
    or
    // If this variable is a phi output, then we have complete
    // points-to information about it if all phi inputs had complete
    // information.
    forex(SsaVariable phiInput | phiInput = var.getAPhiInput() |
      varHasCompletePointsToSet(phiInput)
    )
  )
}

/** A control flow node corresponding to a call expression, such as `func(...)` */
class CallNode extends ControlFlowNode {
  CallNode() { toAst(this) instanceof Call }

  /** Gets the flow node corresponding to the function expression for the call corresponding to this flow node */
  ControlFlowNode getFunction() {
    exists(Call c |
      this.getNode() = c and
      c.getFunc() = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the flow node corresponding to the nth argument of the call corresponding to this flow node */
  ControlFlowNode getArg(int n) {
    exists(Call c |
      this.getNode() = c and
      c.getArg(n) = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the flow node corresponding to the named argument of the call corresponding to this flow node */
  ControlFlowNode getArgByName(string name) {
    exists(Call c, Keyword k |
      this.getNode() = c and
      k = c.getAKeyword() and
      k.getValue() = result.getNode() and
      k.getArg() = name and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the flow node corresponding to an argument of the call corresponding to this flow node */
  ControlFlowNode getAnArg() {
    exists(int n | result = this.getArg(n))
    or
    exists(string name | result = this.getArgByName(name))
  }

  override Call getNode() { result = super.getNode() }

  predicate isDecoratorCall() {
    this.isClassDecoratorCall()
    or
    this.isFunctionDecoratorCall()
  }

  predicate isClassDecoratorCall() {
    exists(ClassExpr cls | this.getNode() = cls.getADecoratorCall())
  }

  predicate isFunctionDecoratorCall() {
    exists(FunctionExpr func | this.getNode() = func.getADecoratorCall())
  }

  /** Gets the tuple (*) argument of this call, provided there is exactly one. */
  ControlFlowNode getStarArg() {
    result.getNode() = this.getNode().getStarArg() and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }
}

/** A control flow corresponding to an attribute expression, such as `value.attr` */
class AttrNode extends ControlFlowNode {
  AttrNode() { toAst(this) instanceof Attribute }

  /** Gets the flow node corresponding to the object of the attribute expression corresponding to this flow node */
  ControlFlowNode getObject() {
    exists(Attribute a |
      this.getNode() = a and
      a.getObject() = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Use getObject() instead */
  deprecated ControlFlowNode getValue() { result = this.getObject() }

  /** Use getObject(name) instead */
  deprecated ControlFlowNode getValue(string name) { result = this.getObject(name) }

  /**
   * Gets the flow node corresponding to the object of the attribute expression corresponding to this flow node,
   * with the matching name
   */
  ControlFlowNode getObject(string name) {
    exists(Attribute a |
      this.getNode() = a and
      a.getObject() = result.getNode() and
      a.getName() = name and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the attribute name of the attribute expression corresponding to this flow node */
  string getName() { exists(Attribute a | this.getNode() = a and a.getName() = result) }

  override Attribute getNode() { result = super.getNode() }
}

/** A control flow node corresponding to a `from ... import ...` expression */
class ImportMemberNode extends ControlFlowNode {
  ImportMemberNode() { toAst(this) instanceof ImportMember }

  /**
   * Gets the flow node corresponding to the module in the import-member expression corresponding to this flow node,
   * with the matching name
   */
  ControlFlowNode getModule(string name) {
    exists(ImportMember i | this.getNode() = i and i.getModule() = result.getNode() |
      i.getName() = name and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  override ImportMember getNode() { result = super.getNode() }
}

/** A control flow node corresponding to an artificial expression representing an import */
class ImportExprNode extends ControlFlowNode {
  ImportExprNode() { toAst(this) instanceof ImportExpr }

  override ImportExpr getNode() { result = super.getNode() }
}

/** A control flow node corresponding to a `from ... import *` statement */
class ImportStarNode extends ControlFlowNode {
  ImportStarNode() { toAst(this) instanceof ImportStar }

  /** Gets the flow node corresponding to the module in the import-star corresponding to this flow node */
  ControlFlowNode getModule() {
    exists(ImportStar i | this.getNode() = i and i.getModuleExpr() = result.getNode() |
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  override ImportStar getNode() { result = super.getNode() }
}

/** A control flow node corresponding to a subscript expression, such as `value[slice]` */
class SubscriptNode extends ControlFlowNode {
  SubscriptNode() { toAst(this) instanceof Subscript }

  /**
   * DEPRECATED: Use `getObject()` instead.
   * This will be formally deprecated before the end 2018 and removed in 2019.
   */
  deprecated ControlFlowNode getValue() {
    exists(Subscript s |
      this.getNode() = s and
      s.getObject() = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** flow node corresponding to the value of the sequence in a subscript operation */
  ControlFlowNode getObject() {
    exists(Subscript s |
      this.getNode() = s and
      s.getObject() = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** flow node corresponding to the index in a subscript operation */
  ControlFlowNode getIndex() {
    exists(Subscript s |
      this.getNode() = s and
      s.getIndex() = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  override Subscript getNode() { result = super.getNode() }
}

/** A control flow node corresponding to a comparison operation, such as `x<y` */
class CompareNode extends ControlFlowNode {
  CompareNode() { toAst(this) instanceof Compare }

  /** Whether left and right are a pair of operands for this comparison */
  predicate operands(ControlFlowNode left, Cmpop op, ControlFlowNode right) {
    exists(Compare c, Expr eleft, Expr eright |
      this.getNode() = c and left.getNode() = eleft and right.getNode() = eright
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

  override Compare getNode() { result = super.getNode() }
}

/** A control flow node corresponding to a conditional expression such as, `body if test else orelse` */
class IfExprNode extends ControlFlowNode {
  IfExprNode() { toAst(this) instanceof IfExp }

  /** flow node corresponding to one of the operands of an if-expression */
  ControlFlowNode getAnOperand() { result = this.getAPredecessor() }

  override IfExp getNode() { result = super.getNode() }
}

/** A control flow node corresponding to a binary expression, such as `x + y` */
class BinaryExprNode extends ControlFlowNode {
  BinaryExprNode() { toAst(this) instanceof BinaryExpr }

  /** flow node corresponding to one of the operands of a binary expression */
  ControlFlowNode getAnOperand() { result = this.getLeft() or result = this.getRight() }

  override BinaryExpr getNode() { result = super.getNode() }

  ControlFlowNode getLeft() {
    exists(BinaryExpr b |
      this.getNode() = b and
      result.getNode() = b.getLeft() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  ControlFlowNode getRight() {
    exists(BinaryExpr b |
      this.getNode() = b and
      result.getNode() = b.getRight() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the operator of this binary expression node. */
  Operator getOp() { result = this.getNode().getOp() }

  /** Whether left and right are a pair of operands for this binary expression */
  predicate operands(ControlFlowNode left, Operator op, ControlFlowNode right) {
    exists(BinaryExpr b, Expr eleft, Expr eright |
      this.getNode() = b and left.getNode() = eleft and right.getNode() = eright
    |
      eleft = b.getLeft() and eright = b.getRight() and op = b.getOp()
    ) and
    left.getBasicBlock().dominates(this.getBasicBlock()) and
    right.getBasicBlock().dominates(this.getBasicBlock())
  }
}

/** A control flow node corresponding to a boolean shortcut (and/or) operation */
class BoolExprNode extends ControlFlowNode {
  BoolExprNode() { toAst(this) instanceof BoolExpr }

  /** flow node corresponding to one of the operands of a boolean expression */
  ControlFlowNode getAnOperand() {
    exists(BoolExpr b | this.getNode() = b and result.getNode() = b.getAValue()) and
    this.getBasicBlock().dominates(result.getBasicBlock())
  }

  override BoolExpr getNode() { result = super.getNode() }
}

/** A control flow node corresponding to a unary expression: (`+x`), (`-x`) or (`~x`) */
class UnaryExprNode extends ControlFlowNode {
  UnaryExprNode() { toAst(this) instanceof UnaryExpr }

  /**
   * Gets flow node corresponding to the operand of a unary expression.
   * Note that this might not be the flow node for the AST operand.
   * In `not (a or b)` the AST operand is `(a or b)`, but as `a or b` is
   * a short-circuiting operation, there will be two `not` CFG nodes, one will
   * have `a` or `b` as it operand, the other will have just `b`.
   */
  ControlFlowNode getOperand() { result = this.getAPredecessor() }

  override UnaryExpr getNode() { result = super.getNode() }

  override ControlFlowNode getAChild() { result = this.getAPredecessor() }
}

/**
 * A control flow node corresponding to a definition, that is a control flow node
 * where a value is assigned to this node.
 * Includes control flow nodes for the targets of assignments, simple or augmented,
 * and nodes implicitly assigned in class and function definitions and imports.
 */
class DefinitionNode extends ControlFlowNode {
  DefinitionNode() {
    exists(Assign a | a.getATarget().getAFlowNode() = this)
    or
    exists(Alias a | a.getAsname().getAFlowNode() = this)
    or
    augstore(_, this)
    or
    // `x, y = 1, 2` where LHS is a combination of list or tuples
    exists(Assign a | list_or_tuple_nested_element(a.getATarget()).getAFlowNode() = this)
    or
    exists(For for | for.getTarget().getAFlowNode() = this)
  }

  /** flow node corresponding to the value assigned for the definition corresponding to this flow node */
  ControlFlowNode getValue() {
    result = assigned_value(this.getNode()).getAFlowNode() and
    (result.getBasicBlock().dominates(this.getBasicBlock()) or result.isImport())
  }
}

private Expr list_or_tuple_nested_element(Expr list_or_tuple) {
  exists(Expr elt |
    elt = list_or_tuple.(Tuple).getAnElt()
    or
    elt = list_or_tuple.(List).getAnElt()
  |
    result = elt
    or
    result = list_or_tuple_nested_element(elt)
  )
}

/**
 * A control flow node corresponding to a deletion statement, such as `del x`.
 * There can be multiple `DeletionNode`s for each `Delete` such that each
 * target has own `DeletionNode`. The CFG for `del a, x.y` looks like:
 * `NameNode('a') -> DeletionNode -> NameNode('b') -> AttrNode('y') -> DeletionNode`.
 */
class DeletionNode extends ControlFlowNode {
  DeletionNode() { toAst(this) instanceof Delete }

  /** Gets the unique target of this deletion node. */
  ControlFlowNode getTarget() { result.getASuccessor() = this }
}

/** A control flow node corresponding to a sequence (tuple or list) literal */
abstract class SequenceNode extends ControlFlowNode {
  SequenceNode() {
    toAst(this) instanceof Tuple
    or
    toAst(this) instanceof List
  }

  /** Gets the control flow node for an element of this sequence */
  ControlFlowNode getAnElement() { result = this.getElement(_) }

  /** Gets the control flow node for the nth element of this sequence */
  abstract ControlFlowNode getElement(int n);
}

/** A control flow node corresponding to a tuple expression such as `( 1, 3, 5, 7, 9 )` */
class TupleNode extends SequenceNode {
  TupleNode() { toAst(this) instanceof Tuple }

  override ControlFlowNode getElement(int n) {
    exists(Tuple t | this.getNode() = t and result.getNode() = t.getElt(n)) and
    (
      result.getBasicBlock().dominates(this.getBasicBlock())
      or
      this.getBasicBlock().dominates(result.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to a list expression, such as `[ 1, 3, 5, 7, 9 ]` */
class ListNode extends SequenceNode {
  ListNode() { toAst(this) instanceof List }

  override ControlFlowNode getElement(int n) {
    exists(List l | this.getNode() = l and result.getNode() = l.getElt(n)) and
    (
      result.getBasicBlock().dominates(this.getBasicBlock())
      or
      this.getBasicBlock().dominates(result.getBasicBlock())
    )
  }
}

class SetNode extends ControlFlowNode {
  SetNode() { toAst(this) instanceof Set }

  ControlFlowNode getAnElement() {
    exists(Set s | this.getNode() = s and result.getNode() = s.getElt(_)) and
    (
      result.getBasicBlock().dominates(this.getBasicBlock())
      or
      this.getBasicBlock().dominates(result.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to a dictionary literal, such as `{ 'a': 1, 'b': 2 }` */
class DictNode extends ControlFlowNode {
  DictNode() { toAst(this) instanceof Dict }

  /**
   * Gets a key of this dictionary literal node, for those items that have keys
   * E.g, in {'a':1, **b} this returns only 'a'
   */
  ControlFlowNode getAKey() {
    exists(Dict d | this.getNode() = d and result.getNode() = d.getAKey()) and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }

  /** Gets a value of this dictionary literal node */
  ControlFlowNode getAValue() {
    exists(Dict d | this.getNode() = d and result.getNode() = d.getAValue()) and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }
}

private AstNode assigned_value(Expr lhs) {
  /* lhs = result */
  exists(Assign a | a.getATarget() = lhs and result = a.getValue())
  or
  /* import result as lhs */
  exists(Alias a | a.getAsname() = lhs and result = a.getValue())
  or
  /* lhs += x  =>  result = (lhs + x) */
  exists(AugAssign a, BinaryExpr b | b = a.getOperation() and result = b and lhs = b.getLeft())
  or
  /*
   * ..., lhs, ... = ..., result, ...
   * or
   * ..., (..., lhs, ...), ... = ..., (..., result, ...), ...
   */

  exists(Assign a | nested_sequence_assign(a.getATarget(), a.getValue(), lhs, result))
  or
  /* for lhs in seq: => `result` is the `for` node, representing the `iter(next(seq))` operation. */
  result.(For).getTarget() = lhs
}

predicate nested_sequence_assign(
  Expr left_parent, Expr right_parent, Expr left_result, Expr right_result
) {
  exists(Assign a |
    a.getATarget().getASubExpression*() = left_parent and
    a.getValue().getASubExpression*() = right_parent
  ) and
  exists(int i, Expr left_elem, Expr right_elem |
    (
      left_elem = left_parent.(Tuple).getElt(i)
      or
      left_elem = left_parent.(List).getElt(i)
    ) and
    (
      right_elem = right_parent.(Tuple).getElt(i)
      or
      right_elem = right_parent.(List).getElt(i)
    )
  |
    left_result = left_elem and right_result = right_elem
    or
    nested_sequence_assign(left_elem, right_elem, left_result, right_result)
  )
}

/** A flow node for a `for` statement. */
class ForNode extends ControlFlowNode {
  ForNode() { toAst(this) instanceof For }

  override For getNode() { result = super.getNode() }

  /** Holds if this `for` statement causes iteration over `sequence` storing each step of the iteration in `target` */
  predicate iterates(ControlFlowNode target, ControlFlowNode sequence) {
    sequence = getSequence() and
    target = possibleTarget() and
    not target = unrolledSuffix().possibleTarget()
  }

  /** Gets the sequence node for this `for` statement. */
  ControlFlowNode getSequence() {
    exists(For for |
      toAst(this) = for and
      for.getIter() = result.getNode()
    |
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** A possible `target` for this `for` statement, not accounting for loop unrolling */
  private ControlFlowNode possibleTarget() {
    exists(For for |
      toAst(this) = for and
      for.getTarget() = result.getNode() and
      this.getBasicBlock().dominates(result.getBasicBlock())
    )
  }

  /** The unrolled `for` statement node matching this one */
  private ForNode unrolledSuffix() {
    not this = result and
    toAst(this) = toAst(result) and
    this.getBasicBlock().dominates(result.getBasicBlock())
  }
}

/** A flow node for a `raise` statement */
class RaiseStmtNode extends ControlFlowNode {
  RaiseStmtNode() { toAst(this) instanceof Raise }

  /** Gets the control flow node for the exception raised by this raise statement */
  ControlFlowNode getException() {
    exists(Raise r |
      r = toAst(this) and
      r.getException() = toAst(result) and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }
}

/**
 * A control flow node corresponding to a (plain variable) name expression, such as `var`.
 * `None`, `True` and `False` are excluded.
 */
class NameNode extends ControlFlowNode {
  NameNode() {
    exists(Name n | py_flow_bb_node(this, n, _, _))
    or
    exists(PlaceHolder p | py_flow_bb_node(this, p, _, _))
  }

  /** Whether this flow node defines the variable `v`. */
  predicate defines(Variable v) {
    exists(Name d | this.getNode() = d and d.defines(v)) and
    not this.isLoad()
  }

  /** Whether this flow node deletes the variable `v`. */
  predicate deletes(Variable v) { exists(Name d | this.getNode() = d and d.deletes(v)) }

  /** Whether this flow node uses the variable `v`. */
  predicate uses(Variable v) {
    this.isLoad() and
    exists(Name u | this.getNode() = u and u.uses(v))
    or
    exists(PlaceHolder u |
      this.getNode() = u and u.getVariable() = v and u.getCtx() instanceof Load
    )
    or
    Scopes::use_of_global_variable(this, v.getScope(), v.getId())
  }

  string getId() {
    result = this.getNode().(Name).getId()
    or
    result = this.getNode().(PlaceHolder).getId()
  }

  /** Whether this is a use of a local variable. */
  predicate isLocal() { Scopes::local(this) }

  /** Whether this is a use of a non-local variable. */
  predicate isNonLocal() { Scopes::non_local(this) }

  /** Whether this is a use of a global (including builtin) variable. */
  predicate isGlobal() { Scopes::use_of_global_variable(this, _, _) }

  predicate isSelf() { exists(SsaVariable selfvar | selfvar.isSelf() and selfvar.getAUse() = this) }
}

/** A control flow node corresponding to a named constant, one of `None`, `True` or `False`. */
class NameConstantNode extends NameNode {
  NameConstantNode() { exists(NameConstant n | py_flow_bb_node(this, n, _, _)) }

  deprecated override predicate defines(Variable v) { none() }

  deprecated override predicate deletes(Variable v) { none() }
  /*
   * We ought to override uses as well, but that has
   * a serious performance impact.
   *    deprecated predicate uses(Variable v) { none() }
   */

  }

/** A control flow node correspoinding to a starred expression, `*a`. */
class StarredNode extends ControlFlowNode {
  StarredNode() { toAst(this) instanceof Starred }

  ControlFlowNode getValue() { toAst(result) = toAst(this).(Starred).getValue() }
}

private module Scopes {
  private predicate fast_local(NameNode n) {
    exists(FastLocalVariable v |
      n.uses(v) and
      v.getScope() = n.getScope()
    )
  }

  predicate local(NameNode n) {
    fast_local(n)
    or
    exists(SsaVariable var |
      var.getAUse() = n and
      n.getScope() instanceof Class and
      exists(var.getDefinition())
    )
  }

  predicate non_local(NameNode n) {
    exists(FastLocalVariable flv |
      flv.getALoad() = n.getNode() and
      not flv.getScope() = n.getScope()
    )
  }

  // magic is fine, but we get questionable join-ordering of it
  pragma[nomagic]
  predicate use_of_global_variable(NameNode n, Module scope, string name) {
    n.isLoad() and
    not non_local(n) and
    not exists(SsaVariable var | var.getAUse() = n |
      var.getVariable() instanceof FastLocalVariable
      or
      n.getScope() instanceof Class and
      not maybe_undefined(var)
    ) and
    name = n.getId() and
    scope = n.getEnclosingModule()
  }

  private predicate maybe_defined(SsaVariable var) {
    exists(var.getDefinition()) and not py_ssa_phi(var, _) and not var.getDefinition().isDelete()
    or
    exists(SsaVariable input | input = var.getAPhiInput() | maybe_defined(input))
  }

  private predicate maybe_undefined(SsaVariable var) {
    not exists(var.getDefinition()) and not py_ssa_phi(var, _)
    or
    var.getDefinition().isDelete()
    or
    maybe_undefined(var.getAPhiInput())
    or
    exists(BasicBlock incoming |
      exists(var.getAPhiInput()) and
      incoming.getASuccessor() = var.getDefinition().getBasicBlock() and
      not var.getAPhiInput().getDefinition().getBasicBlock().dominates(incoming)
    )
  }
}

/** A basic block (ignoring exceptional flow edges to scope exit) */
class BasicBlock extends @py_flow_node {
  BasicBlock() { py_flow_bb_node(_, _, this, _) }

  /** Whether this basic block contains the specified node */
  predicate contains(ControlFlowNode node) { py_flow_bb_node(node, _, this, _) }

  /** Gets the nth node in this basic block */
  ControlFlowNode getNode(int n) { py_flow_bb_node(result, _, this, n) }

  /** Gets a textual representation of this element. */
  string toString() { result = "BasicBlock" }

  /** Whether this basic block strictly dominates the other */
  pragma[nomagic]
  predicate strictlyDominates(BasicBlock other) { other.getImmediateDominator+() = this }

  /** Whether this basic block dominates the other */
  pragma[nomagic]
  predicate dominates(BasicBlock other) {
    this = other
    or
    this.strictlyDominates(other)
  }

  cached
  BasicBlock getImmediateDominator() {
    this.firstNode().getImmediateDominator().getBasicBlock() = result
  }

  /**
   * Dominance frontier of a node x is the set of all nodes `other` such that `this` dominates a predecessor
   * of `other` but does not strictly dominate `other`
   */
  pragma[noinline]
  predicate dominanceFrontier(BasicBlock other) {
    this.dominates(other.getAPredecessor()) and not this.strictlyDominates(other)
  }

  private ControlFlowNode firstNode() { result = this }

  /** Gets the last node in this basic block */
  ControlFlowNode getLastNode() {
    exists(int i |
      this.getNode(i) = result and
      i = max(int j | py_flow_bb_node(_, _, this, j))
    )
  }

  private predicate oneNodeBlock() { this.firstNode() = this.getLastNode() }

  private predicate startLocationInfo(string file, int line, int col) {
    if this.firstNode().getNode() instanceof Scope
    then this.firstNode().getASuccessor().getLocation().hasLocationInfo(file, line, col, _, _)
    else this.firstNode().getLocation().hasLocationInfo(file, line, col, _, _)
  }

  private predicate endLocationInfo(int endl, int endc) {
    if this.getLastNode().getNode() instanceof Scope and not this.oneNodeBlock()
    then this.getLastNode().getAPredecessor().getLocation().hasLocationInfo(_, _, _, endl, endc)
    else this.getLastNode().getLocation().hasLocationInfo(_, _, _, endl, endc)
  }

  /** Gets a successor to this basic block */
  BasicBlock getASuccessor() { result = this.getLastNode().getASuccessor().getBasicBlock() }

  /** Gets a predecessor to this basic block */
  BasicBlock getAPredecessor() { result.getASuccessor() = this }

  /** Whether flow from this basic block reaches a normal exit from its scope */
  predicate reachesExit() {
    exists(Scope s | s.getANormalExit().getBasicBlock() = this)
    or
    this.getASuccessor().reachesExit()
  }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.startLocationInfo(filepath, startline, startcolumn) and
    this.endLocationInfo(endline, endcolumn)
  }

  /** Gets a true successor to this basic block */
  BasicBlock getATrueSuccessor() { result = this.getLastNode().getATrueSuccessor().getBasicBlock() }

  /** Gets a false successor to this basic block */
  BasicBlock getAFalseSuccessor() {
    result = this.getLastNode().getAFalseSuccessor().getBasicBlock()
  }

  /** Gets an unconditional successor to this basic block */
  BasicBlock getAnUnconditionalSuccessor() {
    result = this.getASuccessor() and
    not result = this.getATrueSuccessor() and
    not result = this.getAFalseSuccessor()
  }

  /** Gets an exceptional successor to this basic block */
  BasicBlock getAnExceptionalSuccessor() {
    result = this.getLastNode().getAnExceptionalSuccessor().getBasicBlock()
  }

  /** Gets the scope of this block */
  pragma[nomagic]
  Scope getScope() {
    exists(ControlFlowNode n | n.getBasicBlock() = this |
      /* Take care not to use an entry or exit node as that node's scope will be the outer scope */
      not py_scope_flow(n, _, -1) and
      not py_scope_flow(n, _, 0) and
      not py_scope_flow(n, _, 2) and
      result = n.getScope()
      or
      py_scope_flow(n, result, _)
    )
  }

  /**
   * Whether (as inferred by type inference) it is highly unlikely (or impossible) for control to flow from this to succ.
   */
  predicate unlikelySuccessor(BasicBlock succ) {
    this.getLastNode().(RaisingNode).unlikelySuccessor(succ.firstNode())
    or
    not end_bb_likely_reachable(this) and succ = this.getASuccessor()
  }

  /** Holds if this basic block strictly reaches the other. Is the start of other reachable from the end of this. */
  predicate strictlyReaches(BasicBlock other) { this.getASuccessor+() = other }

  /** Holds if this basic block reaches the other. Is the start of other reachable from the end of this. */
  predicate reaches(BasicBlock other) { this = other or this.strictlyReaches(other) }

  /**
   * Whether (as inferred by type inference) this basic block is likely to be reachable.
   */
  predicate likelyReachable() { start_bb_likely_reachable(this) }

  /**
   * Gets the `ConditionBlock`, if any, that controls this block and
   * does not control any other `ConditionBlock`s that control this block.
   * That is the `ConditionBlock` that is closest dominator.
   */
  ConditionBlock getImmediatelyControllingBlock() {
    result = this.nonControllingImmediateDominator*().getImmediateDominator()
  }

  private BasicBlock nonControllingImmediateDominator() {
    result = this.getImmediateDominator() and
    not result.(ConditionBlock).controls(this, _)
  }

  /**
   * Holds if flow from this BasicBlock always reaches `succ`
   */
  predicate alwaysReaches(BasicBlock succ) {
    succ = this
    or
    strictcount(this.getASuccessor()) = 1 and
    succ = this.getASuccessor()
    or
    forex(BasicBlock immsucc | immsucc = this.getASuccessor() | immsucc.alwaysReaches(succ))
  }
}

private predicate start_bb_likely_reachable(BasicBlock b) {
  exists(Scope s | s.getEntryNode() = b.getNode(_))
  or
  exists(BasicBlock pred |
    pred = b.getAPredecessor() and
    end_bb_likely_reachable(pred) and
    not pred.getLastNode().(RaisingNode).unlikelySuccessor(b)
  )
}

private predicate end_bb_likely_reachable(BasicBlock b) {
  start_bb_likely_reachable(b) and
  not exists(ControlFlowNode p, ControlFlowNode s |
    p.(RaisingNode).unlikelySuccessor(s) and
    p = b.getNode(_) and
    s = b.getNode(_) and
    not p = b.getLastNode()
  )
}
