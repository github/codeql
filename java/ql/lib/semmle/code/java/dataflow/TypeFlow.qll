/**
 * Provides predicates for giving improved type bounds on expressions.
 *
 * An inferred bound on the runtime type of an expression can be either exact
 * or merely an upper bound. Bounds are only reported if they are likely to be
 * better than the static bound, which can happen either if an inferred exact
 * type has a subtype or if an inferred upper bound passed through at least one
 * explicit or implicit cast that lost type information.
 */

import java as J
private import semmle.code.java.dispatch.VirtualDispatch
private import semmle.code.java.dataflow.internal.BaseSSA
private import semmle.code.java.controlflow.Guards
private import codeql.typeflow.TypeFlow
private import codeql.typeflow.UniversalFlow as UniversalFlow

/** Gets `t` if it is a `RefType` or the boxed type if `t` is a primitive type. */
private RefType boxIfNeeded(J::Type t) {
  t.(PrimitiveType).getBoxedType() = result or
  result = t
}

/** Provides the input types and predicates for instantiation of `UniversalFlow`. */
module FlowStepsInput implements UniversalFlow::UniversalFlowInput<Location> {
  private newtype TFlowNode =
    TField(Field f) { not f.getType() instanceof PrimitiveType } or
    TSsa(BaseSsaVariable ssa) { not ssa.getSourceVariable().getType() instanceof PrimitiveType } or
    TExpr(Expr e) or
    TMethod(Method m) { not m.getReturnType() instanceof PrimitiveType }

  /**
   * A `Field`, `BaseSsaVariable`, `Expr`, or `Method`.
   */
  class FlowNode extends TFlowNode {
    /** Gets a textual representation of this element. */
    string toString() {
      result = this.asField().toString() or
      result = this.asSsa().toString() or
      result = this.asExpr().toString() or
      result = this.asMethod().toString()
    }

    /** Gets the source location for this element. */
    Location getLocation() {
      result = this.asField().getLocation() or
      result = this.asSsa().getLocation() or
      result = this.asExpr().getLocation() or
      result = this.asMethod().getLocation()
    }

    /** Gets the field corresponding to this node, if any. */
    Field asField() { this = TField(result) }

    /** Gets the SSA variable corresponding to this node, if any. */
    BaseSsaVariable asSsa() { this = TSsa(result) }

    /** Gets the expression corresponding to this node, if any. */
    Expr asExpr() { this = TExpr(result) }

    /** Gets the method corresponding to this node, if any. */
    Method asMethod() { this = TMethod(result) }

    /** Gets the type of this node. */
    RefType getType() {
      result = this.asField().getType() or
      result = this.asSsa().getSourceVariable().getType() or
      result = boxIfNeeded(this.asExpr().getType()) or
      result = this.asMethod().getReturnType()
    }
  }

  private SrcCallable viableCallable_v1(Call c) {
    result = viableImpl_v1(c)
    or
    c instanceof ConstructorCall and result = c.getCallee().getSourceDeclaration()
  }

  /**
   * Holds if `arg` is an argument for the parameter `p` in a sufficiently
   * private callable that the closed-world assumption applies.
   */
  private predicate privateParamArg(Parameter p, Argument arg) {
    exists(SrcCallable c, Call call |
      c = p.getCallable() and
      not c.isImplicitlyPublic() and
      not p.isVarargs() and
      c = viableCallable_v1(call) and
      call.getArgument(pragma[only_bind_into](pragma[only_bind_out](p.getPosition()))) = arg
    )
  }

  /**
   * Holds if data can flow from `n1` to `n2` in one step.
   *
   * For a given `n2`, this predicate must include all possible `n1` that can flow to `n2`.
   */
  predicate step(FlowNode n1, FlowNode n2) {
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
    or
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
    or
    n2.asExpr().(NotNullExpr).getExpr() = n1.asExpr()
  }

  /**
   * Holds if `null` is the only value that flows to `n`.
   */
  predicate isNullValue(FlowNode n) {
    n.asExpr() instanceof NullLiteral
    or
    exists(LocalVariableDeclExpr decl |
      n.asSsa().(BaseSsaUpdate).getDefiningExpr() = decl and
      not decl.hasImplicitInit() and
      not exists(decl.getInitOrPatternSource())
    )
  }

  predicate isExcludedFromNullAnalysis(FlowNode n) {
    // Fields that are never assigned a non-null value are probably set by
    // reflection and are thus not always null.
    exists(n.asField())
  }
}

private module Input implements TypeFlowInput<Location> {
  import FlowStepsInput

  class TypeFlowNode = FlowNode;

  predicate isExcludedFromNullAnalysis = FlowStepsInput::isExcludedFromNullAnalysis/1;

  class Type = RefType;

  predicate exactTypeBase(TypeFlowNode n, RefType t) {
    exists(ClassInstanceExpr e |
      n.asExpr() = e and
      e.getType() = t and
      not e instanceof FunctionalExpr and
      exists(SrcRefType sub | sub.getASourceSupertype() = t.getSourceDeclaration())
    )
  }

