/**
 * Provides a module to check whether two `ParameterizedType`s are unifiable.
 */

import java

/** Holds if `t` is a relevant type to consider for unification. */
signature predicate unificationTarget(ParameterizedType t);

/**
 * Given two sets of parameterised types to consider for unification, returns
 * the set of pairs that are not unifiable.
 */
module MkUnification<unificationTarget/1 targetLeft, unificationTarget/1 targetRight> {
  pragma[noinline]
  private predicate unificationTargetLeft(ParameterizedType t1, GenericType g) {
    targetLeft(t1) and t1.getGenericType() = g
  }

  pragma[noinline]
  private predicate unificationTargetRight(ParameterizedType t2, GenericType g) {
    targetRight(t2) and t2.getGenericType() = g
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

  /**
   * Holds if `t1` and `t2` are not unifiable.
   *
   * Restricted to only consider pairs of types such that `targetLeft(t1)`,
   * `targetRight(t2)`, and that both are parameterised instances of the same
   * generic type.
   */
  pragma[nomagic]
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
      exists(RefType upperbound, RefType other |
        t1.(BoundedType).getAnUltimateUpperBoundType().getSourceDeclaration() = upperbound and
        t2.(RefType).getSourceDeclaration() = other and
        not t2 instanceof BoundedType
        or
        t2.(BoundedType).getAnUltimateUpperBoundType().getSourceDeclaration() = upperbound and
        t1.(RefType).getSourceDeclaration() = other and
        not t1 instanceof BoundedType
      |
        not other.getASourceSupertype*() = upperbound
      )
      or
      exists(RefType upperbound1, RefType upperbound2 |
        t1.(BoundedType).getAnUltimateUpperBoundType() = upperbound1 and
        t2.(BoundedType).getAnUltimateUpperBoundType() = upperbound2 and
        notHaveIntersection(upperbound1, upperbound2)
      )
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
