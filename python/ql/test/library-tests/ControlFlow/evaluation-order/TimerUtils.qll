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
  abstract Expr getTimerExpr();

  /** Holds if this is a dead-code annotation (`t.dead[n]`). */
  predicate isDead() { this instanceof DeadTimerAnnotation }

  /** Holds if this is a never-evaluated annotation (`t.never`). */
  predicate isNever() { this instanceof NeverTimerAnnotation }

  string toString() { result = this.getAnnotatedExpr().toString() }

  Location getLocation() { result = this.getAnnotatedExpr().getLocation() }
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

  override BinaryExpr getTimerExpr() { result.getLeft() = annotated }
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

  override Call getTimerExpr() { result.getArg(0) = annotated }
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

  override BinaryExpr getTimerExpr() { result.getLeft() = annotated }
}

/** A never-evaluated annotation: `expr @ t.never`. */
class NeverTimerAnnotation extends TNeverAnnotation, TimerAnnotation {
  TestFunction func;
  Expr annotated;

  NeverTimerAnnotation() { this = TNeverAnnotation(func, annotated) }

  override Expr getTimestampsExpr() { none() }

  override TestFunction getTestFunction() { result = func }

  override Expr getAnnotatedExpr() { result = annotated }

  override BinaryExpr getTimerExpr() { result.getLeft() = annotated }
}

/**
 * Signature module defining the CFG interface needed by evaluation-order tests.
 * This allows the test utilities to be instantiated with different CFG implementations.
 */
signature module EvalOrderCfgSig {
  /** A control flow node. */
  class CfgNode {
    /** Gets a textual representation of this node. */
    string toString();

    /** Gets the location of this node. */
    Location getLocation();

    /** Gets the AST node corresponding to this CFG node, if any. */
    AstNode getNode();

    /** Gets a successor of this CFG node (including exceptional). */
    CfgNode getASuccessor();

    /** Gets an exceptional successor of this CFG node. */
    CfgNode getAnExceptionalSuccessor();

    /** Gets the scope containing this CFG node. */
    Scope getScope();

    /** Gets the basic block containing this CFG node. */
    BasicBlock getBasicBlock();
  }

  /** A basic block in the control flow graph. */
  class BasicBlock {
    /** Gets the CFG node at position `n` in this basic block. */
    CfgNode getNode(int n);

    /** Holds if this basic block reaches `bb` (reflexive). */
    predicate reaches(BasicBlock bb);

    /** Holds if this basic block strictly reaches `bb` (non-reflexive). */
    predicate strictlyReaches(BasicBlock bb);

    /** Holds if this basic block strictly dominates `bb`. */
    predicate strictlyDominates(BasicBlock bb);
  }

  /** Gets the entry CFG node for scope `s`. */
  CfgNode scopeGetEntryNode(Scope s);
}

/**
 * Parameterised module providing CFG-dependent utilities for evaluation-order tests.
 * Instantiate with a specific CFG implementation to get `TimerCfgNode` and related predicates.
 */
module EvalOrderCfgUtils<EvalOrderCfgSig Input> {
  /** The CFG node type from the underlying implementation. */
  final class CfgNode = Input::CfgNode;

  /** The basic block type from the underlying implementation (named to avoid clash with `python::BasicBlock`). */
  final class CfgBasicBlock = Input::BasicBlock;

  /** Gets the entry CFG node for scope `s`. */
  CfgNode scopeGetEntryNode(Scope s) { result = Input::scopeGetEntryNode(s) }

  /**
   * A CFG node corresponding to a timer annotation.
   */
  class TimerCfgNode extends CfgNode {
    private TimerAnnotation annot;

    TimerCfgNode() { annot.getAnnotatedExpr() = this.getNode() }

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
  predicate nextTimerAnnotation(CfgNode n, TimerCfgNode next) {
    next = n.getASuccessor() and
    next.getScope() = n.getScope()
    or
    exists(CfgNode mid |
      mid = n.getASuccessor() and
      not mid instanceof TimerCfgNode and
      mid.getScope() = n.getScope() and
      nextTimerAnnotation(mid, next)
    )
  }

  /** CFG-dependent test predicates, one per evaluation-order query. */
  module CfgTests {
    /**
     * Holds if live annotation `a` in function `f` is unreachable from
     * the function entry in the CFG.
     */
    predicate allLiveReachable(TimerCfgNode a, TestFunction f) {
      not a.isDead() and
      f = a.getTestFunction() and
      a.getScope() = f and
      not scopeGetEntryNode(f).getBasicBlock().reaches(a.getBasicBlock())
    }

    /**
     * Holds if annotated node `a` is followed by unannotated `succ` in the
     * same basic block.
     */
    predicate basicBlockAnnotationGap(TimerCfgNode a, CfgNode succ) {
      exists(CfgBasicBlock bb, int i |
        a = bb.getNode(i) and
        succ = bb.getNode(i + 1)
      ) and
      not succ instanceof TimerCfgNode and
      not isUnannotatable(succ.getNode()) and
      not isTimerMechanism(succ.getNode(), a.getTestFunction()) and
      not exists(a.getAnExceptionalSuccessor()) and
      succ.getNode() instanceof Expr
    }

