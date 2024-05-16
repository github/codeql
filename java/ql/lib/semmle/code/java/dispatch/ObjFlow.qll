/**
 * Provides a dispatch relation `viableImpl_out` that reduces the set of
 * dispatch targets for `Object.toString()` calls relative to the input
 * dispatch relation `viableImpl_inp`.
 *
 * The set of dispatch targets for `Object.toString()` calls are reduced based
 * on possible data flow from objects of more specific types to the qualifier.
 */

import java
private import VirtualDispatch
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.dataflow.internal.BaseSSA
private import semmle.code.java.dataflow.internal.DataFlowUtil
private import semmle.code.java.dataflow.internal.DataFlowPrivate
private import semmle.code.java.dataflow.internal.ContainerFlow
private import semmle.code.java.dataflow.InstanceAccess
private import semmle.code.java.dispatch.internal.Unification

/**
 * Gets a viable dispatch target for `ma`. This is the input dispatch relation.
 */
private Method viableImpl_inp(MethodCall ma) { result = viableImpl_v3(ma) }

private Callable dispatchCand(Call c) {
  c instanceof ConstructorCall and result = c.getCallee().getSourceDeclaration()
  or
  result = viableImpl_inp(c)
}

/**
 * Holds if `p` is the `i`th parameter of a viable dispatch target of `call`.
 * The instance parameter is considered to have index `-1`.
 */
pragma[nomagic]
private predicate viableParam(Call call, int i, ParameterNode p) {
  exists(DataFlowCallable callable |
    callable.asCallable() = dispatchCand(call) and
    p.isParameterOf(callable, i)
  )
}

/**
 * Holds if `arg` is a possible argument to `p` taking virtual dispatch into account.
 */
private predicate viableArgParam(ArgumentNode arg, ParameterNode p) {
  exists(int i, DataFlowCall call |
    viableParam(call.asCall(), i, p) and
    arg.argumentOf(call, i)
  )
}

private predicate returnStep(Node n1, Node n2) {
  exists(ReturnStmt ret, Method m |
    ret.getEnclosingCallable() = m and
    ret.getResult() = n1.asExpr() and
    pragma[only_bind_out](m) = dispatchCand(n2.asExpr())
  )
}

/**
 * Holds if data may flow from `n1` to `n2` in a single step through a call or a return.
 */
private predicate callFlowStep(Node n1, Node n2) {
  returnStep(n1, n2) or
  viableArgParam(n1, n2)
}

/**
 * Holds if data may flow from `n1` to `n2` in a single step through local
 * flow, calls, returns, fields, array reads or writes, or container taint steps.
 */
private predicate step(Node n1, Node n2) {
  exists(BaseSsaVariable v, BaseSsaVariable def |
    def.(BaseSsaUpdate).getDefiningExpr().(VariableAssign).getSource() = n1.asExpr()
    or
    def.(BaseSsaImplicitInit).isParameterDefinition(n1.asParameter())
    or
    exists(EnhancedForStmt for |
      for.getVariable() = def.(BaseSsaUpdate).getDefiningExpr() and
      for.getExpr() = n1.asExpr()
    )
  |
    v.getAnUltimateDefinition() = def and
    v.getAUse() = n2.asExpr()
  )
  or
  baseSsaAdjacentUseUse(n1.asExpr(), n2.asExpr())
  or
  exists(Callable c | n1.(InstanceParameterNode).getCallable() = c |
    exists(InstanceAccess ia |
      ia = n2.asExpr() and ia.getEnclosingCallable() = c and ia.isOwnInstanceAccess()
    )
    or
    n2.(ImplicitInstanceAccess).getInstanceAccess().(OwnInstanceAccess).getEnclosingCallable() = c
  )
  or
  n2.(FieldValueNode).getField().getAnAssignedValue() = n1.asExpr()
  or
  n2.asExpr().(FieldRead).getField() = n1.(FieldValueNode).getField()
  or
  n2.asExpr().(CastingExpr).getExpr() = n1.asExpr()
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
  exists(AssignExpr a, Field v |
    a.getSource() = n1.asExpr() and
    a.getDest().(ArrayAccess).getArray() = v.getAnAccess() and
    n2.asExpr() = v.getAnAccess().(VarRead)
  )
  or
  exists(AssignExpr a |
    a.getSource() = n1.asExpr() and
    a.getDest().(ArrayAccess).getArray() = n2.asExpr()
  )
  or
  callFlowStep(n1, n2) and not containerStep(_, n2.asExpr())
  or
  containerStep(n1.asExpr(), n2.asExpr())
  or
  exists(Field v |
    containerStep(n1.asExpr(), v.getAnAccess()) and
    n2.(FieldValueNode).getField() = v
  )
}

