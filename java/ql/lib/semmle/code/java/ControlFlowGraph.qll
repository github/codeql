/**
 * Provides classes and predicates for computing expression-level intra-procedural control flow graphs.
 *
 * The only API exported by this library are the toplevel classes `ControlFlowNode`
 * and its subclass `ConditionNode`, which wrap the successor relation and the
 * concept of true- and false-successors of conditions. A cfg node may either be a
 * statement, an expression, or the enclosing callable, indicating that
 * execution of the callable terminates.
 */

/*
 * The implementation is centered around the concept of a _completion_, which
 * models how the execution of a statement or expression terminates.
 * Completions are represented as an algebraic data type `Completion` defined in
 * `Completion.qll`.
 *
 * The CFG is built by structural recursion over the AST. To achieve this the
 * CFG edges related to a given AST node, `n`, is divided into three categories:
 *   1. The in-going edge that points to the first CFG node to execute when the
 *      `n` is going to be executed.
 *   2. The out-going edges for control-flow leaving `n` that are going to some
 *      other node in the surrounding context of `n`.
 *   3. The edges that have both of their end-points entirely within the AST
 *      node and its children.
 * The edges in (1) and (2) are inherently non-local and are therefore
 * initially calculated as half-edges, that is, the single node, `k`, of the
 * edge contained within `n`, by the predicates `k = first(n)` and
 * `last(n, k, _)`, respectively. The edges in (3) can then be enumerated
 * directly by the predicate `succ` by calling `first` and `last` recursively
 * on the children of `n` and connecting the end-points. This yields the entire
 * CFG, since all edges are in (3) for _some_ AST node.
 *
 * The third parameter of `last` is the completion, which is necessary to
 * distinguish the out-going edges from `n`. Note that the completion changes
 * as the calculation of `last` proceeds outward through the AST; for example,
 * a `breakCompletion` is caught up by its surrounding loop and turned into a
 * `normalCompletion`, or a `normalCompletion` proceeds outward through the end
 * of a `finally` block and is turned into whatever completion was caught by
 * the `finally`, or a `booleanCompletion(false, _)` occurs in a loop condition
 * and is turned into a `normalCompletion` of the entire loop. When the edge is
 * eventually connected we use the completion at that level of the AST as the
 * label of the edge, thus creating an edge-labelled CFG.
 *
 * An important goal of the CFG is to get the order of side-effects correct.
 * Most expressions can have side-effects and must therefore be modeled in the
 * CFG in AST post-order. For example, a `MethodAccess` evaluates its arguments
 * before the call. Most statements don't have side-effects, but merely affect
 * the control-flow and some could therefore be excluded from the CFG. However,
 * as a design choice, all statements are included in the CFG and generally
 * serve as their own entry-points, thus executing in some version of AST
 * pre-order. A few notable exceptions are `ReturnStmt`, `ThrowStmt`,
 * `SynchronizedStmt`, `ThisConstructorInvocationStmt`, and
 * `SuperConstructorInvocationStmt`, which all have side-effects and therefore
 * are modeled in side-effect order. Loop statement nodes are only passed on
 * entry, after which control goes back and forth between body and loop
 * condition.
 *
 * Some out-going edges from boolean expressions have a known value and in some
 * contexts this affects the possible successors. For example, in `if(A || B)`
 * a short-circuit edge that skips `B` must be true and can therefore only lead
 * to the then-branch. If the `||` is modeled in post-order then this
 * information is lost, and consequently it is better to model `||` and `&&` in
 * pre-order. The conditional expression `? :` is also modeled in pre-order to
 * achieve consistent CFGs for the equivalent `A && B` and `A ? B : false`.
 * Finally, the logical negation is also modeled in pre-order to achieve
 * consistent CFGs for the equivalent `!(A || B)` and `!A && !B`. The boolean
 * value `b` is tracked with the completion `booleanCompletion(b, _)`.
 *
 * Note that the second parameter in a `booleanCompletion` isn't needed to
 * calculate the CFG. It is, however, needed to track the value of the
 * sub-expression. For example, this ensures that the false-successor of the
 * `ConditionNode` `A` in `if(!(A && B))` can be correctly identified as the
 * then-branch (even though this completion turns into a
 * `booleanCompletion(true, _)` from the perspective of the `if`-node).
 *
 * As a final note, expressions that aren't actually executed in the usual
 * sense are excluded from the CFG. This covers, for example, parentheses,
 * l-values that aren't r-values as well, and expressions in `ConstCase`s.
 * For example, the `x` in `x=3` is not in the CFG, but the `x` in `x+=3` is.
 */

import java
private import Completion
private import controlflow.internal.Preconditions

/** A node in the expression-level control-flow graph. */
class ControlFlowNode extends Top, @exprparent {
  /** Gets the statement containing this node, if any. */
  Stmt getEnclosingStmt() {
    result = this or
    result = this.(Expr).getEnclosingStmt()
  }

  /** Gets the immediately enclosing callable whose body contains this node. */
  Callable getEnclosingCallable() {
    result = this or
    result = this.(Stmt).getEnclosingCallable() or
    result = this.(Expr).getEnclosingCallable()
  }

  /** Gets an immediate successor of this node. */
  ControlFlowNode getASuccessor() { result = succ(this) }

  /** Gets an immediate predecessor of this node. */
  ControlFlowNode getAPredecessor() { this = succ(result) }

  /** Gets an exception successor of this node. */
  ControlFlowNode getAnExceptionSuccessor() { result = succ(this, ThrowCompletion(_)) }

  /** Gets a successor of this node that is neither an exception successor nor a jump (break, continue, return). */
  ControlFlowNode getANormalSuccessor() {
    result = succ(this, BooleanCompletion(_, _)) or
    result = succ(this, NormalCompletion())
  }

  /** Gets the basic block that contains this node. */
  BasicBlock getBasicBlock() { result.getANode() = this }
}

