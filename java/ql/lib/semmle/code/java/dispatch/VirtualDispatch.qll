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

/**
 * A conservative analysis that returns a single method - if we can establish
 * one - that will be the target of the virtual dispatch.
 */
Method exactVirtualMethod(MethodAccess c) {
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

private predicate implCount(MethodAccess m, int c) { strictcount(viableImpl(m)) = c }

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
    exists(VirtualMethodAccess ma | ma.getMethod().getSourceDeclaration() = this)
  }
}

cached
private module Dispatch {
  /** Gets a viable implementation of the method called in the given method access. */
  cached
  Method viableImpl(MethodAccess ma) { result = ObjFlow::viableImpl_out(ma) }

  /**
   * INTERNAL: Use `viableImpl` instead.
   *
   * Gets a viable implementation of the method called in the given method access.
   */
  cached
  Method viableImpl_v3(MethodAccess ma) { result = DispatchFlow::viableImpl_out(ma) }

  private predicate qualType(VirtualMethodAccess ma, RefType t, boolean exact) {
    exprTypeFlow(ma.getQualifier(), t, exact)
  }

  /**
   * INTERNAL: Use `viableImpl` instead.
   *
   * Gets a viable implementation of the method called in the given method access.
   */
  cached
  Method viableImpl_v2(MethodAccess ma) {
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
          not Unification_v2::failsUnification(t, t2)
        )
      )
      or
      not qualType(ma, _, _)
    )
  }

  private module Unification_v2 {
    pragma[noinline]
    private predicate unificationTargetLeft(ParameterizedType t1, GenericType g) {
      qualType(_, t1, _) and t1.getGenericType() = g
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

    predicate failsUnification(Type t1, Type t2) {
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
  }

  /**
   * INTERNAL: Use `viableImpl` instead.
   *
   * Gets a viable implementation of the method called in the given method access.
   */
  cached
  Method viableImpl_v1(MethodAccess source) {
    result = viableImpl_v1_cand(source) and
    not impossibleDispatchTarget(source, result)
  }

  /**
   * Holds if `source` cannot dispatch to `tgt` due to a negative `instanceof` guard.
   */
  private predicate impossibleDispatchTarget(MethodAccess source, Method tgt) {
    tgt = viableImpl_v1_cand(source) and
    exists(InstanceOfExpr ioe, BaseSsaVariable v, Expr q, RefType t |
      source.getQualifier() = q and
      v.getAUse() = q and
      guardControls_v1(ioe, q.getBasicBlock(), false) and
      ioe.getExpr() = v.getAUse() and
      ioe.getCheckedType().getErasure() = t and
      tgt.getDeclaringType().getSourceDeclaration().getASourceSupertype*() = t
    )
  }

  /**
   * Gets a viable implementation of the method called in the given method access.
   */
  private Method viableImpl_v1_cand(MethodAccess source) {
    not result.isAbstract() and
    if source instanceof VirtualMethodAccess
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

  private module Unification_v1 {
    pragma[noinline]
    private predicate unificationTargetLeft(ParameterizedType t1, GenericType g) {
      hasQualifierType(_, t1, _) and t1.getGenericType() = g
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

    predicate failsUnification(Type t1, Type t2) {
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
  }

  private RefType getPreciseType(Expr e) {
    result = e.(FunctionalExpr).getConstructedType()
    or
    not e instanceof FunctionalExpr and result = e.getType()
  }

  private predicate hasQualifierType(VirtualMethodAccess ma, RefType t, boolean exact) {
    exists(Expr src | src = variableTrack(ma.getQualifier()) |
      // If we have a qualifier, then we track it through variable assignments
      // and take the type of the assigned value.
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
      ma.isOwnMethodAccess() and t = ma.getEnclosingCallable().getDeclaringType()
      or
      ma.isEnclosingMethodAccess(t)
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

  private predicate hasViableSubtype(RefType t, SrcRefType sub) {
    sub.extendsOrImplements*(t) and
    not sub instanceof Interface and
    not sub.isAbstract()
  }
}

import Dispatch

private Expr variableTrackStep(Expr use) {
  exists(Variable v |
    pragma[only_bind_out](use) = v.getAnAccess() and
    use.getType() instanceof RefType and
    not result instanceof NullLiteral and
    not v.(LocalVariableDecl).getDeclExpr().hasImplicitInit()
  |
    not v instanceof Parameter and
    result = v.getAnAssignedValue()
    or
    exists(Parameter p | p = v and p.getCallable().isPrivate() |
      result = p.getAnAssignedValue() or
      result = p.getAnArgument()
    )
  )
}

private Expr variableTrackPath(Expr use) {
  result = variableTrackStep*(use) and
  not exists(variableTrackStep(result))
}

/**
 * Gets an expression by tracking `use` backwards through variable assignments.
 */
pragma[inline]
Expr variableTrack(Expr use) {
  result = variableTrackPath(use)
  or
  not exists(variableTrackPath(use)) and result = use
}
