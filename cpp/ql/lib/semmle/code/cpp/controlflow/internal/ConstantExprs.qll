import cpp
private import PrimitiveBasicBlocks
private import semmle.code.cpp.controlflow.internal.CFG

private class Node = ControlFlowNodeBase;

import Cached

cached
private module Cached {
  /** A call to a function known not to return. */
  cached
  predicate aborting(FunctionCall c) { not potentiallyReturningFunctionCall(c) }

  /**
   * Functions that are known not to return. This is normally because the function
   * exits the program or longjmps to another location.
   */
  cached
  predicate abortingFunction(Function f) { not potentiallyReturningFunction(f) }

  /**
   * An adapted version of the `successors_extended` relation that excludes
   * impossible control-flow edges - flow will never occur along these
   * edges, so it is safe (and indeed sensible) to remove them.
   */
  cached
  predicate successors_adapted(Node pred, Node succ) {
    successors_extended(pred, succ) and
    possiblePredecessor(pred) and
    not impossibleFalseEdge(pred, succ) and
    not impossibleTrueEdge(pred, succ) and
    not impossibleSwitchEdge(pred, succ) and
    not impossibleDefaultSwitchEdge(pred, succ) and
    not impossibleFunctionReturn(pred, succ) and
    not getOptions().exprExits(pred)
  }

  /**
   * Provides predicates that should be exported as if they were top-level
   * predicates in `ControlFlowGraph.qll`. They have to be defined in this file
   * in order to be grouped in a `cached module` with other predicates that
   * must go in the same cached stage.
   */
  cached
  module ControlFlowGraphPublic {
    /**
     * Holds if the control-flow node `n` is reachable, meaning that either
     * it is an entry point, or there exists a path in the control-flow
     * graph of its function that connects an entry point to it.
     * Compile-time constant conditions are taken into account, so that
     * the call to `f` is not reachable in `if (0) f();` even if the
     * `if` statement as a whole is reachable.
     */
    cached
    predicate reachable(ControlFlowNode n) {
      // Okay to use successors_extended directly here
      reachableRecursive(n)
      or
      not successors_extended(_, n) and not successors_extended(n, _)
    }

    /** Holds if `condition` always evaluates to a nonzero value. */
    cached
    predicate conditionAlwaysTrue(Expr condition) { conditionAlways(condition, true) }

    /** Holds if `condition` always evaluates to zero. */
    cached
    predicate conditionAlwaysFalse(Expr condition) {
      conditionAlways(condition, false)
      or
      // If a loop condition evaluates to false upon entry, it will always
      // be false
      loopConditionAlwaysUponEntry(_, condition, false)
    }

    /**
     * The condition `condition` for the loop `loop` is provably `true` upon entry.
     * That is, at least one iteration of the loop is guaranteed.
     */
    cached
    predicate loopConditionAlwaysTrueUponEntry(ControlFlowNode loop, Expr condition) {
      loopConditionAlwaysUponEntry(loop, condition, true)
    }
  }
}

private predicate conditionAlways(Expr condition, boolean b) {
  exists(ConditionEvaluator x, int val | val = x.getValue(condition) |
    val != 0 and b = true
    or
    val = 0 and b = false
  )
}

private predicate loopConditionAlwaysUponEntry(ControlFlowNode loop, Expr condition, boolean b) {
  exists(LoopEntryConditionEvaluator x, int val |
    x.isLoopEntry(condition, loop) and
    val = x.getValue(condition)
  |
    val != 0 and b = true
    or
    val = 0 and b = false
  )
}

/**
 * This relation is the same as the `el instanceof Function`, only obfuscated
 * so the optimizer will not understand that any `FunctionCall.getTarget()`
 * should be in this relation.
 */
pragma[noinline]
private predicate isFunction(Element el) {
  el instanceof Function
  or
  el.(Expr).getParent() = el
}

/**
 * Holds if `fc` is a `FunctionCall` with no return value for `getTarget`. This
 * can happen in case of rare database inconsistencies.
 */
pragma[noopt]
private predicate callHasNoTarget(@funbindexpr fc) {
  exists(Function f |
    funbind(fc, f) and
    not isFunction(f)
  )
}

// Pulled out for performance. See
// https://github.com/github/codeql-coreql-team/issues/1044.
private predicate potentiallyReturningFunctionCall_base(FunctionCall fc) {
  fc.isVirtual()
  or
  callHasNoTarget(fc)
}

/** A function call that *may* return; if in doubt, we assume it may. */
private predicate potentiallyReturningFunctionCall(FunctionCall fc) {
  potentiallyReturningFunctionCall_base(fc)
  or
  potentiallyReturningFunction(fc.getTarget())
}

/** A function that *may* return; if in doubt, we assume it may. */
private predicate potentiallyReturningFunction(Function f) {
  not getOptions().exits(f) and
  (
    nonAnalyzableFunction(f)
    or
    // otherwise the exit-point of `f` must be reachable
    reachableRecursive(f)
  )
}

/**
 * A non-analyzable function is one for which there is no
 * path from the entry point to the exit point using the bare
 * `successors_extended` relation. This can happen if either the
 * function has no entry point (an external/library function),
 * or if the CFG for that function is incomplete.
 */
