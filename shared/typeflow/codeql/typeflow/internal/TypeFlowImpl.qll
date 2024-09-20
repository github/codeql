private import codeql.typeflow.TypeFlow
private import codeql.util.Location
private import codeql.util.Unit

module TypeFlow<LocationSig Location, TypeFlowInput<Location> I> {
  private import I

  /** Holds if `null` is the only value that flows to `n`. */
  predicate isNull(TypeFlowNode n) {
    isNullValue(n)
    or
    exists(TypeFlowNode mid | isNull(mid) and step(mid, n))
    or
    forex(TypeFlowNode mid | joinStep(mid, n) | isNull(mid)) and
    not isExcludedFromNullAnalysis(n)
  }

  /**
   * Holds if data can flow from `n1` to `n2` in one step, `n1` is not necessarily
   * functionally determined by `n2`, and `n1` might take a non-null value.
   */
  private predicate joinStepNotNull(TypeFlowNode n1, TypeFlowNode n2) {
    joinStep(n1, n2) and not isNull(n1)
  }

  private predicate anyStep(TypeFlowNode n1, TypeFlowNode n2) {
    joinStepNotNull(n1, n2) or step(n1, n2)
  }

  private predicate sccEdge(TypeFlowNode n1, TypeFlowNode n2) {
    anyStep(n1, n2) and anyStep+(n2, n1)
  }

  private module Scc = QlBuiltins::EquivalenceRelation<TypeFlowNode, sccEdge/2>;

  private class TypeFlowScc = Scc::EquivalenceClass;

  /** Holds if `n` is part of an SCC of size 2 or more represented by `scc`. */
  private predicate sccRepr(TypeFlowNode n, TypeFlowScc scc) { scc = Scc::getEquivalenceClass(n) }

  private predicate sccJoinStepNotNull(TypeFlowNode n, TypeFlowScc scc) {
    exists(TypeFlowNode mid |
      joinStepNotNull(n, mid) and
      sccRepr(mid, scc) and
      not sccRepr(n, scc)
    )
  }

  private signature class NodeSig;

  private signature module Edge {
    class Node;

    predicate edge(TypeFlowNode n1, Node n2);
  }

  private signature module RankedEdge<NodeSig Node> {
    predicate edgeRank(int r, TypeFlowNode n1, Node n2);

    int lastRank(Node n);
  }

  private module RankEdge<Edge E> implements RankedEdge<E::Node> {
    private import E

    /**
     * Holds if `r` is a ranking of the incoming edges `(n1,n2)` to `n2`. The used
     * ordering is not necessarily total, so the ranking may have gaps.
     */
    private predicate edgeRank1(int r, TypeFlowNode n1, Node n2) {
      n1 =
        rank[r](TypeFlowNode n, int startline, int startcolumn |
          edge(n, n2) and
          n.getLocation().hasLocationInfo(_, startline, startcolumn, _, _)
        |
          n order by startline, startcolumn
        )
    }

    /**
     * Holds if `r2` is a ranking of the ranks from `edgeRank1`. This removes the
     * gaps from the ranking.
     */
    private predicate edgeRank2(int r2, int r1, Node n) {
      r1 = rank[r2](int r | edgeRank1(r, _, n) | r)
    }

    /** Holds if `r` is a ranking of the incoming edges `(n1,n2)` to `n2`. */
    predicate edgeRank(int r, TypeFlowNode n1, Node n2) {
      exists(int r1 |
        edgeRank1(r1, n1, n2) and
        edgeRank2(r, r1, n2)
      )
    }

    int lastRank(Node n) { result = max(int r | edgeRank(r, _, n)) }
  }

  private signature module TypePropagation {
    class Typ;

    predicate candType(TypeFlowNode n, Typ t);

    bindingset[t]
    predicate supportsType(TypeFlowNode n, Typ t);
  }

  /** Implements recursion through `forall` by way of edge ranking. */
  private module ForAll<NodeSig Node, RankedEdge<Node> E, TypePropagation T> {
    /**
     * Holds if `t` is a bound that holds on one of the incoming edges to `n` and
     * thus is a candidate bound for `n`.
     */
    pragma[nomagic]
    private predicate candJoinType(Node n, T::Typ t) {
      exists(TypeFlowNode mid |
        T::candType(mid, t) and
        E::edgeRank(_, mid, n)
      )
    }

    /**
     * Holds if `t` is a candidate bound for `n` that is also valid for data coming
     * through the edges into `n` ranked from `1` to `r`.
     */
    private predicate flowJoin(int r, Node n, T::Typ t) {
      (
        r = 1 and candJoinType(n, t)
        or
        flowJoin(r - 1, n, t) and E::edgeRank(r, _, n)
      ) and
      forall(TypeFlowNode mid | E::edgeRank(r, mid, n) | T::supportsType(mid, t))
    }

