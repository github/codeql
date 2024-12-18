/**
 * Definitions for reasoning about untrusted data used in APIs defined outside the
 * database.
 */

import csharp
private import semmle.code.csharp.commons.QualifiedName
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.dataflow.FlowSummary

/**
 * A callable that is considered a "safe" external API from a security perspective.
 */
abstract class SafeExternalApiCallable extends Callable { }

private class SummarizedCallableSafe extends SafeExternalApiCallable instanceof SummarizedCallable {
}

/** The default set of "safe" external APIs. */
private class DefaultSafeExternalApiCallable extends SafeExternalApiCallable {
  DefaultSafeExternalApiCallable() {
    this instanceof EqualsMethod or
    this instanceof IEquatableEqualsMethod or
    this = any(SystemObjectClass s).getEqualsMethod() or
    this = any(SystemObjectClass s).getReferenceEqualsMethod() or
    this = any(SystemObjectClass s).getStaticEqualsMethod() or
    this = any(SystemObjectClass s).getGetTypeMethod() or
    this = any(SystemStringClass s).getEqualsMethod() or
    this = any(SystemStringClass s).getEqualsOperator() or
    this = any(SystemStringClass s).getIsNullOrEmptyMethod() or
    this = any(SystemStringClass s).getIsNullOrWhiteSpaceMethod() or
    this.getName().regexpMatch("Count|get_Count|get_Length")
  }
}

/** A node representing data being passed to an external API. */
class ExternalApiDataNode extends DataFlow::Node {
  Call call;
  int i;

  ExternalApiDataNode() {
    (
      // Argument to call
      this.asExpr() = call.getArgument(i)
      or
      // Qualifier to call
      this.asExpr() = call.getChild(i) and
      i = -1 and
      // extension methods are covered above
      not call.getTarget().(Method).isExtensionMethod()
    ) and
    // Defined outside the source archive
    not call.getTarget().fromSource() and
    // Not a call to a method which is overridden in source
    not exists(Overridable m |
      m.overridesOrImplementsOrEquals(call.getTarget().getUnboundDeclaration()) and
      m.fromSource()
    ) and
    // Not a call to a known safe external API
    not call.getTarget().getUnboundDeclaration() instanceof SafeExternalApiCallable
  }

  /** Gets the called API callable. */
  Callable getCallable() { result = call.getTarget().getUnboundDeclaration() }

  /** Gets the index which is passed untrusted data (where -1 indicates the qualifier). */
  int getIndex() { result = i }

  /** Holds if the callable being use has name `name` and has qualifier `qualifier`. */
  predicate hasQualifiedName(string qualifier, string name) {
    this.getCallable().hasFullyQualifiedName(qualifier, name)
  }
}

/** A configuration for tracking flow from `ActiveThreatModelSource`s to `ExternalApiDataNode`s. */
private module RemoteSourceToExternalApiConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof ExternalApiDataNode }
}

/** A module for tracking flow from `ActiveThreatModelSource`s to `ExternalApiDataNode`s. */
module RemoteSourceToExternalApi = TaintTracking::Global<RemoteSourceToExternalApiConfig>;

/** A node representing untrusted data being passed to an external API. */
class UntrustedExternalApiDataNode extends ExternalApiDataNode {
  UntrustedExternalApiDataNode() { RemoteSourceToExternalApi::flow(_, this) }

  /** Gets a source of untrusted data which is passed to this external API data node. */
  DataFlow::Node getAnUntrustedSource() { RemoteSourceToExternalApi::flow(result, this) }
}

/** An external API which is used with untrusted data. */
private newtype TExternalApi =
  /** An untrusted API method `m` where untrusted data is passed at `index`. */
  TExternalApiParameter(Callable m, int index) {
    exists(UntrustedExternalApiDataNode n |
      m = n.getCallable().getUnboundDeclaration() and
      index = n.getIndex()
    )
  }

/** An external API which is used with untrusted data. */
class ExternalApiUsedWithUntrustedData extends TExternalApi {
  /** Gets a possibly untrusted use of this external API. */
  UntrustedExternalApiDataNode getUntrustedDataNode() {
    this = TExternalApiParameter(result.getCallable().getUnboundDeclaration(), result.getIndex())
  }

  /** Gets the number of untrusted sources used with this external API. */
  int getNumberOfUntrustedSources() {
    result = count(this.getUntrustedDataNode().getAnUntrustedSource())
  }

  /** Gets a textual representation of this element. */
  string toString() {
    exists(Callable m, int index, string indexString, string qualifier, string name |
      if index = -1 then indexString = "qualifier" else indexString = "param " + index
    |
      this = TExternalApiParameter(m, index) and
      m.getDeclaringType().hasFullyQualifiedName(qualifier, name) and
      result =
        getQualifiedName(qualifier, name) + "." + m.toStringWithTypes() + " [" + indexString + "]"
    )
  }
}