private predicate nonAnalyzableFunction(Function f) {
  /*
   * Identical to
   * ```
   * not successors_extended*(f.getEntryPoint(), f)
   * ```
   * but uses primitive basic blocks instead for better performance
   * (transitive closure of `PrimitiveBasicBlock.getASuccessor()` is
   * faster than transitive closure of the much larger `successors_extended`
   * relation).
   */

  not exists(PrimitiveBasicBlock bb1, int pos1, PrimitiveBasicBlock bb2, int pos2 |
    f.getEntryPoint() = bb1.getNode(pos1) and
    f = bb2.getNode(pos2)
  |
    bb1 = bb2 and pos2 > pos1
    or
    bb1.getASuccessor+() = bb2
  )
}

/**
 * If a condition is provably true, then control-flow edges to its false successors are impossible.
 */
private predicate impossibleFalseEdge(Expr condition, Node succ) {
  conditionAlwaysTrue(condition) and
  qlCfgFalseSuccessor(condition, succ) and
  not qlCfgTrueSuccessor(condition, succ)
}

/**
 * If a condition is provably false, then control-flow edges to its true successors are impossible.
 */
private predicate impossibleTrueEdge(Expr condition, Node succ) {
  conditionAlwaysFalse(condition) and
  qlCfgTrueSuccessor(condition, succ) and
  not qlCfgFalseSuccessor(condition, succ)
}

/**
 * Normally a switch case is for a single value, but it might cover a range
 * of values. Either way, this tells us the upper bound.
 */
private int switchCaseRangeEnd(SwitchCase sc) {
  if exists(sc.getEndExpr())
  then result = sc.getEndExpr().(CompileTimeConstantInt).getIntValue()
  else result = sc.getExpr().(CompileTimeConstantInt).getIntValue()
}

/**
 * Gets a switch expression for switch statement `switch` with
 * body `switchBlock`. There may be several such expressions: for example, if
 * the condition is `(x ? y : z)` then the result is {`y`, `z`}.
 */
private Node getASwitchExpr(SwitchStmt switch, BlockStmt switchBlock) {
  switch.getStmt() = switchBlock and
  successors_extended(result, switchBlock)
}

/**
 * If a switch provably never chooses `sc`, then the control-flow edge
 * from `switchBlock` to `sc` is impossible. This considers only non-`default`
 * switch cases.
 */
private predicate impossibleSwitchEdge(BlockStmt switchBlock, SwitchCase sc) {
  not sc instanceof DefaultCase and
  exists(SwitchStmt switch |
    switch = sc.getSwitchStmt() and
    switch.getStmt() = switchBlock and
    // If all of the successors have known values, and none of those
    // values are in our range, then this edge is impossible.
    forall(Node n | n = getASwitchExpr(switch, switchBlock) |
      exists(int switchValue |
        switchValue = getSwitchValue(n) and
        (
          switchValue < sc.getExpr().(CompileTimeConstantInt).getIntValue() or
          switchValue > switchCaseRangeEnd(sc)
        )
      )
    )
  )
}

/**
 * If a switch provably always chooses a non-default case, then the edge to
 * the default case is impossible.
 */
private predicate impossibleDefaultSwitchEdge(BlockStmt switchBlock, DefaultCase dc) {
  exists(SwitchStmt switch |
    switch = dc.getSwitchStmt() and
    switch.getStmt() = switchBlock and
    // If all of the successors lead to other switch cases
    // then this edge is impossible.
    forall(Node n | n = getASwitchExpr(switch, switchBlock) |
      exists(SwitchCase sc, int val |
        sc.getSwitchStmt() = switch and
        val = getSwitchValue(n) and
        val >= sc.getExpr().(CompileTimeConstantInt).getIntValue() and
        val <= switchCaseRangeEnd(sc)
      )
    )
  )
}

/**
 * Holds if the function `f` never returns due to not containing a return
 * statement (explicit or compiler generated).  This can be thought of as
 * a lightweight `potentiallyReturningFunction`- reachability of return
 * statements is not checked.
 */
private predicate nonReturningFunction(Function f) {
  exists(f.getBlock()) and
  not exists(ReturnStmt ret | ret.getEnclosingFunction() = f) and
  not getOptions().exits(f)
}

/**
 * An edge from a call to a function that never returns is impossible.
 */
private predicate impossibleFunctionReturn(FunctionCall fc, Node succ) {
  nonReturningFunction(fc.getTarget()) and
  not fc.isVirtual() and
  successors_extended(fc, succ)
}

/**
 * If `pred` is a function call with (at least) one function target,
 * (at least) one such target must be potentially returning.
 */
private predicate possiblePredecessor(Node pred) {
  not exists(pred.(FunctionCall).getTarget())
  or
  potentiallyReturningFunctionCall(pred)
}

/**
 * Holds if the control-flow node `n` is reachable, meaning that either
 * it is an entry point, or there exists a path in the control-flow
 * graph of its function that connects an entry point to it.
 * Compile-time constant conditions are taken into account, so that
 * the call to `f` is not reachable in `if (0) f();` even if the
 * `if` statement as a whole is reachable.
 */
private predicate reachableRecursive(ControlFlowNode n) {
  exists(Function f | f.getEntryPoint() = n)
  or
  n instanceof Handler
  or
  reachableRecursive(n.getAPredecessor())
}

/** Holds if `e` is a compile time constant with integer value `val`. */
private predicate compileTimeConstantInt(Expr e, int val) {
  (
    // If we have an integer value then we are done.
    if exists(e.getValue().toInt())
    then val = e.getValue().toInt()
    else
      // Otherwise, if we are a conversion of another expression with an
      // integer value, and that value can be converted into our type,
      // then we have that value.
      exists(Expr x, int valx |
        x.getConversion() = e and
        compileTimeConstantInt(x, valx) and
        val = convertIntToType(valx, e.getType().getUnspecifiedType())
      )
  ) and
  // If our unconverted expression is a string literal `"123"`, then we
  // do not have integer value `123`.
  not e.getUnconverted() instanceof StringLiteral
}

