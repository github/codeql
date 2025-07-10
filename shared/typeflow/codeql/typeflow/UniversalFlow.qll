/**
 * Provides predicates for proving data flow properties that hold for all
 * paths, that is, reachability is computed using universal quantification over
 * the step relation.
 *
 * Regular data flow search for the existence of a path, that is, reachability
 * using existential quantification over the step relation. Hence, this library
 * computes the dual reachability predicate that states that a certain property
 * always holds for a given node regardless of the path taken.
 *
 * As a simple comparison, the computed predicate is essentially equivalent to
 * the folllowing:
 * ```ql
 *   predicate hasProperty(FlowNode n, Prop t) {
 *     basecase(n, t)
 *     or
 *     forex(FlowNode mid | step(mid, n) | hasProperty(mid, t))
 *   }
 * ```
 * More complex property propagation is supported, and strongly connected
 * components in the flow graph are handled.
 *
 * As an initial such property calculation, the library computes the set of
 * nodes that are always null. These are then subtracted from the graph such
 * that subsequently calculated properties hold under the assumption that the
 * value is not null.
 */

private import codeql.util.Location
private import codeql.util.Unit

/** Provides the input specification. */
signature module UniversalFlowInput<LocationSig Location> {
  /**
   * A node for which certain data flow properties may be proved. For example,
   * expressions and method declarations.
   */
  class FlowNode {
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
  predicate step(FlowNode n1, FlowNode n2);

  /** Holds if `n` represents a `null` value. */
  predicate isNullValue(FlowNode n);

  /**
   * Holds if `n` should be excluded from the set of null values even if
   * the null analysis determines that `n` is always null.
   */
  default predicate isExcludedFromNullAnalysis(FlowNode n) { none() }
}

/**
 * Provides an implementation of universal flow using input `I`.
 */
module Make<LocationSig Location, UniversalFlowInput<Location> I> {
  private import I

  /**
   * Holds if data can flow from `n1` to `n2` in one step, and `n1` is
   * functionally determined by `n2`.
   */
  private predicate uniqStep(FlowNode n1, FlowNode n2) { n1 = unique(FlowNode n | step(n, n2)) }

  /**
   * Holds if data can flow from `n1` to `n2` in one step, and `n1` is not
   * functionally determined by `n2`.
   */
  private predicate joinStep(FlowNode n1, FlowNode n2) { step(n1, n2) and not uniqStep(n1, n2) }

  /** Holds if `null` is the only value that flows to `n`. */
  private predicate isNull(FlowNode n) {
    isNullValue(n)
    or
    not isExcludedFromNullAnalysis(n) and
    (
      exists(FlowNode mid | isNull(mid) and uniqStep(mid, n))
      or
      forex(FlowNode mid | joinStep(mid, n) | isNull(mid))
    )
  }

  private predicate uniqStepNotNull(FlowNode n1, FlowNode n2) {
    uniqStep(n1, n2) and not isNull(n1)
  }

  private import Internal

  /** Provides access to internal step relations. */
  module Internal {
    /**
     * Holds if data can flow from `n1` to `n2` in one step, `n1` is not necessarily
     * functionally determined by `n2`, and `n1` might take a non-null value.
     */
    predicate joinStepNotNull(FlowNode n1, FlowNode n2) { joinStep(n1, n2) and not isNull(n1) }

    /**
     * Holds if data can flow from `n1` to `n2` in one step, excluding join
     * steps from nodes that are always null.
     */
    predicate anyStep(FlowNode n1, FlowNode n2) {
      joinStepNotNull(n1, n2) or uniqStepNotNull(n1, n2)
    }
  }

  private predicate sccEdge(FlowNode n1, FlowNode n2) { anyStep(n1, n2) and anyStep+(n2, n1) }

  private module Scc = QlBuiltins::EquivalenceRelation<FlowNode, sccEdge/2>;

  private class FlowScc = Scc::EquivalenceClass;

  /** Holds if `n` is part of an SCC of size 2 or more represented by `scc`. */
  private predicate sccRepr(FlowNode n, FlowScc scc) { scc = Scc::getEquivalenceClass(n) }

  private predicate sccJoinStepNotNull(FlowNode n, FlowScc scc) {
    exists(FlowNode mid |
      joinStepNotNull(n, mid) and
      sccRepr(mid, scc) and
      not sccRepr(n, scc)
    )
  }

  private signature class NodeSig;

  private signature module Edge {
    class Node;

    predicate edge(FlowNode n1, Node n2);
  }

  private signature module RankedEdge<NodeSig Node> {
    predicate edgeRank(int r, FlowNode n1, Node n2);

    int lastRank(Node n);
  }

  private module RankEdge<Edge E> implements RankedEdge<E::Node> {
    private import E

    /**
     * Holds if `r` is a ranking of the incoming edges `(n1,n2)` to `n2`. The used
     * ordering is not necessarily total, so the ranking may have gaps.
     */
    private predicate edgeRank1(int r, FlowNode n1, Node n2) {
      n1 =
        rank[r](FlowNode n, int startline, int startcolumn |
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
    predicate edgeRank(int r, FlowNode n1, Node n2) {
      exists(int r1 |
        edgeRank1(r1, n1, n2) and
        edgeRank2(r, r1, n2)
      )
    }

    int lastRank(Node n) { result = max(int r | edgeRank(r, _, n)) }
  }

  private signature module PropPropagation {
    class Prop;

    predicate candProp(FlowNode n, Prop t);

    bindingset[t]
    predicate supportsProp(FlowNode n, Prop t);
  }

  /** Implements recursion through `forall` by way of edge ranking. */
  private module ForAll<NodeSig Node, RankedEdge<Node> E, PropPropagation T> {
    /**
     * Holds if `t` is a property that holds on one of the incoming edges to `n` and
     * thus is a candidate property for `n`.
     */
    pragma[nomagic]
    private predicate candJoinProp(Node n, T::Prop t) {
      exists(FlowNode mid |
        T::candProp(mid, t) and
        E::edgeRank(_, mid, n)
      )
    }

    /**
     * Holds if `t` is a candidate property for `n` that is also valid for data coming
     * through the edges into `n` ranked from `1` to `r`.
     */
    private predicate flowJoin(int r, Node n, T::Prop t) {
      (
        r = 1 and candJoinProp(n, t)
        or
        flowJoin(r - 1, n, t) and E::edgeRank(r, _, n)
      ) and
      forall(FlowNode mid | E::edgeRank(r, mid, n) | T::supportsProp(mid, t))
    }

    /**
     * Holds if `t` is a candidate property for `n` that is also valid for data
     * coming through all the incoming edges, and therefore is a valid property for
     * `n`.
     */
    predicate flowJoin(Node n, T::Prop t) { flowJoin(E::lastRank(n), n, t) }
  }

  private module JoinStep implements Edge {
    class Node = FlowNode;

    predicate edge = joinStepNotNull/2;
  }

  private module SccJoinStep implements Edge {
    class Node = FlowScc;

    predicate edge = sccJoinStepNotNull/2;
  }

  private module RankedJoinStep = RankEdge<JoinStep>;

  private module RankedSccJoinStep = RankEdge<SccJoinStep>;

  signature module NullaryPropertySig {
    predicate hasPropertyBase(FlowNode n);

    default predicate barrier(FlowNode n) { none() }
  }

  /**
   * Calculates a (nullary) property using universal flow given a base case
   * relation.
   */
  module FlowNullary<NullaryPropertySig P> {
    private module Propagation implements PropPropagation {
      class Prop = Unit;

      predicate candProp(FlowNode n, Unit u) { hasProperty(n) and exists(u) }

      predicate supportsProp = candProp/2;
    }

    /**
     * Holds if all flow reaching `n` originates from nodes in
     * `hasPropertyBase`.
     */
    predicate hasProperty(FlowNode n) {
      P::hasPropertyBase(n)
      or
      not P::barrier(n) and
      (
        exists(FlowNode mid | hasProperty(mid) and uniqStepNotNull(mid, n))
        or
        // The following is an optimized version of
        // `forex(FlowNode mid | joinStepNotNull(mid, n) | hasPropery(mid))`
        ForAll<FlowNode, RankedJoinStep, Propagation>::flowJoin(n, _)
        or
        exists(FlowScc scc |
          sccRepr(n, scc) and
          // Optimized version of
          // `forex(FlowNode mid | sccJoinStepNotNull(mid, scc) | hasPropery(mid))`
          ForAll<FlowScc, RankedSccJoinStep, Propagation>::flowJoin(scc, _)
        )
      )
    }
  }

  signature module PropertySig {
    class Prop;

    bindingset[t1, t2]
    default predicate propImplies(Prop t1, Prop t2) { t1 = t2 }

    predicate hasPropertyBase(FlowNode n, Prop t);

    default predicate barrier(FlowNode n) { none() }
  }

  /**
   * Calculates a unary property using universal flow given a base case
   * relation.
   */
  module Flow<PropertySig P> {
    private module Propagation implements PropPropagation {
      class Prop = P::Prop;

      predicate candProp = hasProperty/2;

      bindingset[t]
      predicate supportsProp(FlowNode n, Prop t) {
        exists(Prop t0 | hasProperty(n, t0) and P::propImplies(t0, t))
      }
    }

    /**
     * Holds if all flow reaching `n` originates from nodes in
     * `hasPropertyBase`. The property `t` is taken from one of those origins
     * such that all other origins imply `t`.
     */
    predicate hasProperty(FlowNode n, P::Prop t) {
      P::hasPropertyBase(n, t)
      or
      not P::barrier(n) and
      (
        exists(FlowNode mid | hasProperty(mid, t) and uniqStepNotNull(mid, n))
        or
        // The following is an optimized version of
        // ```
        // exists(FlowNode mid | joinStepNotNull(mid, n) | hasPropery(mid, t)) and
        // forall(FlowNode mid | joinStepNotNull(mid, n) | hasPropery(mid, _)) and
        // forall(FlowNode mid, P::Prop t0 | joinStepNotNull(mid, n) and hasPropery(mid, t0) |
        //   P::propImplies(t0, t)
        // )
        // ```
        ForAll<FlowNode, RankedJoinStep, Propagation>::flowJoin(n, t)
        or
        exists(FlowScc scc |
          sccRepr(n, scc) and
          // Optimized version of
          // ```
          // exists(FlowNode mid | sccJoinStepNotNull(mid, n) | hasPropery(mid, t)) and
          // forall(FlowNode mid | sccJoinStepNotNull(mid, n) | hasPropery(mid, _)) and
          // forall(FlowNode mid, P::Prop t0 | sccJoinStepNotNull(mid, n) and hasPropery(mid, t0) |
          //   P::propImplies(t0, t)
          // )
          // ```
          ForAll<FlowScc, RankedSccJoinStep, Propagation>::flowJoin(scc, t)
        )
      )
    }
  }
}
