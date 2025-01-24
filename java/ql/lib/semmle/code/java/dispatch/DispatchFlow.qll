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
private import semmle.code.java.dataflow.internal.DataFlowUtil as DataFlow
private import semmle.code.java.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import semmle.code.java.dataflow.InstanceAccess
private import semmle.code.java.Collections
private import semmle.code.java.Maps
private import codeql.typetracking.TypeTracking

/**
 * Gets a viable dispatch target for `ma`. This is the input dispatch relation.
 */
private Method viableImpl_inp(MethodCall ma) { result = viableImpl_v2(ma) }

private Callable dispatchCand(Call c) {
  c instanceof ConstructorCall and result = c.getCallee().getSourceDeclaration()
  or
  result = viableImpl_inp(c) and
  not dispatchOrigin(_, c, result)
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
    cie.getConstructedType().getSourceDeclaration() = t and
    publicStaticFieldInit(cie)
  )
}

/**
 * Holds if `t` and its subtypes are private or anonymous.
 */
private predicate privateConstruction(SrcRefType t) {
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
private predicate dispatchOrigin(ClassInstanceExpr cie, MethodCall ma, Method m) {
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
private class RelevantNode extends DataFlow::Node {
  RelevantNode() { relevant(this.getType()) }
}

private module TypeTrackingSteps {
  class Node = RelevantNode;

  class LocalSourceNode extends RelevantNode {
    LocalSourceNode() {
      this.asExpr() instanceof Call or
      this.asExpr() instanceof VarRead or
      this instanceof DataFlow::ParameterNode or
      this instanceof DataFlow::ImplicitVarargsArray or
      this.asExpr() instanceof ArrayInit or
      this.asExpr() instanceof ArrayAccess or
      this instanceof DataFlow::FieldValueNode
    }
  }

  private newtype TContent =
    ContentArray() or
    ContentArrayArray()

  class Content extends TContent {
    string toString() {
      this = ContentArray() and result = "array"
      or
      this = ContentArrayArray() and result = "array array"
    }
  }

  class ContentFilter extends Content {
    Content getAMatchingContent() { result = this }
  }

  predicate compatibleContents(Content storeContents, Content loadContents) {
    storeContents = loadContents
  }

  predicate simpleLocalSmallStep(Node n1, Node n2) {
    exists(BaseSsaVariable v, BaseSsaVariable def |
      def.(BaseSsaUpdate).getDefiningExpr().(VariableAssign).getSource() = n1.asExpr()
      or
      def.(BaseSsaImplicitInit).isParameterDefinition(n1.asParameter())
    |
      v.getAnUltimateDefinition() = def and
      v.getAUse() = n2.asExpr()
    )
    or
    exists(Callable c | n1.(DataFlow::InstanceParameterNode).getCallable() = c |
      exists(InstanceAccess ia |
        ia = n2.asExpr() and ia.getEnclosingCallable() = c and ia.isOwnInstanceAccess()
      )
      or
      n2.(DataFlow::ImplicitInstanceAccess)
          .getInstanceAccess()
          .(OwnInstanceAccess)
          .getEnclosingCallable() = c
    )
    or
    n2.asExpr().(CastingExpr).getExpr() = n1.asExpr()
    or
    n2.asExpr().(ChooseExpr).getAResultExpr() = n1.asExpr()
    or
    n2.asExpr().(AssignExpr).getSource() = n1.asExpr()
    or
    n2.asExpr().(ArrayCreationExpr).getInit() = n1.asExpr()
  }

  predicate levelStepNoCall(Node n1, LocalSourceNode n2) {
    exists(EnumType enum, Method getValue |
      enum.getAnEnumConstant().getAnAssignedValue() = n1.asExpr() and
      getValue.getDeclaringType() = enum and
      getValue.hasName("valueOf") and
      n2.asExpr().(MethodCall).getMethod() = getValue
    )
    or
    exists(Variable v, MethodCall put, MethodCall get |
      put.getArgument(1) = n1.asExpr() and
      put.getMethod().(MapMethod).hasName("put") and
      put.getQualifier() = v.getAnAccess() and
      get.getQualifier() = v.getAnAccess() and
      get.getMethod().(MapMethod).hasName("get") and
      n2.asExpr() = get
    )
    or
    exists(Variable v, MethodCall add |
      add.getAnArgument() = n1.asExpr() and
      add.getMethod().(CollectionMethod).hasName("add") and
      add.getQualifier() = v.getAnAccess()
    |
      exists(MethodCall get |
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

  predicate levelStepCall(Node n1, LocalSourceNode n2) { none() }

  predicate storeStep(Node n1, Node n2, Content f) {
    exists(EnumType enum, Method getValue |
      enum.getAnEnumConstant().getAnAssignedValue() = n1.asExpr() and
      getValue.getDeclaringType() = enum and
      getValue.hasName("values") and
      n2.asExpr().(MethodCall).getMethod() = getValue and
      f = ContentArray()
    )
    or
    n2.asExpr().(ArrayInit).getAnInit() = n1.asExpr() and
    f = ContentArray()
    or
    exists(Argument arg |
      n1.asExpr() = arg and
      arg.isVararg() and
      n2.(DataFlow::ImplicitVarargsArray).getCall() = arg.getCall() and
      f = ContentArray()
    )
    or
    exists(AssignExpr a, Variable v |
      a.getSource() = n1.asExpr() and
      a.getDest().(ArrayAccess).getArray() = v.getAnAccess() and
      n2.asExpr() = v.getAnAccess().(VarRead) and
      f = ContentArray()
    )
  }

  predicate loadStep(Node n1, LocalSourceNode n2, Content f) {
    exists(BaseSsaVariable v, BaseSsaVariable def |
      exists(EnhancedForStmt for |
        for.getVariable() = def.(BaseSsaUpdate).getDefiningExpr() and
        for.getExpr() = n1.asExpr() and
        n1.getType() instanceof Array and
        f = ContentArray()
      )
    |
      v.getAnUltimateDefinition() = def and
      v.getAUse() = n2.asExpr()
    )
    or
    n2.asExpr().(ArrayAccess).getArray() = n1.asExpr()
  }

  predicate loadStoreStep(Node nodeFrom, Node nodeTo, Content f1, Content f2) {
    loadStep(nodeFrom, nodeTo, ContentArray()) and
    f1 = ContentArrayArray() and
    f2 = ContentArray()
    or
    storeStep(nodeFrom, nodeTo, ContentArray()) and
    f1 = ContentArray() and
    f2 = ContentArrayArray()
  }

  predicate withContentStep(Node nodeFrom, LocalSourceNode nodeTo, ContentFilter f) { none() }

  predicate withoutContentStep(Node nodeFrom, LocalSourceNode nodeTo, ContentFilter f) { none() }

  predicate jumpStep(Node n1, LocalSourceNode n2) {
    n2.(DataFlow::FieldValueNode).getField().getAnAssignedValue() = n1.asExpr()
    or
    n2.asExpr().(FieldRead).getField() = n1.(DataFlow::FieldValueNode).getField()
  }

  predicate hasFeatureBacktrackStoreTarget() { none() }
}

private predicate lambdaSource(RelevantNode n) { dispatchOrigin(n.asExpr(), _, _) }

private predicate lambdaSink(RelevantNode n) {
  exists(MethodCall ma | dispatchOrigin(_, ma, _) | n = DataFlow::getInstanceArgument(ma))
}

private signature Method methodDispatchSig(MethodCall ma);

private module TrackLambda<methodDispatchSig/1 lambdaDispatch0> {
  private Callable dispatch(Call c) {
    result = dispatchCand(c) or
    result = lambdaDispatch0(c)
  }

  /**
   * Holds if `p` is the `i`th parameter of a viable dispatch target of `call`.
   * The instance parameter is considered to have index `-1`.
   */
  pragma[nomagic]
  private predicate paramCand(Call call, int i, DataFlow::ParameterNode p) {
    exists(DataFlowPrivate::DataFlowCallable callable |
      callable.asCallable() = dispatch(call) and
      p.isParameterOf(callable, i) and
      p instanceof RelevantNode
    )
  }

  /**
   * Holds if `arg` is a possible argument to `p` taking virtual dispatch into account.
   */
  private predicate argParamCand(DataFlowPrivate::ArgumentNode arg, DataFlow::ParameterNode p) {
    exists(int i, DataFlowPrivate::DataFlowCall call |
      paramCand(call.asCall(), i, p) and
      arg.argumentOf(call, i)
    )
  }

  private module TtInput implements TypeTrackingInput<Location> {
    import TypeTrackingSteps

    predicate callStep(Node n1, LocalSourceNode n2) { argParamCand(n1, n2) }

    predicate returnStep(Node n1, LocalSourceNode n2) {
      exists(ReturnStmt ret, Method m |
        ret.getEnclosingCallable() = m and
        ret.getResult() = n1.asExpr() and
        m = dispatch(n2.asExpr())
      )
    }
  }

  private import TypeTracking<Location, TtInput>::TypeTrack<lambdaSource/1>::Graph<lambdaSink/1>

  private predicate edgePlus(PathNode n1, PathNode n2) = fastTC(edges/2)(n1, n2)

  private predicate pairCand(PathNode p1, PathNode p2, Method m, MethodCall ma) {
    exists(ClassInstanceExpr cie |
      dispatchOrigin(cie, ma, m) and
      p1.getNode() = DataFlow::exprNode(cie) and
      p2.getNode() = DataFlow::getInstanceArgument(ma) and
      p1.isSource() and
      p2.isSink()
    )
  }

  /**
   * Holds if there is flow from a `ClassInstanceExpr` instantiating a type that
   * declares or inherits the tracked method `result` to the qualifier of `ma` such
   * that `ma` may dispatch to `result`.
   */
  Method lambdaDispatch(MethodCall ma) {
    exists(PathNode p1, PathNode p2 |
      (p1 = p2 or edgePlus(p1, p2)) and
      pairCand(p1, p2, result, ma)
    )
  }
}

private Method noDisp(MethodCall ma) { none() }

pragma[nomagic]
private Method d1(MethodCall ma) { result = TrackLambda<noDisp/1>::lambdaDispatch(ma) }

pragma[nomagic]
private Method d2(MethodCall ma) { result = TrackLambda<d1/1>::lambdaDispatch(ma) }

pragma[nomagic]
private Method d3(MethodCall ma) { result = TrackLambda<d2/1>::lambdaDispatch(ma) }

pragma[nomagic]
private Method d4(MethodCall ma) { result = TrackLambda<d3/1>::lambdaDispatch(ma) }

pragma[nomagic]
private Method d5(MethodCall ma) { result = TrackLambda<d4/1>::lambdaDispatch(ma) }

pragma[nomagic]
private Method d6(MethodCall ma) { result = TrackLambda<d5/1>::lambdaDispatch(ma) }

/**
 * Gets a viable dispatch target for `ma`. This is the output dispatch relation.
 */
Method viableImpl_out(MethodCall ma) {
  result = viableImpl_inp(ma) and
  (result = d6(ma) or not dispatchOrigin(_, ma, result))
}