/**
 * Get `val` represented as type `t`, if that is possible without
 * overflow or underflows.
 */
bindingset[val, t]
private int convertIntToType(int val, IntegralType t) {
  if t instanceof BoolType
  then if val = 0 then result = 0 else result = 1
  else
    if t.isUnsigned()
    then val >= 0 and val.bitShiftRight(t.getSize() * 8) = 0 and result = val
    else
      if val >= 0 and val.bitShiftRight(t.getSize() * 8 - 1) = 0
      then result = val
      else (
        (-(val + 1)).bitShiftRight(t.getSize() * 8 - 1) = 0 and result = val
      )
}

/**
 * INTERNAL: Do not use.
 * An expression that has been found to have an integer value at compile
 * time.
 */
class CompileTimeConstantInt extends Expr {
  int val;

  CompileTimeConstantInt() { compileTimeConstantInt(this.getFullyConverted(), val) }

  int getIntValue() { result = val }
}

library class CompileTimeVariableExpr extends Expr {
  CompileTimeVariableExpr() { not this instanceof CompileTimeConstantInt }
}

/** A helper class for evaluation of expressions. */
library class ExprEvaluator extends int {
  /*
   * 0 = ConditionEvaluator,
   * 1 = SwitchEvaluator,
   * 2 = WhileLoopEntryConditionEvaluator,
   * 3 = ForLoopEntryConditionEvaluator
   */

  ExprEvaluator() { this in [0 .. 3] }

  /** `e` is an expression for which we want to calculate a value. */
  abstract predicate interesting(Expr e);

  /** Gets the value of (interesting) expression `e`, if any. */
  int getValue(Expr e) { result = this.getValueInternal(e, e) }

  /**
   * When evaluating a syntactic subexpression of `e`, we may
   * ignore the non-analyzable variable definition `def` for
   * variable `v`.
   *
   * Subclasses may implement this predicate when needed.
   */
  predicate ignoreNonAnalyzableVariableDefinition(Expr e, Variable v, StmtParent def) { none() }

  /**
   * When evaluating a syntactic subexpression of `e`, we may
   * ignore the expression `value` assigned to variable `v`.
   *
   * Subclasses may implement this predicate when needed.
   */
  predicate ignoreVariableAssignment(Expr e, Variable v, Expr value) { none() }

  /**
   * When evaluating a syntactic subexpression of `e`, we may
   * consider variable `v` even though it lacks an initializer.
   * Normally, this is not sound, as uninitialized variables
   * can contain arbitrary data (in fact, a query
   * UninitialisedLocal.ql exists for finding that).
   *
   * Subclasses may implement this predicate when needed.
   */
  predicate allowVariableWithoutInitializer(Expr e, Variable v) { none() }

  /* Internal implementation predicates below */
  /**
   * `req` is an expression for which a value is required to be evaluated in
   * order to calculate a value for interesting expression `e`. `sub`
   * indicates whether `req` is a syntactic subexpression of `e`.
   *
   * This predicate enumerates the nodes top-down; `getValueInternal()`
   * calculates the values bottom-up.
   */
  predicate interestingInternal(Expr e, Expr req, boolean sub) {
    this.interesting(e) and req = e and sub = true
    or
    exists(Expr mid | this.interestingInternal(e, mid, sub) |
      req = mid.(NotExpr).getOperand() or
      req = mid.(BinaryLogicalOperation).getAnOperand() or
      req = mid.(RelationalOperation).getAnOperand() or
      req = mid.(EQExpr).getAnOperand() or
      req = mid.(NEExpr).getAnOperand() or
      req = mid.(AddExpr).getAnOperand() or
      req = mid.(SubExpr).getAnOperand() or
      req = mid.(MulExpr).getAnOperand() or
      req = mid.(RemExpr).getAnOperand() or
      req = mid.(DivExpr).getAnOperand() or
      req = mid.(AssignExpr).getRValue()
    )
    or
    exists(VariableAccess va, Variable v, boolean sub1 |
      this.interestingVariableAccess(e, va, v, sub1) and
      req = v.getAnAssignedValue() and
      (sub1 = true implies not this.ignoreVariableAssignment(e, v, req)) and
      sub = false
    )
    or
    exists(Function f |
      this.interestingFunction(e, f) and
      returnStmt(f, req) and
      sub = false
    )
  }

  private predicate interestingVariableAccess(Expr e, VariableAccess va, Variable v, boolean sub) {
    this.interestingInternal(e, va, sub) and
    v = getVariableTarget(va) and
    (
      v.hasInitializer()
      or
      sub = true and this.allowVariableWithoutInitializer(e, v)
    ) and
    tractableVariable(v) and
    forall(StmtParent def | nonAnalyzableVariableDefinition(v, def) |
      sub = true and
      this.ignoreNonAnalyzableVariableDefinition(e, v, def)
    )
  }

  private predicate interestingFunction(Expr e, Function f) {
    exists(FunctionCall fc | this.interestingInternal(e, fc, _) |
      f = fc.getTarget() and
      not obviouslyNonConstant(f) and
      not f.getUnspecifiedType() instanceof VoidType
    )
  }

  /** Gets the value of subexpressions `req` for expression `e`, if any. */
  private int getValueInternal(Expr e, Expr req) {
    (
      this.interestingInternal(e, req, true) and
      (
        result = req.(CompileTimeConstantInt).getIntValue() or
        result = this.getCompoundValue(e, req)
      ) and
      (
        req.getUnderlyingType().(IntegralType).isSigned() or
        result >= 0
      )
    )
  }

  /** Gets the value of compound subexpressions `val` for expression `e`, if any. */
  private int getCompoundValue(Expr e, CompileTimeVariableExpr val) {
    this.interestingInternal(e, val, true) and
    (
      exists(NotExpr req | req = val |
        result = 1 and this.getValueInternal(e, req.getOperand()) = 0
        or
        result = 0 and this.getValueInternal(e, req.getOperand()) != 0
      )
      or
      exists(LogicalAndExpr req | req = val |
        result = 1 and
        this.getValueInternal(e, req.getLeftOperand()) != 0 and
        this.getValueInternal(e, req.getRightOperand()) != 0
        or
        result = 0 and this.getValueInternal(e, req.getAnOperand()) = 0
      )
      or
      exists(LogicalOrExpr req | req = val |
        result = 1 and this.getValueInternal(e, req.getAnOperand()) != 0
        or
        result = 0 and
        this.getValueInternal(e, req.getLeftOperand()) = 0 and
        this.getValueInternal(e, req.getRightOperand()) = 0
      )
      or
      exists(LTExpr req | req = val |
        result = 1 and
        this.getValueInternal(e, req.getLeftOperand()) <
          this.getValueInternal(e, req.getRightOperand())
        or
        result = 0 and
        this.getValueInternal(e, req.getLeftOperand()) >=
          this.getValueInternal(e, req.getRightOperand())
      )
      or
      exists(GTExpr req | req = val |
        result = 1 and
        this.getValueInternal(e, req.getLeftOperand()) >
          this.getValueInternal(e, req.getRightOperand())
        or
        result = 0 and
        this.getValueInternal(e, req.getLeftOperand()) <=
          this.getValueInternal(e, req.getRightOperand())
      )
      or
      exists(LEExpr req | req = val |
        result = 1 and
        this.getValueInternal(e, req.getLeftOperand()) <=
          this.getValueInternal(e, req.getRightOperand())
        or
        result = 0 and
        this.getValueInternal(e, req.getLeftOperand()) >
          this.getValueInternal(e, req.getRightOperand())
      )
      or
      exists(GEExpr req | req = val |
        result = 1 and
        this.getValueInternal(e, req.getLeftOperand()) >=
          this.getValueInternal(e, req.getRightOperand())
        or
        result = 0 and
        this.getValueInternal(e, req.getLeftOperand()) <
          this.getValueInternal(e, req.getRightOperand())
      )
      or
      exists(EQExpr req | req = val |
        result = 1 and
        this.getValueInternal(e, req.getLeftOperand()) =
          this.getValueInternal(e, req.getRightOperand())
        or
        result = 0 and
        this.getValueInternal(e, req.getLeftOperand()) !=
          this.getValueInternal(e, req.getRightOperand())
      )
      or
      exists(NEExpr req | req = val |
        result = 0 and
        this.getValueInternal(e, req.getLeftOperand()) =
          this.getValueInternal(e, req.getRightOperand())
        or
        result = 1 and
        this.getValueInternal(e, req.getLeftOperand()) !=
          this.getValueInternal(e, req.getRightOperand())
      )
      or
      exists(AddExpr req | req = val |
        result =
          this.getValueInternal(e, req.getLeftOperand()) +
            this.getValueInternal(e, req.getRightOperand())
      )
      or
      exists(SubExpr req | req = val |
        result =
          this.getValueInternal(e, req.getLeftOperand()) -
            this.getValueInternal(e, req.getRightOperand())
      )
      or
      exists(MulExpr req | req = val |
        result =
          this.getValueInternal(e, req.getLeftOperand()) *
            this.getValueInternal(e, req.getRightOperand())
      )
      or
      exists(RemExpr req | req = val |
        result =
          this.getValueInternal(e, req.getLeftOperand()) %
            this.getValueInternal(e, req.getRightOperand())
      )
      or
      exists(DivExpr req | req = val |
        result =
          this.getValueInternal(e, req.getLeftOperand()) /
            this.getValueInternal(e, req.getRightOperand())
      )
      or
      exists(AssignExpr req | req = val | result = this.getValueInternal(e, req.getRValue()))
      or
      result = this.getVariableValue(e, val)
      or
      exists(FunctionCall call | call = val and not callWithMultipleTargets(call) |
        result = this.getFunctionValue(call.getTarget())
      )
    )
  }

  language[monotonicAggregates]
  private int getVariableValue(Expr e, VariableAccess va) {
    exists(Variable v |
      this.interestingVariableAccess(e, va, v, true) and
      // All assignments must have the same int value
      result =
        unique(Expr value |
          value = v.getAnAssignedValue() and not this.ignoreVariableAssignment(e, v, value)
        |
          this.getValueInternalNonSubExpr(value)
        )
    )
  }

  /** Holds if the function `f` is considered by the analysis and may return `ret`. */
  pragma[noinline]
  private predicate interestingReturnValue(Function f, Expr ret) {
    this.interestingFunction(_, f) and
    returnStmt(f, ret)
  }

  private int getFunctionValue(Function f) {
    // All returns must have the same int value
    // And it must have at least one return
    forex(Expr ret | this.interestingReturnValue(f, ret) |
      result = this.getValueInternalNonSubExpr(ret)
    )
  }

  /**
   * Same as `getValueInternal` but where `req` is not a syntactic subexpression
   * of an interesting expression, and hence `nonAnalyzableVariableDefinition` and
   * `ignoreNonAnalyzableVariableDefinition` are not relevant. That is, `req` is
   * either a value assigned to an interesting variable or the return expression of
   * an interesting function.
   *
   * This predicate, `getCompoundValueNonSubExpr`, and `getVariableValueNonSubExpr`
   * need to be duplicated for performance reasons (the extra argument `e` can be
   * omitted).
   */
  private int getValueInternalNonSubExpr(Expr req) {
    this.interestingInternal(_, req, false) and
    (
      result = req.(CompileTimeConstantInt).getIntValue() or
      result = this.getCompoundValueNonSubExpr(req)
    ) and
    (
      req.getUnderlyingType().(IntegralType).isSigned() or
      result >= 0
    )
  }

  private int getCompoundValueNonSubExpr(CompileTimeVariableExpr val) {
    (
      exists(NotExpr req | req = val |
        result = 1 and this.getValueInternalNonSubExpr(req.getOperand()) = 0
        or
        result = 0 and this.getValueInternalNonSubExpr(req.getOperand()) != 0
      )
      or
      exists(LogicalAndExpr req | req = val |
        result = 1 and
        this.getValueInternalNonSubExpr(req.getLeftOperand()) != 0 and
        this.getValueInternalNonSubExpr(req.getRightOperand()) != 0
        or
        result = 0 and this.getValueInternalNonSubExpr(req.getAnOperand()) = 0
      )
      or
      exists(LogicalOrExpr req | req = val |
        result = 1 and this.getValueInternalNonSubExpr(req.getAnOperand()) != 0
        or
        result = 0 and
        this.getValueInternalNonSubExpr(req.getLeftOperand()) = 0 and
        this.getValueInternalNonSubExpr(req.getRightOperand()) = 0
      )
      or
      exists(LTExpr req | req = val |
        result = 1 and
        this.getValueInternalNonSubExpr(req.getLeftOperand()) <
          this.getValueInternalNonSubExpr(req.getRightOperand())
        or
        result = 0 and
        this.getValueInternalNonSubExpr(req.getLeftOperand()) >=
          this.getValueInternalNonSubExpr(req.getRightOperand())
      )
      or
      exists(GTExpr req | req = val |
        result = 1 and
        this.getValueInternalNonSubExpr(req.getLeftOperand()) >
          this.getValueInternalNonSubExpr(req.getRightOperand())
        or
        result = 0 and
        this.getValueInternalNonSubExpr(req.getLeftOperand()) <=
          this.getValueInternalNonSubExpr(req.getRightOperand())
      )
      or
      exists(LEExpr req | req = val |
        result = 1 and
        this.getValueInternalNonSubExpr(req.getLeftOperand()) <=
          this.getValueInternalNonSubExpr(req.getRightOperand())
        or
        result = 0 and
        this.getValueInternalNonSubExpr(req.getLeftOperand()) >
          this.getValueInternalNonSubExpr(req.getRightOperand())
      )
      or
      exists(GEExpr req | req = val |
        result = 1 and
        this.getValueInternalNonSubExpr(req.getLeftOperand()) >=
          this.getValueInternalNonSubExpr(req.getRightOperand())
        or
        result = 0 and
        this.getValueInternalNonSubExpr(req.getLeftOperand()) <
          this.getValueInternalNonSubExpr(req.getRightOperand())
      )
      or
      exists(EQExpr req | req = val |
        result = 1 and
        this.getValueInternalNonSubExpr(req.getLeftOperand()) =
          this.getValueInternalNonSubExpr(req.getRightOperand())
        or
        result = 0 and
        this.getValueInternalNonSubExpr(req.getLeftOperand()) !=
          this.getValueInternalNonSubExpr(req.getRightOperand())
      )
      or
      exists(NEExpr req | req = val |
        result = 0 and
        this.getValueInternalNonSubExpr(req.getLeftOperand()) =
          this.getValueInternalNonSubExpr(req.getRightOperand())
        or
        result = 1 and
        this.getValueInternalNonSubExpr(req.getLeftOperand()) !=
          this.getValueInternalNonSubExpr(req.getRightOperand())
      )
      or
      exists(AddExpr req | req = val |
        result =
          this.getValueInternalNonSubExpr(req.getLeftOperand()) +
            this.getValueInternalNonSubExpr(req.getRightOperand())
      )
      or
      exists(SubExpr req | req = val |
        result =
          this.getValueInternalNonSubExpr(req.getLeftOperand()) -
            this.getValueInternalNonSubExpr(req.getRightOperand())
      )
      or
      exists(MulExpr req | req = val |
        result =
          this.getValueInternalNonSubExpr(req.getLeftOperand()) *
            this.getValueInternalNonSubExpr(req.getRightOperand())
      )
      or
      exists(RemExpr req | req = val |
        result =
          this.getValueInternalNonSubExpr(req.getLeftOperand()) %
            this.getValueInternalNonSubExpr(req.getRightOperand())
      )
      or
      exists(DivExpr req | req = val |
        result =
          this.getValueInternalNonSubExpr(req.getLeftOperand()) /
            this.getValueInternalNonSubExpr(req.getRightOperand())
      )
      or
      exists(AssignExpr req | req = val | result = this.getValueInternalNonSubExpr(req.getRValue()))
      or
      result = this.getVariableValueNonSubExpr(val)
      or
      exists(FunctionCall call | call = val and not callWithMultipleTargets(call) |
        result = this.getFunctionValue(call.getTarget())
      )
    )
  }

  private int getVariableValueNonSubExpr(VariableAccess va) {
    // All assignments must have the same int value
    result = this.getMinVariableValueNonSubExpr(va) and
    result = this.getMaxVariableValueNonSubExpr(va)
  }

  /**
   * Helper predicate for `getVariableValueNonSubExpr`: computes the minimum value considered by this library
   * that is assigned to the variable accessed by `va`.
   */
  language[monotonicAggregates]
  pragma[noopt]
  private int getMinVariableValueNonSubExpr(VariableAccess va) {
    exists(Variable v |
      this.interestingVariableAccess(_, va, v, false) and
      result =
        min(Expr value | value = v.getAnAssignedValue() | this.getValueInternalNonSubExpr(value))
    )
  }

  /**
   * Helper predicate for `getVariableValueNonSubExpr`: computes the maximum value considered by this library
   * that is assigned to the variable accessed by `va`.
   */
  language[monotonicAggregates]
  pragma[noopt]
  private int getMaxVariableValueNonSubExpr(VariableAccess va) {
    exists(Variable v |
      this.interestingVariableAccess(_, va, v, false) and
      result =
        max(Expr value | value = v.getAnAssignedValue() | this.getValueInternalNonSubExpr(value))
    )
  }
}