    /**
     * Holds if `t` is a candidate bound for `n` that is also valid for data
     * coming through all the incoming edges, and therefore is a valid bound for
     * `n`.
     */
    predicate flowJoin(Node n, T::Typ t) { flowJoin(E::lastRank(n), n, t) }
  }

  private module JoinStep implements Edge {
    class Node = TypeFlowNode;

    predicate edge = joinStepNotNull/2;
  }

  private module SccJoinStep implements Edge {
    class Node = TypeFlowScc;

    predicate edge = sccJoinStepNotNull/2;
  }

  private module RankedJoinStep = RankEdge<JoinStep>;

  private module RankedSccJoinStep = RankEdge<SccJoinStep>;

  private module ExactTypePropagation implements TypePropagation {
    class Typ = Type;

    predicate candType = exactType/2;

    predicate supportsType = exactType/2;
  }

  /**
   * Holds if the runtime type of `n` is exactly `t` and if this bound is a
   * non-trivial lower bound, that is, `t` has a subtype.
   */
  private predicate exactType(TypeFlowNode n, Type t) {
    exactTypeBase(n, t)
    or
    exists(TypeFlowNode mid | exactType(mid, t) and step(mid, n))
    or
    // The following is an optimized version of
    // `forex(TypeFlowNode mid | joinStepNotNull(mid, n) | exactType(mid, t))`
    ForAll<TypeFlowNode, RankedJoinStep, ExactTypePropagation>::flowJoin(n, t)
    or
    exists(TypeFlowScc scc |
      sccRepr(n, scc) and
      // Optimized version of
      // `forex(TypeFlowNode mid | sccJoinStepNotNull(mid, scc) | exactType(mid, t))`
      ForAll<TypeFlowScc, RankedSccJoinStep, ExactTypePropagation>::flowJoin(scc, t)
    )
  }

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

  private module TypeFlowPropagation implements TypePropagation {
    class Typ = Type;

    predicate candType = typeFlow/2;

    bindingset[t]
    predicate supportsType(TypeFlowNode mid, Type t) {
      exists(Type midtyp | exactType(mid, midtyp) or typeFlow(mid, midtyp) |
        getAnAncestor(pragma[only_bind_out](midtyp)) = t
      )
    }
  }

  /**
   * Holds if the runtime type of `n` is bounded by `t` and if this bound is
   * likely to be better than the static type of `n`.
   */
  private predicate typeFlow(TypeFlowNode n, Type t) {
    typeFlowBase(n, t)
    or
    exists(TypeFlowNode mid | typeFlow(mid, t) and step(mid, n))
    or
    ForAll<TypeFlowNode, RankedJoinStep, TypeFlowPropagation>::flowJoin(n, t)
    or
    exists(TypeFlowScc scc |
      sccRepr(n, scc) and
      ForAll<TypeFlowScc, RankedSccJoinStep, TypeFlowPropagation>::flowJoin(scc, t)
    )
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
      joinStepNotNull(n, next) and
      bestTypeFlowOrTypeFlowBase(n, t, exact) and
      not bestTypeFlowOrTypeFlowBase(next, t, exact) and
      not exactType(next, _)
    )
  }

  private module HasUnionTypePropagation implements TypePropagation {
    class Typ = Unit;

    predicate candType(TypeFlowNode mid, Unit unit) {
      exists(unit) and
      (unionTypeFlowBaseCand(mid, _, _) or hasUnionTypeFlow(mid))
    }

    predicate supportsType = candType/2;
  }

  /**
   * Holds if all incoming type flow can be traced back to a
   * `unionTypeFlowBaseCand`, such that we can compute a union type bound for `n`.
   * Disregards nodes for which we have an exact bound.
   */
  private predicate hasUnionTypeFlow(TypeFlowNode n) {
    not exactType(n, _) and
    (
      // Optimized version of
      // `forex(TypeFlowNode mid | joinStepNotNull(mid, n) | unionTypeFlowBaseCand(mid, _, _) or hasUnionTypeFlow(mid))`
      ForAll<TypeFlowNode, RankedJoinStep, HasUnionTypePropagation>::flowJoin(n, _)
      or
      exists(TypeFlowScc scc |
        sccRepr(n, scc) and
        // Optimized version of
        // `forex(TypeFlowNode mid | sccJoinStep(mid, scc) | unionTypeFlowBaseCand(mid, _, _) or hasUnionTypeFlow(mid))`
        ForAll<TypeFlowScc, RankedSccJoinStep, HasUnionTypePropagation>::flowJoin(scc, _)
      )
      or
      exists(TypeFlowNode mid | step(mid, n) and hasUnionTypeFlow(mid))
      or
      instanceofDisjunctionGuarded(n, _)
    )
  }

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
      exists(TypeFlowNode mid | anyStep(mid, n) |
        unionTypeFlowBaseCand(mid, t, exact) or unionTypeFlow(mid, t, exact)
      )
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
    not irrelevantUnionType(n) and
    not irrelevantUnionTypePart(n, t, exact)
  }
}