/** Gets the intra-procedural successor of `n`. */
private ControlFlowNode succ(ControlFlowNode n) { result = succ(n, _) }

cached
private module ControlFlowGraphImpl {
  /**
   * Gets a label that applies to this statement.
   */
  private Label getLabel(Stmt s) {
    exists(LabeledStmt l | s = l.getStmt() |
      result = MkLabel(l.getLabel()) or
      result = getLabel(l)
    )
  }

  /**
   * A throwable that's a (reflexive, transitive) supertype of an unchecked
   * exception. Besides the unchecked exceptions themselves, this includes
   * `java.lang.Throwable` and `java.lang.Exception`.
   */
  private class UncheckedThrowableSuperType extends RefType {
    UncheckedThrowableSuperType() {
      this instanceof TypeThrowable or
      this instanceof TypeException or
      this instanceof UncheckedThrowableType
    }

    /**
     * An unchecked throwable that is a subtype of this `UncheckedThrowableSuperType` and
     * sits as high as possible in the type hierarchy. This is mostly unique except for
     * `TypeThrowable` which results in both `TypeError` and `TypeRuntimeException`.
     */
    UncheckedThrowableType getAnUncheckedSubtype() {
      result = this
      or
      result instanceof TypeError and this instanceof TypeThrowable
      or
      result instanceof TypeRuntimeException and
      (this instanceof TypeThrowable or this instanceof TypeException)
    }
  }

  /**
   * Bind `t` to an exception type that may be thrown during execution of `n`,
   * either because `n` is a `throw` statement, or because it is a call
   * that may throw an exception, or because it is a cast and a
   * `ClassCastException` is expected.
   */
  private predicate mayThrow(ControlFlowNode n, ThrowableType t) {
    t = n.(ThrowStmt).getThrownExceptionType()
    or
    exists(Call c | c = n |
      t = c.getCallee().getAThrownExceptionType() or
      uncheckedExceptionFromCatch(n, t) or
      uncheckedExceptionFromFinally(n, t) or
      uncheckedExceptionFromMethod(c, t)
    )
    or
    exists(CastExpr c | c = n |
      t instanceof TypeClassCastException and
      uncheckedExceptionFromCatch(n, t)
    )
  }

  /**
   * Bind `t` to an unchecked exception that may occur in a precondition check.
   */
  private predicate uncheckedExceptionFromMethod(MethodAccess ma, ThrowableType t) {
    conditionCheckArgument(ma, _, _) and
    (t instanceof TypeError or t instanceof TypeRuntimeException)
  }

  /**
   * Bind `t` to an unchecked exception that may transfer control to a finally
   * block inside which `n` is nested.
   */
  private predicate uncheckedExceptionFromFinally(ControlFlowNode n, ThrowableType t) {
    exists(TryStmt try |
      n.getEnclosingStmt().getEnclosingStmt+() = try.getBlock() or
      n.(Expr).getParent*() = try.getAResource()
    |
      exists(try.getFinally()) and
      (t instanceof TypeError or t instanceof TypeRuntimeException)
    )
  }

  /**
   * Bind `t` to all unchecked exceptions that may be caught by some
   * `try-catch` inside which `n` is nested.
   */
  private predicate uncheckedExceptionFromCatch(ControlFlowNode n, ThrowableType t) {
    exists(TryStmt try, UncheckedThrowableSuperType caught |
      n.getEnclosingStmt().getEnclosingStmt+() = try.getBlock() or
      n.(Expr).getParent*() = try.getAResource()
    |
      t = caught.getAnUncheckedSubtype() and
      try.getACatchClause().getACaughtType() = caught
    )
  }

  /**
   * Gets an exception type that may be thrown during execution of the
   * body or the resources (if any) of `try`.
   */
  private ThrowableType thrownInBody(TryStmt try) {
    exists(ControlFlowNode n | mayThrow(n, result) |
      n.getEnclosingStmt().getEnclosingStmt+() = try.getBlock() or
      n.(Expr).getParent*() = try.getAResource()
    )
  }

  /**
   * Bind `thrown` to an exception type that may be thrown during execution
   * of the body or the resource declarations of the `try` block to which
   * `c` belongs, such that `c` definitely catches that exception (if no
   * prior catch clause handles it).
   */
  private predicate mustCatch(CatchClause c, ThrowableType thrown) {
    thrown = thrownInBody(c.getTry()) and
    hasDescendant(c.getACaughtType(), thrown)
  }

  /**
   * Bind `thrown` to an exception type that may be thrown during execution
   * of the body or the resource declarations of the `try` block to which
   * `c` belongs, such that `c` may _not_ catch that exception.
   *
   * This predicate computes the complement of `mustCatch` over those
   * exception types that are thrown in the body/resource declarations of
   * the corresponding `try`.
   */
  private predicate mayNotCatch(CatchClause c, ThrowableType thrown) {
    thrown = thrownInBody(c.getTry()) and
    not hasDescendant(c.getACaughtType(), thrown)
  }

  /**
   * Bind `thrown` to an exception type that may be thrown during execution
   * of the body or the resource declarations of the `try` block to which
   * `c` belongs, such that `c` possibly catches that exception.
   */
  private predicate mayCatch(CatchClause c, ThrowableType thrown) {
    mustCatch(c, thrown)
    or
    mayNotCatch(c, thrown) and exists(c.getACaughtType().commonSubtype(thrown))
  }

  /**
   * Given an exception type `thrown`, determine which catch clauses of
   * `try` may possibly catch that exception.
   */
  private CatchClause handlingCatchClause(TryStmt try, ThrowableType thrown) {
    exists(int i | result = try.getCatchClause(i) |
      mayCatch(result, thrown) and
      not exists(int j | j < i | mustCatch(try.getCatchClause(j), thrown))
    )
  }

