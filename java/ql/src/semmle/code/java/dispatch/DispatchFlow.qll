/**
 * INTERNAL: This is part of the virtual dispatch computation.
 *
 * Provides a strengthening of the virtual dispatch relation using a dedicated
 * data flow check for lambdas, anonymous classes, and other sufficiently
 * private classes where all object instantiations are accounted for.
 */

import java
private import VirtualDispatch
private import semmle.code.java.dataflow.internal.BaseSSA
private import semmle.code.java.dataflow.internal.DataFlowUtil
private import semmle.code.java.dataflow.internal.DataFlowPrivate
private import semmle.code.java.Collections
private import semmle.code.java.Maps

/**
 * Gets a viable dispatch target for `ma`. This is the input dispatch relation.
 */
private Method viableImpl_inp(MethodAccess ma) { result = viableImpl_v2(ma) }

private Callable dispatchCand(Call c) {
  c instanceof ConstructorCall and result = c.getCallee().getSourceDeclaration()
  or
  result = viableImpl_inp(c)
}

/**
 * Holds if `t` and all its enclosing types are public.
 */
private predicate veryPublic(RefType t) {
  t.isPublic() and
  (
    not t instanceof NestedType or
    veryPublic(t.(NestedType).getEnclosingType())
  )
}

/**
 * Holds if `cie` occurs as the initializer of a public static field.
 */
private predicate publicStaticFieldInit(ClassInstanceExpr cie) {
  exists(Field f |
    f.isStatic() and
    f.isPublic() and
    veryPublic(f.getDeclaringType()) and
    f.getInitializer() = cie
  )
}

/**
 * Holds if a `ClassInstanceExpr` constructing `t` occurs as the initializer of
 * a public static field.
 */
private predicate publicThroughField(RefType t) {
  exists(ClassInstanceExpr cie |
    cie.getConstructedType() = t and
    publicStaticFieldInit(cie)
  )
}

/**
 * Holds if `t` and its subtypes are private or anonymous.
 */
private predicate privateConstruction(RefType t) {
  (t.isPrivate() or t instanceof AnonymousClass) and
  not publicThroughField(t) and
  forall(SrcRefType sub | sub.getASourceSupertype+() = t.getSourceDeclaration() |
    (sub.isPrivate() or sub instanceof AnonymousClass) and
    not publicThroughField(sub)
  )
}

/**
 * Holds if `m` is declared on a type that we will track all instantiations of
 * for the purpose of virtual dispatch to `m`. This holds in particular for
 * lambda methods and methods on other anonymous classes.
 */
private predicate trackedMethod(Method m) {
  privateConstruction(m.getDeclaringType().getSourceDeclaration())
}

/**
 * Holds if `t` declares or inherits the tracked method `m`.
 */
private predicate trackedMethodOnType(Method m, SrcRefType t) {
  exists(Method m0 |
    t.hasMethod(m0, _, _) and
    m = m0.getSourceDeclaration() and
    trackedMethod(m)
  )
}

/**
 * Holds if `ma` may dispatch to the tracked method `m` declared or inherited
 * by the type constructed by `cie`. Thus the dispatch from `ma` to `m` will
 * only be included if `cie` flows to the qualifier of `ma`.
 */
private predicate dispatchOrigin(ClassInstanceExpr cie, MethodAccess ma, Method m) {
  m = viableImpl_inp(ma) and
  not m = ma.getMethod().getSourceDeclaration() and
  trackedMethodOnType(m, cie.getConstructedType().getSourceDeclaration())
}

/** Holds if `t` is a type that is relevant for dispatch flow. */
private predicate relevant(RefType t) {
  exists(ClassInstanceExpr cie |
    dispatchOrigin(cie, _, _) and t = cie.getConstructedType().getSourceDeclaration()
  )
  or
  relevant(t.getErasure())
  or
  exists(RefType r | relevant(r) and t = r.getASourceSupertype())
  or
  relevant(t.(Array).getComponentType())
  or
  t instanceof MapType
  or
  t instanceof CollectionType
}

/** A node with a type that is relevant for dispatch flow. */
private class RelevantNode extends Node {
  RelevantNode() { relevant(this.getType()) }
}

/**
 * Holds if `p` is the `i`th parameter of a viable dispatch target of `call`.
 * The instance parameter is considered to have index `-1`.
 */
pragma[nomagic]
private predicate viableParamCand(Call call, int i, ParameterNode p) {
  exists(Callable callable |
    callable = dispatchCand(call) and
    p.isParameterOf(callable, i) and
    p instanceof RelevantNode
  )
}

/**
 * Holds if `arg` is a possible argument to `p` taking virtual dispatch into account.
 */
private predicate viableArgParamCand(ArgumentNode arg, ParameterNode p) {
  exists(int i, Call call |
    viableParamCand(call, i, p) and
    arg.argumentOf(call, i)
  )
}

/**
 * Holds if data may flow from `n1` to `n2` in a single step through a call or a return.
 */
private predicate callFlowStepCand(RelevantNode n1, RelevantNode n2) {
  exists(ReturnStmt ret, Method m |
    ret.getEnclosingCallable() = m and
    ret.getResult() = n1.asExpr() and
    m = dispatchCand(n2.asExpr())
  )
  or
  viableArgParamCand(n1, n2)
}

/**
 * Holds if data may flow from `n1` to `n2` in a single step that does not go
 * through a call or a return.
 */
