/**
 * Provides predicates for giving improved type bounds on expressions.
 *
 * An inferred bound on the runtime type of an expression can be either exact
 * or merely an upper bound. Bounds are only reported if they are likely to be
 * better than the static bound, which can happen either if an inferred exact
 * type has a subtype or if an inferred upper bound passed through at least one
 * explicit or implicit cast that lost type information.
 */

import java
private import semmle.code.java.dispatch.VirtualDispatch
private import semmle.code.java.dataflow.internal.BaseSSA
private import semmle.code.java.controlflow.Guards

private newtype TTypeFlowNode =
  TField(Field f) { not f.getType() instanceof PrimitiveType } or
  TSsa(BaseSsaVariable ssa) { not ssa.getSourceVariable().getType() instanceof PrimitiveType } or
  TExpr(Expr e) or
  TMethod(Method m) { not m.getReturnType() instanceof PrimitiveType }

/**
 * A `Field`, `BaseSsaVariable`, `Expr`, or `Method`.
 */
private class TypeFlowNode extends TTypeFlowNode {
  string toString() {
    result = asField().toString() or
    result = asSsa().toString() or
    result = asExpr().toString() or
    result = asMethod().toString()
  }

  Location getLocation() {
    result = asField().getLocation() or
    result = asSsa().getLocation() or
    result = asExpr().getLocation() or
    result = asMethod().getLocation()
  }

  Field asField() { this = TField(result) }

  BaseSsaVariable asSsa() { this = TSsa(result) }

  Expr asExpr() { this = TExpr(result) }

  Method asMethod() { this = TMethod(result) }

  RefType getType() {
    result = asField().getType() or
    result = asSsa().getSourceVariable().getType() or
    result = boxIfNeeded(asExpr().getType()) or
    result = asMethod().getReturnType()
  }
}

/** Gets `t` if it is a `RefType` or the boxed type if `t` is a primitive type. */
private RefType boxIfNeeded(Type t) {
  t.(PrimitiveType).getBoxedType() = result or
  result = t
}

/**
 * Holds if `arg` is an argument for the parameter `p` in a private callable.
 */
private predicate privateParamArg(Parameter p, Argument arg) {
  p.getAnArgument() = arg and
  p.getCallable().isPrivate()
}

/**
 * Holds if data can flow from `n1` to `n2` in one step, and `n1` is not
 * necessarily functionally determined by `n2`.
 */
private predicate joinStep0(TypeFlowNode n1, TypeFlowNode n2) {
  n2.asExpr().(ChooseExpr).getAResultExpr() = n1.asExpr()
  or
  exists(Field f, Expr e |
    f = n2.asField() and
    f.getAnAssignedValue() = e and
    e = n1.asExpr() and
    not e.(FieldAccess).getField() = f
  )
  or
  n2.asSsa().(BaseSsaPhiNode).getAnUltimateLocalDefinition() = n1.asSsa()
  or
  exists(ReturnStmt ret |
    n2.asMethod() = ret.getEnclosingCallable() and ret.getResult() = n1.asExpr()
  )
  or
  viableImpl_v1(n2.asExpr()) = n1.asMethod()
  or
  exists(Argument arg, Parameter p |
    privateParamArg(p, arg) and
    n1.asExpr() = arg and
    n2.asSsa().(BaseSsaImplicitInit).isParameterDefinition(p) and
    // skip trivial recursion
    not arg = n2.asSsa().getAUse()
  )
}

/**
 * Holds if data can flow from `n1` to `n2` in one step, and `n1` is
 * functionally determined by `n2`.
 */
private predicate step(TypeFlowNode n1, TypeFlowNode n2) {
  n2.asExpr() = n1.asField().getAnAccess()
  or
  n2.asExpr() = n1.asSsa().getAUse()
  or
  n2.asExpr().(CastingExpr).getExpr() = n1.asExpr() and
  not n2.asExpr().getType() instanceof PrimitiveType
  or
  n2.asExpr().(AssignExpr).getSource() = n1.asExpr() and
  not n2.asExpr().getType() instanceof PrimitiveType
  or
  n2.asSsa().(BaseSsaUpdate).getDefiningExpr().(VariableAssign).getSource() = n1.asExpr()
  or
  n2.asSsa().(BaseSsaImplicitInit).captures(n1.asSsa())
}

/**
 * Holds if `null` is the only value that flows to `n`.
 */