  /**
   * Boolean expressions that occur in a context in which their value affect control flow.
   * That is, contexts where the control-flow edges depend on `value` given that `b` ends
   * with a `booleanCompletion(value, _)`.
   */
  private predicate inBooleanContext(Expr b) {
    exists(LogicExpr logexpr |
      logexpr.(BinaryExpr).getLeftOperand() = b
      or
      // Cannot use LogicExpr.getAnOperand or BinaryExpr.getAnOperand as they remove parentheses.
      logexpr.(BinaryExpr).getRightOperand() = b and inBooleanContext(logexpr)
      or
      logexpr.(UnaryExpr).getExpr() = b and inBooleanContext(logexpr)
    )
    or
    exists(ConditionalExpr condexpr |
      condexpr.getCondition() = b
      or
      condexpr.getABranchExpr() = b and
      inBooleanContext(condexpr)
    )
    or
    exists(SwitchExpr switch |
      inBooleanContext(switch) and
      switch.getAResult() = b
    )
    or
    exists(ConditionalStmt condstmt | condstmt.getCondition() = b)
  }

  /**
   * A virtual method with a unique implementation. That is, the method does not
   * participate in overriding and there are no call targets that could dispatch
   * to both this and another method.
   */
  private class EffectivelyNonVirtualMethod extends SrcMethod {
    EffectivelyNonVirtualMethod() {
      exists(this.getBody()) and
      this.isVirtual() and
      not this = any(Method m).getASourceOverriddenMethod() and
      not this.overrides(_) and
      // guard against implicit overrides of default methods
      not this.getAPossibleImplementationOfSrcMethod() != this and
      // guard against interface implementations in inheriting subclasses
      not exists(SrcMethod m |
        1 < strictcount(m.getAPossibleImplementationOfSrcMethod()) and
        this = m.getAPossibleImplementationOfSrcMethod()
      ) and
      // UnsupportedOperationException could indicate that this is meant to be overridden
      not exists(ClassInstanceExpr ex |
        this.getBody().getLastStmt().(ThrowStmt).getExpr() = ex and
        ex.getConstructedType().hasQualifiedName("java.lang", "UnsupportedOperationException")
      ) and
      // an unused parameter could indicate that this is meant to be overridden
      forall(Parameter p | p = this.getAParameter() | exists(p.getAnAccess()))
    }

    /** Gets a `MethodAccess` that calls this method. */
    MethodAccess getAnAccess() { result.getMethod().getAPossibleImplementation() = this }
  }

  /** Holds if a call to `m` indicates that `m` is expected to return. */
  private predicate expectedReturn(EffectivelyNonVirtualMethod m) {
    exists(Stmt s, BlockStmt b |
      m.getAnAccess().getEnclosingStmt() = s and
      b.getAStmt() = s and
      not b.getLastStmt() = s
    )
  }

  /**
   * Gets a non-overridable method that always throws an exception or calls `exit`.
   */
  private Method nonReturningMethod() {
    result instanceof MethodExit
    or
    not result.isOverridable() and
    exists(BlockStmt body |
      body = result.getBody() and
      not exists(ReturnStmt ret | ret.getEnclosingCallable() = result)
    |
      not result.getReturnType() instanceof VoidType or
      body.getLastStmt() = nonReturningStmt()
    )
  }

  /**
   * Gets a virtual method that always throws an exception or calls `exit`.
   */
  private EffectivelyNonVirtualMethod likelyNonReturningMethod() {
    result.getReturnType() instanceof VoidType and
    not exists(ReturnStmt ret | ret.getEnclosingCallable() = result) and
    not expectedReturn(result) and
    forall(Parameter p | p = result.getAParameter() | exists(p.getAnAccess())) and
    result.getBody().getLastStmt() = nonReturningStmt()
  }

  /**
   * Gets a `MethodAccess` that always throws an exception or calls `exit`.
   */
  private MethodAccess nonReturningMethodAccess() {
    result.getMethod().getSourceDeclaration() = nonReturningMethod() or
    result = likelyNonReturningMethod().getAnAccess()
  }

  /**
   * Gets a statement that always throws an exception or calls `exit`.
   */
  private Stmt nonReturningStmt() {
    result instanceof ThrowStmt
    or
    result.(ExprStmt).getExpr() = nonReturningMethodAccess()
    or
    result.(BlockStmt).getLastStmt() = nonReturningStmt()
    or
    exists(IfStmt ifstmt | ifstmt = result |
      ifstmt.getThen() = nonReturningStmt() and
      ifstmt.getElse() = nonReturningStmt()
    )
    or
    exists(TryStmt try | try = result |
      try.getBlock() = nonReturningStmt() and
      forall(CatchClause cc | cc = try.getACatchClause() | cc.getBlock() = nonReturningStmt())
    )
  }

  /**
   * Expressions and statements with CFG edges in post-order AST traversal.
   *
   * This includes most expressions, except those that initiate or propagate branching control
   * flow (`LogicExpr`, `ConditionalExpr`).
   * Only a few statements are included; those with specific side-effects
   * occurring after the evaluation of their children, that is, `Call`, `ReturnStmt`,
   * and `ThrowStmt`. CFG nodes without child nodes in the CFG that may complete
   * normally are also included.
   */
  private class PostOrderNode extends ControlFlowNode {
    PostOrderNode() {
      // For VarAccess and ArrayAccess only read accesses (r-values) are included,
      // as write accesses aren't included in the CFG.
      this instanceof ArrayAccess and not exists(AssignExpr a | this = a.getDest())
      or
      this instanceof ArrayCreationExpr
      or
      this instanceof ArrayInit
      or
      this instanceof Assignment
      or
      this instanceof BinaryExpr and not this instanceof LogicExpr
      or
      this instanceof UnaryExpr and not this instanceof LogNotExpr
      or
      this instanceof CastExpr
      or
      this instanceof InstanceOfExpr and not this.(InstanceOfExpr).isPattern()
      or
      this instanceof LocalVariableDeclExpr and
      not this = any(InstanceOfExpr ioe).getLocalVariableDeclExpr()
      or
      this instanceof RValue
      or
      this instanceof Call // includes both expressions and statements
      or
      this instanceof ReturnStmt
      or
      this instanceof ThrowStmt
      or
      this instanceof Literal
      or
      this instanceof TypeLiteral
      or
      this instanceof ThisAccess
      or
      this instanceof SuperAccess
      or
      this.(BlockStmt).getNumStmt() = 0
      or
      this instanceof SwitchCase and not this.(SwitchCase).isRule()
      or
      this instanceof EmptyStmt
      or
      this instanceof LocalTypeDeclStmt
      or
      this instanceof AssertStmt
    }

