overlay[local]
module;

import python as Py
private import semmle.python.internal.CachedStages
private import codeql.controlflow.BasicBlock as BB

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
  exists(Py::Expr load_store | exists(Py::AugAssign aa | aa.getTarget() = load_store) |
    toAst(load) = load_store and
    toAst(store) = load_store and
    load.strictlyDominates(store)
  )
}

/** A non-dispatched getNode() to avoid negative recursion issues */
private Py::AstNode toAst(ControlFlowNode n) { py_flow_bb_node(n, result, _, _) }

/**
 * A control flow node. Control flow nodes have a many-to-one relation with syntactic nodes,
 * although most syntactic nodes have only one corresponding control flow node.
 * Edges between control flow nodes include exceptional as well as normal control flow.
 */
class ControlFlowNode extends @py_flow_node {
  /** Whether this control flow node is a load (including those in augmented assignments) */
  predicate isLoad() {
    exists(Py::Expr e | e = toAst(this) | py_expr_contexts(_, 3, e) and not augstore(_, this))
  }

  /** Whether this control flow node is a store (including those in augmented assignments) */
  predicate isStore() {
    exists(Py::Expr e | e = toAst(this) | py_expr_contexts(_, 5, e) or augstore(_, this))
  }

  /** Whether this control flow node is a delete */
  predicate isDelete() { exists(Py::Expr e | e = toAst(this) | py_expr_contexts(_, 2, e)) }

  /** Whether this control flow node is a parameter */
  predicate isParameter() { exists(Py::Expr e | e = toAst(this) | py_expr_contexts(_, 4, e)) }

  /** Whether this control flow node is a store in an augmented assignment */
  predicate isAugStore() { augstore(_, this) }

  /** Whether this control flow node is a load in an augmented assignment */
  predicate isAugLoad() { augstore(this, _) }

  /** Whether this flow node corresponds to a literal */
  predicate isLiteral() {
    toAst(this) instanceof Py::Bytes
    or
    toAst(this) instanceof Py::Dict
    or
    toAst(this) instanceof Py::DictComp
    or
    toAst(this) instanceof Py::Set
    or
    toAst(this) instanceof Py::SetComp
    or
    toAst(this) instanceof Py::Ellipsis
    or
    toAst(this) instanceof Py::GeneratorExp
    or
    toAst(this) instanceof Py::Lambda
    or
    toAst(this) instanceof Py::ListComp
    or
    toAst(this) instanceof Py::List
    or
    toAst(this) instanceof Py::Num
    or
    toAst(this) instanceof Py::Tuple
    or
    toAst(this) instanceof Py::Unicode
    or
    toAst(this) instanceof Py::NameConstant
  }

  /** Whether this flow node corresponds to an attribute expression */
  predicate isAttribute() { toAst(this) instanceof Py::Attribute }

  /** Whether this flow node corresponds to an subscript expression */
  predicate isSubscript() { toAst(this) instanceof Py::Subscript }

  /** Whether this flow node corresponds to an import member */
  predicate isImportMember() { toAst(this) instanceof Py::ImportMember }

  /** Whether this flow node corresponds to a call */
  predicate isCall() { toAst(this) instanceof Py::Call }

  /** Whether this flow node is the first in a module */
  predicate isModuleEntry() { this.isEntryNode() and toAst(this) instanceof Py::Module }

  /** Whether this flow node corresponds to an import */
  predicate isImport() { toAst(this) instanceof Py::ImportExpr }

  /** Whether this flow node corresponds to a conditional expression */
  predicate isIfExp() { toAst(this) instanceof Py::IfExp }

  /** Whether this flow node corresponds to a function definition expression */
  predicate isFunction() { toAst(this) instanceof Py::FunctionExpr }

  /** Whether this flow node corresponds to a class definition expression */
  predicate isClass() { toAst(this) instanceof Py::ClassExpr }

  /** Gets a predecessor of this flow node */
  ControlFlowNode getAPredecessor() { this = result.getASuccessor() }

  /** Gets a successor of this flow node */
  ControlFlowNode getASuccessor() { py_successors(this, result) }

  /** Gets the immediate dominator of this flow node */
  ControlFlowNode getImmediateDominator() { py_idoms(this, result) }

  /** Gets the syntactic element corresponding to this flow node */
  Py::AstNode getNode() { py_flow_bb_node(this, result, _, _) }

