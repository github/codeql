private import codeql.typeflow.TypeFlow
private import codeql.typeflow.UniversalFlow as UniversalFlow
private import codeql.util.Location
private import codeql.util.Unit

module TypeFlow<LocationSig Location, TypeFlowInput<Location> I> {
  private import I

  private module UfInput implements UniversalFlow::UniversalFlowInput<Location> {
    class FlowNode = TypeFlowNode;

    predicate step = I::step/2;

    predicate isNullValue = I::isNullValue/1;

    predicate isExcludedFromNullAnalysis = I::isExcludedFromNullAnalysis/1;
  }

  private module UnivFlow = UniversalFlow::Make<Location, UfInput>;

  private module ExactTypeProperty implements UnivFlow::PropertySig {
    class Prop = Type;

    predicate hasPropertyBase = exactTypeBase/2;
  }

  /**
   * Holds if the runtime type of `n` is exactly `t` and if this bound is a
   * non-trivial lower bound, that is, `t` has a subtype.
   */
  private predicate exactType = UnivFlow::Flow<ExactTypeProperty>::hasProperty/2;

  /**
   * Gets the source declaration of a direct supertype of this type, excluding itself.
   */
  pragma[nomagic]
  private Type getASourceSupertype(Type t) {
    result = getSourceDeclaration(t.getASupertype()) and
    result != t
  }

  /**
   * Holds if `n` has type `t` and this information is discarded, such that `t`
   * might be a better type bound for nodes where `n` flows to. This only includes
   * the best such bound for each node.
   */
  private predicate typeFlowBase(TypeFlowNode n, Type t) {
    exists(Type te |
      typeFlowBaseCand(n, t) and
      te = getErasure(t) and
      not exists(Type better |
        typeFlowBaseCand(n, better) and
        better != t and
        not t.getASupertype+() = better
      |
        better.getASupertype+() = t or
        getASourceSupertype+(getErasure(better)) = te
      )
    )
  }

  private module TypeFlowProperty implements UnivFlow::PropertySig {
    class Prop = Type;

    bindingset[t1, t2]
    predicate propImplies(Type t1, Type t2) { getAnAncestor(pragma[only_bind_out](t1)) = t2 }

    predicate hasPropertyBase(TypeFlowNode n, Prop t) { typeFlowBase(n, t) or exactType(n, t) }
  }

  /**
   * Holds if the runtime type of `n` is bounded by `t` and if this bound is
   * likely to be better than the static type of `n`.
   */
  private predicate typeFlow(TypeFlowNode n, Type t) {
    UnivFlow::Flow<TypeFlowProperty>::hasProperty(n, t) and
    not exactType(n, t)
  }

  pragma[nomagic]
  private predicate erasedTypeBound(Type t) {
    exists(Type t0 | typeFlow(_, t0) and t = getErasure(t0))
  }

  pragma[nomagic]
  private predicate typeBound(Type t) { typeFlow(_, t) }

  /**
   * Gets a direct or indirect supertype of this type.
   * This does not include itself, unless this type is part of a cycle
   * in the type hierarchy.
   */
  private Type getAStrictAncestor(Type sub) { result = getAnAncestor(sub.getASupertype()) }

  /**
   * Holds if we have a bound for `n` that is better than `t`.
   */
  pragma[nomagic]
  private predicate irrelevantBound(TypeFlowNode n, Type t) {
    exists(Type bound |
      typeFlow(n, bound) and
      t = getAStrictAncestor(bound) and
      typeBound(t) and
      typeFlow(n, pragma[only_bind_into](t)) and
      not getAnAncestor(t) = bound
      or
      n.getType() = pragma[only_bind_into](bound) and
      typeFlow(n, t) and
      t = getAnAncestor(bound)
    )
  }

  /**
   * Holds if we have a bound for `n` that is better than `t`, taking only erased
   * types into account.
   */
  pragma[nomagic]
  private predicate irrelevantErasedBound(TypeFlowNode n, Type t) {
    exists(Type bound |
      typeFlow(n, bound)
      or
      n.getType() = bound and typeFlow(n, _)
    |
      t = getASourceSupertype+(getErasure(bound)) and
      erasedTypeBound(t)
    )
  }

  /**
   * Holds if the runtime type of `n` is bounded by `t`, if this bound is likely
   * to be better than the static type of `n`, and if this the best such bound.
   */
  private predicate bestTypeFlow(TypeFlowNode n, Type t) {
    typeFlow(n, t) and
    not irrelevantErasedBound(n, getErasure(t)) and
    not irrelevantBound(n, t)
  }

  /**
   * Holds if the runtime type of `n` is bounded by `t` and if this bound is
   * likely to be better than the static type of `n`. The flag `exact` indicates
   * whether `t` is an exact bound or merely an upper bound.
   */
  predicate bestTypeFlow(TypeFlowNode n, Type t, boolean exact) {
    exactType(n, t) and exact = true
    or
    not exactType(n, _) and bestTypeFlow(n, t) and exact = false
  }

