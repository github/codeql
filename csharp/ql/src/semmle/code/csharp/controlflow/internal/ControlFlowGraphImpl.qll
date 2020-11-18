/**
 * Provides auxiliary classes and predicates used to construct the basic successor
 * relation on control flow elements.
 *
 * The implementation is centered around the concept of a _completion_, which
 * models how the execution of a statement or expression terminates.
 * Completions are represented as an algebraic data type `Completion` defined in
 * `Completion.qll`.
 *
 * The CFG is built by structural recursion over the AST. To achieve this the
 * CFG edges related to a given AST node, `n`, are divided into three categories:
 *
 *   1. The in-going edge that points to the first CFG node to execute when
 *      `n` is going to be executed.
 *   2. The out-going edges for control flow leaving `n` that are going to some
 *      other node in the surrounding context of `n`.
 *   3. The edges that have both of their end-points entirely within the AST
 *      node and its children.
 *
 * The edges in (1) and (2) are inherently non-local and are therefore
 * initially calculated as half-edges, that is, the single node, `k`, of the
 * edge contained within `n`, by the predicates `k = first(n)` and `k = last(n, _)`,
 * respectively. The edges in (3) can then be enumerated directly by the predicate
 * `succ` by calling `first` and `last` recursively on the children of `n` and
 * connecting the end-points. This yields the entire CFG, since all edges are in
 * (3) for _some_ AST node.
 *
 * The second parameter of `last` is the completion, which is necessary to distinguish
 * the out-going edges from `n`. Note that the completion changes as the calculation of
 * `last` proceeds outward through the AST; for example, a `BreakCompletion` is
 * caught up by its surrounding loop and turned into a `NormalCompletion`, and a
 * `NormalCompletion` proceeds outward through the end of a `finally` block and is
 * turned into whatever completion was caught by the `finally`.
 *
 * An important goal of the CFG is to get the order of side-effects correct.
 * Most expressions can have side-effects and must therefore be modeled in the
 * CFG in AST post-order. For example, a `MethodCall` evaluates its arguments
 * before the call. Most statements do not have side-effects, but merely affect
 * the control flow and some could therefore be excluded from the CFG. However,
 * as a design choice, all statements are included in the CFG and generally
 * serve as their own entry-points, thus executing in some version of AST
 * pre-order.
 */

import csharp
private import semmle.code.csharp.controlflow.ControlFlowGraph::ControlFlow
private import Completion
private import SuccessorType
private import SuccessorTypes
private import Splitting
private import semmle.code.csharp.ExprOrStmtParent

abstract private class ControlFlowTree extends ControlFlowElement {
  /**
   * Holds if `first` is the first element executed within this control
   * flow element.
   */
  pragma[nomagic]
  abstract predicate first(ControlFlowElement first);

  /**
   * Holds if `last` with completion `c` is a potential last element executed
   * within this control flow element.
   */
  pragma[nomagic]
  abstract predicate last(ControlFlowElement last, Completion c);

  /** Holds if abnormal execution of `child` should propagate upwards. */
  abstract predicate propagatesAbnormal(ControlFlowElement child);

  /**
   * Holds if `succ` is a control flow successor for `pred`, given that `pred`
   * finishes with completion `c`.
   */
  pragma[nomagic]
  abstract predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c);
}

/**
 * Holds if `first` is the first element executed within control flow
 * element `cft`.
 */
predicate first(ControlFlowTree cft, ControlFlowElement first) { cft.first(first) }

/**
 * Holds if `last` with completion `c` is a potential last element executed
 * within control flow element `cft`.
 */
predicate last(ControlFlowTree cft, ControlFlowElement last, Completion c) {
  cft.last(last, c)
  or
  exists(ControlFlowElement cfe |
    cft.propagatesAbnormal(cfe) and
    last(cfe, last, c) and
    not c instanceof NormalCompletion
  )
}

pragma[noinline]
private LabeledStmt getLabledStmt(string label, Callable c) {
  result.getEnclosingCallable() = c and
  label = result.getLabel()
}

pragma[nomagic]
private predicate goto(ControlFlowElement cfe, GotoCompletion gc, string label, Callable enclosing) {
  last(_, cfe, gc) and
  // Special case: when a `goto` happens inside a `try` statement with a
  // `finally` block, flow does not go directly to the target, but instead
  // to the `finally` block (and from there possibly to the target)
  not cfe = any(Statements::TryStmtTree t | t.hasFinally()).getBlockOrCatchFinallyPred(_) and
  label = gc.getLabel() and
  enclosing = cfe.getEnclosingCallable()
}

/**
 * Holds if `succ` is a control flow successor for `pred`, given that `pred`
 * finishes with completion `c`.
 */
pragma[nomagic]
predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
  any(ControlFlowTree cft).succ(pred, succ, c)
  or
  exists(Constructor con, InitializerSplitting::InitializedInstanceMember m, int i |
    last(m.getInitializer(), pred, c) and
    c instanceof NormalCompletion and
    InitializerSplitting::constructorInitializeOrder(con, m, i)
  |
    // Flow from one member initializer to the next
    exists(InitializerSplitting::InitializedInstanceMember next |
      InitializerSplitting::constructorInitializeOrder(con, next, i + 1) and
      first(next.getInitializer(), succ)
    )
    or
    // Flow from last member initializer to constructor body
    m = InitializerSplitting::lastConstructorInitializer(con) and
    first(con.getBody(), succ)
  )
  or
  // Flow from element with `goto` completion to first element of relevant
  // target
  exists(string label, Callable enclosing |
    goto(pred, c, label, enclosing) and
    first(getLabledStmt(label, enclosing), succ)
  )
}

/** Holds if `first` is first executed when entering `scope`. */
predicate succEntry(@top_level_exprorstmt_parent scope, ControlFlowElement first) {
  scope =
    any(Callable c |
      if exists(c.(Constructor).getInitializer())
      then first(c.(Constructor).getInitializer(), first)
      else
        if InitializerSplitting::constructorInitializes(c, _)
        then
          first(any(InitializerSplitting::InitializedInstanceMember m |
              InitializerSplitting::constructorInitializeOrder(c, m, 0)
            ).getInitializer(), first)
        else first(c.getBody(), first)
    )
  or
  expr_parent_top_level_adjusted(any(Expr e | first(e, first)), _, scope) and
  not scope instanceof Callable and
  not scope instanceof InitializerSplitting::InitializedInstanceMember
}

