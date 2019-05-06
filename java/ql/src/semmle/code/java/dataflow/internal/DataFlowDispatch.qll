private import java
private import DataFlowPrivate
import semmle.code.java.dispatch.VirtualDispatch

cached
private module DispatchImpl {
  /**
   * Holds if the set of viable implementations that can be called by `ma`
   * might be improved by knowing the call context. This is the case if the
   * qualifier is the `i`th parameter of the enclosing callable `c`.
   */
  private predicate benefitsFromCallContext(MethodAccess ma, Callable c, int i) {
    exists(Parameter p |
      2 <= strictcount(viableImpl(ma)) and
      ma.getQualifier().(VarAccess).getVariable() = p and
      p.getPosition() = i and
      c.getAParameter() = p and
      not p.isVarargs() and
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
      benefitsFromCallContext(_, c, i) and
      c = viableCallable(ctx)
    )
  }

  /**
   * Holds if the `i`th argument of `ctx` has type `t` and `ctx` is a
   * relevant call context.
   */
  private predicate contextArgHasType(Call ctx, int i, RefType t, boolean exact) {
    exists(Expr arg, Expr src |
      relevantContext(ctx, i) and
      ctx.getArgument(i) = arg and
      src = variableTrack(arg) and
      exists(RefType srctype | srctype = src.getType() |
        exists(TypeVariable v | v = srctype |
          t = v.getUpperBoundType+() and not t instanceof TypeVariable
        )
        or
        t = srctype and not srctype instanceof TypeVariable
      ) and
      if src instanceof ClassInstanceExpr then exact = true else exact = false
    )
  }

  /**
   * Gets a viable dispatch target of `ma` in the context `ctx`. This is
   * restricted to those `ma`s for which a context might make a difference.
   */
  private Method viableImplInCallContext(MethodAccess ma, Call ctx) {
    result = viableImpl(ma) and
    exists(int i, Callable c, Method def, RefType t, boolean exact |
      benefitsFromCallContext(ma, c, i) and
      c = viableCallable(ctx) and
      contextArgHasType(ctx, i, t, exact) and
      ma.getMethod() = def
    |
      exact = true and result = exactMethodImpl(def, t.getSourceDeclaration())
      or
      exact = false and
      exists(RefType t2 |
        result = viableMethodImpl(def, t.getSourceDeclaration(), t2) and
        not failsUnification(t, t2)
      )
    )
  }

  pragma[noinline]
  private predicate unificationTargetLeft(ParameterizedType t1, GenericType g) {
    contextArgHasType(_, _, t1, _) and t1.getGenericType() = g
  }

  pragma[noinline]
  private predicate unificationTargetRight(ParameterizedType t2, GenericType g) {
    exists(viableMethodImpl(_, _, t2)) and t2.getGenericType() = g
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

  /**
   * Holds if the call context `ctx` reduces the set of viable dispatch
   * targets of `ma` in `c`.
   */
  cached
  predicate reducedViableImplInCallContext(MethodAccess ma, Callable c, Call ctx) {
    exists(int tgts, int ctxtgts |
      benefitsFromCallContext(ma, c, _) and
      c = viableCallable(ctx) and
      ctxtgts = count(viableImplInCallContext(ma, ctx)) and
      tgts = strictcount(viableImpl(ma)) and
      ctxtgts < tgts
    )
  }

  /**
   * Gets a viable dispatch target of `ma` in the context `ctx`. This is
   * restricted to those `ma`s for which the context makes a difference.
   */
  cached
  Method prunedViableImplInCallContext(MethodAccess ma, Call ctx) {
    result = viableImplInCallContext(ma, ctx) and
    reducedViableImplInCallContext(ma, _, ctx)
  }

  /**
   * Holds if flow returning from `m` to `ma` might return further and if
   * this path restricts the set of call sites that can be returned to.
   */
  cached
  predicate reducedViableImplInReturn(Method m, MethodAccess ma) {
    exists(int tgts, int ctxtgts |
      benefitsFromCallContext(ma, _, _) and
      m = viableImpl(ma) and
      ctxtgts = count(Call ctx | m = viableImplInCallContext(ma, ctx)) and
      tgts = strictcount(Call ctx | viableCallable(ctx) = ma.getEnclosingCallable()) and
      ctxtgts < tgts
    )
  }

  /**
   * Gets a viable dispatch target of `ma` in the context `ctx`. This is
   * restricted to those `ma`s and results for which the return flow from the
   * result to `ma` restricts the possible context `ctx`.
   */
  cached
  Method prunedViableImplInCallContextReverse(MethodAccess ma, Call ctx) {
    result = viableImplInCallContext(ma, ctx) and
    reducedViableImplInReturn(result, ma)
  }
}
import DispatchImpl
