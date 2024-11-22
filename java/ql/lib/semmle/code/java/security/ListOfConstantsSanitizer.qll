/**
 * Provides a default taint sanitizer identifying comparisons against lists of
 * compile-time constants.
 */

import java
private import codeql.typeflow.UniversalFlow as UniversalFlow
private import semmle.code.java.Collections
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.dataflow.internal.BaseSSA
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.dataflow.TypeFlow
private import semmle.code.java.dispatch.VirtualDispatch

private class FlowNode = FlowStepsInput::FlowNode;

/**
 * Holds if `n2` is an unmodifiable collection constructed from input `n1`,
 * which is either another collection or a number of elements.
 */
private predicate unmodifiableCollectionStep(FlowNode n1, FlowNode n2) {
  exists(Call c, Callable tgt |
    n2.asExpr() = c and
    n1.asExpr() = c.getAnArgument() and
    c.getCallee().getSourceDeclaration() = tgt
  |
    tgt.hasQualifiedName("java.util", "Collections",
      ["unmodifiableCollection", "unmodifiableList", "unmodifiableSet"])
    or
    tgt.hasQualifiedName("java.util", ["List", "Set"], ["copyOf", "of"])
    or
    tgt.hasQualifiedName("com.google.common.collect", ["ImmutableList", "ImmutableSet"],
      ["copyOf", "of"])
  )
}

/**
 * Holds if `n2` is a collection or array constructed from input `n1`, which is
 * either a collection, an array, or a number of elements.
 */
private predicate collectionStep(FlowNode n1, FlowNode n2) {
  n2.asExpr().(ArrayInit).getAnInit() = n1.asExpr()
  or
  n2.asExpr().(ArrayCreationExpr).getInit() = n1.asExpr()
  or
  unmodifiableCollectionStep(n1, n2)
  or
  exists(Call c, Callable tgt |
    n2.asExpr() = c and
    n1.asExpr() = c.getAnArgument() and
    c.getCallee().getSourceDeclaration() = tgt
  |
    tgt.hasQualifiedName("java.util", "Arrays", "asList")
    or
    tgt.isStatic() and
    tgt.hasName(["copyOf", "of"]) and
    tgt.getDeclaringType().getASourceSupertype+().hasQualifiedName("java.util", "Collection")
    or
    tgt instanceof Constructor and
    tgt.getNumberOfParameters() = 1 and
    tgt.getParameterType(0) instanceof CollectionType and
    tgt.getDeclaringType() instanceof CollectionType
  )
}

private module BaseUniversalFlow = UniversalFlow::Make<Location, FlowStepsInput>;

private module UnmodifiableProp implements BaseUniversalFlow::NullaryPropertySig {
  predicate hasPropertyBase(FlowNode n) { unmodifiableCollectionStep(_, n) }
}

/** Holds if the given node is an unmodifiable collection. */
private predicate unmodifiableCollection =
  BaseUniversalFlow::FlowNullary<UnmodifiableProp>::hasProperty/1;

/**
 * Holds if `v` is a collection or array with an access, `coll`, at which the
 * element `e` gets added.
 */
private predicate collectionAddition(Variable v, VarAccess coll, Expr e) {
  exists(MethodCall mc, Method m, int arg |
    mc.getMethod().getSourceDeclaration().overridesOrInstantiates*(m) and
    mc.getQualifier() = coll and
    v.getAnAccess() = coll and
    mc.getArgument(arg) = e
  |
    m.hasQualifiedName("java.util", "Collection", ["add", "addAll"]) and
    m.getNumberOfParameters() = 1 and
    arg = 0
    or
    m.hasQualifiedName("java.util", "List", ["add", "addAll"]) and
    m.getNumberOfParameters() = 2 and
    arg = 1
    or
    m.hasQualifiedName("java.util", "SequencedCollection", ["addFirst", "addLast"]) and
    m.getNumberOfParameters() = 1 and
    arg = 0
  )
  or
  v.getAnAccess() = coll and
  exists(Assignment assign | assign.getSource() = e |
    coll = assign.getDest().(ArrayAccess).getArray()
  )
}

/**
 * Holds if `n` represents a definition of `v` and `v` is a collection or
 * array that has additions occurring as side-effects after its definition.
 */
private predicate nodeWithAddition(FlowNode n, Variable v) {
  collectionAddition(v, _, _) and
  (
    n.asField() = v
    or
    n.asSsa().getSourceVariable().getVariable() = v and
    (n.asSsa() instanceof BaseSsaUpdate or n.asSsa().(BaseSsaImplicitInit).isParameterDefinition(_))
  )
}

/** Holds if `c` does not add elements to the given collection. */
private predicate safeCallable(Callable c) {
  c instanceof CollectionQueryMethod
  or
  c instanceof CollectionMethod and
  c.hasName(["clear", "remove", "removeAll", "stream", "iterator", "toArray"])
  or
  c.hasQualifiedName("org.apache.commons.lang3", "StringUtils", "join")
}