    /** Gets child nodes in their order of execution. Indexing starts at either -1 or 0. */
    ControlFlowNode getChildNode(int index) {
      exists(ArrayAccess e | e = this |
        index = 0 and result = e.getArray()
        or
        index = 1 and result = e.getIndexExpr()
      )
      or
      exists(ArrayCreationExpr e | e = this |
        result = e.getDimension(index)
        or
        index = count(e.getADimension()) and result = e.getInit()
      )
      or
      result = this.(ArrayInit).getInit(index) and index >= 0
      or
      exists(AssignExpr e, ArrayAccess lhs | e = this and lhs = e.getDest() |
        index = 0 and result = lhs.getArray()
        or
        index = 1 and result = lhs.getIndexExpr()
        or
        index = 2 and result = e.getSource()
      )
      or
      exists(AssignExpr e, VarAccess lhs | e = this and lhs = e.getDest() |
        index = -1 and result = lhs.getQualifier() and not result instanceof TypeAccess
        or
        index = 0 and result = e.getSource()
      )
      or
      exists(AssignOp e | e = this |
        index = 0 and result = e.getDest()
        or
        index = 1 and result = e.getRhs()
      )
      or
      exists(BinaryExpr e | e = this |
        index = 0 and result = e.getLeftOperand()
        or
        index = 1 and result = e.getRightOperand()
      )
      or
      index = 0 and result = this.(UnaryExpr).getExpr()
      or
      index = 0 and result = this.(CastExpr).getExpr()
      or
      index = 0 and result = this.(InstanceOfExpr).getExpr()
      or
      index = 0 and result = this.(LocalVariableDeclExpr).getInit()
      or
      index = 0 and result = this.(RValue).getQualifier() and not result instanceof TypeAccess
      or
      exists(Call e | e = this |
        index = -1 and result = e.getQualifier() and not result instanceof TypeAccess
        or
        result = e.getArgument(index)
      )
      or
      index = 0 and result = this.(ReturnStmt).getResult()
      or
      index = 0 and result = this.(ThrowStmt).getExpr()
      or
      index = 0 and result = this.(AssertStmt).getExpr()
    }

    /** Gets the first child node, if any. */
    ControlFlowNode firstChild() {
      result = this.getChildNode(-1)
      or
      result = this.getChildNode(0) and not exists(this.getChildNode(-1))
    }

    /** Holds if this CFG node has any child nodes. */
    predicate isLeafNode() { not exists(this.getChildNode(_)) }

    /** Holds if this node can finish with a `normalCompletion`. */
    predicate mayCompleteNormally() {
      not this instanceof BooleanLiteral and
      not this instanceof ReturnStmt and
      not this instanceof ThrowStmt and
      not this = nonReturningMethodAccess()
    }
  }

  /**
   * If the body of `loop` finishes with `completion`, the loop will
   * continue executing (provided the loop condition still holds).
   */
  private predicate continues(Completion completion, LoopStmt loop) {
    completion = NormalCompletion()
    or
    // only consider continue completions if there actually is a `continue`
    // somewhere inside this loop; we don't particularly care whether that
    // `continue` could actually target this loop, we just want to restrict
    // the size of the predicate
    exists(ContinueStmt cnt | cnt.getEnclosingStmt+() = loop |
      completion = anonymousContinueCompletion() or
      completion = labelledContinueCompletion(getLabel(loop))
    )
  }

  /**
   * Determine the part of the AST node `n` that will be executed first.
   */
  private ControlFlowNode first(ControlFlowNode n) {
    result = n and n instanceof LogicExpr
    or
    result = n and n instanceof ConditionalExpr
    or
    result = n and n.(PostOrderNode).isLeafNode()
    or
    result = first(n.(PostOrderNode).firstChild())
    or
    result = first(n.(InstanceOfExpr).getExpr())
    or
    result = first(n.(SynchronizedStmt).getExpr())
    or
    result = n and
    n instanceof Stmt and
    not n instanceof PostOrderNode and
    not n instanceof SynchronizedStmt
    or
    result = n and n instanceof SwitchExpr
  }

  /**
   * Bind `last` to a node inside the body of `try` that may finish with `completion`
   * such that control will be transferred to a `catch` block or the `finally` block of `try`.
   *
   * In other words, `last` is either a resource declaration that throws, or a
   * node in the `try` block that may not complete normally, or a node in
   * the `try` block that has no control flow successors inside the block.
   */
  private predicate catchOrFinallyCompletion(
    TryStmt try, ControlFlowNode last, Completion completion
  ) {
    last(try.getBlock(), last, completion)
    or
    last(try.getAResource(), last, completion) and completion = ThrowCompletion(_)
  }

  /**
   * Bind `last` to a node inside the body of `try` that may finish with `completion`
   * such that control may be transferred to the `finally` block (if it exists).
   *
   * In other words, if `last` throws an exception it is possibly not caught by any
   * of the catch clauses.
   */
  private predicate uncaught(TryStmt try, ControlFlowNode last, Completion completion) {
    catchOrFinallyCompletion(try, last, completion) and
    (
      exists(ThrowableType thrown |
        thrown = thrownInBody(try) and
        completion = ThrowCompletion(thrown) and
        not mustCatch(try.getACatchClause(), thrown)
      )
      or
      completion = NormalCompletion()
      or
      completion = ReturnCompletion()
      or
      completion = anonymousBreakCompletion()
      or
      completion = labelledBreakCompletion(_)
      or
      completion = anonymousContinueCompletion()
      or
      completion = labelledContinueCompletion(_)
    )
  }

