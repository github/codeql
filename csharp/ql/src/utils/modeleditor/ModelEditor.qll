/** Provides classes and predicates related to handling APIs for the VS Code extension. */

private import csharp
private import semmle.code.csharp.dataflow.FlowSummary
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.csharp.frameworks.Test
private import Telemetry.TestLibrary

/** Holds if the given callable is not worth supporting. */
private predicate isUninteresting(Callable c) {
  c.getDeclaringType() instanceof TestLibrary or
  c.(Constructor).isParameterless() or
  c.getDeclaringType() instanceof AnonymousClass
}

/**
 * A callable method or accessor from either the C# Standard Library, a 3rd party library, or from the source.
 */
class Endpoint extends Callable {
  Endpoint() {
    [this.(Modifiable), this.(Accessor).getDeclaration()].isEffectivelyPublic() and
    not isUninteresting(this) and
    this.isUnboundDeclaration()
  }

  /**
   * Gets the namespace of this endpoint.
   */
  bindingset[this]
  string getNamespace() { this.getDeclaringType().hasQualifiedName(result, _) }

  /**
   * Gets the unbound type name of this endpoint.
   */
  bindingset[this]
  string getTypeName() { result = nestedName(this.getDeclaringType().getUnboundDeclaration()) }

  /**
   * Gets the parameter types of this endpoint.
   */
  bindingset[this]
  string getParameterTypes() { result = "(" + parameterQualifiedTypeNamesToString(this) + ")" }

  private string getDllName() { result = this.getLocation().(Assembly).getName() }

  private string getDllVersion() { result = this.getLocation().(Assembly).getVersion().toString() }

  string dllName() {
    result = this.getDllName()
    or
    not exists(this.getDllName()) and result = this.getFile().getBaseName()
  }

  string dllVersion() {
    result = this.getDllVersion()
    or
    not exists(this.getDllVersion()) and result = ""
  }

  /** Holds if this API has a supported summary. */
  pragma[nomagic]
  predicate hasSummary() { this instanceof SummarizedCallable }

  /** Holds if this API is a known source. */
  pragma[nomagic]
  abstract predicate isSource();

  /** Holds if this API is a known sink. */
  pragma[nomagic]
  abstract predicate isSink();

  /** Holds if this API is a known neutral. */
  pragma[nomagic]
  predicate isNeutral() { this instanceof FlowSummaryImpl::Public::NeutralCallable }

  /**
   * Holds if this API is supported by existing CodeQL libraries, that is, it is either a
   * recognized source, sink or neutral or it has a flow summary.
   */
  predicate isSupported() {
    this.hasSummary() or this.isSource() or this.isSink() or this.isNeutral()
  }
}

boolean isSupported(Endpoint endpoint) {
  if endpoint.isSupported() then result = true else result = false
}

string supportedType(Endpoint endpoint) {
  endpoint.isSink() and result = "sink"
  or
  endpoint.isSource() and result = "source"
  or
  endpoint.hasSummary() and result = "summary"
  or
  endpoint.isNeutral() and result = "neutral"
  or
  not endpoint.isSupported() and result = ""
}

string methodClassification(Call method) {
  method.getFile() instanceof TestFile and result = "test"
  or
  not method.getFile() instanceof TestFile and
  result = "source"
}

/**
 * Gets the nested name of the type `t`.
 *
 * If the type is not a nested type, the result is the same as `getName()`.
 * Otherwise the name of the nested type is prefixed with a `+` and appended to
 * the name of the enclosing type, which might be a nested type as well.
 */
private string nestedName(Type t) {
  not exists(t.getDeclaringType().getUnboundDeclaration()) and
  result = t.getName()
  or
  nestedName(t.getDeclaringType().getUnboundDeclaration()) + "+" + t.getName() = result
}