  /** Gets a textual representation of this element. */
  cached
  string toString() {
    Stages::AST::ref() and
    // Since modules can have ambigous names, entry nodes can too, if we do not collate them.
    exists(Py::Scope s | s.getEntryNode() = this |
      result = "Entry node for " + concat( | | s.toString(), ",")
    )
    or
    exists(Py::Scope s | s.getANormalExit() = this | result = "Exit node for " + s.toString())
    or
    not exists(Py::Scope s | s.getEntryNode() = this or s.getANormalExit() = this) and
    result = "ControlFlowNode for " + this.getNode().toString()
  }

  /** Gets the location of this ControlFlowNode */
  Py::Location getLocation() { result = this.getNode().getLocation() }

  /** Whether this flow node is the first in its scope */
  predicate isEntryNode() { py_scope_flow(this, _, -1) }

  /** Gets the basic block containing this flow node */
  BasicBlock getBasicBlock() { result.contains(this) }

  /** Gets the scope containing this flow node */
  cached
  Py::Scope getScope() {
    Stages::AST::ref() and
    if this.getNode() instanceof Py::Scope
    then
      /* Entry or exit node */
      result = this.getNode()
    else result = this.getNode().getScope()
  }

  /** Gets the enclosing module */
  Py::Module getEnclosingModule() { result = this.getScope().getEnclosingModule() }

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
  predicate isExceptionalExit(Py::Scope s) { py_scope_flow(this, s, 1) }

  /** Whether this node is a normal (non-exceptional) exit */
  predicate isNormalExit() { py_scope_flow(this, _, 0) or py_scope_flow(this, _, 2) }

  /** Whether this strictly dominates other. */
  overlay[caller]
  pragma[inline]
  predicate strictlyDominates(ControlFlowNode other) {
    // This predicate is gigantic, so it must be inlined.
    // About 1.4 billion tuples for OpenStack Py::Cinder.
    this.getBasicBlock().strictlyDominates(other.getBasicBlock())
    or
    exists(BasicBlock b, int i, int j | this = b.getNode(i) and other = b.getNode(j) and i < j)
  }

  /**
   * Whether this dominates other.
   * Note that all nodes dominate themselves.
   */
  overlay[caller]
  pragma[inline]
  predicate dominates(ControlFlowNode other) {
    // This predicate is gigantic, so it must be inlined.
    this.getBasicBlock().strictlyDominates(other.getBasicBlock())
    or
    exists(BasicBlock b, int i, int j | this = b.getNode(i) and other = b.getNode(j) and i <= j)
  }

  /** Whether this strictly reaches other. */
  overlay[caller]
  pragma[inline]
  predicate strictlyReaches(ControlFlowNode other) {
    // This predicate is gigantic, even larger than strictlyDominates,
    // so it must be inlined.
    this.getBasicBlock().strictlyReaches(other.getBasicBlock())
    or
    exists(BasicBlock b, int i, int j | this = b.getNode(i) and other = b.getNode(j) and i < j)
  }

  /** Holds if this CFG node is a branch */
  predicate isBranch() { py_true_successors(this, _) or py_false_successors(this, _) }

  ControlFlowNode getAChild() { result = this.getExprChild(this.getBasicBlock()) }

  /* join-ordering helper for `getAChild() */
  pragma[noinline]
  private ControlFlowNode getExprChild(BasicBlock dom) {
    this.getNode().(Py::Expr).getAChildNode() = result.getNode() and
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
  override Py::AstNode getNode() { result = super.getNode() }
}

/** A control flow node corresponding to a call expression, such as `func(...)` */
class CallNode extends ControlFlowNode {
  CallNode() { toAst(this) instanceof Py::Call }