  /**
   * Bind `last` to a node inside `try` that may finish with `completion` such
   * that control may be transferred to the `finally` block (if it exists).
   *
   * This is similar to `uncaught`, but also includes final statements of `catch`
   * clauses.
   */
  private predicate finallyPred(TryStmt try, ControlFlowNode last, Completion completion) {
    uncaught(try, last, completion) or
    last(try.getACatchClause(), last, completion)
  }

  private predicate lastInFinally(TryStmt try, ControlFlowNode last) {
    last(try.getFinally(), last, NormalCompletion())
  }

  /**
   * Bind `last` to a cfg node nested inside `n` (or, indeed, `n` itself) such
   * that `last` may be the last node during an execution of `n` and finish
   * with the given completion.
   *
   * A `booleanCompletion` implies that `n` is an `Expr`. Any abnormal
   * completion besides `throwCompletion` implies that `n` is a `Stmt`.
   */
  private predicate last(ControlFlowNode n, ControlFlowNode last, Completion completion) {
    // Exceptions are propagated from any sub-expression.
    // As are any break, continue, or return completions.
    exists(Expr e | e.getParent() = n |
      last(e, last, completion) and not completion instanceof NormalOrBooleanCompletion
    )
    or
    // If an expression doesn't finish with a throw completion, then it executes normally with
    // either a `normalCompletion` or a `booleanCompletion`.
    // A boolean completion in a non-boolean context just indicates a normal completion
    // and a normal completion in a boolean context indicates an arbitrary boolean completion.
    last(n, last, NormalCompletion()) and
    inBooleanContext(n) and
    completion = basicBooleanCompletion(_)
    or
    last(n, last, BooleanCompletion(_, _)) and
    not inBooleanContext(n) and
    completion = NormalCompletion()
    or
    // Logic expressions and conditional expressions are executed in AST pre-order to facilitate
    // proper short-circuit representation. All other expressions are executed in post-order.
    // The last node of a logic expression is either in the right operand with an arbitrary
    // completion, or in the left operand with the corresponding boolean completion.
    exists(AndLogicalExpr andexpr | andexpr = n |
      last(andexpr.getLeftOperand(), last, completion) and completion = BooleanCompletion(false, _)
      or
      last(andexpr.getRightOperand(), last, completion)
    )
    or
    exists(OrLogicalExpr orexpr | orexpr = n |
      last(orexpr.getLeftOperand(), last, completion) and completion = BooleanCompletion(true, _)
      or
      last(orexpr.getRightOperand(), last, completion)
    )
    or
    // The last node of a `LogNotExpr` is in its sub-expression with an inverted boolean completion
    // (or a `normalCompletion`).
    exists(Completion subcompletion | last(n.(LogNotExpr).getExpr(), last, subcompletion) |
      subcompletion = NormalCompletion() and
      completion = NormalCompletion() and
      not inBooleanContext(n)
      or
      exists(boolean outervalue, boolean innervalue |
        subcompletion = BooleanCompletion(outervalue, innervalue) and
        completion = BooleanCompletion(outervalue.booleanNot(), innervalue)
      )
    )
    or
    // The last node of a `ConditionalExpr` is in either of its branches.
    exists(ConditionalExpr condexpr | condexpr = n |
      last(condexpr.getABranchExpr(), last, completion)
    )
    or
    exists(InstanceOfExpr ioe | ioe.isPattern() and ioe = n |
      last = n and completion = basicBooleanCompletion(false)
      or
      last = ioe.getLocalVariableDeclExpr() and completion = basicBooleanCompletion(true)
    )
    or
    // The last node of a node executed in post-order is the node itself.
    n.(PostOrderNode).mayCompleteNormally() and last = n and completion = NormalCompletion()
    or
    last = n and completion = basicBooleanCompletion(n.(BooleanLiteral).getBooleanValue())
    or
    // The last statement in a block is any statement that does not complete normally,
    // or the last statement.
    exists(BlockStmt blk | blk = n |
      last(blk.getAStmt(), last, completion) and completion != NormalCompletion()
      or
      last(blk.getStmt(blk.getNumStmt() - 1), last, completion)
    )
    or
    // The last node in an `if` statement is the last node in either of its branches or
    // the last node of the condition with a false-completion in the absence of an else-branch.
    exists(IfStmt ifstmt | ifstmt = n |
      last(ifstmt.getCondition(), last, BooleanCompletion(false, _)) and
      completion = NormalCompletion() and
      not exists(ifstmt.getElse())
      or
      last(ifstmt.getThen(), last, completion)
      or
      last(ifstmt.getElse(), last, completion)
    )
    or
    // A loop may terminate normally if its condition is false...
    exists(LoopStmt loop | loop = n |
      last(loop.getCondition(), last, BooleanCompletion(false, _)) and
      completion = NormalCompletion()
      or
      // ...or if it's an enhanced for loop running out of items to iterate over...
      // ...which may happen either immediately after the loop expression...
      last(loop.(EnhancedForStmt).getExpr(), last, completion) and completion = NormalCompletion()
      or
      exists(Completion bodyCompletion | last(loop.getBody(), last, bodyCompletion) |
        // ...or after the last node in the loop's body in an iteration that would otherwise continue.
        loop instanceof EnhancedForStmt and
        continues(bodyCompletion, loop) and
        completion = NormalCompletion()
        or
        // Otherwise the last node is the last node in the loop's body...
        // ...if it is an unlabelled `break` (causing the entire loop to complete normally)
        (
          if bodyCompletion = anonymousBreakCompletion()
          then completion = NormalCompletion()
          else (
            // ...or if it is some other completion that does not continue the loop.
            not continues(bodyCompletion, loop) and completion = bodyCompletion
          )
        )
      )
    )
    or
    // `try` statements are a bit more complicated:
    exists(TryStmt try | try = n |
      // the last node in a `try` is the last node in its `finally` block
      // if the `finally` block completes normally, it resumes any completion that
      // was current before the `finally` block was entered
      lastInFinally(try, last) and
      finallyPred(try, _, completion)
      or
      // otherwise, just take the completion of the `finally` block itself
      last(try.getFinally(), last, completion) and
      completion != NormalCompletion()
      or
      // if there is no `finally` block, take the last node of the body or
      // any of the `catch` clauses
      not exists(try.getFinally()) and finallyPred(try, last, completion)
    )
    or
    // handle `switch` statements
    exists(SwitchStmt switch | switch = n |
      // unlabelled `break` causes the whole `switch` to complete normally
      last(switch.getAStmt(), last, anonymousBreakCompletion()) and
      completion = NormalCompletion()
      or
      // any other abnormal completion is propagated
      last(switch.getAStmt(), last, completion) and
      completion != anonymousBreakCompletion() and
      completion != NormalCompletion()
      or
      // if the last case completes normally, then so does the switch
      last(switch.getStmt(strictcount(switch.getAStmt()) - 1), last, NormalCompletion()) and
      completion = NormalCompletion()
      or
      // if no default case exists, then normal completion of the expression may terminate the switch
      not exists(switch.getDefaultCase()) and
      last(switch.getExpr(), last, completion) and
      completion = NormalCompletion()
    )
    or
    // handle `switch` expression
    exists(SwitchExpr switch | switch = n |
      // `yield` terminates the `switch`
      last(switch.getAStmt(), last, YieldCompletion(completion))
      or
      // any other abnormal completion is propagated
      last(switch.getAStmt(), last, completion) and
      not completion instanceof YieldCompletion and
      completion != NormalCompletion()
    )
    or
    // the last node in a case rule is the last node in the right-hand side
    last(n.(SwitchCase).getRuleStatement(), last, completion)
    or
    // ...and if the rhs is an expression we wrap the completion as a yield
    exists(Completion caseCompletion |
      last(n.(SwitchCase).getRuleExpression(), last, caseCompletion) and
      if caseCompletion instanceof NormalOrBooleanCompletion
      then completion = YieldCompletion(caseCompletion)
      else completion = caseCompletion
    )
    or
    // the last statement of a synchronized statement is the last statement of its body
    last(n.(SynchronizedStmt).getBlock(), last, completion)
    or
    // `return` statements give rise to a `Return` completion
    last = n.(ReturnStmt) and completion = ReturnCompletion()
    or
    // `throw` statements or throwing calls give rise to ` Throw` completion
    exists(ThrowableType tt | mayThrow(n, tt) | last = n and completion = ThrowCompletion(tt))
    or
    // `break` statements give rise to a `Break` completion
    exists(BreakStmt break | break = n and last = n |
      completion = labelledBreakCompletion(MkLabel(break.getLabel()))
      or
      not exists(break.getLabel()) and completion = anonymousBreakCompletion()
    )
    or
    // yield statements get their completion wrapped as a yield
    exists(Completion caseCompletion |
      last(n.(YieldStmt).getValue(), last, caseCompletion) and
      if caseCompletion instanceof NormalOrBooleanCompletion
      then completion = YieldCompletion(caseCompletion)
      else completion = caseCompletion
    )
    or
    // `continue` statements give rise to a `Continue` completion
    exists(ContinueStmt cont | cont = n and last = n |
      completion = labelledContinueCompletion(MkLabel(cont.getLabel()))
      or
      not exists(cont.getLabel()) and completion = anonymousContinueCompletion()
    )
    or
    // the last node in an `ExprStmt` is the last node in the expression
    last(n.(ExprStmt).getExpr(), last, completion) and completion = NormalCompletion()
    or
    // the last statement of a labeled statement is the last statement of its body...
    exists(LabeledStmt lbl, Completion bodyCompletion |
      lbl = n and last(lbl.getStmt(), last, bodyCompletion)
    |
      // ...except if it's a `break` that refers to this labelled statement
      if bodyCompletion = labelledBreakCompletion(MkLabel(lbl.getLabel()))
      then completion = NormalCompletion()
      else completion = bodyCompletion
    )
    or
    // the last statement of a `catch` clause is the last statement of its block
    last(n.(CatchClause).getBlock(), last, completion)
    or
    // the last node in a variable declaration statement is in the last of its individual declarations
    exists(LocalVariableDeclStmt s | s = n |
      last(s.getVariable(count(s.getAVariable())), last, completion) and
      completion = NormalCompletion()
    )
  }

