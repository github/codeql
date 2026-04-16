/**
 * Utility library for identifying timer annotations in evaluation-order tests.
 *
 * Identifies `expr @ t[n]` (matmul), `t(expr, n)` (call), and
 * `expr @ t.dead[n]` (dead-code) patterns, extracts timestamp values,
 * and provides predicates for traversing consecutive annotated CFG nodes.
 */

import python

/**
 * A function decorated with `@test` from the timer module.
 * The first parameter is the timer object.
 */
class TestFunction extends Function {
  TestFunction() {
    this.getADecorator().(Name).getId() = "test" and
    this.getPositionalParameterCount() >= 1
  }

  /** Gets the name of the timer parameter (first parameter). */
  string getTimerParamName() { result = this.getArgName(0) }
}

/** Gets an IntegerLiteral from a timestamp expression (single int or tuple of ints). */
private IntegerLiteral timestampLiteral(Expr timestamps) {
  result = timestamps
  or
  result = timestamps.(Tuple).getAnElt()
}

/** A timer annotation in the AST. */
private newtype TTimerAnnotation =
  /** `expr @ t[n]` or `expr @ t[n, m, ...]` */
  TMatmulAnnotation(TestFunction func, Expr annotated, Expr timestamps) {
    exists(BinaryExpr be |
      be.getOp() instanceof MatMult and
      be.getRight().(Subscript).getObject().(Name).getId() = func.getTimerParamName() and
      be.getScope().getEnclosingScope*() = func and
      annotated = be.getLeft() and
      timestamps = be.getRight().(Subscript).getIndex()
    )
  } or
  /** `t(expr, n)` */
  TCallAnnotation(TestFunction func, Expr annotated, Expr timestamps) {
    exists(Call call |
      call.getFunc().(Name).getId() = func.getTimerParamName() and
      call.getScope().getEnclosingScope*() = func and
      annotated = call.getArg(0) and
      timestamps = call.getArg(1)
    )
  } or
  /** `expr @ t.dead[n]` — dead-code annotation */
  TDeadAnnotation(TestFunction func, Expr annotated, Expr timestamps) {
    exists(BinaryExpr be |
      be.getOp() instanceof MatMult and
      be.getRight().(Subscript).getObject().(Attribute).getObject("dead").(Name).getId() =
        func.getTimerParamName() and
      be.getScope().getEnclosingScope*() = func and
      annotated = be.getLeft() and
      timestamps = be.getRight().(Subscript).getIndex()
    )
  } or
  /** `expr @ t.never` — annotation for code that should never be evaluated */
  TNeverAnnotation(TestFunction func, Expr annotated) {
    exists(BinaryExpr be |
      be.getOp() instanceof MatMult and
      be.getRight().(Attribute).getObject("never").(Name).getId() = func.getTimerParamName() and
      be.getScope().getEnclosingScope*() = func and
      annotated = be.getLeft()
    )
  }

/** A timer annotation (wrapping the newtype for a clean API). */
class TimerAnnotation extends TTimerAnnotation {
  /** Gets a timestamp value from this annotation. */
  int getATimestamp() { exists(this.getTimestampExpr(result)) }

  /** Gets the source expression for timestamp value `ts`. */
  IntegerLiteral getTimestampExpr(int ts) {
    result = timestampLiteral(this.getTimestampsExpr()) and
    result.getValue() = ts
  }

  /** Gets the raw timestamp expression (single int or tuple). */
  abstract Expr getTimestampsExpr();

  /** Gets the test function this annotation belongs to. */
  abstract TestFunction getTestFunction();

  /** Gets the annotated expression (the LHS of `@` or the first arg of `t(...)`). */
  abstract Expr getAnnotatedExpr();

  /** Gets the enclosing annotation expression (the `BinaryExpr` or `Call`). */
  abstract Expr getExpr();

  /** Holds if this is a dead-code annotation (`t.dead[n]`). */
  predicate isDead() { this instanceof DeadTimerAnnotation }

  /** Holds if this is a never-evaluated annotation (`t.never`). */
  predicate isNever() { this instanceof NeverTimerAnnotation }

  string toString() { result = this.getExpr().toString() }

  Location getLocation() { result = this.getExpr().getLocation() }
}

/** A matmul-based timer annotation: `expr @ t[n]`. */
class MatmulTimerAnnotation extends TMatmulAnnotation, TimerAnnotation {
  TestFunction func;
  Expr annotated;
  Expr timestamps;

  MatmulTimerAnnotation() { this = TMatmulAnnotation(func, annotated, timestamps) }

  override Expr getTimestampsExpr() { result = timestamps }

  override TestFunction getTestFunction() { result = func }

  override Expr getAnnotatedExpr() { result = annotated }

  override BinaryExpr getExpr() { result.getLeft() = annotated }
}

/** A call-based timer annotation: `t(expr, n)`. */
class CallTimerAnnotation extends TCallAnnotation, TimerAnnotation {
  TestFunction func;
  Expr annotated;
  Expr timestamps;

  CallTimerAnnotation() { this = TCallAnnotation(func, annotated, timestamps) }

  override Expr getTimestampsExpr() { result = timestamps }

  override TestFunction getTestFunction() { result = func }

  override Expr getAnnotatedExpr() { result = annotated }

  override Call getExpr() { result.getArg(0) = annotated }
}

/** A dead-code timer annotation: `expr @ t.dead[n]`. */
class DeadTimerAnnotation extends TDeadAnnotation, TimerAnnotation {
  TestFunction func;
  Expr annotated;
  Expr timestamps;