/**
 * Holds if the dynamic target of `call` cannot be determined statically even
 * though there is a `call.getTarget()`. This can happen due to virtual
 * dispatch or due to insufficient information about which object files should
 * be linked together.
 */
private predicate callWithMultipleTargets(FunctionCall call) {
  // Some function calls have more than one possible target. Such call need to
  // be excluded from the analysis, because they could lead to ambiguous
  // results.
  call.getTarget() != call.getTarget()
  or
  call.isVirtual()
}

// Folded predicate for proper join-order
private Variable getVariableTarget(VariableAccess va) {
  result = va.getTarget() and
  (result instanceof LocalVariable or result instanceof GlobalOrNamespaceVariable)
}

/**
 * Holds if `def` is a (potential) definition of variable `v` that makes it
 * impossible to analyze the value of `v` by only looking at direct assignments
 * to `v`.
 */
private predicate nonAnalyzableVariableDefinition(Variable v, StmtParent def) {
  def.(AddressOfExpr).getAddressable() = v
  or
  exists(VariableAccess va | va.getTarget() = v |
    definitionByReference(va, def)
    or
    def.(CrementOperation).getAnOperand() = va
    or
    def.(Assignment).getLValue() = va and not def instanceof AssignExpr
  )
  or
  asmStmtMayDefineVariable(def, v)
}

