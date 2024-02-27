/**
 * Provides predicates for reasoning about runtime call targets through virtual
 * dispatch.
 */

import java
import semmle.code.java.dataflow.TypeFlow
private import DispatchFlow as DispatchFlow
private import ObjFlow as ObjFlow
private import semmle.code.java.dataflow.internal.BaseSSA
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.dispatch.internal.Unification

/**
 * A conservative analysis that returns a single method - if we can establish
 * one - that will be the target of the virtual dispatch.
 */
Method exactVirtualMethod(MethodCall c) {
  // If there are multiple potential implementations, return nothing.
  implCount(c, 1) and
  result = viableImpl(c)
}

/**
 * A conservative analysis that returns a single callable - if we can establish
 * one - that will be the target of the call.
 */
Callable exactCallable(Call c) {
  result = exactVirtualMethod(c)
  or
  c instanceof ConstructorCall and result = c.getCallee()
}

private predicate implCount(MethodCall m, int c) { strictcount(viableImpl(m)) = c }

/** Gets a viable implementation of the target of the given `Call`. */
Callable viableCallable(Call c) {
  result = viableImpl(c)
  or
  c instanceof ConstructorCall and result = c.getCallee().getSourceDeclaration()
}

/** The source declaration of a method that is the target of a virtual call. */
class VirtCalledSrcMethod extends SrcMethod {
  pragma[nomagic]
  VirtCalledSrcMethod() {
    exists(VirtualMethodCall ma | ma.getMethod().getSourceDeclaration() = this)
  }
}

private module Dispatch {
  /** Gets a viable implementation of the method called in the given method access. */
  cached
  Method viableImpl(MethodCall ma) { result = ObjFlow::viableImpl_out(ma) }

  /**
   * Holds if `m` is a viable implementation of the method called in `ma` for
   * which we only have imprecise open-world type-based dispatch resolution, and
   * the dispatch type is likely to yield implausible dispatch targets.
   */
  cached
  predicate lowConfidenceDispatchTarget(MethodCall ma, Method m) {
    m = viableImpl(ma) and lowConfidenceDispatch(ma)
  }

  /**
   * INTERNAL: Use `viableImpl` instead.
   *
   * Gets a viable implementation of the method called in the given method access.
   */
  cached
  Method viableImpl_v3(MethodCall ma) { result = DispatchFlow::viableImpl_out(ma) }

  /**
   * Holds if the best type bounds for the qualifier of `ma` are likely to
   * contain implausible dispatch targets.
   */
  private predicate lowConfidenceDispatch(VirtualMethodCall ma) {
    exists(RefType t | hasQualifierType(ma, t, false) |
      lowConfidenceDispatchType(t.getSourceDeclaration())
    ) and
    (
      not qualType(ma, _, _)
      or
      exists(RefType t | qualType(ma, t, false) |
        lowConfidenceDispatchType(t.getSourceDeclaration())
      )
    ) and
    (
      not qualUnionType(ma, _, _)
      or
      exists(RefType t | qualUnionType(ma, t, false) |
        lowConfidenceDispatchType(t.getSourceDeclaration())
      )
    ) and
    not ObjFlow::objectToStringCall(ma)
  }

  private predicate lowConfidenceDispatchType(SrcRefType t) {
    t instanceof TypeObject
    or
    t instanceof Interface and not t.fromSource()
    or
    t instanceof TypeInputStream
    or
    t.hasQualifiedName("java.io", "Serializable")
    or
    t.hasQualifiedName("java.lang", "Iterable")
    or
    t.hasQualifiedName("java.lang", "Cloneable")
    or
    t.getPackage().hasName("java.util") and t instanceof Interface
    or
    t.hasQualifiedName("java.util", "Hashtable")
  }

  /**
   * INTERNAL: Use `viableImpl` instead.
   *
   * Gets a viable implementation of the method called in the given method access.
   */
  cached
  Method viableImpl_v2(MethodCall ma) {
    result = viableImpl_v2_cand(pragma[only_bind_into](ma)) and
    exists(Method def, RefType t, boolean exact |
      qualUnionType(pragma[only_bind_into](ma), pragma[only_bind_into](t),
        pragma[only_bind_into](exact)) and
      def = ma.getMethod().getSourceDeclaration()
    |
      exact = true and result = exactMethodImpl(def, t.getSourceDeclaration())
      or
      exact = false and
      exists(RefType t2 |
        result = viableMethodImpl(def, t.getSourceDeclaration(), t2) and
        not Unification_v2::failsUnification(t, t2)
      )
    )
    or
    result = viableImpl_v2_cand(ma) and
    not qualUnionType(ma, _, _)
  }

  private predicate qualUnionType(VirtualMethodCall ma, RefType t, boolean exact) {
    exprUnionTypeFlow(ma.getQualifier(), t, exact)
  }

  private predicate unificationTargetLeft_v2(ParameterizedType t1) { qualUnionType(_, t1, _) }

  private module Unification_v2 =
    MkUnification<unificationTargetLeft_v2/1, unificationTargetRight/1>;

