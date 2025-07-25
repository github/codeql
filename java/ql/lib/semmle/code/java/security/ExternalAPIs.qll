/**
 * Definitions for reasoning about untrusted data used in APIs defined outside the
 * database.
 */
overlay[local?]
module;

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking

/**
 * A `Method` that is considered a "safe" external API from a security perspective.
 */
abstract class SafeExternalApiMethod extends Method { }

/** The default set of "safe" external APIs. */
private class DefaultSafeExternalApiMethod extends SafeExternalApiMethod {
  DefaultSafeExternalApiMethod() {
    this instanceof EqualsMethod
    or
    this.hasName(["size", "length", "compareTo", "getClass", "lastIndexOf"])
    or
    this.getDeclaringType().hasQualifiedName("org.apache.commons.lang3", "Validate")
    or
    this.hasQualifiedName("java.util", "Objects", "equals")
    or
    this.getDeclaringType() instanceof TypeString and this.getName() = "equals"
    or
    this.getDeclaringType().hasQualifiedName("com.google.common.base", "Preconditions")
    or
    this.getDeclaringType().getPackage().getName().matches("org.junit%")
    or
    this.getDeclaringType().hasQualifiedName("com.google.common.base", "Strings") and
    this.getName() = "isNullOrEmpty"
    or
    this.getDeclaringType().hasQualifiedName("org.apache.commons.lang3", "StringUtils") and
    this.getName() = "isNotEmpty"
    or
    this.getDeclaringType().hasQualifiedName("java.lang", "Character") and
    this.getName() = "isDigit"
    or
    this.getDeclaringType().hasQualifiedName("java.lang", "String") and
    this.hasName(["equalsIgnoreCase", "regionMatches"])
    or
    this.getDeclaringType().hasQualifiedName("java.lang", "Boolean") and
    this.getName() = "parseBoolean"
    or
    this.getDeclaringType().hasQualifiedName("org.apache.commons.io", "IOUtils") and
    this.getName() = "closeQuietly"
    or
    this.getDeclaringType().hasQualifiedName("org.springframework.util", "StringUtils") and
    this.hasName(["hasText", "isEmpty"])
  }
}

/** A node representing data being passed to an external API. */
class ExternalApiDataNode extends DataFlow::Node {
  Call call;
  int i;

  ExternalApiDataNode() {
    (
      // Argument to call to a method
      this.asExpr() = call.getArgument(i)
      or
      // Qualifier to call to a method which returns non trivial value
      this.asExpr() = call.getQualifier() and
      i = -1 and
      not call.getCallee().getReturnType() instanceof VoidType and
      not call.getCallee().getReturnType() instanceof BooleanType
    ) and
    // Defined outside the source archive
    not call.getCallee().fromSource() and
    // Not a call to an method which is overridden in source
    not exists(Method m |
      m.getASourceOverriddenMethod() = call.getCallee().getSourceDeclaration() and
      m.fromSource()
    ) and
    // Not already modeled as a taint step (we need both of these to handle `AdditionalTaintStep` subclasses as well)
    not TaintTracking::localTaintStep(this, _) and
    not TaintTracking::defaultAdditionalTaintStep(this, _, _) and
    // Not a call to a known safe external API
    not call.getCallee() instanceof SafeExternalApiMethod
  }

  /** Gets the called API `Method`. */
  Method getMethod() { result = call.getCallee() }

  /** Gets the index which is passed untrusted data (where -1 indicates the qualifier). */
  int getIndex() { result = i }

  /** Gets the description of the method being called. */
  string getMethodDescription() { result = this.getMethod().getQualifiedName() }
}

/**
 * Taint tracking configuration for flow from `ActiveThreatModelSource`s to `ExternalApiDataNode`s.
 */
module UntrustedDataToExternalApiConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof ExternalApiDataNode }

  predicate observeDiffInformedIncrementalMode() {
    any() // Simple use in UntrustedDataToExternalAPI.ql; also used through ExternalApiUsedWithUntrustedData in ExternalAPIsUsedWithUntrustedData.ql
  }
}

/**
 * Tracks flow from untrusted data to external APIs.
 */
module UntrustedDataToExternalApiFlow = TaintTracking::Global<UntrustedDataToExternalApiConfig>;

/** A node representing untrusted data being passed to an external API. */
class UntrustedExternalApiDataNode extends ExternalApiDataNode {
  UntrustedExternalApiDataNode() { UntrustedDataToExternalApiFlow::flowTo(this) }

  /** Gets a source of untrusted data which is passed to this external API data node. */
  DataFlow::Node getAnUntrustedSource() { UntrustedDataToExternalApiFlow::flow(result, this) }
}

/** An external API which is used with untrusted data. */
private newtype TExternalApi =
  /** An untrusted API method `m` where untrusted data is passed at `index`. */
  TExternalApiParameter(Method m, int index) {
    exists(UntrustedExternalApiDataNode n |
      m = n.getMethod() and
      index = n.getIndex()
    )
  }

/** An external API which is used with untrusted data. */
class ExternalApiUsedWithUntrustedData extends TExternalApi {
  /** Gets a possibly untrusted use of this external API. */
  UntrustedExternalApiDataNode getUntrustedDataNode() {
    this = TExternalApiParameter(result.getMethod(), result.getIndex())
  }

  /** Gets the number of untrusted sources used with this external API. */
  int getNumberOfUntrustedSources() {
    result = count(this.getUntrustedDataNode().getAnUntrustedSource())
  }

  /** Gets a textual representation of this element. */
  string toString() {
    exists(Method m, int index, string indexString |
      if index = -1 then indexString = "qualifier" else indexString = "param " + index
    |
      this = TExternalApiParameter(m, index) and
      result =
        m.getDeclaringType().getQualifiedName() + "." + m.getSignature() + " [" + indexString + "]"
    )
  }
}