  /**
   * Compute the intra-procedural successors of cfg node `n`, assuming its
   * execution finishes with the given completion.
   */
  cached
  ControlFlowNode succ(ControlFlowNode n, Completion completion) {
    // Callables serve as their own exit nodes.
    exists(Callable c | last(c.getBody(), n, completion) | result = c)
    or
    // Logic expressions and conditional expressions execute in AST pre-order.
    completion = NormalCompletion() and
    (
      result = first(n.(AndLogicalExpr).getLeftOperand()) or
      result = first(n.(OrLogicalExpr).getLeftOperand()) or
      result = first(n.(LogNotExpr).getExpr()) or
      result = first(n.(ConditionalExpr).getCondition())
    )
    or
    // If a logic expression doesn't short-circuit then control flows from its left operand to its right.
    exists(AndLogicalExpr e |
      last(e.getLeftOperand(), n, completion) and
      completion = BooleanCompletion(true, _) and
      result = first(e.getRightOperand())
    )
    or
    exists(OrLogicalExpr e |
      last(e.getLeftOperand(), n, completion) and
      completion = BooleanCompletion(false, _) and
      result = first(e.getRightOperand())
    )
    or
    // Control flows to the corresponding branch depending on the boolean completion of the condition.
    exists(ConditionalExpr e, boolean branch |
      last(e.getCondition(), n, completion) and
      completion = BooleanCompletion(branch, _) and
      result = first(e.getBranchExpr(branch))
    )
    or
    exists(InstanceOfExpr ioe | ioe.isPattern() |
      last(ioe.getExpr(), n, completion) and completion = NormalCompletion() and result = ioe
      or
      n = ioe and
      result = ioe.getLocalVariableDeclExpr() and
      completion = basicBooleanCompletion(true)
    )
    or
    // In other expressions control flows from left to right and ends in the node itself.
    exists(PostOrderNode p, int i |
      last(p.getChildNode(i), n, completion) and completion = NormalCompletion()
    |
      result = first(p.getChildNode(i + 1))
      or
      not exists(p.getChildNode(i + 1)) and result = p
    )
    or
    // Statements within a block execute sequentially.
    result = first(n.(BlockStmt).getStmt(0)) and completion = NormalCompletion()
    or
    exists(BlockStmt blk, int i |
      last(blk.getStmt(i), n, completion) and
      completion = NormalCompletion() and
      result = first(blk.getStmt(i + 1))
    )
    or
    // Control flows to the corresponding branch depending on the boolean completion of the condition.
    exists(IfStmt s |
      n = s and result = first(s.getCondition()) and completion = NormalCompletion()
      or
      last(s.getCondition(), n, completion) and
      completion = BooleanCompletion(true, _) and
      result = first(s.getThen())
      or
      last(s.getCondition(), n, completion) and
      completion = BooleanCompletion(false, _) and
      result = first(s.getElse())
    )
    or
    // For statements:
    exists(ForStmt for, ControlFlowNode condentry |
      // Any part of the control flow that aims for the condition needs to hit either the condition...
      condentry = first(for.getCondition())
      or
      // ...or the body if the for doesn't include a condition.
      not exists(for.getCondition()) and condentry = first(for.getStmt())
    |
      // From the entry point, which is the for statement itself, control goes to either the first init expression...
      n = for and result = first(for.getInit(0)) and completion = NormalCompletion()
      or
      // ...or the condition if the for doesn't include init expressions.
      n = for and
      not exists(for.getAnInit()) and
      result = condentry and
      completion = NormalCompletion()
      or
      // Init expressions execute sequentially, after which control is transferred to the condition.
      exists(int i | last(for.getInit(i), n, completion) and completion = NormalCompletion() |
        result = first(for.getInit(i + 1))
        or
        not exists(for.getInit(i + 1)) and result = condentry
      )
      or
      // The true-successor of the condition is the body of the for loop.
      last(for.getCondition(), n, completion) and
      completion = BooleanCompletion(true, _) and
      result = first(for.getStmt())
      or
      // The updates execute sequentially, after which control is transferred to the condition.
      exists(int i | last(for.getUpdate(i), n, completion) and completion = NormalCompletion() |
        result = first(for.getUpdate(i + 1))
        or
        not exists(for.getUpdate(i + 1)) and result = condentry
      )
      or
      // The back edge of the loop: control goes to either the first update or the condition if no updates exist.
      last(for.getStmt(), n, completion) and
      continues(completion, for) and
      (
        result = first(for.getUpdate(0))
        or
        result = condentry and not exists(for.getAnUpdate())
      )
    )
    or
    // Enhanced for statements:
    exists(EnhancedForStmt for |
      // First the expression gets evaluated...
      n = for and result = first(for.getExpr()) and completion = NormalCompletion()
      or
      // ...then the variable gets assigned...
      last(for.getExpr(), n, completion) and
      completion = NormalCompletion() and
      result = for.getVariable()
      or
      // ...and then control goes to the body of the loop.
      n = for.getVariable() and result = first(for.getStmt()) and completion = NormalCompletion()
      or
      // Finally, the back edge of the loop goes to reassign the variable.
      last(for.getStmt(), n, completion) and
      continues(completion, for) and
      result = for.getVariable()
    )
    or
    // While loops start at the condition...
    result = first(n.(WhileStmt).getCondition()) and completion = NormalCompletion()
    or
    // ...and do-while loops start at the body.
    result = first(n.(DoStmt).getStmt()) and completion = NormalCompletion()
    or
    exists(LoopStmt loop | loop instanceof WhileStmt or loop instanceof DoStmt |
      // Control goes from the condition via a true-completion to the body...
      last(loop.getCondition(), n, completion) and
      completion = BooleanCompletion(true, _) and
      result = first(loop.getBody())
      or
      // ...and through the back edge from the body back to the condition.
      last(loop.getBody(), n, completion) and
      continues(completion, loop) and
      result = first(loop.getCondition())
    )
    or
    // Resource declarations in a try-with-resources execute sequentially.
    exists(TryStmt try, int i |
      last(try.getResource(i), n, completion) and completion = NormalCompletion()
    |
      result = first(try.getResource(i + 1))
      or
      not exists(try.getResource(i + 1)) and result = first(try.getBlock())
    )
    or
    // After the last resource declaration, control transfers to the body.
    exists(TryStmt try | n = try and completion = NormalCompletion() |
      result = first(try.getResource(0))
      or
      not exists(try.getAResource()) and result = first(try.getBlock())
    )
    or
    // exceptional control flow
    exists(TryStmt try | catchOrFinallyCompletion(try, n, completion) |
      // if the body of the `try` throws...
      exists(ThrowableType tt | completion = ThrowCompletion(tt) |
        // ...control transfers to a catch clause...
        result = first(handlingCatchClause(try, tt))
        or
        // ...or to the finally block
        not mustCatch(try.getACatchClause(), tt) and result = first(try.getFinally())
      )
      or
      // if the body completes normally, control transfers to the finally block
      not completion = ThrowCompletion(_) and result = first(try.getFinally())
    )
    or
    // after each catch clause, control transfers to the finally block
    exists(TryStmt try | last(try.getACatchClause(), n, completion) |
      result = first(try.getFinally())
    )
    or
    // Catch clauses first assign their variable and then execute their block
    exists(CatchClause cc | completion = NormalCompletion() |
      n = cc and result = first(cc.getVariable())
      or
      last(cc.getVariable(), n, completion) and result = first(cc.getBlock())
    )
    or
    // Switch statements
    exists(SwitchStmt switch | completion = NormalCompletion() |
      // From the entry point control is transferred first to the expression...
      n = switch and result = first(switch.getExpr())
      or
      // ...and then to one of the cases.
      last(switch.getExpr(), n, completion) and result = first(switch.getACase())
      or
      // Statements within a switch body execute sequentially.
      exists(int i |
        last(switch.getStmt(i), n, completion) and result = first(switch.getStmt(i + 1))
      )
    )
    or
    // Switch expressions
    exists(SwitchExpr switch | completion = NormalCompletion() |
      // From the entry point control is transferred first to the expression...
      n = switch and result = first(switch.getExpr())
      or
      // ...and then to one of the cases.
      last(switch.getExpr(), n, completion) and result = first(switch.getACase())
      or
      // Statements within a switch body execute sequentially.
      exists(int i |
        last(switch.getStmt(i), n, completion) and result = first(switch.getStmt(i + 1))
      )
    )
    or
    // No edges in a non-rule SwitchCase - the constant expression in a ConstCase isn't included in the CFG.
    exists(SwitchCase case | completion = NormalCompletion() |
      n = case and result = first(case.getRuleExpression())
      or
      n = case and result = first(case.getRuleStatement())
    )
    or
    // Yield
    exists(YieldStmt yield | completion = NormalCompletion() |
      n = yield and result = first(yield.getValue())
    )
    or
    // Synchronized statements execute their expression _before_ synchronization, so the CFG reflects that.
    exists(SynchronizedStmt synch | completion = NormalCompletion() |
      last(synch.getExpr(), n, completion) and result = synch
      or
      n = synch and result = first(synch.getBlock())
    )
    or
    result = first(n.(ExprStmt).getExpr()) and completion = NormalCompletion()
    or
    result = first(n.(LabeledStmt).getStmt()) and completion = NormalCompletion()
    or
    // Variable declarations in a variable declaration statement are executed sequentially.
    exists(LocalVariableDeclStmt s | completion = NormalCompletion() |
      n = s and result = first(s.getVariable(1))
      or
      exists(int i | last(s.getVariable(i), n, completion) and result = first(s.getVariable(i + 1)))
    )
  }