/**
 * For performance reasons, we want to restrict some of the computation to only
 * variables that are tractable. The threshold chosen here has been tested
 * empirically to have effect only on a few rare and pathological examples.
 */
private predicate tractableVariable(Variable v) {
  not exists(StmtParent def | nonAnalyzableVariableDefinition(v, def)) or
  strictcount(StmtParent def | nonAnalyzableVariableDefinition(v, def)) < 1000
}

/**
 * Helper predicate: Gets an expression which is obviously just an access to
 * the parameter `p`, including ternary expressions.
 */
private Expr parameterAccess(Parameter p) {
  result = p.getAnAccess() or
  result.(ConditionalExpr).getThen() = parameterAccess(p) or
  result.(ConditionalExpr).getElse() = parameterAccess(p)
}

/**
 * Holds if the function `f` is obviously not tractable for this library's
 * analysis techniques:
 * - it may obviously return multiple distinct constant values,
 * - it may return one of its parameters without reassigning it, or
 * - it may return an expression for which this analysis cannot infer a constant value.
 *
 * For example, `int f(int x) { if (x) return 0; else return 1; }` may
 * obviously return two constant values, and so will never be considered to
 * have a compile-time constant value by this library, and
 * `int min(int x, int y) { return x < y ? x : y; }` returns a parameter and
 * so won't have a locally constant value.
 */
