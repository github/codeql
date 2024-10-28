private import codeql.util.Location
private import codeql.util.Unit

/** Provides the input specification. */
signature module UniversalFlowInput<LocationSig Location> {
  /**
   * A node for which certain data flow properties may be proved. For example,
   * expressions and method declarations.
   */
  class TypeFlowNode {
    /** Gets a textual representation of this node. */
    string toString();

    /** Gets the location of this node. */
    Location getLocation();
  }

  /**
   * Holds if data can flow from `n1` to `n2` in one step.
   *
   * For a given `n2`, this predicate must include all possible `n1` that can flow to `n2`.
   */
  predicate step(TypeFlowNode n1, TypeFlowNode n2);

  /** Holds if `n` represents a `null` value. */
  predicate isNullValue(TypeFlowNode n);

  /**
   * Holds if `n` should be excluded from the set of null values even if
   * the null analysis determines that `n` is always null.
   */
  default predicate isExcludedFromNullAnalysis(TypeFlowNode n) { none() }
}

module UfMake<LocationSig Location, UniversalFlowInput<Location> I> {
  private import I

  /**
   * Holds if data can flow from `n1` to `n2` in one step, and `n1` is
   * functionally determined by `n2`.
   */
  private predicate uniqStep(TypeFlowNode n1, TypeFlowNode n2) { n1 = unique(TypeFlowNode n | step(n, n2)) }

  /**
   * Holds if data can flow from `n1` to `n2` in one step, and `n1` is not
   * functionally determined by `n2`.
   */
  private predicate joinStep(TypeFlowNode n1, TypeFlowNode n2) { step(n1, n2) and not uniqStep(n1, n2) }

  /** Holds if `null` is the only value that flows to `n`. */
  private predicate isNull(TypeFlowNode n) {
    isNullValue(n)
    or
    exists(TypeFlowNode mid | isNull(mid) and uniqStep(mid, n))
    or
    forex(TypeFlowNode mid | joinStep(mid, n) | isNull(mid)) and
    not isExcludedFromNullAnalysis(n)
  }

  /**
   * Holds if data can flow from `n1` to `n2` in one step, `n1` is not necessarily
   * functionally determined by `n2`, and `n1` might take a non-null value.
   */
  predicate joinStepNotNull(TypeFlowNode n1, TypeFlowNode n2) {
    joinStep(n1, n2) and not isNull(n1)
  }

  predicate anyStep(TypeFlowNode n1, TypeFlowNode n2) {
    joinStepNotNull(n1, n2) or uniqStep(n1, n2)
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

  signature module NullaryPropertySig {
    predicate hasPropertyBase(TypeFlowNode n);

    default predicate barrier(TypeFlowNode n) { none() }
  }

  module FlowNullary<NullaryPropertySig P> {
    private module Propagation implements TypePropagation {
      class Typ = Unit;

      predicate candType(TypeFlowNode n, Unit u) { hasProperty(n) and exists(u) }

      predicate supportsType = candType/2;
    }

    predicate hasProperty(TypeFlowNode n) {
      P::hasPropertyBase(n)
      or
      not P::barrier(n) and
      (
        exists(TypeFlowNode mid | hasProperty(mid) and uniqStep(mid, n))
        or
        // The following is an optimized version of
        // `forex(TypeFlowNode mid | joinStepNotNull(mid, n) | hasPropery(mid))`
        ForAll<TypeFlowNode, RankedJoinStep, Propagation>::flowJoin(n, _)
        or
        exists(TypeFlowScc scc |
          sccRepr(n, scc) and
          // Optimized version of
          // `forex(TypeFlowNode mid | sccJoinStepNotNull(mid, scc) | hasPropery(mid))`
          ForAll<TypeFlowScc, RankedSccJoinStep, Propagation>::flowJoin(scc, _)
        )
      )
    }
  }

  signature module PropertySig {
    class Prop;

    bindingset[t1, t2]
    default predicate propImplies(Prop t1, Prop t2) { t1 = t2 }

    predicate hasPropertyBase(TypeFlowNode n, Prop t);

    default predicate barrier(TypeFlowNode n) { none() }
  }

  module Flow<PropertySig P> {
    private module Propagation implements TypePropagation {
      class Typ = P::Prop;

      predicate candType = hasProperty/2;

      bindingset[t]
      predicate supportsType(TypeFlowNode n, Typ t) {
        exists(Typ t0 | hasProperty(n, t0) and P::propImplies(t0, t))
      }
    }

    /**
     * Holds if the runtime type of `n` is exactly `t` and if this bound is a
     * non-trivial lower bound, that is, `t` has a subtype.
     */
    predicate hasProperty(TypeFlowNode n, P::Prop t) {
      P::hasPropertyBase(n, t)
      or
      not P::barrier(n) and
      (
        exists(TypeFlowNode mid | hasProperty(mid, t) and uniqStep(mid, n))
        or
        // The following is an optimized version of
        // `forex(TypeFlowNode mid | joinStepNotNull(mid, n) | hasPropery(mid, t))`
        ForAll<TypeFlowNode, RankedJoinStep, Propagation>::flowJoin(n, t)
        or
        exists(TypeFlowScc scc |
          sccRepr(n, scc) and
          // Optimized version of
          // `forex(TypeFlowNode mid | sccJoinStepNotNull(mid, scc) | hasPropery(mid, t))`
          ForAll<TypeFlowScc, RankedSccJoinStep, Propagation>::flowJoin(scc, t)
        )
      )
    }
  }
}