private predicate isNull(TypeFlowNode n) {
  n.asExpr() instanceof NullLiteral
  or
  exists(LocalVariableDeclExpr decl |
    n.asSsa().(BaseSsaUpdate).getDefiningExpr() = decl and
    not decl.hasImplicitInit() and
    not exists(decl.getInit())
  )
  or
  exists(TypeFlowNode mid | isNull(mid) and step(mid, n))
  or
  forex(TypeFlowNode mid | joinStep0(mid, n) | isNull(mid)) and
  // Fields that are never assigned a non-null value are probably set by
  // reflection and are thus not always null.
  not exists(n.asField())
}

/**
 * Holds if data can flow from `n1` to `n2` in one step, `n1` is not necessarily
 * functionally determined by `n2`, and `n1` might take a non-null value.
 */
private predicate joinStep(TypeFlowNode n1, TypeFlowNode n2) {
  joinStep0(n1, n2) and not isNull(n1)
}

private predicate anyStep(TypeFlowNode n1, TypeFlowNode n2) { joinStep(n1, n2) or step(n1, n2) }

private predicate sccEdge(TypeFlowNode n1, TypeFlowNode n2) { anyStep(n1, n2) and anyStep+(n2, n1) }

private module Scc = QlBuiltins::EquivalenceRelation<TypeFlowNode, sccEdge/2>;

private class TypeFlowScc = Scc::EquivalenceClass;

/** Holds if `n` is part of an SCC of size 2 or more represented by `scc`. */
private predicate sccRepr(TypeFlowNode n, TypeFlowScc scc) { scc = Scc::getEquivalenceClass(n) }

