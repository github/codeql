private import java
private import DataFlowPrivate
private import DataFlowUtil
private import semmle.code.java.dataflow.InstanceAccess
private import semmle.code.java.dataflow.FlowSummary
private import semmle.code.java.dispatch.VirtualDispatch as VirtualDispatch
private import semmle.code.java.dispatch.internal.Unification

private module DispatchImpl {
  /** Gets a viable implementation of the target of the given `Call`. */
  DataFlowCallable viableCallable(DataFlowCall c) {
    result.asCallable() = VirtualDispatch::viableCallable(c.asCall())
    or
    result.asSummarizedCallable() = c.asCall().getCallee().getSourceDeclaration()
  }

  /**
   * Holds if the set of viable implementations that can be called by `ma`
   * might be improved by knowing the call context. This is the case if the
   * qualifier is the `i`th parameter of the enclosing callable `c`.
   */
  private predicate mayBenefitFromCallContext(MethodAccess ma, Callable c, int i) {
    exists(Parameter p |
      2 <= strictcount(VirtualDispatch::viableImpl(ma)) and
      ma.getQualifier().(VarAccess).getVariable() = p and
      p.getPosition() = i and
      c.getAParameter() = p and
      not p.isVarargs() and
      c = ma.getEnclosingCallable()
    )
    or
    exists(OwnInstanceAccess ia |
      2 <= strictcount(VirtualDispatch::viableImpl(ma)) and
      (ia.isExplicit(ma.getQualifier()) or ia.isImplicitMethodQualifier(ma)) and
      i = -1 and
      c = ma.getEnclosingCallable()
    )
  }

  /**
   * Holds if the call `ctx` might act as a context that improves the set of
   * dispatch targets of a `MethodAccess` that occurs in a viable target of
   * `ctx`.
   */
  pragma[nomagic]
  private predicate relevantContext(Call ctx, int i) {
    exists(Callable c |
      mayBenefitFromCallContext(_, c, i) and
      c = VirtualDispatch::viableCallable(ctx)
    )
  }

  private RefType getPreciseType(Expr e) {
    result = e.(FunctionalExpr).getConstructedType()
    or
    not e instanceof FunctionalExpr and result = e.getType()
  }

  /**
   * Holds if the `i`th argument of `ctx` has type `t` and `ctx` is a
   * relevant call context.
   */
  private predicate contextArgHasType(Call ctx, int i, RefType t, boolean exact) {
    relevantContext(ctx, i) and
    exists(RefType srctype |
      exists(Expr arg, Expr src |
        i = -1 and
        ctx.getQualifier() = arg
        or
        ctx.getArgument(i) = arg
      |
        src = VirtualDispatch::variableTrack(arg) and
        srctype = getPreciseType(src) and
        if src instanceof ClassInstanceExpr then exact = true else exact = false
      )
      or
      exists(Node arg |
        i = -1 and
        not exists(ctx.getQualifier()) and
        getInstanceArgument(ctx) = arg and
        arg.getTypeBound() = srctype and
        if ctx instanceof ClassInstanceExpr then exact = true else exact = false
      )
    |
      t = srctype.(BoundedType).getAnUltimateUpperBoundType()
      or
      t = srctype and not srctype instanceof BoundedType
    )
  }

  /**
   * Holds if the set of viable implementations that can be called by `call`
   * might be improved by knowing the call context. This is the case if the
   * qualifier is a parameter of the enclosing callable `c`.
   */
  predicate mayBenefitFromCallContext(DataFlowCall call, DataFlowCallable c) {
    mayBenefitFromCallContext(call.asCall(), c.asCallable(), _)
  }

  /**
   * Gets a viable dispatch target of `call` in the context `ctx`. This is
   * restricted to those `call`s for which a context might make a difference.
   */
  DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) {
    result = viableCallable(call) and
    exists(int i, Callable c, Method def, RefType t, boolean exact, MethodAccess ma |
      ma = call.asCall() and
      mayBenefitFromCallContext(ma, c, i) and
      c = viableCallable(ctx).asCallable() and
      contextArgHasType(ctx.asCall(), i, t, exact) and
      ma.getMethod().getSourceDeclaration() = def
    |
      exact = true and
      result.asCallable() = VirtualDispatch::exactMethodImpl(def, t.getSourceDeclaration())
      or
      exact = false and
      exists(RefType t2 |
        result.asCallable() = VirtualDispatch::viableMethodImpl(def, t.getSourceDeclaration(), t2) and
        not Unification::failsUnification(t, t2)
      )
      or
      result.asSummarizedCallable() = def
    )
  }

  private predicate unificationTargetLeft(ParameterizedType t1) { contextArgHasType(_, _, t1, _) }

  private predicate unificationTargetRight(ParameterizedType t2) {
    exists(VirtualDispatch::viableMethodImpl(_, _, t2))
  }

  private module Unification = MkUnification<unificationTargetLeft/1, unificationTargetRight/1>;

  private int parameterPosition() { result in [-1, any(Parameter p).getPosition()] }

  /** A parameter position represented by an integer. */
  class ParameterPosition extends int {
    ParameterPosition() { this = parameterPosition() }
  }

  /** An argument position represented by an integer. */
  class ArgumentPosition extends int {
    ArgumentPosition() { this = parameterPosition() }
  }

  /** Holds if arguments at position `apos` match parameters at position `ppos`. */
  pragma[inline]
  predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { ppos = apos }
}

import DispatchImpl