/**
 * Holds if `n` might be mutated in ways that adds elements that are not
 * tracked by the `collectionAddition` predicate.
 */
private predicate collectionWithPossibleMutation(FlowNode n) {
  not unmodifiableCollection(n) and
  (
    exists(Expr e |
      n.asExpr() = e and
      (e.getType() instanceof CollectionType or e.getType() instanceof Array) and
      not collectionAddition(_, e, _) and
      not collectionStep(n, _)
    |
      exists(ArrayAccess aa | e = aa.getArray())
      or
      exists(Call c, Callable tgt | c.getAnArgument() = e or c.getQualifier() = e |
        tgt = c.getCallee().getSourceDeclaration() and
        not safeCallable(tgt)
      )
    )
    or
    exists(FlowNode mid |
      FlowStepsInput::step(n, mid) and
      collectionWithPossibleMutation(mid)
    )
  )
}

/**
 * A collection constructor that constructs an empty mutable collection.
 */
private class EmptyCollectionConstructor extends Constructor {
  EmptyCollectionConstructor() {
    this.getDeclaringType() instanceof CollectionType and
    forall(Type t | t = this.getAParamType() | t instanceof PrimitiveType)
  }
}

private module CollectionFlowStepsInput implements UniversalFlow::UniversalFlowInput<Location> {
  import FlowStepsInput

  /**
   * Holds if `n2` is a collection/array/constant whose value(s) are
   * determined completely from the range of `n1` nodes.
   */
  predicate step(FlowNode n1, FlowNode n2) {
    // Exclude the regular input constraints for those nodes that are covered
    // completely by `collectionStep`.
    FlowStepsInput::step(n1, n2) and
    not collectionStep(_, n2)
    or
    // For collections with side-effects in the form of additions, we add the
    // sources of those additions as additional input that need to originate
    // from constants.
    exists(Variable v |
      nodeWithAddition(n2, v) and
      collectionAddition(v, _, n1.asExpr())
    )
    or
    // Include various forms of collection transformation.
    collectionStep(n1, n2)
  }

  predicate isExcludedFromNullAnalysis = FlowStepsInput::isExcludedFromNullAnalysis/1;
}

private module CollectionUniversalFlow = UniversalFlow::Make<Location, CollectionFlowStepsInput>;

private module ConstantCollectionProp implements CollectionUniversalFlow::NullaryPropertySig {
  /**
   * Holds if `n` forms the base case for finding collections of constants.
   * These are individual constants and empty collections.
   */
  predicate hasPropertyBase(FlowNode n) {
    n.asExpr().isCompileTimeConstant() or
    n.asExpr().(ConstructorCall).getConstructor() instanceof EmptyCollectionConstructor
  }

  predicate barrier = collectionWithPossibleMutation/1;
}

/**
 * Holds if the given node is either a constant or a collection/array of
 * constants.
 */
private predicate constantCollection =
  CollectionUniversalFlow::FlowNullary<ConstantCollectionProp>::hasProperty/1;

/** Gets the result of a case normalization call of `arg`. */
private MethodCall normalizeCaseCall(Expr arg) {
  exists(Method changecase | result.getMethod() = changecase |
    changecase.hasName(["toUpperCase", "toLowerCase"]) and
    changecase.getDeclaringType() instanceof TypeString and
    arg = result.getQualifier()
    or
    changecase
        .hasQualifiedName(["org.apache.commons.lang", "org.apache.commons.lang3"], "StringUtils",
          ["lowerCase", "upperCase"]) and
    arg = result.getArgument(0)
    or
    changecase
        .hasQualifiedName("org.apache.hadoop.util", "StringUtils", ["toLowerCase", "toUpperCase"]) and
    arg = result.getArgument(0)
  )
}

/**
 * Holds if the guard `g` ensures that the expression `e` is one of a set of
 * known constants upon evaluating to `branch`.
 */
private predicate constantCollectionContainsCheck(Guard g, Expr e, boolean branch) {
  exists(MethodCall mc, Method m, FlowNode n, Expr checked |
    g = mc and
    mc.getMethod().getSourceDeclaration().overridesOrInstantiates*(m) and
    m.hasQualifiedName("java.util", "Collection", "contains") and
    n.asExpr() = mc.getQualifier() and
    constantCollection(n) and
    checked = mc.getAnArgument() and
    branch = true
  |
    checked = e or
    checked = normalizeCaseCall(e)
  )
}

/**
 * A comparison against a list of compile-time constants, sanitizing taint by
 * restricting to a set of known values.
 */
private class ListOfConstantsComparisonSanitizerGuard extends TaintTracking::DefaultTaintSanitizer {
  ListOfConstantsComparisonSanitizerGuard() {
    this = DataFlow::BarrierGuard<constantCollectionContainsCheck/3>::getABarrierNode()
  }
}