/** Holds if `scope` is exited when `last` finishes with completion `c`. */
predicate succExit(ControlFlowElement last, Callable scope, Completion c) {
  last(scope.getBody(), last, c) and
  not c instanceof GotoCompletion
  or
  exists(InitializerSplitting::InitializedInstanceMember m |
    m = InitializerSplitting::lastConstructorInitializer(scope) and
    last(m.getInitializer(), last, c) and
    not scope.hasBody()
  )
}

/**
 * A control flow element where the children are evaluated following a
 * standard left-to-right evaluation. The actual evaluation order is
 * determined by the predicate `getChildElement()`.
 */
abstract private class StandardElement extends ControlFlowTree {
  /** Gets the `i`th child element, in order of evaluation, starting from 0. */
  abstract ControlFlowElement getChildElement(int i);

  /** Gets the first child element of this element. */
  final ControlFlowElement getFirstChild() { result = this.getChildElement(0) }

  /** Holds if this element has no children. */
  final predicate isLeafElement() { not exists(this.getFirstChild()) }

  /** Gets the last child element of this element. */
  final ControlFlowTree getLastChild() {
    exists(int last |
      result = this.getChildElement(last) and
      not exists(this.getChildElement(last + 1))
    )
  }

  final override predicate propagatesAbnormal(ControlFlowElement child) {
    child = this.getChildElement(_)
  }

  override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
    exists(int i |
      last(this.getChildElement(i), pred, c) and
      first(this.getChildElement(i + 1), succ) and
      c instanceof NormalCompletion
    )
  }
}

abstract private class PreOrderTree extends ControlFlowTree {
  final override predicate first(ControlFlowElement first) { first = this }
}

abstract private class PostOrderTree extends ControlFlowTree {
  override predicate last(ControlFlowElement last, Completion c) {
    last = this and
    c.isValidFor(last)
  }
}

abstract private class SwitchTree extends ControlFlowTree, Switch {
  Expr expr;

  SwitchTree() { expr = this.getExpr() }

  override predicate propagatesAbnormal(ControlFlowElement child) { child = expr }

  override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
    // Flow from last element of switch expression to first element of first case
    last(expr, pred, c) and
    c instanceof NormalCompletion and
    first(this.getCase(0), succ)
    or
    // Flow from last element of case pattern to next case
    exists(Case case, int i | case = this.getCase(i) |
      last(case.getPattern(), pred, c) and
      c.(MatchingCompletion).isNonMatch() and
      first(this.getCase(i + 1), succ)
    )
    or
    // Flow from last element of condition to next case
    exists(Case case, int i | case = this.getCase(i) |
      last(case.getCondition(), pred, c) and
      c instanceof FalseCompletion and
      first(this.getCase(i + 1), succ)
    )
  }
}

abstract private class CaseTree extends ControlFlowTree, Case {
  PatternExpr pattern;
  ControlFlowElement body;

  CaseTree() { pattern = this.getPattern() and body = this.getBody() }

  final override predicate propagatesAbnormal(ControlFlowElement child) {
    child in [pattern, this.getCondition().(ControlFlowElement), body]
  }

  override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
    last(pattern, pred, c) and
    c.(MatchingCompletion).isMatch() and
    (
      if exists(this.getCondition())
      then
        // Flow from the last element of pattern to the condition
        first(this.getCondition(), succ)
      else
        // Flow from last element of pattern to first element of body
        first(body, succ)
    )
    or
    // Flow from last element of condition to first element of body
    last(this.getCondition(), pred, c) and
    c instanceof TrueCompletion and
    first(body, succ)
  }
}

module Expressions {
  /** An expression that should not be included in the control flow graph. */
  abstract private class NoNodeExpr extends Expr { }

  private class SimpleNoNodeExpr extends NoNodeExpr {
    SimpleNoNodeExpr() {
      this instanceof TypeAccess and
      not this = any(PatternMatch pm).getPattern()
    }
  }

  /** A write access that is not also a read access. */
  private class WriteAccess extends AssignableWrite {
    WriteAccess() {
      // `x++` is both a read and write access
      not this instanceof AssignableRead
    }
  }

  private class WriteAccessNoNodeExpr extends WriteAccess, NoNodeExpr {
    WriteAccessNoNodeExpr() {
      // For example a write to a static field, `Foo.Bar = 0`.
      forall(Expr e | e = this.getAChildExpr() | e instanceof NoNodeExpr)
    }
  }

  private ControlFlowElement getExprChild0(Expr e, int i) {
    not e instanceof NameOfExpr and
    not e instanceof QualifiableExpr and
    not e instanceof Assignment and
    not e instanceof AnonymousFunctionExpr and
    result = e.getChild(i)
    or
    e = any(ExtensionMethodCall emc | result = emc.getArgument(i))
    or
    e =
      any(QualifiableExpr qe |
        not qe instanceof ExtensionMethodCall and
        result = qe.getChild(i)
      )
    or
    e =
      any(Assignment a |
        // The left-hand side of an assignment is evaluated before the right-hand side
        i = 0 and result = a.getLValue()
        or
        i = 1 and result = a.getRValue()
      )
  }

  private ControlFlowElement getExprChild(Expr e, int i) {
    result =
      rank[i + 1](ControlFlowElement cfe, int j |
        cfe = getExprChild0(e, j) and
        not cfe instanceof NoNodeExpr
      |
        cfe order by j
      )
  }

  private ControlFlowElement getLastExprChild(Expr e) {
    exists(int last |
      result = getExprChild(e, last) and
      not exists(getExprChild(e, last + 1))
    )
  }

  private class StandardExpr extends StandardElement, PostOrderTree, Expr {
    StandardExpr() {
      // The following expressions need special treatment
      not this instanceof LogicalNotExpr and
      not this instanceof LogicalAndExpr and
      not this instanceof LogicalOrExpr and
      not this instanceof NullCoalescingExpr and
      not this instanceof ConditionalExpr and
      not this instanceof AssignOperationWithExpandedAssignment and
      not this instanceof ConditionallyQualifiedExpr and
      not this instanceof ThrowExpr and
      not this instanceof ObjectCreation and
      not this instanceof ArrayCreation and
      not this instanceof QualifiedWriteAccess and
      not this instanceof AccessorWrite and
      not this instanceof NoNodeExpr and
      not this instanceof SwitchExpr and
      not this instanceof SwitchCaseExpr and
      not this instanceof ConstructorInitializer
    }