private predicate sccJoinStep(TypeFlowNode n, TypeFlowScc scc) {
  exists(TypeFlowNode mid |
    joinStep(n, mid) and
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
      rank[r](TypeFlowNode n |
        edge(n, n2)
      |
        n order by n.getLocation().getStartLine(), n.getLocation().getStartColumn()
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
  pragma[assume_small_delta]
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

  predicate edge = joinStep/2;
}

private module SccJoinStep implements Edge {
  class Node = TypeFlowScc;

  predicate edge = sccJoinStep/2;
}

private module RankedJoinStep = RankEdge<JoinStep>;

private module RankedSccJoinStep = RankEdge<SccJoinStep>;

private predicate exactTypeBase(TypeFlowNode n, RefType t) {
  exists(ClassInstanceExpr e |
    n.asExpr() = e and
    e.getType() = t and
    not e instanceof FunctionalExpr and
    exists(SrcRefType sub | sub.getASourceSupertype() = t.getSourceDeclaration())
  )
}

private module ExactTypePropagation implements TypePropagation {
  class Typ = RefType;

  predicate candType = exactType/2;

  predicate supportsType = exactType/2;
}

/**
 * Holds if the runtime type of `n` is exactly `t` and if this bound is a
 * non-trivial lower bound, that is, `t` has a subtype.
 */
private predicate exactType(TypeFlowNode n, RefType t) {
  exactTypeBase(n, t)
  or
  exists(TypeFlowNode mid | exactType(mid, t) and step(mid, n))
  or
  // The following is an optimized version of
  // `forex(TypeFlowNode mid | joinStep(mid, n) | exactType(mid, t))`
  ForAll<TypeFlowNode, RankedJoinStep, ExactTypePropagation>::flowJoin(n, t)
  or
  exists(TypeFlowScc scc |
    sccRepr(n, scc) and
    // Optimized version of
    // `forex(TypeFlowNode mid | sccJoinStep(mid, scc) | exactType(mid, t))`
    ForAll<TypeFlowScc, RankedSccJoinStep, ExactTypePropagation>::flowJoin(scc, t)
  )
}

/**
 * Holds if `n` occurs in a position where type information might be discarded;
 * `t1` is the type of `n`, `t1e` is the erasure of `t1`, `t2` is the type of
 * the implicit or explicit cast, and `t2e` is the erasure of `t2`.
 */
pragma[nomagic]
private predicate upcastCand(TypeFlowNode n, RefType t1, RefType t1e, RefType t2, RefType t2e) {
  exists(TypeFlowNode next | step(n, next) or joinStep(n, next) |
    n.getType() = t1 and
    next.getType() = t2 and
    t1.getErasure() = t1e and
    t2.getErasure() = t2e and
    t1 != t2
  )
}

private predicate unconstrained(BoundedType t) {
  t.(Wildcard).isUnconstrained()
  or
  t.getUpperBoundType() instanceof TypeObject and
  not t.(Wildcard).hasLowerBound()
  or
  unconstrained(t.getUpperBoundType())
  or
  unconstrained(t.(Wildcard).getLowerBoundType())
}

/** Holds if `t` is a raw type or parameterised type with unrestricted type arguments. */
private predicate unbound(RefType t) {
  t instanceof RawType
  or
  exists(ParameterizedType pt | pt = t |
    forex(RefType arg | arg = pt.getATypeArgument() | unconstrained(arg))
  )
}

/** Holds if `n` occurs in a position where type information is discarded. */
private predicate upcast(TypeFlowNode n, RefType t1) {
  exists(RefType t1e, RefType t2, RefType t2e | upcastCand(n, t1, t1e, t2, t2e) |
    t1e.getASourceSupertype+() = t2e
    or
    t1e = t2e and
    unbound(t2) and
    not unbound(t1)
  )
}

/** Gets the element type of an array or subtype of `Iterable`. */
private Type elementType(RefType t) {
  result = t.(Array).getComponentType()
  or
  exists(ParameterizedType it |
    it.getSourceDeclaration().hasQualifiedName("java.lang", "Iterable") and
    result = it.getATypeArgument() and
    t.extendsOrImplements*(it)
  )
}

private predicate upcastEnhancedForStmtAux(BaseSsaUpdate v, RefType t, RefType t1, RefType t2) {
  exists(EnhancedForStmt for |
    for.getVariable() = v.getDefiningExpr() and
    v.getSourceVariable().getType().getErasure() = t2 and
    t = boxIfNeeded(elementType(for.getExpr().getType())) and
    t.getErasure() = t1
  )
}

/**
 * Holds if `v` is the iteration variable of an enhanced for statement, `t` is
 * the type of the elements being iterated over, and this type is more precise
 * than the type of `v`.
 */
private predicate upcastEnhancedForStmt(BaseSsaUpdate v, RefType t) {
  exists(RefType t1, RefType t2 |
    upcastEnhancedForStmtAux(v, t, t1, t2) and
    t1.getASourceSupertype+() = t2
  )
}

private predicate downcastSuccessorAux(
  CastingExpr cast, BaseSsaVariable v, RefType t, RefType t1, RefType t2
) {
  cast.getExpr() = v.getAUse() and
  t = cast.getType() and
  t1 = t.getErasure() and
  t2 = v.getSourceVariable().getType().getErasure()
}

/**
 * Holds if `va` is an access to a value that has previously been downcast to `t`.
 */
private predicate downcastSuccessor(VarAccess va, RefType t) {
  exists(CastingExpr cast, BaseSsaVariable v, RefType t1, RefType t2 |
    downcastSuccessorAux(pragma[only_bind_into](cast), v, t, t1, t2) and
    t1.getASourceSupertype+() = t2 and
    va = v.getAUse() and
    dominates(cast, va) and
    dominates(cast.(ControlFlowNode).getANormalSuccessor(), va)
  )
}

/**
 * Holds if `va` is an access to a value that is guarded by `instanceof t`.
 */
private predicate instanceOfGuarded(VarAccess va, RefType t) {
  exists(InstanceOfExpr ioe, BaseSsaVariable v |
    ioe.getExpr() = v.getAUse() and
    t = ioe.getCheckedType() and
    va = v.getAUse() and
    guardControls_v1(ioe, va.getBasicBlock(), true)
  )
}

/**
 * Holds if `aa` is an access to a value that is guarded by `instanceof t`.
 */
predicate arrayInstanceOfGuarded(ArrayAccess aa, RefType t) {
  exists(InstanceOfExpr ioe, BaseSsaVariable v1, BaseSsaVariable v2, ArrayAccess aa1 |
    ioe.getExpr() = aa1 and
    t = ioe.getCheckedType() and
    aa1.getArray() = v1.getAUse() and
    aa1.getIndexExpr() = v2.getAUse() and
    aa.getArray() = v1.getAUse() and
    aa.getIndexExpr() = v2.getAUse() and
    guardControls_v1(ioe, aa.getBasicBlock(), true)
  )
}

/**
 * Holds if `n` has type `t` and this information is discarded, such that `t`
 * might be a better type bound for nodes where `n` flows to. This might include
 * multiple bounds for a single node.
 */
private predicate typeFlowBaseCand(TypeFlowNode n, RefType t) {
  exists(RefType srctype |
    upcast(n, srctype) or
    upcastEnhancedForStmt(n.asSsa(), srctype) or
    downcastSuccessor(n.asExpr(), srctype) or
    instanceOfGuarded(n.asExpr(), srctype) or
    arrayInstanceOfGuarded(n.asExpr(), srctype) or
    n.asExpr().(FunctionalExpr).getConstructedType() = srctype
  |
    t = srctype.(BoundedType).getAnUltimateUpperBoundType()
    or
    t = srctype and not srctype instanceof BoundedType
  )
}

/**
 * Holds if `n` has type `t` and this information is discarded, such that `t`
 * might be a better type bound for nodes where `n` flows to. This only includes
 * the best such bound for each node.
 */
private predicate typeFlowBase(TypeFlowNode n, RefType t) {
  exists(RefType te |
    typeFlowBaseCand(n, t) and
    te = t.getErasure() and
    not exists(RefType better |
      typeFlowBaseCand(n, better) and
      better != t and
      not t.getASupertype+() = better
    |
      better.getASupertype+() = t or
      better.getErasure().(RefType).getASourceSupertype+() = te
    )
  )
}

private module TypeFlowPropagation implements TypePropagation {
  class Typ = RefType;

  predicate candType = typeFlow/2;

  bindingset[t]
  predicate supportsType(TypeFlowNode mid, RefType t) {
    exists(RefType midtyp | exactType(mid, midtyp) or typeFlow(mid, midtyp) |
      pragma[only_bind_out](midtyp).getAnAncestor() = t
    )
  }
}

/**
 * Holds if the runtime type of `n` is bounded by `t` and if this bound is
 * likely to be better than the static type of `n`.
 */
private predicate typeFlow(TypeFlowNode n, RefType t) {
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
private predicate erasedTypeBound(RefType t) {
  exists(RefType t0 | typeFlow(_, t0) and t = t0.getErasure())
}

pragma[nomagic]
private predicate typeBound(RefType t) { typeFlow(_, t) }

/**
 * Holds if we have a bound for `n` that is better than `t`, taking only erased
 * types into account.
 */
pragma[nomagic]
private predicate irrelevantErasedBound(TypeFlowNode n, RefType t) {
  exists(RefType bound |
    typeFlow(n, bound)
    or
    n.getType() = bound and typeFlow(n, _)
  |
    t = bound.getErasure().(RefType).getASourceSupertype+() and
    erasedTypeBound(t)
  )
}

/**
 * Holds if we have a bound for `n` that is better than `t`.
 */
pragma[nomagic]
private predicate irrelevantBound(TypeFlowNode n, RefType t) {
  exists(RefType bound |
    typeFlow(n, bound) and
    t = bound.getAStrictAncestor() and
    typeBound(t) and
    typeFlow(n, pragma[only_bind_into](t)) and
    not t.getAnAncestor() = bound
    or
    n.getType() = pragma[only_bind_into](bound) and
    typeFlow(n, t) and
    t = bound.getAnAncestor()
  )
}

/**
 * Holds if the runtime type of `n` is bounded by `t`, if this bound is likely
 * to be better than the static type of `n`, and if this the best such bound.
 */
private predicate bestTypeFlow(TypeFlowNode n, RefType t) {
  typeFlow(n, t) and
  not irrelevantErasedBound(n, t.getErasure()) and
  not irrelevantBound(n, t)
}

private predicate bestTypeFlow(TypeFlowNode n, RefType t, boolean exact) {
  exactType(n, t) and exact = true
  or
  not exactType(n, _) and bestTypeFlow(n, t) and exact = false
}

private predicate bestTypeFlowOrTypeFlowBase(TypeFlowNode n, RefType t, boolean exact) {
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
private predicate unionTypeFlowBaseCand(TypeFlowNode n, RefType t, boolean exact) {
  exists(TypeFlowNode next |
    joinStep(n, next) and
    bestTypeFlowOrTypeFlowBase(n, t, exact) and
    not bestTypeFlowOrTypeFlowBase(next, t, exact) and
    not exactType(next, _)
  )
}

/**
 * Holds if `ioe` checks `v`, its true-successor is `bb`, and `bb` has multiple
 * predecessors.
 */
private predicate instanceofDisjunct(InstanceOfExpr ioe, BasicBlock bb, BaseSsaVariable v) {
  ioe.getExpr() = v.getAUse() and
  strictcount(bb.getABBPredecessor()) > 1 and
  exists(ConditionBlock cb | cb.getCondition() = ioe and cb.getTestSuccessor(true) = bb)
}

/** Holds if `bb` is disjunctively guarded by multiple `instanceof` tests on `v`. */
private predicate instanceofDisjunction(BasicBlock bb, BaseSsaVariable v) {
  strictcount(InstanceOfExpr ioe | instanceofDisjunct(ioe, bb, v)) =
    strictcount(bb.getABBPredecessor())
}

/**
 * Holds if `n` is a value that is guarded by a disjunction of
 * `instanceof t_i` where `t` is one of those `t_i`.
 */
private predicate instanceofDisjunctionGuarded(TypeFlowNode n, RefType t) {
  exists(BasicBlock bb, InstanceOfExpr ioe, BaseSsaVariable v, VarAccess va |
    instanceofDisjunction(bb, v) and
    bb.bbDominates(va.getBasicBlock()) and
    va = v.getAUse() and
    instanceofDisjunct(ioe, bb, v) and
    t = ioe.getCheckedType() and
    n.asExpr() = va
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
    // `forex(TypeFlowNode mid | joinStep(mid, n) | unionTypeFlowBaseCand(mid, _, _) or hasUnionTypeFlow(mid))`
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
private RefType getTypeBound(TypeFlowNode n) {
  bestTypeFlow(n, result)
  or
  not bestTypeFlow(n, _) and result = n.getType()
}

pragma[nomagic]
private predicate unionTypeFlow0(TypeFlowNode n, RefType t, boolean exact) {
  hasUnionTypeFlow(n) and
  (
    exists(TypeFlowNode mid | anyStep(mid, n) |
      unionTypeFlowBaseCand(mid, t, exact) or unionTypeFlow(mid, t, exact)
    )
    or
    instanceofDisjunctionGuarded(n, t) and exact = false
  )
}

/** Holds if we have a union type bound for `n` and `t` is one of its parts. */
private predicate unionTypeFlow(TypeFlowNode n, RefType t, boolean exact) {
  unionTypeFlow0(n, t, exact) and
  // filter impossible union parts:
  exists(RefType tErased, RefType boundErased |
    pragma[only_bind_into](tErased) = t.getErasure() and
    pragma[only_bind_into](boundErased) = getTypeBound(n).getErasure()
  |
    if exact = true
    then tErased.getASourceSupertype*() = boundErased
    else erasedHaveIntersection(tErased, boundErased)
  )
}

/**
 * Holds if the inferred union type bound for `n` contains the best universal
 * bound and thus is irrelevant.
 */
private predicate irrelevantUnionType(TypeFlowNode n) {
  exists(RefType t, RefType nt, RefType te, RefType nte |
    unionTypeFlow(n, t, false) and
    nt = getTypeBound(n) and
    te = t.getErasure() and
    nte = nt.getErasure()
  |
    nt.getASupertype*() = t
    or
    nte.getASourceSupertype+() = te
    or
    nte = te and unbound(t)
  )
}

/**
 * Holds if `t` is an irrelevant part of the union type bound for `n` due to
 * being contained in another part of the union type bound.
 */
private predicate irrelevantUnionTypePart(TypeFlowNode n, RefType t, boolean exact) {
  unionTypeFlow(n, t, exact) and
  not irrelevantUnionType(n) and
  exists(RefType weaker |
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
private predicate bestUnionType(TypeFlowNode n, RefType t, boolean exact) {
  unionTypeFlow(n, t, exact) and
  not irrelevantUnionType(n) and
  not irrelevantUnionTypePart(n, t, exact)
}

cached
private module TypeFlowBounds {
  /**
   * Holds if the runtime type of `f` is bounded by `t` and if this bound is
   * likely to be better than the static type of `f`. The flag `exact` indicates
   * whether `t` is an exact bound or merely an upper bound.
   */
  cached
  predicate fieldTypeFlow(Field f, RefType t, boolean exact) {
    exists(TypeFlowNode n |
      n.asField() = f and
      bestTypeFlow(n, t, exact)
    )
  }

  /**
   * Holds if the runtime type of `e` is bounded by `t` and if this bound is
   * likely to be better than the static type of `e`. The flag `exact` indicates
   * whether `t` is an exact bound or merely an upper bound.
   */
  cached
  predicate exprTypeFlow(Expr e, RefType t, boolean exact) {
    exists(TypeFlowNode n |
      n.asExpr() = e and
      bestTypeFlow(n, t, exact)
    )
  }

  /**
   * Holds if the runtime type of `e` is bounded by a union type and if this
   * bound is likely to be better than the static type of `e`. The union type is
   * made up of the types `t` related to `e` by this predicate, and the flag
   * `exact` indicates whether `t` is an exact bound or merely an upper bound.
   */
  cached
  predicate exprUnionTypeFlow(Expr e, RefType t, boolean exact) {
    exists(TypeFlowNode n |
      n.asExpr() = e and
      bestUnionType(n, t, exact)
    )
  }
}

import TypeFlowBounds
