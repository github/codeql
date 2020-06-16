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
  n2.asExpr().(CastExpr).getExpr() = n1.asExpr() and
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

private predicate joinStepRank1(int r, TypeFlowNode n1, TypeFlowNode n2) {
  n1 =
    rank[r](TypeFlowNode n |
      joinStep(n, n2)
    |
      n order by n.getLocation().getStartLine(), n.getLocation().getStartColumn()
    )
}

private predicate joinStepRank2(int r2, int r1, TypeFlowNode n) {
  r1 = rank[r2](int r | joinStepRank1(r, _, n) | r)
}

private predicate joinStepRank(int r, TypeFlowNode n1, TypeFlowNode n2) {
  exists(int r1 |
    joinStepRank1(r1, n1, n2) and
    joinStepRank2(r, r1, n2)
  )
}

private int lastRank(TypeFlowNode n) { result = max(int r | joinStepRank(r, _, n)) }

private predicate exactTypeBase(TypeFlowNode n, RefType t) {
  exists(ClassInstanceExpr e |
    n.asExpr() = e and
    e.getType() = t and
    not e instanceof FunctionalExpr and
    exists(RefType sub | sub.getASourceSupertype() = t.getSourceDeclaration())
  )
}

private predicate exactTypeRank(int r, TypeFlowNode n, RefType t) {
  forall(TypeFlowNode mid | joinStepRank(r, mid, n) | exactType(mid, t)) and
  joinStepRank(r, _, n)
}

private predicate exactTypeJoin(int r, TypeFlowNode n, RefType t) {
  exactTypeRank(1, n, t) and r = 1
  or
  exactTypeJoin(r - 1, n, t) and exactTypeRank(r, n, t)
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
  exactTypeJoin(lastRank(n), n, t)
}

/**
 * Holds if `n` occurs in a position where type information might be discarded;
 * `t` is the potentially boxed type of `n`, `t1` is the erasure of `t`, and
 * `t2` is the erased type of the implicit or explicit cast.
 */
pragma[noinline]
private predicate upcastCand(TypeFlowNode n, RefType t, RefType t1, RefType t2) {
  t = boxIfNeeded(n.getType()) and
  t.getErasure() = t1 and
  (
    exists(Variable v | v.getAnAssignedValue() = n.asExpr() and t2 = v.getType().getErasure())
    or
    exists(CastExpr c | c.getExpr() = n.asExpr() and t2 = c.getType().getErasure())
    or
    exists(ReturnStmt ret |
      ret.getResult() = n.asExpr() and t2 = ret.getEnclosingCallable().getReturnType().getErasure()
    )
    or
    exists(MethodAccess ma | viableImpl_v1(ma) = n.asMethod() and t2 = ma.getType())
    or
    exists(Parameter p | privateParamArg(p, n.asExpr()) and t2 = p.getType().getErasure())
    or
    exists(ChooseExpr cond |
      cond.getAResultExpr() = n.asExpr() and
      t2 = cond.getType().getErasure()
    )
  )
}

/** Holds if `n` occurs in a position where type information is discarded. */
private predicate upcast(TypeFlowNode n, RefType t) {
  exists(RefType t1, RefType t2 |
    upcastCand(n, t, t1, t2) and
    t1.getASourceSupertype+() = t2
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
  CastExpr cast, BaseSsaVariable v, RefType t, RefType t1, RefType t2
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
  exists(CastExpr cast, BaseSsaVariable v, RefType t1, RefType t2 |
    downcastSuccessorAux(cast, v, t, t1, t2) and
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
    t = ioe.getTypeName().getType() and
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
    t = ioe.getTypeName().getType() and
    aa1.getArray() = v1.getAUse() and
    aa1.getIndexExpr() = v2.getAUse() and
    aa.getArray() = v1.getAUse() and
    aa.getIndexExpr() = v2.getAUse() and
    guardControls_v1(ioe, aa.getBasicBlock(), true)
  )
}

/**
 * Holds if `n` has type `t` and this information is discarded, such that `t`
 * might be a better type bound for nodes where `n` flows to.
 */
private predicate typeFlowBase(TypeFlowNode n, RefType t) {
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
 * Holds if `t` is a bound that holds on one of the incoming edges to `n` and
 * thus is a candidate bound for `n`.
 */
pragma[noinline]
private predicate typeFlowJoinCand(TypeFlowNode n, RefType t) {
  exists(TypeFlowNode mid | joinStep(mid, n) | typeFlow(mid, t))
}

/**
 * Holds if `t` is a candidate bound for `n` that is also valid for data coming
 * through the edges into `n` ranked from `1` to `r`.
 */
private predicate typeFlowJoin(int r, TypeFlowNode n, RefType t) {
  (
    r = 1 and typeFlowJoinCand(n, t)
    or
    typeFlowJoin(r - 1, n, t) and joinStepRank(r, _, n)
  ) and
  forall(TypeFlowNode mid | joinStepRank(r, mid, n) |
    exists(RefType midtyp | exactType(mid, midtyp) or typeFlow(mid, midtyp) |
      midtyp.getASupertype*() = t
    )
  )
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
  typeFlowJoin(lastRank(n), n, t)
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
    t = bound.getASupertype+() and
    typeBound(t) and
    typeFlow(n, t) and
    not t.getASupertype*() = bound
    or
    n.getType() = bound and
    typeFlow(n, t) and
    t = bound.getASupertype*()
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
      (
        exactType(n, t) and exact = true
        or
        not exactType(n, _) and bestTypeFlow(n, t) and exact = false
      )
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
      (
        exactType(n, t) and exact = true
        or
        not exactType(n, _) and bestTypeFlow(n, t) and exact = false
      )
    )
  }
}

import TypeFlowBounds