  /** Gets the flow node corresponding to the function expression for the call corresponding to this flow node */
  ControlFlowNode getFunction() {
    exists(Py::Call c |
      this.getNode() = c and
      c.getFunc() = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the flow node corresponding to the n'th positional argument of the call corresponding to this flow node */
  ControlFlowNode getArg(int n) {
    exists(Py::Call c |
      this.getNode() = c and
      c.getArg(n) = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the flow node corresponding to the named argument of the call corresponding to this flow node */
  ControlFlowNode getArgByName(string name) {
    exists(Py::Call c, Py::Keyword k |
      this.getNode() = c and
      k = c.getANamedArg() and
      k.getValue() = result.getNode() and
      k.getArg() = name and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the flow node corresponding to an argument of the call corresponding to this flow node */
  ControlFlowNode getAnArg() {
    result = this.getArg(_)
    or
    result = this.getArgByName(_)
  }

  override Py::Call getNode() { result = super.getNode() }

  predicate isDecoratorCall() {
    this.isClassDecoratorCall()
    or
    this.isFunctionDecoratorCall()
  }

  predicate isClassDecoratorCall() {
    exists(Py::ClassExpr cls | this.getNode() = cls.getADecoratorCall())
  }

  predicate isFunctionDecoratorCall() {
    exists(Py::FunctionExpr func | this.getNode() = func.getADecoratorCall())
  }

  /** Gets the first tuple (*) argument of this call, if any. */
  ControlFlowNode getStarArg() {
    result.getNode() = this.getNode().getStarArg() and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }

  /** Gets a dictionary (**) argument of this call, if any. */
  ControlFlowNode getKwargs() {
    result.getNode() = this.getNode().getKwargs() and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }
}

/** A control flow corresponding to an attribute expression, such as `value.attr` */
class AttrNode extends ControlFlowNode {
  AttrNode() { toAst(this) instanceof Py::Attribute }

  /** Gets the flow node corresponding to the object of the attribute expression corresponding to this flow node */
  ControlFlowNode getObject() {
    exists(Py::Attribute a |
      this.getNode() = a and
      a.getObject() = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /**
   * Gets the flow node corresponding to the object of the attribute expression corresponding to this flow node,
   * with the matching name
   */
  ControlFlowNode getObject(string name) {
    exists(Py::Attribute a |
      this.getNode() = a and
      a.getObject() = result.getNode() and
      a.getName() = name and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the attribute name of the attribute expression corresponding to this flow node */
  string getName() { exists(Py::Attribute a | this.getNode() = a and a.getName() = result) }

  override Py::Attribute getNode() { result = super.getNode() }
}

/** A control flow node corresponding to a `from ... import ...` expression */
class ImportMemberNode extends ControlFlowNode {
  ImportMemberNode() { toAst(this) instanceof Py::ImportMember }

  /**
   * Gets the flow node corresponding to the module in the import-member expression corresponding to this flow node,
   * with the matching name
   */
  ControlFlowNode getModule(string name) {
    exists(Py::ImportMember i | this.getNode() = i and i.getModule() = result.getNode() |
      i.getName() = name and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  override Py::ImportMember getNode() { result = super.getNode() }
}

/** A control flow node corresponding to an artificial expression representing an import */
class ImportExprNode extends ControlFlowNode {
  ImportExprNode() { toAst(this) instanceof Py::ImportExpr }

  override Py::ImportExpr getNode() { result = super.getNode() }
}

/** A control flow node corresponding to a `from ... import *` statement */
class ImportStarNode extends ControlFlowNode {
  ImportStarNode() { toAst(this) instanceof Py::ImportStar }

  /** Gets the flow node corresponding to the module in the import-star corresponding to this flow node */
  ControlFlowNode getModule() {
    exists(Py::ImportStar i | this.getNode() = i and i.getModuleExpr() = result.getNode() |
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  override Py::ImportStar getNode() { result = super.getNode() }
}

/** A control flow node corresponding to a subscript expression, such as `value[slice]` */
class SubscriptNode extends ControlFlowNode {
  SubscriptNode() { toAst(this) instanceof Py::Subscript }

  /** flow node corresponding to the value of the sequence in a subscript operation */
  ControlFlowNode getObject() {
    exists(Py::Subscript s |
      this.getNode() = s and
      s.getObject() = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** flow node corresponding to the index in a subscript operation */
  ControlFlowNode getIndex() {
    exists(Py::Subscript s |
      this.getNode() = s and
      s.getIndex() = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  override Py::Subscript getNode() { result = super.getNode() }
}

/** A control flow node corresponding to a comparison operation, such as `x<y` */
class CompareNode extends ControlFlowNode {
  CompareNode() { toAst(this) instanceof Py::Compare }

  /** Whether left and right are a pair of operands for this comparison */
  predicate operands(ControlFlowNode left, Py::Cmpop op, ControlFlowNode right) {
    exists(Py::Compare c, Py::Expr eleft, Py::Expr eright |
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

  override Py::Compare getNode() { result = super.getNode() }
}

/** A control flow node corresponding to a conditional expression such as, `body if test else orelse` */
class IfExprNode extends ControlFlowNode {
  IfExprNode() { toAst(this) instanceof Py::IfExp }

  /** flow node corresponding to one of the operands of an if-expression */
  ControlFlowNode getAnOperand() { result = this.getAPredecessor() }

  override Py::IfExp getNode() { result = super.getNode() }
}

/** A control flow node corresponding to an assignment expression such as `lhs := rhs`. */
class AssignmentExprNode extends ControlFlowNode {
  AssignmentExprNode() { toAst(this) instanceof Py::AssignExpr }

  /** Gets the flow node corresponding to the left-hand side of the assignment expression */
  ControlFlowNode getTarget() {
    exists(Py::AssignExpr a |
      this.getNode() = a and
      a.getTarget() = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the flow node corresponding to the right-hand side of the assignment expression */
  ControlFlowNode getValue() {
    exists(Py::AssignExpr a |
      this.getNode() = a and
      a.getValue() = result.getNode() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  override Py::AssignExpr getNode() { result = super.getNode() }
}

/** A control flow node corresponding to a binary expression, such as `x + y` */
class BinaryExprNode extends ControlFlowNode {
  BinaryExprNode() { toAst(this) instanceof Py::BinaryExpr }

  /** flow node corresponding to one of the operands of a binary expression */
  ControlFlowNode getAnOperand() { result = this.getLeft() or result = this.getRight() }

  override Py::BinaryExpr getNode() { result = super.getNode() }

  ControlFlowNode getLeft() {
    exists(Py::BinaryExpr b |
      this.getNode() = b and
      result.getNode() = b.getLeft() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  ControlFlowNode getRight() {
    exists(Py::BinaryExpr b |
      this.getNode() = b and
      result.getNode() = b.getRight() and
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** Gets the operator of this binary expression node. */
  Py::Operator getOp() { result = this.getNode().getOp() }

  /** Whether left and right are a pair of operands for this binary expression */
  predicate operands(ControlFlowNode left, Py::Operator op, ControlFlowNode right) {
    exists(Py::BinaryExpr b, Py::Expr eleft, Py::Expr eright |
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
  BoolExprNode() { toAst(this) instanceof Py::BoolExpr }

  /** flow node corresponding to one of the operands of a boolean expression */
  ControlFlowNode getAnOperand() {
    exists(Py::BoolExpr b | this.getNode() = b and result.getNode() = b.getAValue()) and
    this.getBasicBlock().dominates(result.getBasicBlock())
  }

  override Py::BoolExpr getNode() { result = super.getNode() }
}

/** A control flow node corresponding to a unary expression: (`+x`), (`-x`) or (`~x`) */
class UnaryExprNode extends ControlFlowNode {
  UnaryExprNode() { toAst(this) instanceof Py::UnaryExpr }

  /**
   * Gets flow node corresponding to the operand of a unary expression.
   * Note that this might not be the flow node for the AST operand.
   * In `not (a or b)` the AST operand is `(a or b)`, but as `a or b` is
   * a short-circuiting operation, there will be two `not` CFG nodes, one will
   * have `a` or `b` as it operand, the other will have just `b`.
   */
  ControlFlowNode getOperand() { result = this.getAPredecessor() }

  override Py::UnaryExpr getNode() { result = super.getNode() }

  override ControlFlowNode getAChild() { result = this.getAPredecessor() }
}

/**
 * A control flow node corresponding to a definition, that is a control flow node
 * where a value is assigned to this node.
 * Includes control flow nodes for the targets of assignments, simple or augmented,
 * and nodes implicitly assigned in class and function definitions and imports.
 */
class DefinitionNode extends ControlFlowNode {
  cached
  DefinitionNode() {
    Stages::AST::ref() and
    exists(Py::Assign a | this.getNode() = a.getATarget())
    or
    exists(Py::AssignExpr a | this.getNode() = a.getTarget())
    or
    exists(Py::AnnAssign a | this.getNode() = a.getTarget() and exists(a.getValue()))
    or
    exists(Py::Alias a | this.getNode() = a.getAsname())
    or
    augstore(_, this)
    or
    // `x, y = 1, 2` where LHS is a combination of list or tuples
    exists(Py::Assign a | this.getNode() = list_or_tuple_nested_element(a.getATarget()))
    or
    exists(Py::For for | this.getNode() = for.getTarget())
    or
    exists(Py::Parameter param | this.getNode() = param.asName() and exists(param.getDefault()))
  }

  /** flow node corresponding to the value assigned for the definition corresponding to this flow node */
  ControlFlowNode getValue() {
    result.getNode() = assigned_value(this.getNode()) and
    (
      result.getBasicBlock().dominates(this.getBasicBlock())
      or
      result.isImport()
      or
      // since the default value for a parameter is evaluated in the same basic block as
      // the function definition, but the parameter belongs to the basic block of the function,
      // there is no dominance relationship between the two.
      exists(Py::Parameter param | this.getNode() = param.asName())
    )
  }
}

private Py::Expr list_or_tuple_nested_element(Py::Expr list_or_tuple) {
  exists(Py::Expr elt |
    elt = list_or_tuple.(Py::Tuple).getAnElt()
    or
    elt = list_or_tuple.(Py::List).getAnElt()
  |
    result = elt
    or
    result = list_or_tuple_nested_element(elt)
  )
}

/**
 * A control flow node corresponding to a deletion statement, such as `del x`.
 * There can be multiple `DeletionNode`s for each `Py::Delete` such that each
 * target has own `DeletionNode`. The CFG for `del a, x.y` looks like:
 * `NameNode('a') -> DeletionNode -> NameNode('b') -> AttrNode('y') -> DeletionNode`.
 */
class DeletionNode extends ControlFlowNode {
  DeletionNode() { toAst(this) instanceof Py::Delete }

  /** Gets the unique target of this deletion node. */
  ControlFlowNode getTarget() { result.getASuccessor() = this }
}

/** A control flow node corresponding to a sequence (tuple or list) literal */
abstract class SequenceNode extends ControlFlowNode {
  SequenceNode() {
    toAst(this) instanceof Py::Tuple
    or
    toAst(this) instanceof Py::List
  }

  /** Gets the control flow node for an element of this sequence */
  ControlFlowNode getAnElement() { result = this.getElement(_) }

  /** Gets the control flow node for the nth element of this sequence */
  cached
  abstract ControlFlowNode getElement(int n);
}

/** A control flow node corresponding to a tuple expression such as `( 1, 3, 5, 7, 9 )` */
class TupleNode extends SequenceNode {
  TupleNode() { toAst(this) instanceof Py::Tuple }

  override ControlFlowNode getElement(int n) {
    Stages::AST::ref() and
    exists(Py::Tuple t | this.getNode() = t and result.getNode() = t.getElt(n)) and
    (
      result.getBasicBlock().dominates(this.getBasicBlock())
      or
      this.getBasicBlock().dominates(result.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to a list expression, such as `[ 1, 3, 5, 7, 9 ]` */
class ListNode extends SequenceNode {
  ListNode() { toAst(this) instanceof Py::List }

  override ControlFlowNode getElement(int n) {
    exists(Py::List l | this.getNode() = l and result.getNode() = l.getElt(n)) and
    (
      result.getBasicBlock().dominates(this.getBasicBlock())
      or
      this.getBasicBlock().dominates(result.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to a set expression, such as `{ 1, 3, 5, 7, 9 }` */
class SetNode extends ControlFlowNode {
  SetNode() { toAst(this) instanceof Py::Set }

  ControlFlowNode getAnElement() {
    exists(Py::Set s | this.getNode() = s and result.getNode() = s.getElt(_)) and
    (
      result.getBasicBlock().dominates(this.getBasicBlock())
      or
      this.getBasicBlock().dominates(result.getBasicBlock())
    )
  }
}

/** A control flow node corresponding to a dictionary literal, such as `{ 'a': 1, 'b': 2 }` */
class DictNode extends ControlFlowNode {
  DictNode() { toAst(this) instanceof Py::Dict }

  /**
   * Gets a key of this dictionary literal node, for those items that have keys
   * E.g, in {'a':1, **b} this returns only 'a'
   */
  ControlFlowNode getAKey() {
    exists(Py::Dict d | this.getNode() = d and result.getNode() = d.getAKey()) and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }

  /** Gets a value of this dictionary literal node */
  ControlFlowNode getAValue() {
    exists(Py::Dict d | this.getNode() = d and result.getNode() = d.getAValue()) and
    result.getBasicBlock().dominates(this.getBasicBlock())
  }
}

/**
 * A control flow node corresponding to an iterable literal. Currently does not include
 * dictionaries, use `DictNode` directly instead.
 */
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

private Py::AstNode assigned_value(Py::Expr lhs) {
  /* lhs = result */
  exists(Py::Assign a | a.getATarget() = lhs and result = a.getValue())
  or
  /* lhs := result */
  exists(Py::AssignExpr a | a.getTarget() = lhs and result = a.getValue())
  or
  /* lhs : annotation = result */
  exists(Py::AnnAssign a | a.getTarget() = lhs and result = a.getValue())
  or
  /* import result as lhs */
  exists(Py::Alias a | a.getAsname() = lhs and result = a.getValue())
  or
  /* lhs += x  =>  result = (lhs + x) */
  exists(Py::AugAssign a, Py::BinaryExpr b | b = a.getOperation() and result = b and lhs = b.getLeft())
  or
  /*
   * ..., lhs, ... = ..., result, ...
   * or
   * ..., (..., lhs, ...), ... = ..., (..., result, ...), ...
   */

  exists(Py::Assign a | nested_sequence_assign(a.getATarget(), a.getValue(), lhs, result))
  or
  /* for lhs in seq: => `result` is the `for` node, representing the `iter(next(seq))` operation. */
  result.(Py::For).getTarget() = lhs
  or
  exists(Py::Parameter param | lhs = param.asName() and result = param.getDefault())
}

predicate nested_sequence_assign(
  Py::Expr left_parent, Py::Expr right_parent, Py::Expr left_result, Py::Expr right_result
) {
  exists(Py::Assign a |
    a.getATarget().getASubExpression*() = left_parent and
    a.getValue().getASubExpression*() = right_parent
  ) and
  exists(int i, Py::Expr left_elem, Py::Expr right_elem |
    (
      left_elem = left_parent.(Py::Tuple).getElt(i)
      or
      left_elem = left_parent.(Py::List).getElt(i)
    ) and
    (
      right_elem = right_parent.(Py::Tuple).getElt(i)
      or
      right_elem = right_parent.(Py::List).getElt(i)
    )
  |
    left_result = left_elem and right_result = right_elem
    or
    nested_sequence_assign(left_elem, right_elem, left_result, right_result)
  )
}

/** A flow node for a `for` statement. */
class ForNode extends ControlFlowNode {
  ForNode() { toAst(this) instanceof Py::For }

  override Py::For getNode() { result = super.getNode() }

  /** Holds if this `for` statement causes iteration over `sequence` storing each step of the iteration in `target` */
  predicate iterates(ControlFlowNode target, ControlFlowNode sequence) {
    sequence = this.getSequence() and
    target = this.possibleTarget() and
    not target = this.unrolledSuffix().possibleTarget()
  }

  /** Gets the sequence node for this `for` statement. */
  ControlFlowNode getSequence() {
    exists(Py::For for |
      toAst(this) = for and
      for.getIter() = result.getNode()
    |
      result.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  /** A possible `target` for this `for` statement, not accounting for loop unrolling */
  private ControlFlowNode possibleTarget() {
    exists(Py::For for |
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
  RaiseStmtNode() { toAst(this) instanceof Py::Raise }

  /** Gets the control flow node for the exception raised by this raise statement */
  ControlFlowNode getException() {
    exists(Py::Raise r |
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
    exists(Py::Name n | py_flow_bb_node(this, n, _, _))
    or
    exists(Py::PlaceHolder p | py_flow_bb_node(this, p, _, _))
  }

  /** Whether this flow node defines the variable `v`. */
  predicate defines(Py::Variable v) {
    exists(Py::Name d | this.getNode() = d and d.defines(v)) and
    not this.isLoad()
  }

  /** Whether this flow node deletes the variable `v`. */
  predicate deletes(Py::Variable v) { exists(Py::Name d | this.getNode() = d and d.deletes(v)) }

  /** Whether this flow node uses the variable `v`. */
  predicate uses(Py::Variable v) {
    this.isLoad() and
    exists(Py::Name u | this.getNode() = u and u.uses(v))
    or
    exists(Py::PlaceHolder u |
      this.getNode() = u and u.getVariable() = v and u.getCtx() instanceof Py::Load
    )
    or
    Scopes::use_of_global_variable(this, v.getScope(), v.getId())
  }

  string getId() {
    result = this.getNode().(Py::Name).getId()
    or
    result = this.getNode().(Py::PlaceHolder).getId()
  }

  /** Whether this is a use of a local variable. */
  predicate isLocal() { Scopes::local(this) }

  /** Whether this is a use of a non-local variable. */
  predicate isNonLocal() { Scopes::non_local(this) }

  /** Whether this is a use of a global (including builtin) variable. */
  predicate isGlobal() { Scopes::use_of_global_variable(this, _, _) }

  predicate isSelf() { exists(Py::SsaVariable selfvar | selfvar.isSelf() and selfvar.getAUse() = this) }
}

/** A control flow node corresponding to a named constant, one of `None`, `True` or `False`. */
class NameConstantNode extends NameNode {
  NameConstantNode() { exists(Py::NameConstant n | py_flow_bb_node(this, n, _, _)) }
  /*
   * We ought to override uses as well, but that has
   * a serious performance impact.
   *    deprecated predicate uses(Py::Variable v) { none() }
   */

  }

/** A control flow node corresponding to a starred expression, `*a`. */
class StarredNode extends ControlFlowNode {
  StarredNode() { toAst(this) instanceof Py::Starred }

  ControlFlowNode getValue() { toAst(result) = toAst(this).(Py::Starred).getValue() }
}

/** The ControlFlowNode for an 'except' statement. */
class ExceptFlowNode extends ControlFlowNode {
  ExceptFlowNode() { this.getNode() instanceof Py::ExceptStmt }

  /**
   * Gets the type handled by this exception handler.
   * `Py::ExceptionType` in `except Py::ExceptionType as e:`
   */
  ControlFlowNode getType() {
    exists(Py::ExceptStmt ex |
      this.getBasicBlock().dominates(result.getBasicBlock()) and
      ex = this.getNode() and
      result.getNode() = ex.getType()
    )
  }

  /**
   * Gets the name assigned to the handled exception, if any.
   * `e` in `except Py::ExceptionType as e:`
   */
  ControlFlowNode getName() {
    exists(Py::ExceptStmt ex |
      this.getBasicBlock().dominates(result.getBasicBlock()) and
      ex = this.getNode() and
      result.getNode() = ex.getName()
    )
  }
}

/** The ControlFlowNode for an 'except*' statement. */
class ExceptGroupFlowNode extends ControlFlowNode {
  ExceptGroupFlowNode() { this.getNode() instanceof Py::ExceptGroupStmt }

  /**
   * Gets the type handled by this exception handler.
   * `Py::ExceptionType` in `except* Py::ExceptionType as e:`
   */
  ControlFlowNode getType() {
    this.getBasicBlock().dominates(result.getBasicBlock()) and
    result.getNode() = this.getNode().(Py::ExceptGroupStmt).getType()
  }

  /**
   * Gets the name assigned to the handled exception, if any.
   * `e` in `except* Py::ExceptionType as e:`
   */
  ControlFlowNode getName() {
    this.getBasicBlock().dominates(result.getBasicBlock()) and
    result.getNode() = this.getNode().(Py::ExceptGroupStmt).getName()
  }
}

private module Scopes {
  private predicate fast_local(NameNode n) {
    exists(Py::FastLocalVariable v |
      n.uses(v) and
      v.getScope() = n.getScope()
    )
  }

  predicate local(NameNode n) {
    fast_local(n)
    or
    exists(Py::SsaVariable var |
      var.getAUse() = n and
      n.getScope() instanceof Py::Class and
      exists(var.getDefinition())
    )
  }

  predicate non_local(NameNode n) {
    exists(Py::FastLocalVariable flv |
      flv.getALoad() = n.getNode() and
      not flv.getScope() = n.getScope()
    )
  }

  // magic is fine, but we get questionable join-ordering of it
  pragma[nomagic]
  predicate use_of_global_variable(NameNode n, Py::Module scope, string name) {
    n.isLoad() and
    not non_local(n) and
    not exists(Py::SsaVariable var | var.getAUse() = n |
      var.getVariable() instanceof Py::FastLocalVariable
      or
      n.getScope() instanceof Py::Class and
      not maybe_undefined(var)
    ) and
    name = n.getId() and
    scope = n.getEnclosingModule()
  }

  private predicate maybe_undefined(Py::SsaVariable var) {
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
  cached
  predicate strictlyDominates(BasicBlock other) {
    Stages::AST::ref() and
    other.getImmediateDominator+() = this
  }

  /** Whether this basic block dominates the other */
  predicate dominates(BasicBlock other) {
    this = other
    or
    this.strictlyDominates(other)
  }

  cached
  BasicBlock getImmediateDominator() {
    Stages::AST::ref() and
    this.firstNode().getImmediateDominator().getBasicBlock() = result
  }

  /**
   * Dominance frontier of a node x is the set of all nodes `other` such that `this` dominates a predecessor
   * of `other` but does not strictly dominate `other`
   */
  predicate dominanceFrontier(BasicBlock other) { this.inDominanceFrontier(other) }

  predicate inDominanceFrontier(BasicBlock df) {
    this = df.getAPredecessor() and not this = df.getImmediateDominator()
    or
    exists(BasicBlock prev | prev.inDominanceFrontier(df) |
      this = prev.getImmediateDominator() and
      not this = df.getImmediateDominator()
    )
  }

  /** Gets the first node in this basic block */
  ControlFlowNode firstNode() { result = this }

  /** Gets the last node in this basic block */
  ControlFlowNode getLastNode() {
    exists(int i |
      this.getNode(i) = result and
      i = max(int j | py_flow_bb_node(_, _, this, j))
    )
  }

  private predicate oneNodeBlock() { this.firstNode() = this.getLastNode() }

  private predicate startLocationInfo(string file, int line, int col) {
    if this.firstNode().getNode() instanceof Py::Scope
    then this.firstNode().getASuccessor().getLocation().hasLocationInfo(file, line, col, _, _)
    else this.firstNode().getLocation().hasLocationInfo(file, line, col, _, _)
  }

  private predicate endLocationInfo(int endl, int endc) {
    if this.getLastNode().getNode() instanceof Py::Scope and not this.oneNodeBlock()
    then this.getLastNode().getAPredecessor().getLocation().hasLocationInfo(_, _, _, endl, endc)
    else this.getLastNode().getLocation().hasLocationInfo(_, _, _, endl, endc)
  }

  /** Gets a successor to this basic block */
  cached
  BasicBlock getASuccessor() {
    Stages::AST::ref() and
    result = this.getLastNode().getASuccessor().getBasicBlock()
  }

  /** Gets a predecessor to this basic block */
  BasicBlock getAPredecessor() { result.getASuccessor() = this }

  /** Whether flow from this basic block reaches a normal exit from its scope */
  predicate reachesExit() {
    exists(Py::Scope s | s.getANormalExit().getBasicBlock() = this)
    or
    this.getASuccessor().reachesExit()
  }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * Py::For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
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
  Py::Scope getScope() {
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

  /** Holds if this basic block strictly reaches the other. Is the start of other reachable from the end of this. */
  cached
  predicate strictlyReaches(BasicBlock other) {
    Stages::AST::ref() and
    this.getASuccessor+() = other
  }

  /** Holds if this basic block reaches the other. Is the start of other reachable from the end of this. */
  predicate reaches(BasicBlock other) { this = other or this.strictlyReaches(other) }

  /**
   * Gets the `Py::ConditionBlock`, if any, that controls this block and
   * does not control any other `Py::ConditionBlock`s that control this block.
   * That is the `Py::ConditionBlock` that is closest dominator.
   */
  Py::ConditionBlock getImmediatelyControllingBlock() {
    result = this.nonControllingImmediateDominator*().getImmediateDominator()
  }

  private BasicBlock nonControllingImmediateDominator() {
    result = this.getImmediateDominator() and
    not result.(Py::ConditionBlock).controls(this, _)
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

private class ControlFlowNodeAlias = ControlFlowNode;

final private class FinalBasicBlock = BasicBlock;

module Cfg implements BB::CfgSig<Py::Location> {
  private import codeql.controlflow.SuccessorType

  class ControlFlowNode = ControlFlowNodeAlias;

  class BasicBlock extends FinalBasicBlock {
    // Note `PY:BasicBlock` does not have a `getLocation`.
    // (Instead it has a complicated location info logic.)
    // Using the location of the first node is simple
    // and we just need a way to identify the basic block
    // during debugging, so this will be serviceable.
    Py::Location getLocation() { result = super.getNode(0).getLocation() }

    int length() { result = count(int i | exists(this.getNode(i))) }

    BasicBlock getASuccessor() { result = super.getASuccessor() }

    private BasicBlock getANonDirectSuccessor(SuccessorType t) {
      result = this.getATrueSuccessor() and
      t.(BooleanSuccessor).getValue() = true
      or
      result = this.getAFalseSuccessor() and
      t.(BooleanSuccessor).getValue() = false
      or
      result = this.getAnExceptionalSuccessor() and
      t instanceof ExceptionSuccessor
    }

    BasicBlock getASuccessor(SuccessorType t) {
      result = this.getANonDirectSuccessor(t)
      or
      result = super.getASuccessor() and
      t instanceof DirectSuccessor and
      not result = this.getANonDirectSuccessor(_)
    }

    predicate strictlyDominates(BasicBlock bb) { super.strictlyDominates(bb) }

    predicate dominates(BasicBlock bb) { super.dominates(bb) }

    predicate inDominanceFrontier(BasicBlock df) { super.inDominanceFrontier(df) }

    BasicBlock getImmediateDominator() { result = super.getImmediateDominator() }

    /** Unsupported. Do not use. */
    predicate strictlyPostDominates(BasicBlock bb) { none() }

    /** Unsupported. Do not use. */
    predicate postDominates(BasicBlock bb) {
      this.strictlyPostDominates(bb) or
      this = bb
    }
  }

  class EntryBasicBlock extends BasicBlock {
    EntryBasicBlock() { this.getNode(0).isEntryNode() }
  }

  pragma[nomagic]
  predicate dominatingEdge(BasicBlock bb1, BasicBlock bb2) {
    bb1.getASuccessor() = bb2 and
    bb1 = bb2.getImmediateDominator() and
    forall(BasicBlock pred | pred = bb2.getAPredecessor() and pred != bb1 | bb2.dominates(pred))
  }
}