    final override ControlFlowTree getChildElement(int i) { result = getExprChild(this, i) }

    final override predicate first(ControlFlowElement first) {
      first(this.getFirstChild(), first)
      or
      not exists(this.getFirstChild()) and
      first = this
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      StandardElement.super.succ(pred, succ, c)
      or
      last(this.getLastChild(), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  /**
   * A qualified write access. In a qualified write access, the access itself is
   * not evaluated, only the qualifier and the indexer arguments (if any).
   */
  private class QualifiedWriteAccess extends WriteAccess, QualifiableExpr, ControlFlowTree {
    QualifiedWriteAccess() {
      this.hasQualifier()
      or
      // Member initializers like
      // ```csharp
      // new Dictionary<int, string>() { [0] = "Zero", [1] = "One", [2] = "Two" }
      // ```
      // need special treatment, because the the accesses `[0]`, `[1]`, and `[2]`
      // have no qualifier.
      this = any(MemberInitializer mi).getLValue()
    }

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child = getExprChild(this, _)
    }

    final override predicate first(ControlFlowElement first) { first(getExprChild(this, 0), first) }

    final override predicate last(ControlFlowElement last, Completion c) {
      // Skip the access in a qualified write access
      last(getLastExprChild(this), last, c)
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      exists(int i |
        last(getExprChild(this, i), pred, c) and
        c instanceof NormalCompletion and
        first(getExprChild(this, i + 1), succ)
      )
    }
  }

  /** A normal or a (potential) dynamic call to an accessor. */
  private class StatOrDynAccessorCall extends Expr {
    StatOrDynAccessorCall() {
      this instanceof AccessorCall or
      this instanceof DynamicAccess
    }
  }

  /**
   * An expression that writes via an accessor call, for example `x.Prop = 0`,
   * where `Prop` is a property.
   *
   * Accessor writes need special attention, because we need to model the fact
   * that the accessor is called *after* the assigned value has been evaluated.
   * In the example above, this means we want a CFG that looks like
   *
   * ```csharp
   * x -> 0 -> set_Prop -> x.Prop = 0
   * ```
   */
  class AccessorWrite extends Expr, PostOrderTree {
    AssignableDefinition def;

    AccessorWrite() {
      def.getExpr() = this and
      def.getTargetAccess().(WriteAccess) instanceof StatOrDynAccessorCall and
      not this instanceof AssignOperationWithExpandedAssignment
    }

    /**
     * Gets the `i`th accessor being called in this write. More than one call
     * can happen in tuple assignments.
     */
    StatOrDynAccessorCall getCall(int i) {
      result =
        rank[i + 1](AssignableDefinitions::TupleAssignmentDefinition tdef |
          tdef.getExpr() = this and tdef.getTargetAccess() instanceof StatOrDynAccessorCall
        |
          tdef order by tdef.getEvaluationOrder()
        ).getTargetAccess()
      or
      i = 0 and
      result = def.getTargetAccess() and
      not def instanceof AssignableDefinitions::TupleAssignmentDefinition
    }

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child = getExprChild(this, _)
      or
      child = this.getCall(_)
    }

    final override predicate first(ControlFlowElement first) { first(getExprChild(this, 0), first) }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Standard left-to-right evaluation
      exists(int i |
        last(getExprChild(this, i), pred, c) and
        c instanceof NormalCompletion and
        first(getExprChild(this, i + 1), succ)
      )
      or
      // Flow from last element of last child to first accessor call
      last(getLastExprChild(this), pred, c) and
      succ = this.getCall(0) and
      c instanceof NormalCompletion
      or
      // Flow from one call to the next
      exists(int i | pred = this.getCall(i) |
        succ = this.getCall(i + 1) and
        c.isValidFor(pred) and
        c instanceof NormalCompletion
      )
      or
      // Post-order: flow from last call to element itself
      exists(int last | last = max(int i | exists(this.getCall(i))) |
        pred = this.getCall(last) and
        succ = this and
        c.isValidFor(pred) and
        c instanceof NormalCompletion
      )
    }
  }

  private class LogicalNotExprTree extends PostOrderTree, LogicalNotExpr {
    private Expr operand;

    LogicalNotExprTree() { operand = this.getOperand() }

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child = this.getOperand()
    }