private predicate obviouslyNonConstant(Function f) {
  // May return multiple distinct constant values
  1 < strictcount(Expr e, string value | returnStmt(f, e) and value = e.getValue())
  or
  // May return a parameter without reassignment
  exists(Parameter p, Expr ret |
    returnStmt(f, ret) and
    p = f.getAParameter() and
    not exists(p.getAnAssignedValue())
  |
    ret = parameterAccess(p)
  )
  or
  // May return a value for which this analysis cannot infer a constant value
  exists(Expr ret | returnStmt(f, ret) | nonComputableConstant(ret))
  or
  // Returns many non-constant values
  strictcount(Expr e | returnStmt(f, e) and not exists(e.getValue())) > 100
}

/**
 * Helper predicate: holds if the analysis cannot compute a
 * constant value for the expression `e`.
 */
private predicate nonComputableConstant(Expr e) {
  // Variable targets that are ignored
  e instanceof VariableAccess and not exists(getVariableTarget(e))
  or
  // Recursive cases
  nonComputableConstant(e.(BinaryArithmeticOperation).getAnOperand())
  or
  nonComputableConstant(e.(ComparisonOperation).getAnOperand())
}

/** Holds if assembler statement `asm` may define variable `v`. */
private predicate asmStmtMayDefineVariable(AsmStmt asm, Variable v) {
  // We don't actually have access to the assembler code, so assume
  // that any variable declared in the same function may be defined
  exists(DeclStmt decl, Function f |
    decl.getADeclaration() = v and
    f = decl.getEnclosingFunction() and
    f = asm.getEnclosingFunction()
  )
}