  /*
   * Conditions give rise to nodes with two normal successors, a true successor
   * and a false successor. At least one of them is completely contained in the
   * AST node of the branching construct and is therefore tagged with the
   * corresponding `booleanCompletion` in the `succ` relation (for example, the
   * then-branch of an if-statement, or the right operand of a binary logic
   * expression). The other successor may be tagged with either the corresponding
   * `booleanCompletion` (for example in an if-statement with an else-branch or
   * in a `ConditionalExpr`) or a `normalCompletion` (for example in an
   * if-statement without an else-part).
   *
   * If the other successor ends a finally block it may also be tagged with an
   * abnormal completion instead of a `normalCompletion`. This completion is
   * calculated by the `resumption` predicate. In this case the successor might
   * no longer be unique, as there can be multiple completions to be resumed
   * after the finally block.
   */

  /**
   * Gets the _resumption_ for cfg node `n`, that is, the completion according
   * to which control flow is determined if `n` completes normally.
   *
   * In most cases, the resumption is simply the normal completion, except if
   * `n` is the last node of a `finally` block, in which case it is the
   * completion of any predecessors of the `finally` block as determined by
   * predicate `finallyPred`, since their completion is resumed after normal
   * completion of the `finally`.
   */
  private Completion resumption(ControlFlowNode n) {
    exists(TryStmt try | lastInFinally(try, n) and finallyPred(try, _, result))
    or
    not lastInFinally(_, n) and result = NormalCompletion()
  }