    final override predicate first(ControlFlowElement first) { first(operand, first) }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      succ = this and
      (
        last(operand, pred, c.(BooleanCompletion).getDual())
        or
        last(operand, pred, c) and
        c instanceof SimpleCompletion
      )
    }
  }

  private class LogicalAndExprTree extends PostOrderTree, LogicalAndExpr {
    private Expr left;
    private Expr right;

    LogicalAndExprTree() { left = this.getLeftOperand() and right = this.getRightOperand() }

    final override predicate propagatesAbnormal(ControlFlowElement child) { child in [left, right] }

    final override predicate first(ControlFlowElement first) { first(left, first) }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Flow from last element of left operand to first element of right operand
      last(left, pred, c) and
      c instanceof TrueCompletion and
      first(right, succ)
      or
      // Post-order: flow from last element of left operand to element itself
      last(left, pred, c) and
      c instanceof FalseCompletion and
      succ = this
      or
      // Post-order: flow from last element of right operand to element itself
      last(right, pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  private class LogicalOrExprTree extends PostOrderTree, LogicalOrExpr {
    private Expr left;
    private Expr right;

    LogicalOrExprTree() { left = this.getLeftOperand() and right = this.getRightOperand() }

    final override predicate propagatesAbnormal(ControlFlowElement child) { child in [left, right] }

    final override predicate first(ControlFlowElement first) { first(left, first) }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Flow from last element of left operand to first element of right operand
      last(left, pred, c) and
      c instanceof FalseCompletion and
      first(right, succ)
      or
      // Post-order: flow from last element of left operand to element itself
      last(left, pred, c) and
      c instanceof TrueCompletion and
      succ = this
      or
      // Post-order: flow from last element of right operand to element itself
      last(right, pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  private class NullCoalescingExprTree extends PostOrderTree, NullCoalescingExpr {
    private Expr left;
    private Expr right;

    NullCoalescingExprTree() { left = this.getLeftOperand() and right = this.getRightOperand() }

    final override predicate propagatesAbnormal(ControlFlowElement child) { child in [left, right] }

    final override predicate first(ControlFlowElement first) { first(left, first) }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Flow from last element of left operand to first element of right operand
      last(left, pred, c) and
      c.(NullnessCompletion).isNull() and
      first(right, succ)
      or
      // Post-order: flow from last element of left operand to element itself
      last(left, pred, c) and
      succ = this and
      c instanceof NormalCompletion and
      not c.(NullnessCompletion).isNull()
      or
      // Post-order: flow from last element of right operand to element itself
      last(right, pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  private class ConditionalExprTree extends PostOrderTree, ConditionalExpr {
    private Expr condition;
    private Expr thenBranch;
    private Expr elseBranch;

    ConditionalExprTree() {
      condition = this.getCondition() and
      thenBranch = this.getThen() and
      elseBranch = this.getElse()
    }

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child in [condition, thenBranch, elseBranch]
    }

    final override predicate first(ControlFlowElement first) { first(condition, first) }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Flow from last element of condition to first element of then branch
      last(condition, pred, c) and
      c instanceof TrueCompletion and
      first(thenBranch, succ)
      or
      // Flow from last element of condition to first element of else branch
      last(condition, pred, c) and
      c instanceof FalseCompletion and
      first(elseBranch, succ)
      or
      // Post-order: flow from last element of a branch to element itself
      last([thenBranch, elseBranch], pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  /**
   * An assignment operation that has an expanded version. We use the expanded
   * version in the control flow graph in order to get better data flow / taint
   * tracking.
   */
  private class AssignOperationWithExpandedAssignment extends AssignOperation, ControlFlowTree {
    private Expr expanded;

    AssignOperationWithExpandedAssignment() { expanded = this.getExpandedAssignment() }

    final override predicate first(ControlFlowElement first) { first(expanded, first) }

    final override predicate last(ControlFlowElement last, Completion c) {
      last = expanded and
      last(expanded, last, c)
    }

    final override predicate propagatesAbnormal(ControlFlowElement child) { none() }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      none()
    }
  }

  /** A conditionally qualified expression. */
  private class ConditionallyQualifiedExpr extends PostOrderTree, QualifiableExpr {
    private Expr qualifier;

    ConditionallyQualifiedExpr() { this.isConditional() and qualifier = getExprChild(this, 0) }

    final override predicate propagatesAbnormal(ControlFlowElement child) { child = qualifier }

    final override predicate first(ControlFlowElement first) { first(qualifier, first) }

    pragma[nomagic]
    private predicate lastQualifier(ControlFlowElement last, Completion c) {
      last(qualifier, last, c)
    }

    final override predicate last(ControlFlowElement last, Completion c) {
      PostOrderTree.super.last(last, c)
      or
      // Qualifier exits with a `null` completion
      lastQualifier(last, c) and
      c.(NullnessCompletion).isNull()
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      exists(int i |
        last(getExprChild(this, i), pred, c) and
        c instanceof NormalCompletion and
        if i = 0 then c.(NullnessCompletion).isNonNull() else any()
      |
        // Post-order: flow from last element of last child to element itself
        i = max(int j | exists(getExprChild(this, j))) and
        succ = this
        or
        // Standard left-to-right evaluation
        first(getExprChild(this, i + 1), succ)
      )
    }
  }

  private class ThrowExprTree extends PostOrderTree, ThrowExpr {
    private Expr expr;

    ThrowExprTree() { expr = this.getExpr() }

    final override predicate propagatesAbnormal(ControlFlowElement child) { child = expr }

    final override predicate first(ControlFlowElement first) { first(expr, first) }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      last(expr, pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  private class ObjectCreationTree extends ControlFlowTree, ObjectCreation {
    private Expr getObjectCreationArgument(int i) {
      i >= 0 and
      if this.hasInitializer()
      then result = getExprChild(this, i + 1)
      else result = getExprChild(this, i)
    }

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child = this.getObjectCreationArgument(_)
    }

    final override predicate first(ControlFlowElement first) {
      first(this.getObjectCreationArgument(0), first)
      or
      not exists(this.getObjectCreationArgument(0)) and
      first = this
    }

    final override predicate last(ControlFlowElement last, Completion c) {
      // Post-order: element itself (when no initializer)
      last = this and
      not this.hasInitializer() and
      c.isValidFor(this)
      or
      // Last element of initializer
      last(this.getInitializer(), last, c)
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Flow from last element of argument `i` to first element of argument `i+1`
      exists(int i | last(this.getObjectCreationArgument(i), pred, c) |
        first(this.getObjectCreationArgument(i + 1), succ) and
        c instanceof NormalCompletion
      )
      or
      // Flow from last element of last argument to self
      exists(int last | last = max(int i | exists(this.getObjectCreationArgument(i))) |
        last(this.getObjectCreationArgument(last), pred, c) and
        succ = this and
        c instanceof NormalCompletion
      )
      or
      // Flow from self to first element of initializer
      pred = this and
      first(this.getInitializer(), succ) and
      c instanceof SimpleCompletion
    }
  }

  private class ArrayCreationTree extends ControlFlowTree, ArrayCreation {
    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child = this.getALengthArgument()
    }

    final override predicate first(ControlFlowElement first) {
      // First element of first length argument
      first(this.getLengthArgument(0), first)
      or
      // No length argument: element itself
      not exists(this.getLengthArgument(0)) and
      first = this
    }

    final override predicate last(ControlFlowElement last, Completion c) {
      // Post-order: element itself (when no initializer)
      last = this and
      not this.hasInitializer() and
      c.isValidFor(this)
      or
      // Last element of initializer
      last(this.getInitializer(), last, c)
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Flow from self to first element of initializer
      pred = this and
      first(this.getInitializer(), succ) and
      c instanceof SimpleCompletion
      or
      exists(int i |
        last(this.getLengthArgument(i), pred, c) and
        c instanceof SimpleCompletion
      |
        // Flow from last length argument to self
        i = max(int j | exists(this.getLengthArgument(j))) and
        succ = this
        or
        // Flow from one length argument to the next
        first(this.getLengthArgument(i + 1), succ)
      )
    }
  }

  private class SwitchExprTree extends PostOrderTree, SwitchTree, SwitchExpr {
    final override predicate propagatesAbnormal(ControlFlowElement child) {
      SwitchTree.super.propagatesAbnormal(child)
      or
      child = this.getACase()
    }

    final override predicate first(ControlFlowElement first) { first(expr, first) }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      SwitchTree.super.succ(pred, succ, c)
      or
      last(this.getACase(), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  private class SwitchCaseExprTree extends PostOrderTree, CaseTree, SwitchCaseExpr {
    final override predicate first(ControlFlowElement first) { first(pattern, first) }

    final override predicate last(ControlFlowElement last, Completion c) {
      PostOrderTree.super.last(last, c)
      or
      // Last case exists with a non-match
      exists(SwitchExpr se, int i, ConditionalCompletion cc |
        this = se.getCase(i) and
        not this.matchesAll() and
        not exists(se.getCase(i + 1)) and
        last([pattern, this.getCondition()], last, cc) and
        (cc.(MatchingCompletion).isNonMatch() or cc instanceof FalseCompletion) and
        c =
          any(NestedCompletion nc |
            nc.getInnerCompletion() = cc and
            nc
                .getOuterCompletion()
                .(ThrowCompletion)
                .getExceptionClass()
                .hasQualifiedName("System.InvalidOperationException")
          )
      )
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      CaseTree.super.succ(pred, succ, c)
      or
      last(body, pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  private class ConstructorInitializerTree extends PostOrderTree, ConstructorInitializer {
    private ControlFlowTree getChildElement(int i) { result = getExprChild(this, i) }

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child = this.getChildElement(_)
    }

    final override predicate first(ControlFlowElement first) {
      first(this.getChildElement(0), first)
      or
      not exists(this.getChildElement(0)) and
      first = this
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Post-order: flow from last element of last child to element itself
      exists(int lst |
        lst = max(int i | exists(this.getChildElement(i))) and
        last(this.getChildElement(lst), pred, c) and
        succ = this and
        c instanceof NormalCompletion
      )
      or
      // Standard left-to-right evaluation
      exists(int i |
        last(this.getChildElement(i), pred, c) and
        c instanceof NormalCompletion and
        first(this.getChildElement(i + 1), succ)
      )
      or
      exists(Constructor con |
        last(this, pred, c) and
        con = this.getConstructor() and
        c instanceof NormalCompletion
      |
        // Flow from constructor initializer to first member initializer
        exists(InitializerSplitting::InitializedInstanceMember m |
          InitializerSplitting::constructorInitializeOrder(con, m, 0)
        |
          first(m.getInitializer(), succ)
        )
        or
        // Flow from constructor initializer to first element of constructor body
        not InitializerSplitting::constructorInitializeOrder(con, _, _) and
        first(con.getBody(), succ)
      )
    }
  }
}

module Statements {
  private class StandardStmt extends StandardElement, PreOrderTree, Stmt {
    StandardStmt() {
      // The following statements need special treatment
      not this instanceof IfStmt and
      not this instanceof SwitchStmt and
      (this instanceof DefaultCase or not this instanceof CaseStmt) and
      not this instanceof LoopStmt and
      not this instanceof TryStmt and
      not this instanceof SpecificCatchClause and
      not this instanceof JumpStmt
    }

    final override ControlFlowTree getChildElement(int i) {
      not this instanceof GeneralCatchClause and
      not this instanceof FixedStmt and
      not this instanceof UsingBlockStmt and
      not this instanceof DefaultCase and
      result = this.getChild(i)
      or
      this = any(GeneralCatchClause gcc | i = 0 and result = gcc.getBlock())
      or
      this =
        any(FixedStmt fs |
          result = fs.getVariableDeclExpr(i)
          or
          result = fs.getBody() and
          i = max(int j | exists(fs.getVariableDeclExpr(j))) + 1
        )
      or
      this =
        any(UsingBlockStmt us |
          if exists(us.getExpr())
          then (
            result = us.getExpr() and
            i = 0
            or
            result = us.getBody() and
            i = 1
          ) else (
            result = us.getVariableDeclExpr(i)
            or
            result = us.getBody() and
            i = max(int j | exists(us.getVariableDeclExpr(j))) + 1
          )
        )
      or
      result = this.(DefaultCase).getStmt() and
      i = 0
    }

    final override predicate last(ControlFlowElement last, Completion c) {
      last(this.getLastChild(), last, c)
      or
      this.isLeafElement() and
      last = this and
      c.isValidFor(this)
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      StandardElement.super.succ(pred, succ, c)
      or
      pred = this and
      first(this.getFirstChild(), succ) and
      c instanceof SimpleCompletion
    }
  }

  private class IfStmtTree extends PreOrderTree, IfStmt {
    private Expr condition;

    IfStmtTree() { condition = this.getCondition() }

    final override predicate propagatesAbnormal(ControlFlowElement child) { child = condition }

    final override predicate last(ControlFlowElement last, Completion c) {
      // Condition exits with a false completion and there is no `else` branch
      last(condition, last, c) and
      c instanceof FalseCompletion and
      not exists(this.getElse())
      or
      // Then branch exits with any completion
      last(this.getThen(), last, c)
      or
      // Else branch exits with any completion
      last(this.getElse(), last, c)
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Pre-order: flow from statement itself to first element of condition
      pred = this and
      first(condition, succ) and
      c instanceof SimpleCompletion
      or
      last(condition, pred, c) and
      (
        // Flow from last element of condition to first element of then branch
        c instanceof TrueCompletion and first(this.getThen(), succ)
        or
        // Flow from last element of condition to first element of else branch
        c instanceof FalseCompletion and first(this.getElse(), succ)
      )
    }
  }

  private class SwitchStmtTree extends PreOrderTree, SwitchTree, SwitchStmt {
    final override predicate last(ControlFlowElement last, Completion c) {
      // Switch expression exits normally and there are no cases
      not exists(this.getACase()) and
      last(expr, last, c) and
      c instanceof NormalCompletion
      or
      // A statement exits with a `break` completion
      last(this.getStmt(_), last, any(BreakCompletion bc)) and
      c instanceof BreakNormalCompletion
      or
      // A statement exits abnormally
      last(this.getStmt(_), last, c) and
      not c instanceof BreakCompletion and
      not c instanceof NormalCompletion and
      not getLabledStmt(c.(GotoCompletion).getLabel(), this.getEnclosingCallable()) instanceof
        CaseStmt
      or
      // Last case exits with a non-match
      exists(CaseStmt cs, int last_ |
        last_ = max(int i | exists(this.getCase(i))) and
        cs = this.getCase(last_)
      |
        last(cs.getPattern(), last, c) and
        not c.(MatchingCompletion).isMatch()
        or
        last(cs.getCondition(), last, c) and
        c instanceof FalseCompletion
      )
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      SwitchTree.super.succ(pred, succ, c)
      or
      // Pre-order: flow from statement itself to first switch expression
      pred = this and
      first(expr, succ) and
      c instanceof SimpleCompletion
      or
      // Flow from last element of non-`case` statement `i` to first element of statement `i+1`
      exists(int i | last(this.getStmt(i), pred, c) |
        not this.getStmt(i) instanceof CaseStmt and
        c instanceof NormalCompletion and
        first(this.getStmt(i + 1), succ)
      )
      or
      // Flow from last element of `case` statement `i` to first element of statement `i+1`
      exists(int i | last(this.getStmt(i).(CaseStmt).getBody(), pred, c) |
        c instanceof NormalCompletion and
        first(this.getStmt(i + 1), succ)
      )
    }
  }

  private class CaseStmtTree extends PreOrderTree, CaseTree, CaseStmt {
    final override predicate last(ControlFlowElement last, Completion c) {
      // Condition exists with a `false` completion
      last(this.getCondition(), last, c) and
      c instanceof FalseCompletion
      or
      // Case pattern exits with a non-match
      last(pattern, last, c) and
      not c.(MatchingCompletion).isMatch()
      or
      // Case body exits with any completion
      last(body, last, c)
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      CaseTree.super.succ(pred, succ, c)
      or
      pred = this and
      first(pattern, succ) and
      c instanceof SimpleCompletion
    }
  }

  abstract private class LoopStmtTree extends PreOrderTree, LoopStmt {
    Stmt body;

    LoopStmtTree() { body = this.getBody() }

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child = this.getCondition()
    }

    final override predicate last(ControlFlowElement last, Completion c) {
      // Condition exits with a false completion
      last(this.getCondition(), last, c) and
      c instanceof FalseCompletion
      or
      // Body exits with a break completion; the loop exits normally
      // Note: we use a `BreakNormalCompletion` rather than a `NormalCompletion`
      // in order to be able to get the correct break label in the control flow
      // graph from the `result` node to the node after the loop.
      last(body, last, any(BreakCompletion bc)) and
      c instanceof BreakNormalCompletion
      or
      // Body exits with a completion that does not continue the loop
      last(body, last, c) and
      not c instanceof BreakCompletion and
      not c.continuesLoop()
    }

    override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Flow from last element of condition to first element of loop body
      last(this.getCondition(), pred, c) and
      c instanceof TrueCompletion and
      first(body, succ)
      or
      // Flow from last element of loop body back to first element of condition
      not this instanceof ForStmt and
      last(body, pred, c) and
      c.continuesLoop() and
      first(this.getCondition(), succ)
    }
  }

  private class WhileStmtTree extends LoopStmtTree, WhileStmt {
    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      LoopStmtTree.super.succ(pred, succ, c)
      or
      pred = this and
      first(this.getCondition(), succ) and
      c instanceof SimpleCompletion
    }
  }

  private class DoStmtTree extends LoopStmtTree, DoStmt {
    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      LoopStmtTree.super.succ(pred, succ, c)
      or
      pred = this and
      first(body, succ) and
      c instanceof SimpleCompletion
    }
  }

  private class ForStmtTree extends LoopStmtTree, ForStmt {
    /** Gets the condition if it exists, otherwise the body. */
    private ControlFlowElement getConditionOrBody() {
      result = this.getCondition()
      or
      not exists(this.getCondition()) and
      result = body
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      LoopStmtTree.super.succ(pred, succ, c)
      or
      // Pre-order: flow from statement itself to first element of first initializer/
      // condition/loop body
      exists(ControlFlowElement next |
        pred = this and
        first(next, succ) and
        c instanceof SimpleCompletion
      |
        next = this.getInitializer(0)
        or
        not exists(this.getInitializer(0)) and
        next = this.getConditionOrBody()
      )
      or
      // Flow from last element of initializer `i` to first element of initializer `i+1`
      exists(int i | last(this.getInitializer(i), pred, c) |
        c instanceof NormalCompletion and
        first(this.getInitializer(i + 1), succ)
      )
      or
      // Flow from last element of last initializer to first element of condition/loop body
      exists(int last | last = max(int i | exists(this.getInitializer(i))) |
        last(this.getInitializer(last), pred, c) and
        c instanceof NormalCompletion and
        first(this.getConditionOrBody(), succ)
      )
      or
      // Flow from last element of condition into first element of loop body
      last(this.getCondition(), pred, c) and
      c instanceof TrueCompletion and
      first(body, succ)
      or
      // Flow from last element of loop body to first element of update/condition/self
      exists(ControlFlowElement next |
        last(body, pred, c) and
        c.continuesLoop() and
        first(next, succ) and
        if exists(this.getUpdate(0))
        then next = this.getUpdate(0)
        else next = this.getConditionOrBody()
      )
      or
      // Flow from last element of update to first element of next update/condition/loop body
      exists(ControlFlowElement next, int i |
        last(this.getUpdate(i), pred, c) and
        c instanceof NormalCompletion and
        first(next, succ) and
        if exists(this.getUpdate(i + 1))
        then next = this.getUpdate(i + 1)
        else next = this.getConditionOrBody()
      )
    }
  }

  private class ForeachStmtTree extends ControlFlowTree, ForeachStmt {
    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child = this.getIterableExpr()
    }

    final override predicate first(ControlFlowElement first) {
      // Unlike most other statements, `foreach` statements are not modelled in
      // pre-order, because we use the `foreach` node itself to represent the
      // emptiness test that determines whether to execute the loop body
      first(this.getIterableExpr(), first)
    }

    final override predicate last(ControlFlowElement last, Completion c) {
      // Emptiness test exits with no more elements
      last = this and
      c.(EmptinessCompletion).isEmpty()
      or
      // Body exits with a break completion; the loop exits normally
      // Note: we use a `BreakNormalCompletion` rather than a `NormalCompletion`
      // in order to be able to get the correct break label in the control flow
      // graph from the `result` node to the node after the loop.
      last(this.getBody(), last, any(BreakCompletion bc)) and
      c instanceof BreakNormalCompletion
      or
      // Body exits abnormally
      last(this.getBody(), last, c) and
      not c instanceof NormalCompletion and
      not c instanceof ContinueCompletion and
      not c instanceof BreakCompletion
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Flow from last element of iterator expression to emptiness test
      last(this.getIterableExpr(), pred, c) and
      c instanceof NormalCompletion and
      succ = this
      or
      // Flow from emptiness test to first element of variable declaration/loop body
      pred = this and
      c = any(EmptinessCompletion ec | not ec.isEmpty()) and
      (
        first(this.getVariableDeclExpr(), succ)
        or
        first(this.getVariableDeclTuple(), succ)
        or
        not exists(this.getVariableDeclExpr()) and
        not exists(this.getVariableDeclTuple()) and
        first(this.getBody(), succ)
      )
      or
      // Flow from last element of variable declaration to first element of loop body
      (
        last(this.getVariableDeclExpr(), pred, c) or
        last(this.getVariableDeclTuple(), pred, c)
      ) and
      c instanceof SimpleCompletion and
      first(this.getBody(), succ)
      or
      // Flow from last element of loop body back to emptiness test
      last(this.getBody(), pred, c) and
      c.continuesLoop() and
      succ = this
    }
  }

  pragma[nomagic]
  private ControlFlowElement lastLastCatchClause(CatchClause cc, Completion c) {
    cc.isLast() and
    last(cc, result, c)
  }

  pragma[nomagic]
  private ControlFlowElement lastCatchClauseBlock(CatchClause cc, Completion c) {
    last(cc.getBlock(), result, c)
  }

  class TryStmtTree extends PreOrderTree, TryStmt {
    ControlFlowTree body;

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child = this.getFinally()
    }

    /** Holds if `last` is a last element of the block of this `try` statement. */
    pragma[nomagic]
    predicate lastBlock(ControlFlowElement last, Completion c) { last(this.getBlock(), last, c) }

    /**
     * Gets a last element from a `try` or `catch` block of this `try` statement
     * that may finish with completion `c`, such that control may be transferred
     * to the `finally` block (if it exists).
     */
    pragma[nomagic]
    ControlFlowElement getBlockOrCatchFinallyPred(Completion c) {
      this.lastBlock(result, c) and
      (
        // Any non-throw completion from the `try` block will always continue directly
        // to the `finally` block
        not c instanceof ThrowCompletion
        or
        // Any completion from the `try` block will continue to the `finally` block
        // when there are no catch clauses
        not exists(this.getACatchClause())
      )
      or
      // Last element from any of the `catch` clause blocks continues to the `finally` block
      result = lastCatchClauseBlock(this.getACatchClause(), c)
      or
      // Last element of last `catch` clause continues to the `finally` block
      result = lastLastCatchClause(this.getACatchClause(), c)
    }

    pragma[nomagic]
    private predicate lastFinally0(ControlFlowElement last, Completion c) {
      last(this.getFinally(), last, c)
    }

    pragma[nomagic]
    private predicate lastFinally(
      ControlFlowElement last, NormalCompletion finally, Completion outer
    ) {
      this.lastFinally0(last, finally) and
      exists(this.getBlockOrCatchFinallyPred(any(Completion c0 | outer = c0.getOuterCompletion())))
    }

    final override predicate last(ControlFlowElement last, Completion c) {
      last = this.getBlockOrCatchFinallyPred(c) and
      (
        // If there is no `finally` block, last elements are from the body, from
        // the blocks of one of the `catch` clauses, or from the last `catch` clause
        not this.hasFinally()
        or
        // Exit completions ignore the `finally` block
        c instanceof ExitCompletion
      )
      or
      this.lastFinally(last, c, any(NormalCompletion nc))
      or
      // If the `finally` block completes normally, it inherits any non-normal
      // completion that was current before the `finally` block was entered
      exists(NormalCompletion finally, Completion outer | this.lastFinally(last, finally, outer) |
        c =
          any(NestedCompletion nc |
            nc.getInnerCompletion() = finally and nc.getOuterCompletion() = outer
          )
        or
        not finally instanceof ConditionalCompletion and
        c = outer
      )
    }

    /**
     * Gets an exception type that is thrown by `cfe` in the block of this `try`
     * statement. Throw completion `c` matches the exception type.
     */
    ExceptionClass getAThrownException(ControlFlowElement cfe, ThrowCompletion c) {
      this.lastBlock(cfe, c) and
      result = c.getExceptionClass()
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Pre-order: flow from statement itself to first element of body
      pred = this and
      first(this.getBlock(), succ) and
      c instanceof SimpleCompletion
      or
      // Flow from last element of body to first `catch` clause
      exists(this.getAThrownException(pred, c)) and
      first(this.getCatchClause(0), succ)
      or
      exists(CatchClause cc, int i | cc = this.getCatchClause(i) |
        pred = cc and
        last(this.getCatchClause(i), cc, c) and
        (
          // Flow from one `catch` clause to the next
          first(this.getCatchClause(i + 1), succ) and
          c = any(MatchingCompletion mc | not mc.isMatch())
          or
          // Flow from last `catch` clause to first element of `finally` block
          this.getCatchClause(i).isLast() and
          first(this.getFinally(), succ) and
          c instanceof ThrowCompletion // inherited from `try` block
        )
        or
        last(this.getCatchClause(i), pred, c) and
        last(cc.getFilterClause(), pred, _) and
        (
          // Flow from last element of `catch` clause filter to next `catch` clause
          first(this.getCatchClause(i + 1), succ) and
          c instanceof FalseCompletion
          or
          // Flow from last element of `catch` clause filter, of last clause, to first
          // element of `finally` block
          this.getCatchClause(i).isLast() and
          first(this.getFinally(), succ) and
          c instanceof ThrowCompletion // inherited from `try` block
        )
        or
        // Flow from last element of a `catch` block to first element of `finally` block
        pred = lastCatchClauseBlock(cc, c) and
        first(this.getFinally(), succ)
      )
      or
      // Flow from last element of `try` block to first element of `finally` block
      this.lastBlock(pred, c) and
      first(this.getFinally(), succ) and
      not c instanceof ExitCompletion and
      (c instanceof ThrowCompletion implies not exists(this.getACatchClause()))
    }
  }

  private class SpecificCatchClauseTree extends PreOrderTree, SpecificCatchClause {
    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child = this.getFilterClause()
    }

    pragma[nomagic]
    private predicate lastFilterClause(ControlFlowElement last, Completion c) {
      last(this.getFilterClause(), last, c)
    }

    /**
     * Holds if the `try` block that this catch clause belongs to may throw an
     * exception of type `c`, where no `catch` clause is guaranteed to catch it.
     * This catch clause is the last catch clause in the `try` statement that
     * it belongs to.
     */
    pragma[nomagic]
    private predicate throwMayBeUncaught(ThrowCompletion c) {
      exists(TryStmtTree ts |
        ts = this.getTryStmt() and
        ts.lastBlock(_, c) and
        not ts.getACatchClause() instanceof GeneralCatchClause and
        forall(SpecificCatchClause scc | scc = ts.getACatchClause() |
          scc.hasFilterClause()
          or
          not c.getExceptionClass().getABaseType*() = scc.getCaughtExceptionType()
        ) and
        this.isLast()
      )
    }

    final override predicate last(ControlFlowElement last, Completion c) {
      // Last element of `catch` block
      last(this.getBlock(), last, c)
      or
      not this.isLast() and
      (
        // Incompatible exception type: clause itself
        last = this and
        c.(MatchingCompletion).isNonMatch()
        or
        // Incompatible filter
        this.lastFilterClause(last, c) and
        c instanceof FalseCompletion
      )
      or
      // Last `catch` clause inherits throw completions from the `try` block,
      // when the clause does not match
      this.isLast() and
      c =
        any(NestedCompletion nc |
          this.throwMayBeUncaught(nc.getOuterCompletion().(ThrowCompletion)) and
          (
            // Incompatible exception type: clause itself
            last = this and
            nc.getInnerCompletion() =
              any(MatchingCompletion mc |
                mc.isNonMatch() and
                mc.isValidFor(this)
              )
            or
            // Incompatible filter
            this.lastFilterClause(last, nc.getInnerCompletion().(FalseCompletion))
          )
        )
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Flow from catch clause to variable declaration/filter clause/block
      pred = this and
      c.(MatchingCompletion).isMatch() and
      exists(ControlFlowElement next | first(next, succ) |
        if exists(this.getVariableDeclExpr())
        then next = this.getVariableDeclExpr()
        else
          if exists(this.getFilterClause())
          then next = this.getFilterClause()
          else next = this.getBlock()
      )
      or
      // Flow from variable declaration to filter clause/block
      last(this.getVariableDeclExpr(), pred, c) and
      c instanceof SimpleCompletion and
      exists(ControlFlowElement next | first(next, succ) |
        if exists(this.getFilterClause())
        then next = this.getFilterClause()
        else next = this.getBlock()
      )
      or
      // Flow from filter to block
      last(this.getFilterClause(), pred, c) and
      c instanceof TrueCompletion and
      first(this.getBlock(), succ)
    }
  }

  private class JumpStmtTree extends PostOrderTree, JumpStmt {
    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child = this.getChild(0)
    }

    final override predicate first(ControlFlowElement first) {
      first(this.getChild(0), first)
      or
      not exists(this.getChild(0)) and first = this
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      last(this.getChild(0), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }
}

cached
private module Cached {
  private import semmle.code.csharp.Caching

  private predicate isAbnormalExitType(SuccessorType t) {
    t instanceof ExceptionSuccessor or t instanceof ExitSuccessor
  }

  /**
   * Internal representation of control flow nodes in the control flow graph.
   * The control flow graph is pruned for unreachable nodes.
   */
  cached
  newtype TNode =
    TEntryNode(Callable c) {
      Stages::ControlFlowStage::forceCachingInSameStage() and
      succEntrySplits(c, _, _, _)
    } or
    TAnnotatedExitNode(Callable c, boolean normal) {
      exists(Reachability::SameSplitsBlock b, SuccessorType t | b.isReachable(_) |
        succExitSplits(b.getAnElement(), _, c, t) and
        if isAbnormalExitType(t) then normal = false else normal = true
      )
    } or
    TExitNode(Callable c) {
      exists(Reachability::SameSplitsBlock b | b.isReachable(_) |
        succExitSplits(b.getAnElement(), _, c, _)
      )
    } or
    TElementNode(ControlFlowElement cfe, Splits splits) {
      exists(Reachability::SameSplitsBlock b | b.isReachable(splits) | cfe = b.getAnElement())
    }

  /** Gets a successor node of a given flow type, if any. */
  cached
  Node getASuccessorByType(Node pred, SuccessorType t) {
    // Callable entry node -> callable body
    exists(ControlFlowElement succElement, Splits succSplits |
      result = TElementNode(succElement, succSplits)
    |
      succEntrySplits(pred.(Nodes::EntryNode).getCallable(), succElement, succSplits, t)
    )
    or
    exists(ControlFlowElement predElement, Splits predSplits |
      pred = TElementNode(predElement, predSplits)
    |
      // Element node -> callable exit (annotated)
      result =
        any(Nodes::AnnotatedExitNode exit |
          succExitSplits(predElement, predSplits, exit.getCallable(), t) and
          if isAbnormalExitType(t) then not exit.isNormal() else exit.isNormal()
        )
      or
      // Element node -> element node
      exists(ControlFlowElement succElement, Splits succSplits, Completion c |
        result = TElementNode(succElement, succSplits)
      |
        succSplits(predElement, predSplits, succElement, succSplits, c) and
        t.matchesCompletion(c)
      )
    )
    or
    // Callable exit (annotated) -> callable exit
    pred.(Nodes::AnnotatedExitNode).getCallable() = result.(Nodes::ExitNode).getCallable() and
    t instanceof SuccessorTypes::NormalSuccessor
  }

  /**
   * Gets a first control flow element executed within `cfe`.
   */
  cached
  ControlFlowElement getAControlFlowEntryNode(ControlFlowElement cfe) { first(cfe, result) }

  /**
   * Gets a potential last control flow element executed within `cfe`.
   */
  cached
  ControlFlowElement getAControlFlowExitNode(ControlFlowElement cfe) { last(cfe, result, _) }
}

import Cached

/** A control flow element that is split into multiple control flow nodes. */
class SplitControlFlowElement extends ControlFlowElement {
  SplitControlFlowElement() { strictcount(this.getAControlFlowNode()) > 1 }
}