private predicate returnStmt(Function f, Expr value) {
  exists(ReturnStmt ret |
    ret.getEnclosingFunction() = f and
    value = ret.getExpr()
  )
}

/** A helper class for evaluation of conditions. */
library class ConditionEvaluator extends ExprEvaluator {
  ConditionEvaluator() { this = 0 }

  override predicate interesting(Expr e) {
    qlCfgFalseSuccessor(e, _)
    or
    qlCfgTrueSuccessor(e, _)
  }
}

/** A helper class for evaluation of switch expressions. */
library class SwitchEvaluator extends ExprEvaluator {
  SwitchEvaluator() { this = 1 }

  override predicate interesting(Expr e) { e = getASwitchExpr(_, _) }
}

private int getSwitchValue(Expr e) { exists(SwitchEvaluator x | result = x.getValue(e)) }

/** A helper class for evaluation of loop entry conditions. */
library class LoopEntryConditionEvaluator extends ExprEvaluator {
  LoopEntryConditionEvaluator() { this in [2 .. 3] }

  abstract override predicate interesting(Expr e);

  /** Holds if `cfn` is the entry point of the loop for which `e` is the condition. */
  abstract predicate isLoopEntry(Expr e, Node cfn);

  /** Holds if `s` is the loop body guarded by the condition `e`. */
  abstract predicate isLoopBody(Expr e, StmtParent s);

  private predicate isLoopBodyDescendant(Expr e, StmtParent s) {
    this.isLoopBody(e, s)
    or
    exists(StmtParent mid | this.isLoopBodyDescendant(e, mid) |
      s = mid.(Stmt).getAChild() or
      s = mid.(Expr).getAChild()
    )
  }

  // Same as `interestingInternal(e, sub, true)` but avoids negative recursion
  private predicate interestingSubExpr(Expr e, Expr sub) {
    this.interesting(e) and e = sub
    or
    exists(Expr mid | this.interestingSubExpr(e, mid) and sub = mid.getAChild())
  }

  private predicate maybeInterestingVariable(Expr e, Variable v) {
    exists(VariableAccess va | this.interestingSubExpr(e, va) | va.getTarget() = v)
  }

  /**
   * Holds if the expression `valueOrDef` in the body of the loop belonging to
   * `e` can reach the entry point of the loop without crossing an assignment
   * to `v`.
   *
   * `valueOrDef` is either a value assigned to variable `v` or a non-analyzable
   * definition of `v`.
   */
  private predicate reachesLoopEntryFromLoopBody(Expr e, Variable v, StmtParent valueOrDef) {
    this.maybeInterestingVariable(e, v) and
    (valueOrDef = v.getAnAssignedValue() or nonAnalyzableVariableDefinition(v, valueOrDef)) and
    this.isLoopBodyDescendant(e, valueOrDef) and
    /*
     * Use primitive basic blocks in reachability analysis for better performance.
     * This is similar to the pattern used in e.g. `DefinitionsAndUses` and
     * `StackVariableReachability`.
     */

    exists(PrimitiveBasicBlock bb1, int pos1 | bb1.getNode(pos1) = valueOrDef |
      // Reaches in same basic block
      exists(int pos2 |
        this.loopEntryAt(bb1, pos2, e) and
        pos2 > pos1 and
        not exists(int k | this.assignmentAt(bb1, k, v) | k in [pos1 + 1 .. pos2 - 1])
      )
      or
      // Reaches in a successor block
      exists(PrimitiveBasicBlock bb2 |
        bb2 = bb1.getASuccessor() and
        not exists(int pos3 | this.assignmentAt(bb1, pos3, v) and pos3 > pos1) and
        this.bbReachesLoopEntry(bb2, e, v)
      )
    )
  }

  private predicate loopEntryAt(PrimitiveBasicBlock bb, int pos, Expr e) {
    exists(Node cfn |
      bb.getNode(pos) = cfn and
      this.isLoopEntry(e, cfn)
    )
  }

  private predicate assignmentAt(PrimitiveBasicBlock bb, int pos, Variable v) {
    this.maybeInterestingVariable(_, v) and
    bb.getNode(pos) = v.getAnAssignedValue()
  }

  /**
   * Holds if the entry point of basic block `bb` can reach the entry point of
   * the loop belonging to `e` without crossing an assignment to `v`.
   */
  private predicate bbReachesLoopEntry(PrimitiveBasicBlock bb, Expr e, Variable v) {
    this.bbReachesLoopEntryLocally(bb, e, v)
    or
    exists(PrimitiveBasicBlock succ | succ = bb.getASuccessor() |
      this.bbReachesLoopEntry(succ, e, v) and
      not this.assignmentAt(bb, _, v)
    )
  }

  private predicate bbReachesLoopEntryLocally(PrimitiveBasicBlock bb, Expr e, Variable v) {
    exists(int pos |
      this.loopEntryAt(bb, pos, e) and
      this.maybeInterestingVariable(e, v) and
      not exists(int pos1 | this.assignmentAt(bb, pos1, v) | pos1 < pos)
    )
  }

  /**
   * When evaluating a syntactic subexpression of loop condition `e`,
   * we may ignore non-analyzable variable definition `def` for
   * variable `v`, provided that `def` is in the body of the loop and
   * cannot reach the loop entry point.
   *
   * Example:
   *
   * ```
   * done = false;
   * while (!done) {
   *   f(&done); // can be ignored
   * }
   *
   * while (...) {
   *   done = false;
   *   while (!done) {
   *     f(&done); // can be ignored
   *   }
   * }
   *
   * done = false;
   * while (...) {
   *   while (!done) {
   *     f(&done); // cannot be ignored
   *   }
   * }
   * ```
   */
  override predicate ignoreNonAnalyzableVariableDefinition(Expr e, Variable v, StmtParent def) {
    this.maybeInterestingVariable(e, v) and
    nonAnalyzableVariableDefinition(v, def) and
    this.isLoopBodyDescendant(e, def) and
    not this.reachesLoopEntryFromLoopBody(e, v, def)
  }

  /**
   * When evaluating a syntactic subexpression of loop condition `e`,
   * we may ignore the expression `value` assigned to variable `v`,
   * provided that `value` is in the body of the loop and cannot reach
   * the loop entry point.
   *
   * Example:
   *
   * ```
   * done = false;
   * while (!done) {
   *   done = true; // can be ignored
   * }
   *
   * while (...) {
   *   done = false;
   *   while (!done) {
   *     done = true; // can be ignored
   *   }
   * }
   *
   * done = false;
   * while (...) {
   *   while (!done) {
   *     done = true; // cannot be ignored
   *   }
   * }
   * ```
   */
  override predicate ignoreVariableAssignment(Expr e, Variable v, Expr value) {
    this.maybeInterestingVariable(e, v) and
    value = v.getAnAssignedValue() and
    this.isLoopBodyDescendant(e, value) and
    not this.reachesLoopEntryFromLoopBody(e, v, value)
  }
}

