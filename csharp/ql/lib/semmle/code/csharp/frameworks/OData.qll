/**
 * Provides taint modeling for `Microsoft.AspNet.OData`/`Microsoft.AspNetCore.OData`
 * (and the older `System.Web.Http.OData`) OData action parameter binding.
 *
 * OData actions receive their untrusted payload in one of two shapes that
 * bypass the usual "type used as an action-method parameter" taint modeling:
 *
 * - `ODataActionParameters`, an untyped `Dictionary<string, object>` whose
 *   values are cast, `as`-converted, or type-tested to arbitrary model types
 *   by the action method body.
 * - `Delta<T>`, a change-tracking wrapper for PATCH/PUT requests, whose
 *   tracked property values are exposed via `GetInstance()` or copied onto an
 *   existing entity via `Patch`/`Put`/`CopyChangedValues`/`CopyUnchangedValues`.
 *
 * In both cases the type that ends up holding the client-controlled data has
 * no static relationship to the action method's parameter types, so its
 * members need to be taint-tracked explicitly.
 */

import csharp
private import semmle.code.csharp.commons.Collections
private import semmle.code.csharp.dataflow.FlowSteps
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.security.dataflow.flowsources.Remote

/** The `ODataActionParameters` dictionary type, across OData library versions. */
class ODataActionParametersClass extends Class {
  ODataActionParametersClass() {
    this.hasFullyQualifiedName("Microsoft.AspNet.OData", "ODataActionParameters") or
    this.hasFullyQualifiedName("Microsoft.AspNetCore.OData.Formatter", "ODataActionParameters") or
    this.hasFullyQualifiedName("System.Web.Http.OData", "ODataActionParameters")
  }
}

/** An indexer read on an `ODataActionParameters` dictionary, e.g. `parameters["Foo"]`. */
class ODataActionParameterRead extends ElementAccess {
  ODataActionParameterRead() { this.getQualifier().getType() instanceof ODataActionParametersClass }
}

/** Holds if `e` may (locally) hold the value of an `ODataActionParameters` entry. */
private predicate isODataParameterValue(Expr e) {
  TaintTracking::localExprTaint(any(ODataActionParameterRead r), e)
}

/** The generic `Delta<TStructuralType>` change-tracking class, across OData library versions. */
class DeltaClass extends UnboundGenericClass {
  DeltaClass() {
    this.getNumberOfTypeParameters() = 1 and
    (
      this.hasFullyQualifiedName("Microsoft.AspNet.OData", "Delta`1") or
      this.hasFullyQualifiedName("Microsoft.AspNetCore.OData.Deltas", "Delta`1")
    )
  }
}

/**
 * A type that a value read out of `ODataActionParameters` is cast, `as`-converted,
 * or type-tested to -- directly, or wrapped in a collection (`List<T>`,
 * `IEnumerable<T>`, arrays, ...) -- or a type that is tracked by a `Delta<T>`.
 */
class ODataBoundType extends ValueOrRefType {
  ODataBoundType() {
    exists(Cast c | isODataParameterValue(c.getExpr()) |
      this = c.getTargetType() or
      this = c.getTargetType().(CollectionType).getElementType() or
      this = c.getTargetType().(ParamsCollectionType).getElementType()
    )
    or
    exists(IsExpr ie, Type t |
      isODataParameterValue(ie.getExpr()) and
      t = ie.getPattern().(TypePatternExpr).getCheckedType()
    |
      this = t or
      this = t.(CollectionType).getElementType() or
      this = t.(ParamsCollectionType).getElementType()
    )
    or
    this = any(ConstructedClass c | c.getUnboundGeneric() instanceof DeltaClass).getTypeArgument(0)
  }
}

/** The `Patch`, `Put`, `CopyChangedValues`, and `CopyUnchangedValues` methods on `Delta<T>`. */
class DeltaMutatingMethod extends Method {
  DeltaMutatingMethod() {
    this.getDeclaringType() instanceof DeltaClass and
    this.hasName(["Patch", "Put", "CopyChangedValues", "CopyUnchangedValues"])
  }
}

/**
 * Taint members (transitively) on types used in
 * 1. Casts, `as`-conversions, or type tests applied to `ODataActionParameters` values.
 * 2. The type argument of a `Delta<T>`.
 *
 * Note that this also impacts uses of such types in other contexts, the same
 * trade-off `AspNetRemoteFlowSourceMember` (`Remote.qll`) makes for ASP.NET
 * action-method parameters.
 */
private class ODataBoundMember extends TaintTracking::TaintedMember, CandidateMemberToTaint {
  ODataBoundMember() {
    exists(Type t, Type t0 | t = this.getDeclaringType() |
      (t = t0 or t = t0.(CollectionType).getElementType()) and
      (
        t0 = any(ODataBoundMember m).getType()
        or
        t0 instanceof ODataBoundType
      )
    )
  }
}

/**
 * A call to `Delta<T>.Patch`/`Put`/`CopyChangedValues`/`CopyUnchangedValues`
 * copies the changes tracked by the `Delta<T>` receiver onto its `original`
 * entity argument.
 */
private class DeltaMutatingCallTaintStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodCall mc |
      mc.getTarget().getUnboundDeclaration() instanceof DeltaMutatingMethod and
      node1.asExpr() = mc.getQualifier() and
      node2.(PostUpdateNode).getPreUpdateNode().asExpr() = mc.getArgument(0)
    )
  }
}