  /**
   * A true- or false-successor that is tagged with the corresponding `booleanCompletion`.
   *
   * That is, the `booleanCompletion` is the label of the edge in the CFG.
   */
  private ControlFlowNode mainBranchSucc(ControlFlowNode n, boolean b) {
    result = succ(n, BooleanCompletion(_, b))
  }

  /**
   * A true- or false-successor that is not tagged with a `booleanCompletion`.
   *
   * That is, the label of the edge in the CFG is a `normalCompletion` or
   * some other completion if `n` occurs as the last node in a finally block.
   *
   * In the latter case, when `n` occurs as the last node in a finally block, there might be
   * multiple different such successors.
   */
  private ControlFlowNode otherBranchSucc(ControlFlowNode n, boolean b) {
    exists(ControlFlowNode main | main = mainBranchSucc(n, b.booleanNot()) |
      result = succ(n, resumption(n)) and
      not result = main and
      (b = true or b = false)
    )
  }

  /** Gets a true- or false-successor of `n`. */
  cached
  ControlFlowNode branchSuccessor(ControlFlowNode n, boolean branch) {
    result = mainBranchSucc(n, branch) or
    result = otherBranchSucc(n, branch)
  }
}

private import ControlFlowGraphImpl

/** A control-flow node that branches based on a condition. */
class ConditionNode extends ControlFlowNode {
  ConditionNode() { exists(branchSuccessor(this, _)) }

  /** Gets a true- or false-successor of the `ConditionNode`. */
  ControlFlowNode getABranchSuccessor(boolean branch) { result = branchSuccessor(this, branch) }

  /** Gets a true-successor of the `ConditionNode`. */
  ControlFlowNode getATrueSuccessor() { result = this.getABranchSuccessor(true) }

  /** Gets a false-successor of the `ConditionNode`. */
  ControlFlowNode getAFalseSuccessor() { result = this.getABranchSuccessor(false) }

  /** Gets the condition of this `ConditionNode`. This is equal to the node itself. */
  Expr getCondition() { result = this }
}