/** A helper class for evaluation of while-loop entry conditions. */
library class WhileLoopEntryConditionEvaluator extends LoopEntryConditionEvaluator {
  WhileLoopEntryConditionEvaluator() { this = 2 }

  override predicate interesting(Expr e) { exists(WhileStmt while | e = while.getCondition()) }

  override predicate isLoopEntry(Expr e, Node cfn) { cfn.(WhileStmt).getCondition() = e }

  override predicate isLoopBody(Expr e, StmtParent s) {
    exists(WhileStmt while | e = while.getCondition() | s = while.getStmt())
  }
}

/** A helper class for evaluation of for-loop entry conditions. */
library class ForLoopEntryConditionEvaluator extends LoopEntryConditionEvaluator {
  ForLoopEntryConditionEvaluator() { this = 3 }

  override predicate interesting(Expr e) { exists(ForStmt for | e = for.getCondition()) }

  override predicate isLoopEntry(Expr e, Node cfn) { cfn.(ForStmt).getCondition() = e }

  override predicate isLoopBody(Expr e, StmtParent s) {
    exists(ForStmt for | e = for.getCondition() |
      s = for.getUpdate() or
      s = for.getStmt()
    )
  }

  override predicate ignoreNonAnalyzableVariableDefinition(Expr e, Variable v, StmtParent def) {
    LoopEntryConditionEvaluator.super.ignoreNonAnalyzableVariableDefinition(e, v, def)
    or
    // If the for loop initializes variable `v` we know its exact value so all
    // non-analyzable definitions can be ignored
    exists(ForStmt for |
      forLoopInitializesVariable(for, v, _) and
      e = for.getCondition() and
      nonAnalyzableVariableDefinition(v, def)
    )
  }

  override predicate ignoreVariableAssignment(Expr e, Variable v, Expr value) {
    LoopEntryConditionEvaluator.super.ignoreVariableAssignment(e, v, value)
    or
    // If the for loop initializes variable `v` we know its exact value so all
    // other assignments can be ignored
    exists(ForStmt for |
      forLoopInitializesVariable(for, v, _) and
      e = for.getCondition() and
      value = v.getAnAssignedValue() and
      not forLoopInitializesVariable(for, v, value)
    )
  }

  override predicate allowVariableWithoutInitializer(Expr e, Variable v) {
    // If the for loop initializes variable `v` we know its exact value
    // regardless of a lacking initializer
    exists(ForStmt for |
      forLoopInitializesVariable(for, v, _) and
      e = for.getCondition() and
      not v.hasInitializer()
    )
  }
}

/** Holds if for-loop `for` initializes variable `v` to expression `e`. */
private predicate forLoopInitializesVariable(ForStmt for, Variable v, Expr e) {
  exists(AssignExpr ae |
    ae = for.getInitialization().(ExprStmt).getExpr() and
    assignsValue(ae, v, e)
  )
  or
  exists(DeclStmt decl, Expr init, Variable v1 |
    decl = for.getInitialization() and
    v1 = decl.getADeclaration() and
    init = v1.getInitializer().getExpr()
  |
    e = init and v = v1
    or
    assignsValue(init, v, e)
  )
}

/**
 * Holds if assignment `ae` assigns expression `e` to variable `v`.
 *
 * Nested assignments are included, e.g. `i = j = 0;` assigns the
 * expression `j = 0` to `i` and the expression `0` to `j`.
 */
private predicate assignsValue(AssignExpr ae, Variable v, Expr e) {
  v.getAnAccess() = ae.getLValue() and e = ae.getRValue()
  or
  assignsValue(ae.getRValue(), v, e)
}