  private predicate bestTypeFlowOrTypeFlowBase(TypeFlowNode n, Type t, boolean exact) {
    bestTypeFlow(n, t, exact)
    or
    typeFlowBase(n, t) and
    exact = false and
    not bestTypeFlow(n, _, _)
  }

  /**
   * Holds if `n` has type `t` and this information is not propagated as a
   * universal bound to a subsequent node, such that `t` might form the basis for
   * a union type bound for that node.
   */
  private predicate unionTypeFlowBaseCand(TypeFlowNode n, Type t, boolean exact) {
    exists(TypeFlowNode next |
      UnivFlow::Internal::joinStepNotNull(n, next) and
      bestTypeFlowOrTypeFlowBase(n, t, exact) and
      not bestTypeFlowOrTypeFlowBase(next, t, exact) and
      not exactType(next, _)
    )
  }

  module UnionTypeFlowProperty implements UnivFlow::NullaryPropertySig {
    predicate hasPropertyBase(TypeFlowNode n) {
      unionTypeFlowBaseCand(n, _, _) or
      instanceofDisjunctionGuarded(n, _)
    }

    predicate barrier(TypeFlowNode n) { exactType(n, _) }
  }

  /**
   * Holds if all incoming type flow can be traced back to a
   * `unionTypeFlowBaseCand`, such that we can compute a union type bound for `n`.
   * Disregards nodes for which we have an exact bound.
   */
  private predicate hasUnionTypeFlow = UnivFlow::FlowNullary<UnionTypeFlowProperty>::hasProperty/1;

  pragma[nomagic]
  private Type getTypeBound(TypeFlowNode n) {
    bestTypeFlow(n, result)
    or
    not bestTypeFlow(n, _) and result = n.getType()
  }

  pragma[nomagic]
  private predicate unionTypeFlow0(TypeFlowNode n, Type t, boolean exact) {
    hasUnionTypeFlow(n) and
    (
      exists(TypeFlowNode mid | UnivFlow::Internal::anyStep(mid, n) | unionTypeFlow(mid, t, exact))
      or
      unionTypeFlowBaseCand(n, t, exact)
      or
      instanceofDisjunctionGuarded(n, t) and exact = false
    )
  }

  /** Holds if this type is the same as its source declaration. */
  private predicate isSourceDeclaration(Type t) { getSourceDeclaration(t) = t }

  final private class FinalType = Type;

  /** A type that is the same as its source declaration. */
  private class SrcType extends FinalType {
    SrcType() { isSourceDeclaration(this) }
  }

  /**
   * Holds if there is a common (reflexive, transitive) subtype of the erased
   * types `t1` and `t2`.
   */
  pragma[nomagic]
  private predicate erasedHaveIntersection(Type t1, Type t2) {
    exists(SrcType commonSub |
      getASourceSupertype*(commonSub) = t1 and getASourceSupertype*(commonSub) = t2
    ) and
    t1 = getErasure(_) and
    t2 = getErasure(_)
  }

  /** Holds if we have a union type bound for `n` and `t` is one of its parts. */
  private predicate unionTypeFlow(TypeFlowNode n, Type t, boolean exact) {
    unionTypeFlow0(n, t, exact) and
    // filter impossible union parts:
    exists(Type tErased, Type boundErased |
      pragma[only_bind_into](tErased) = getErasure(t) and
      pragma[only_bind_into](boundErased) = getErasure(getTypeBound(n))
    |
      if exact = true
      then getASourceSupertype*(tErased) = boundErased
      else erasedHaveIntersection(tErased, boundErased)
    )
  }

  /**
   * Holds if the inferred union type bound for `n` contains the best universal
   * bound and thus is irrelevant.
   */
  private predicate irrelevantUnionType(TypeFlowNode n) {
    exists(Type t, Type nt, Type te, Type nte |
      unionTypeFlow(n, t, false) and
      nt = getTypeBound(n) and
      te = getErasure(t) and
      nte = getErasure(nt)
    |
      nt.getASupertype*() = t
      or
      getASourceSupertype+(nte) = te
      or
      nte = te and unbound(t)
    )
  }

  /**
   * Holds if `t` is an irrelevant part of the union type bound for `n` due to
   * being contained in another part of the union type bound.
   */
  private predicate irrelevantUnionTypePart(TypeFlowNode n, Type t, boolean exact) {
    unionTypeFlow(n, t, exact) and
    not irrelevantUnionType(n) and
    exists(Type weaker |
      unionTypeFlow(n, weaker, false) and
      t.getASupertype*() = weaker
    |
      exact = true or not weaker.getASupertype*() = t
    )
  }

  /**
   * Holds if the runtime type of `n` is bounded by a union type and if this
   * bound is likely to be better than the static type of `n`. The union type is
   * made up of the types `t` related to `n` by this predicate, and the flag
   * `exact` indicates whether `t` is an exact bound or merely an upper bound.
   */
  predicate bestUnionType(TypeFlowNode n, Type t, boolean exact) {
    unionTypeFlow(n, t, exact) and
    not exactType(n, _) and
    not irrelevantUnionType(n) and
    not irrelevantUnionTypePart(n, t, exact)
  }
}
