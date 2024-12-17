/** Provides classes and predicates related to handling APIs for the VS Code extension. */

private import csharp
private import semmle.code.csharp.dataflow.FlowSummary
private import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.csharp.dataflow.internal.ExternalFlow
private import semmle.code.csharp.frameworks.Test
private import semmle.code.csharp.telemetry.TestLibrary

/** Holds if the given callable is not worth supporting. */
private predicate isUninteresting(Callable c) {
  c.getDeclaringType() instanceof TestLibrary
  or
  c.(Constructor).isParameterless()
  or
  c.getDeclaringType() instanceof AnonymousClass
  or
  // The data flow library uses read/store steps for properties, so we don't need to model them,
  // if both a getter and a setter exist.
  c.(Accessor).getDeclaration().(Property).isReadWrite()
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
  string getNamespace() { this.getDeclaringType().hasFullyQualifiedName(result, _) }

  /**
   * Gets the unbound type name of this endpoint.
   */
  bindingset[this]
  string getTypeName() {
    result = qualifiedTypeName(this.getNamespace(), this.getDeclaringType().getUnboundDeclaration())
  }

  /**
   * Gets the qualified name of this endpoint.
   */
  bindingset[this]
  string getEndpointName() {
    result = qualifiedCallableName(this.getNamespace(), this.getTypeName(), this)
  }

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
  method.getFile() instanceof TestRelatedFile and result = "test"
  or
  not method.getFile() instanceof TestRelatedFile and
  result = "source"
}

/**
 * Gets the fully qualified name of the type `t`.
 */
private string qualifiedTypeName(string namespace, Type t) {
  exists(string type | hasQualifiedTypeName(t, namespace, type) | result = type)
}

/**
 * Gets the fully qualified name of the callable `c`.
 */
private string qualifiedCallableName(string namespace, string type, Callable c) {
  exists(string name | hasQualifiedMethodName(c, namespace, type, name) | result = name)
}

/** A file that is either a test file or is only used in tests. */
class TestRelatedFile extends File {
  TestRelatedFile() {
    this instanceof TestFile
    or
    this.getAbsolutePath().matches(["%/test/%", "%/tests/%"]) and
    not this.getAbsolutePath().matches("%/ql/test/%") // allows our test cases to work
  }
}