    /**
     * Holds if annotations `a` and `b` appear in the same basic block with
     * `a` before `b`, but `a`'s minimum timestamp is not less than `b`'s.
     */
    predicate basicBlockOrdering(TimerCfgNode a, TimerCfgNode b, int minA, int minB) {
      exists(CfgBasicBlock bb, int i, int j | a = bb.getNode(i) and b = bb.getNode(j) and i < j) and
      minA = min(a.getATimestamp()) and
      minB = min(b.getATimestamp()) and
      minA >= minB
    }

    /**
     * Holds if function `f` has an annotation in a nested scope
     * (generator, async function, comprehension, lambda).
     */
    private predicate hasNestedScopeAnnotation(TestFunction f) {
      exists(TimerAnnotation a |
        a.getTestFunction() = f and
        a.getAnnotatedExpr().getScope() != f
      )
    }

    /**
     * Holds if annotation `ann` with timestamp `a` has no consecutive
     * successor (expected `a + 1`) in the CFG.
     */
    predicate consecutiveTimestamps(TimerAnnotation ann, int a) {
      not hasNestedScopeAnnotation(ann.getTestFunction()) and
      not ann.isDead() and
      a = ann.getATimestamp() and
      not exists(TimerCfgNode x, TimerCfgNode y |
        ann.getAnnotatedExpr() = x.getNode() and
        nextTimerAnnotation(x, y) and
        (a + 1) = y.getATimestamp()
      ) and
      // Exclude the maximum timestamp in the function (it has no successor)
      not a =
        max(TimerAnnotation other |
          other.getTestFunction() = ann.getTestFunction()
        |
          other.getATimestamp()
        )
    }

    /**
     * Holds if the expression annotated with `t.never` is reachable from
     * its scope's entry.
     */
    predicate neverReachable(NeverTimerAnnotation ann) {
      exists(CfgNode n, Scope s |
        n.getNode() = ann.getAnnotatedExpr() and
        s = n.getScope() and
        (
          // Reachable via inter-block path (includes same block)
          scopeGetEntryNode(s).getBasicBlock().reaches(n.getBasicBlock())
          or
          // In same block as entry but at a later index
          exists(CfgBasicBlock bb, int i, int j |
            bb.getNode(i) = scopeGetEntryNode(s) and bb.getNode(j) = n and i < j
          )
        )
      )
    }

    /**
     * Holds if consecutive annotated nodes `a` -> `b` have backward time
     * flow (`minA >= maxB`).
     */
    predicate noBackwardFlow(TimerCfgNode a, TimerCfgNode b, int minA, int maxB) {
      nextTimerAnnotation(a, b) and
      not a.isDead() and
      not b.isDead() and
      minA = min(a.getATimestamp()) and
      maxB = max(b.getATimestamp()) and
      minA >= maxB
    }

    /**
     * Holds if annotations `a` and `b` share timestamp `ts` but `a`
     * can reach `b` in the CFG.
     */
    predicate noSharedReachable(TimerCfgNode a, TimerCfgNode b, int ts) {
      a != b and
      not a.isDead() and
      not b.isDead() and
      a.getTestFunction() = b.getTestFunction() and
      ts = a.getATimestamp() and
      ts = b.getATimestamp() and
      (
        a.getBasicBlock().strictlyReaches(b.getBasicBlock())
        or
        exists(CfgBasicBlock bb, int i, int j | a = bb.getNode(i) and b = bb.getNode(j) and i < j)
      )
    }

    /**
     * Holds if consecutive single-timestamp annotations `a` -> `b` on a
     * forward edge have `maxA >= minB`.
     */
    predicate strictForward(TimerCfgNode a, TimerCfgNode b, int maxA, int minB) {
      nextTimerAnnotation(a, b) and
      not a.isDead() and
      not b.isDead() and
      // Only apply to non-loop code (single timestamps on both sides)
      strictcount(a.getATimestamp()) = 1 and
      strictcount(b.getATimestamp()) = 1 and
      // Forward edge: B does not strictly dominate A (excludes loop back-edges
      // but still checks same-basic-block pairs)
      not b.getBasicBlock().strictlyDominates(a.getBasicBlock()) and
      maxA = max(a.getATimestamp()) and
      minB = min(b.getATimestamp()) and
      maxA >= minB
    }

    /**
     * Holds if CFG node `n` in test function `f` does not belong to any basic block.
     */
    predicate noBasicBlock(CfgNode n, TestFunction f) {
      n.getScope() = f and
      not exists(n.getBasicBlock())
    }

    /**
     * Holds if non-dead annotation `ann` has no corresponding CFG node.
     */
    predicate annotationWithoutCfgNode(TimerAnnotation ann) {
      not ann.isDead() and
      not ann.isNever() and
      not exists(CfgNode n | n.getNode() = ann.getAnnotatedExpr())
    }

    predicate annotationWithCfgNode(TimerAnnotation ann) {
      exists(CfgNode n | n.getNode() = ann.getAnnotatedExpr())
    }
  }
}

/**
 * Holds if `e` is part of the timer mechanism: a top-level timer
 * expression or a (transitive) sub-expression of one.
 */
predicate isTimerMechanism(Expr e, TestFunction f) {
  exists(TimerAnnotation a |
    a.getTestFunction() = f and
    e = a.getTimerExpr().getASubExpression*()
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