  /**
   * Holds if `n` occurs in a position where type information might be discarded;
   * `t1` is the type of `n`, `t1e` is the erasure of `t1`, `t2` is the type of
   * the implicit or explicit cast, and `t2e` is the erasure of `t2`.
   */
  pragma[nomagic]
  private predicate upcastCand(TypeFlowNode n, RefType t1, RefType t1e, RefType t2, RefType t2e) {
    exists(TypeFlowNode next | step(n, next) |
      n.getType() = t1 and
      next.getType() = t2 and
      t1.getErasure() = t1e and
      t2.getErasure() = t2e and
      t1 != t2
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
  private J::Type elementType(RefType t) {
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
      dominates(cast.getControlFlowNode(), va.getControlFlowNode()) and
      dominates(cast.getControlFlowNode().getANormalSuccessor(), va.getControlFlowNode())
    )
  }

  /**
   * Holds if `va` is an access to a value that is guarded by `instanceof t` or `case e t`.
   */
  private predicate typeTestGuarded(VarAccess va, RefType t) {
    exists(Guard typeTest, BaseSsaVariable v |
      typeTest.appliesTypeTest(v.getAUse(), t, _) and
      va = v.getAUse() and
      guardControls_v1(typeTest, va.getBasicBlock(), true)
    )
  }

  /**
   * Holds if `aa` is an access to a value that is guarded by `instanceof t` or `case e t`.
   */
  private predicate arrayTypeTestGuarded(ArrayAccess aa, RefType t) {
    exists(Guard typeTest, BaseSsaVariable v1, BaseSsaVariable v2, ArrayAccess aa1 |
      typeTest.appliesTypeTest(aa1, t, _) and
      aa1.getArray() = v1.getAUse() and
      aa1.getIndexExpr() = v2.getAUse() and
      aa.getArray() = v1.getAUse() and
      aa.getIndexExpr() = v2.getAUse() and
      guardControls_v1(typeTest, aa.getBasicBlock(), true)
    )
  }

  /**
   * Holds if `t` is the type of the `this` value corresponding to the the
   * `SuperAccess`. As the `SuperAccess` expression has the type of the supertype,
   * the type `t` is a stronger type bound.
   */
  private predicate superAccess(SuperAccess sup, RefType t) {
    sup.isEnclosingInstanceAccess(t)
    or
    sup.isOwnInstanceAccess() and
    t = sup.getEnclosingCallable().getDeclaringType()
  }

  /**
   * Holds if `n` has type `t` and this information is discarded, such that `t`
   * might be a better type bound for nodes where `n` flows to. This might include
   * multiple bounds for a single node.
   */
  predicate typeFlowBaseCand(TypeFlowNode n, RefType t) {
    exists(RefType srctype |
      upcast(n, srctype) or
      upcastEnhancedForStmt(n.asSsa(), srctype) or
      downcastSuccessor(n.asExpr(), srctype) or
      typeTestGuarded(n.asExpr(), srctype) or
      arrayTypeTestGuarded(n.asExpr(), srctype) or
      n.asExpr().(FunctionalExpr).getConstructedType() = srctype or
      superAccess(n.asExpr(), srctype)
    |
      t = srctype.(BoundedType).getAnUltimateUpperBoundType()
      or
      t = srctype and not srctype instanceof BoundedType
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
  predicate instanceofDisjunctionGuarded(TypeFlowNode n, RefType t) {
    exists(BasicBlock bb, InstanceOfExpr ioe, BaseSsaVariable v, VarAccess va |
      instanceofDisjunction(bb, v) and
      bb.bbDominates(va.getBasicBlock()) and
      va = v.getAUse() and
      instanceofDisjunct(ioe, bb, v) and
      t = ioe.getSyntacticCheckedType() and
      n.asExpr() = va
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
  predicate unbound(RefType t) {
    t instanceof RawType
    or
    exists(ParameterizedType pt | pt = t |
      forex(RefType arg | arg = pt.getATypeArgument() | unconstrained(arg))
    )
  }

  Type getErasure(Type t) { result = t.getErasure() }

  Type getAnAncestor(Type sub) { result = sub.getAnAncestor() }

  RefType getSourceDeclaration(Type t) { result = t.getSourceDeclaration() }
}

cached
private module TypeFlowBounds {
  private module TypeFlow = Make<Location, Input>;

  /**
   * Holds if the runtime type of `f` is bounded by `t` and if this bound is
   * likely to be better than the static type of `f`. The flag `exact` indicates
   * whether `t` is an exact bound or merely an upper bound.
   */
  cached
  predicate fieldTypeFlow(Field f, RefType t, boolean exact) {
    exists(Input::TypeFlowNode n |
      n.asField() = f and
      TypeFlow::bestTypeFlow(n, t, exact)
    )
  }

  /**
   * Holds if the runtime type of `e` is bounded by `t` and if this bound is
   * likely to be better than the static type of `e`. The flag `exact` indicates
   * whether `t` is an exact bound or merely an upper bound.
   */
  cached
  predicate exprTypeFlow(Expr e, RefType t, boolean exact) {
    exists(Input::TypeFlowNode n |
      n.asExpr() = e and
      TypeFlow::bestTypeFlow(n, t, exact)
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
    exists(Input::TypeFlowNode n |
      n.asExpr() = e and
      TypeFlow::bestUnionType(n, t, exact)
    )
  }
}

import TypeFlowBounds