/**
 * Gets the type contained by `t` in the sense of element types of arrays and
 * collections and upper bounds of type variables and wildcards.
 *
 * For example, given `Collection<? extends Foo[]>` the type `Foo` is returned.
 */
private RefType getContainedType(RefType t) {
  not t instanceof Array and
  not t instanceof ContainerType and
  not t instanceof BoundedType and
  result = t
  or
  result = getContainedType(t.(Array).getElementType())
  or
  result = getContainedType(t.(ContainerType).getElementType())
  or
  result = getContainedType(t.(BoundedType).getFirstUpperBoundType())
}

/**
 * Holds if `t` can carry a value for which `t` reveals no type information,
 * possibly nested in an array or container.
 */
private predicate containsObj(RefType t) {
  t instanceof TypeObject
  or
  exists(RefType r | containsObj(r) and t = r.getASourceSupertype())
  or
  containsObj(getContainedType(t))
}

/**
 * A node that can carry a value for which the static type reveals no type
 * information other than `Object`.
 */
private class ObjNode extends Node {
  ObjNode() { containsObj(this.getTypeBound()) }
}

private predicate objStep(ObjNode n1, ObjNode n2) { step(n1, n2) }

/**
 * Holds if `n` has discarded the type information `t`.
 */
private predicate source(RefType t, ObjNode n) {
  exists(Node n1, RefType nt |
    not n1 instanceof ObjNode and
    nt = n1.getTypeBound() and
    step(n1, n) and
    t = getContainedType(nt)
  )
}

/**
 * Holds if `n` is the qualifier of an `Object.toString()` call.
 */
private predicate sink(ObjNode n) {
  exists(MethodCall toString |
    toString.getQualifier() = n.asExpr() and
    toString.getMethod() instanceof ToStringMethod
  ) and
  n.getTypeBound().getErasure() instanceof TypeObject
}

private predicate relevantNodeBack(ObjNode n) {
  sink(n)
  or
  exists(ObjNode mid | objStep(n, mid) and relevantNodeBack(mid))
}

private predicate relevantNode(ObjNode n) {
  source(_, n) and relevantNodeBack(n)
  or
  exists(ObjNode mid | relevantNode(mid) and objStep(mid, n) and relevantNodeBack(n))
}

pragma[noinline]
private predicate objStepPruned(ObjNode n1, ObjNode n2) {
  objStep(n1, n2) and relevantNode(n1) and relevantNode(n2)
}

private predicate stepPlus(Node n1, Node n2) = fastTC(objStepPruned/2)(n1, n2)

/**
 * Holds if the qualifier `n` of an `Object.toString()` call might have type `t`.
 */
pragma[noopt]
private predicate objType(ObjNode n, RefType t) {
  exists(ObjNode n2 |
    sink(n) and
    (stepPlus(n2, n) or n2 = n) and
    source(t, n2)
  )
}

private VirtualMethodCall objectToString(ObjNode n) {
  result.getQualifier() = n.asExpr() and sink(n)
}

/**
 * Holds if `ma` is an `Object.toString()` call taking possibly improved type
 * bounds into account.
 */
predicate objectToStringCall(VirtualMethodCall ma) { ma = objectToString(_) }

/**
 * Holds if the qualifier of the `Object.toString()` call `ma` might have type `t`.
 */
private predicate objectToStringQualType(MethodCall ma, RefType t) {
  exists(ObjNode n | ma = objectToString(n) and objType(n, t))
}

private Method viableImplObjectToString(MethodCall ma) {
  exists(Method def, RefType t |
    objectToStringQualType(ma, t) and
    def = ma.getMethod() and
    exists(RefType t2 |
      result = viableMethodImpl(def, t.getSourceDeclaration(), t2) and
      not Unification::failsUnification(t, t2)
    )
  )
}

/**
 * Gets a viable dispatch target for `ma`. This is the output dispatch relation.
 *
 * The set of dispatch targets for `Object.toString()` calls are reduced based
 * on possible data flow from objects of more specific types to the qualifier.
 */
Method viableImpl_out(MethodCall ma) {
  result = viableImpl_inp(ma) and
  (
    result = viableImplObjectToString(ma) or
    not ma = objectToString(_)
  )
}

private predicate unificationTargetLeft(ParameterizedType t1) { objectToStringQualType(_, t1) }

private predicate unificationTargetRight(ParameterizedType t2) {
  exists(viableMethodImpl(_, _, t2))
}

private module Unification = MkUnification<unificationTargetLeft/1, unificationTargetRight/1>;