  private Method viableImpl_v2_cand(MethodCall ma) {
    result = viableImpl_v1(ma) and
    (
      exists(Method def, RefType t, boolean exact |
        qualType(ma, t, exact) and
        def = ma.getMethod().getSourceDeclaration()
      |
        exact = true and result = exactMethodImpl(def, t.getSourceDeclaration())
        or
        exact = false and
        exists(RefType t2 |
          result = viableMethodImpl(def, t.getSourceDeclaration(), t2) and
          not Unification_v2_cand::failsUnification(t, t2)
        )
      )
      or
      not qualType(ma, _, _)
    )
  }

  private predicate qualType(VirtualMethodCall ma, RefType t, boolean exact) {
    exprTypeFlow(ma.getQualifier(), t, exact)
  }

  private predicate unificationTargetLeft_v2_cand(ParameterizedType t1) { qualType(_, t1, _) }

  private module Unification_v2_cand =
    MkUnification<unificationTargetLeft_v2_cand/1, unificationTargetRight/1>;

  /**
   * INTERNAL: Use `viableImpl` instead.
   *
   * Gets a viable implementation of the method called in the given method access.
   */
  cached
  Method viableImpl_v1(MethodCall source) {
    result = viableImpl_v1_cand(source) and
    not impossibleDispatchTarget(source, result)
  }

  /**
   * Holds if `source` cannot dispatch to `tgt` due to a negative `instanceof` guard.
   */
  private predicate impossibleDispatchTarget(MethodCall source, Method tgt) {
    tgt = viableImpl_v1_cand(source) and
    exists(Guard typeTest, BaseSsaVariable v, Expr q, RefType t |
      source.getQualifier() = q and
      v.getAUse() = q and
      typeTest.appliesTypeTest(v.getAUse(), t, false) and
      guardControls_v1(typeTest, q.getBasicBlock(), false) and
      tgt.getDeclaringType().getSourceDeclaration().getASourceSupertype*() = t.getErasure()
    )
  }

  /**
   * Gets a viable implementation of the method called in the given method access.
   */
  private Method viableImpl_v1_cand(MethodCall source) {
    not result.isAbstract() and
    if source instanceof VirtualMethodCall
    then
      exists(VirtCalledSrcMethod def, RefType t, boolean exact |
        source.getMethod().getSourceDeclaration() = def and
        hasQualifierType(source, t, exact)
      |
        exact = true and result = exactMethodImpl(def, t.getSourceDeclaration())
        or
        exact = false and
        exists(RefType t2 |
          result = viableMethodImpl(def, t.getSourceDeclaration(), t2) and
          not Unification_v1::failsUnification(t, t2)
        )
      )
    else result = source.getMethod().getSourceDeclaration()
  }

  private predicate unificationTargetLeft_v1(ParameterizedType t1) { hasQualifierType(_, t1, _) }

  private predicate unificationTargetRight(ParameterizedType t2) {
    exists(viableMethodImpl(_, _, t2))
  }

  private module Unification_v1 =
    MkUnification<unificationTargetLeft_v1/1, unificationTargetRight/1>;

  private RefType getPreciseType(Expr e) {
    result = e.(FunctionalExpr).getConstructedType()
    or
    not e instanceof FunctionalExpr and result = e.getType()
  }

  private predicate hasQualifierType(VirtualMethodCall ma, RefType t, boolean exact) {
    exists(Expr src | src = ma.getQualifier() |
      // If we have a qualifier, then we take its type.
      exists(RefType srctype | srctype = getPreciseType(src) |
        exists(BoundedType bd | bd = srctype |
          t = bd.getAnUltimateUpperBoundType()
          or
          not exists(bd.getAnUltimateUpperBoundType()) and t = ma.getMethod().getDeclaringType()
        )
        or
        t = srctype and not srctype instanceof BoundedType
      ) and
      // If we have a class instance expression, then we know the exact type.
      // This is an important improvement in precision.
      if src instanceof ClassInstanceExpr then exact = true else exact = false
    )
    or
    // If the call has no qualifier then it's an implicit `this` qualifier,
    // so start from the caller's declaring type or enclosing type.
    not exists(ma.getQualifier()) and
    exact = false and
    (
      ma.isOwnMethodCall() and t = ma.getEnclosingCallable().getDeclaringType()
      or
      ma.isEnclosingMethodCall(t)
    )
  }

  /** Gets the implementation of `top` present on a value of precisely type `t`. */
  cached
  Method exactMethodImpl(VirtCalledSrcMethod top, SrcRefType t) {
    hasSrcMethod(t, result) and
    top.getAPossibleImplementationOfSrcMethod() = result
  }

  /** Gets the implementations of `top` present on viable subtypes of `t`. */
  cached
  Method viableMethodImpl(VirtCalledSrcMethod top, SrcRefType tsrc, RefType t) {
    exists(SrcRefType sub |
      result = exactMethodImpl(top, sub) and
      tsrc = t.getSourceDeclaration() and
      hasViableSubtype(t, sub)
    )
  }

  pragma[noinline]
  private predicate hasSrcMethod(SrcRefType t, Method impl) {
    exists(Method m | t.hasMethod(m, _, _) and impl = m.getSourceDeclaration())
  }

  private predicate isAbstractWithSubclass(SrcRefType t) {
    t.isAbstract() and exists(Class c | c.getASourceSupertype() = t)
  }

  private predicate hasViableSubtype(RefType t, SrcRefType sub) {
    sub.extendsOrImplements*(t) and
    not sub instanceof Interface and
    not isAbstractWithSubclass(sub)
  }
}

import Dispatch