private predicate flowStep(RelevantNode n1, RelevantNode n2) {
  exists(BaseSsaVariable v, BaseSsaVariable def |
    def.(BaseSsaUpdate).getDefiningExpr().(VariableAssign).getSource() = n1.asExpr()
    or
    def.(BaseSsaImplicitInit).isParameterDefinition(n1.asParameter())
    or
    exists(EnhancedForStmt for |
      for.getVariable() = def.(BaseSsaUpdate).getDefiningExpr() and
      for.getExpr() = n1.asExpr() and
      n1.getType() instanceof Array
    )
  |
    v.getAnUltimateDefinition() = def and
    v.getAUse() = n2.asExpr()
  )
  or
  exists(Callable c | n1.(InstanceParameterNode).getCallable() = c |
    exists(InstanceAccess ia |
      ia = n2.asExpr() and ia.getEnclosingCallable() = c and ia.isOwnInstanceAccess()
    )
    or
    n2.(ImplicitInstanceAccess).getInstanceAccess().(OwnInstanceAccess).getEnclosingCallable() = c
  )
  or
  exists(Field f |
    f.getAnAssignedValue() = n1.asExpr() and
    n2.asExpr().(FieldRead).getField() = f
  )
  or
  exists(EnumType enum, Method getValue |
    enum.getAnEnumConstant().getAnAssignedValue() = n1.asExpr() and
    getValue.getDeclaringType() = enum and
    (getValue.hasName("values") or getValue.hasName("valueOf")) and
    n2.asExpr().(MethodAccess).getMethod() = getValue
  )
  or
  n2.asExpr().(CastExpr).getExpr() = n1.asExpr()
  or
  n2.asExpr().(ChooseExpr).getAResultExpr() = n1.asExpr()
  or
  n2.asExpr().(AssignExpr).getSource() = n1.asExpr()
  or
  n2.asExpr().(ArrayInit).getAnInit() = n1.asExpr()
  or
  n2.asExpr().(ArrayCreationExpr).getInit() = n1.asExpr()
  or
  n2.asExpr().(ArrayAccess).getArray() = n1.asExpr()
  or
  exists(Argument arg |
    n1.asExpr() = arg and arg.isVararg() and n2.(ImplicitVarargsArray).getCall() = arg.getCall()
  )
  or
  exists(AssignExpr a, Variable v |
    a.getSource() = n1.asExpr() and
    a.getDest().(ArrayAccess).getArray() = v.getAnAccess() and
    n2.asExpr() = v.getAnAccess().(RValue)
  )
  or
  exists(Variable v, MethodAccess put, MethodAccess get |
    put.getArgument(1) = n1.asExpr() and
    put.getMethod().(MapMethod).hasName("put") and
    put.getQualifier() = v.getAnAccess() and
    get.getQualifier() = v.getAnAccess() and
    get.getMethod().(MapMethod).hasName("get") and
    n2.asExpr() = get
  )
  or
  exists(Variable v, MethodAccess add |
    add.getAnArgument() = n1.asExpr() and
    add.getMethod().(CollectionMethod).hasName("add") and
    add.getQualifier() = v.getAnAccess()
  |
    exists(MethodAccess get |
      get.getQualifier() = v.getAnAccess() and
      get.getMethod().(CollectionMethod).hasName("get") and
      n2.asExpr() = get
    )
    or
    exists(EnhancedForStmt for, BaseSsaVariable ssa, BaseSsaVariable def |
      for.getVariable() = def.(BaseSsaUpdate).getDefiningExpr() and
      for.getExpr() = v.getAnAccess() and
      ssa.getAnUltimateDefinition() = def and
      ssa.getAUse() = n2.asExpr()
    )
  )
}

/**
 * Holds if `n` is forward-reachable from a relevant `ClassInstanceExpr`.
 */
private predicate nodeCandFwd(Node n) {
  dispatchOrigin(n.asExpr(), _, _)
  or
  exists(Node mid | nodeCandFwd(mid) | flowStep(mid, n) or callFlowStepCand(mid, n))
}

/**
 * Holds if `n` may occur on a dispatch flow path. That is, a path from a
 * relevant `ClassInstanceExpr` to a qualifier of a relevant `MethodAccess`.
 */
private predicate nodeCand(Node n) {
  exists(MethodAccess ma |
    dispatchOrigin(_, ma, _) and
    n = getInstanceArgument(ma) and
    nodeCandFwd(n)
  )
  or
  exists(Node mid | nodeCand(mid) | flowStep(n, mid) or callFlowStepCand(n, mid)) and
  nodeCandFwd(n)
}

/**
 * Holds if `n1 -> n2` is a relevant dispatch flow step.
 */
private predicate step(Node n1, Node n2) {
  (flowStep(n1, n2) or callFlowStepCand(n1, n2)) and
  nodeCand(n1) and
  nodeCand(n2)
}

private predicate stepPlus(Node n1, Node n2) = fastTC(step/2)(n1, n2)

/**
 * Holds if there is flow from a `ClassInstanceExpr` instantiating a type that
 * declares or inherits the tracked method `m` to the qualifier of `ma` such
 * that `ma` may dispatch to `m`.
 */
pragma[inline]
private predicate hasDispatchFlow(MethodAccess ma, Method m) {
  exists(ClassInstanceExpr cie |
    dispatchOrigin(cie, ma, m) and
    stepPlus(exprNode(cie), getInstanceArgument(ma))
  )
}

/**
 * Gets a viable dispatch target for `ma`. This is the output dispatch relation.
 */
Method viableImpl_out(MethodAccess ma) {
  result = viableImpl_inp(ma) and
  (hasDispatchFlow(ma, result) or not dispatchOrigin(_, ma, result))
}
