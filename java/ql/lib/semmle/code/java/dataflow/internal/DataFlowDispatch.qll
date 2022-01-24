private import java
private import DataFlowPrivate
private import DataFlowUtil
private import semmle.code.java.dataflow.InstanceAccess
private import semmle.code.java.dataflow.FlowSummary
private import semmle.code.java.dispatch.VirtualDispatch as VirtualDispatch

private module DispatchImpl {
  /** Gets a viable implementation of the target of the given `Call`. */
  DataFlowCallable viableCallable(DataFlowCall c) {
    result.asCallable() = VirtualDispatch::viableCallable(c.asCall())
    or
    result.(SummarizedCallable).asCallable() = c.asCall().getCallee().getSourceDeclaration()
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
        not failsUnification(t, t2)
      )
      or
      result.asCallable() = def and result instanceof SummarizedCallable
    )
  }

  pragma[noinline]
  private predicate unificationTargetLeft(ParameterizedType t1, GenericType g) {
    contextArgHasType(_, _, t1, _) and t1.getGenericType() = g
  }

  pragma[noinline]
  private predicate unificationTargetRight(ParameterizedType t2, GenericType g) {
    exists(VirtualDispatch::viableMethodImpl(_, _, t2)) and t2.getGenericType() = g
  }

  private predicate unificationTargets(Type t1, Type t2) {
    exists(GenericType g | unificationTargetLeft(t1, g) and unificationTargetRight(t2, g))
    or
    exists(Array a1, Array a2 |
      unificationTargets(a1, a2) and
      t1 = a1.getComponentType() and
      t2 = a2.getComponentType()
    )
    or
    exists(ParameterizedType pt1, ParameterizedType pt2, int pos |
      unificationTargets(pt1, pt2) and
      not pt1.getSourceDeclaration() != pt2.getSourceDeclaration() and
      t1 = pt1.getTypeArgument(pos) and
      t2 = pt2.getTypeArgument(pos)
    )
  }

  pragma[noinline]
  private predicate typeArgsOfUnificationTargets(
    ParameterizedType t1, ParameterizedType t2, int pos, RefType arg1, RefType arg2
  ) {
    unificationTargets(t1, t2) and
    arg1 = t1.getTypeArgument(pos) and
    arg2 = t2.getTypeArgument(pos)
  }

  private predicate failsUnification(Type t1, Type t2) {
    unificationTargets(t1, t2) and
    (
      exists(RefType arg1, RefType arg2 |
        typeArgsOfUnificationTargets(t1, t2, _, arg1, arg2) and
        failsUnification(arg1, arg2)
      )
      or
      failsUnification(t1.(Array).getComponentType(), t2.(Array).getComponentType())
      or
      not (
        t1 instanceof Array and t2 instanceof Array
        or
        t1.(PrimitiveType) = t2.(PrimitiveType)
        or
        t1.(Class).getSourceDeclaration() = t2.(Class).getSourceDeclaration()
        or
        t1.(Interface).getSourceDeclaration() = t2.(Interface).getSourceDeclaration()
        or
        t1 instanceof BoundedType and t2 instanceof RefType
        or
        t1 instanceof RefType and t2 instanceof BoundedType
      )
    )
  }

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