  DeadTimerAnnotation() { this = TDeadAnnotation(func, annotated, timestamps) }

  override Expr getTimestampsExpr() { result = timestamps }

  override TestFunction getTestFunction() { result = func }

  override Expr getAnnotatedExpr() { result = annotated }

  override BinaryExpr getExpr() { result.getLeft() = annotated }
}

/** A never-evaluated annotation: `expr @ t.never`. */
class NeverTimerAnnotation extends TNeverAnnotation, TimerAnnotation {
  TestFunction func;
  Expr annotated;

  NeverTimerAnnotation() { this = TNeverAnnotation(func, annotated) }

  override Expr getTimestampsExpr() { none() }

  override TestFunction getTestFunction() { result = func }

  override Expr getAnnotatedExpr() { result = annotated }

  override BinaryExpr getExpr() { result.getLeft() = annotated }
}

/**
 * A CFG node corresponding to a timer annotation.
 */
class TimerCfgNode extends ControlFlowNode {
  private TimerAnnotation annot;

  TimerCfgNode() { annot.getExpr() = this.getNode() }

  /** Gets a timestamp value from this annotation. */
  int getATimestamp() { result = annot.getATimestamp() }

  /** Gets the source expression for timestamp value `ts`. */
  IntegerLiteral getTimestampExpr(int ts) { result = annot.getTimestampExpr(ts) }

  /** Gets the test function this annotation belongs to. */
  TestFunction getTestFunction() { result = annot.getTestFunction() }

  /** Holds if this is a dead-code annotation. */
  predicate isDead() { annot.isDead() }

  /** Holds if this is a never-evaluated annotation. */
  predicate isNever() { annot.isNever() }
}

/**
 * Holds if `next` is the next timer annotation reachable from `n` via
 * CFG successors (both normal and exceptional), skipping non-annotated
 * intermediaries within the same scope.
 */
predicate nextTimerAnnotation(ControlFlowNode n, TimerCfgNode next) {
  next = n.getASuccessor() and
  next.getScope() = n.getScope()
  or
  exists(ControlFlowNode mid |
    mid = n.getASuccessor() and
    not mid instanceof TimerCfgNode and
    mid.getScope() = n.getScope() and
    nextTimerAnnotation(mid, next)
  )
}

/**
 * Holds if `e` is part of the timer mechanism: a top-level timer
 * expression or a (transitive) sub-expression of one.
 */
predicate isTimerMechanism(Expr e, TestFunction f) {
  exists(TimerAnnotation a |
    a.getTestFunction() = f and
    e = a.getExpr().getASubExpression*()
  )
}

/**
 * Holds if expression `e` cannot be annotated due to Python syntax
 * limitations (e.g., it is a definition target, a pattern, or part
 * of a decorator application).
 */
predicate isUnannotatable(Expr e) {
  // Function/class definitions
  e instanceof FunctionExpr
  or
  e instanceof ClassExpr
  or
  // Docstrings are string literals used as expression statements
  e instanceof StringLiteral and e.getParent() instanceof ExprStmt
  or
  // Function parameters are bound by the call, not evaluated in the body
  e instanceof Parameter
  or
  // Name nodes that are definitions or deletions (assignment targets, def/class
  // name bindings, augmented assignment targets, for-loop targets, del targets)
  e.(Name).isDefinition()
  or
  e.(Name).isDeletion()
  or
  // Tuple/List/Starred nodes in assignment or for-loop targets are
  // structural unpack patterns, not evaluations
  (e instanceof Tuple or e instanceof List or e instanceof Starred) and
  e = any(AssignStmt a).getATarget().getASubExpression*()
  or
  (e instanceof Tuple or e instanceof List or e instanceof Starred) and
  e = any(For f).getTarget().getASubExpression*()
  or
  // The decorator call node wrapping a function/class definition,
  // and its sub-expressions (the decorator name itself)
  e = any(FunctionExpr func).getADecoratorCall().getASubExpression*()
  or
  e = any(ClassExpr cls).getADecoratorCall().getASubExpression*()
  or
  // Augmented assignment (x += e): the implicit BinaryExpr for the operation
  e = any(AugAssign aug).getOperation()
  or
  // with-statement `as` variables are bindings
  (e instanceof Name or e instanceof Tuple or e instanceof List) and
  e = any(With w).getOptionalVars().getASubExpression*()
  or
  // except-clause exception type and `as` variable are part of except syntax
  exists(ExceptStmt ex | e = ex.getType() or e = ex.getName())
  or
  // match/case pattern expressions are part of pattern syntax
  e.getParent+() instanceof Pattern
  or
  // Subscript/Attribute nodes on the LHS of an assignment are store
  // operations, not value expressions (including nested ones like d["a"][1])
  (e instanceof Subscript or e instanceof Attribute) and
  e = any(AssignStmt a).getATarget().getASubExpression*()
  or
  // Match/case guard nodes are part of case syntax
  e instanceof Guard
  or
  // Yield/YieldFrom in statement position — the return value is
  // discarded and cannot be meaningfully annotated
  (e instanceof Yield or e instanceof YieldFrom) and
  e.getParent() instanceof ExprStmt
  or
  // Synthetic nodes inside desugared comprehensions
  e.getScope() = any(Comp c).getFunction() and
  (
    e.(Name).getId() = ".0"
    or
    e instanceof Tuple and e.getParent() instanceof Yield
  )
}
