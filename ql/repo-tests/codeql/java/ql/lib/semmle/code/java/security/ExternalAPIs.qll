/**
 * Definitions for reasoning about untrusted data used in APIs defined outside the
 * database.
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking

/**
 * A `Method` that is considered a "safe" external API from a security perspective.
 */
abstract class SafeExternalAPIMethod extends Method { }

/** The default set of "safe" external APIs. */
private class DefaultSafeExternalAPIMethod extends SafeExternalAPIMethod {
  DefaultSafeExternalAPIMethod() {
    this instanceof EqualsMethod
    or
    this.getName().regexpMatch("size|length|compareTo|getClass|lastIndexOf")
    or
    this.getDeclaringType().hasQualifiedName("org.apache.commons.lang3", "Validate")
    or
    this.getQualifiedName() = "Objects.equals"
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
    this.getName().regexpMatch("equalsIgnoreCase|regionMatches")
    or
    this.getDeclaringType().hasQualifiedName("java.lang", "Boolean") and
    this.getName() = "parseBoolean"
    or
    this.getDeclaringType().hasQualifiedName("org.apache.commons.io", "IOUtils") and
    this.getName() = "closeQuietly"
    or
    this.getDeclaringType().hasQualifiedName("org.springframework.util", "StringUtils") and
    this.getName().regexpMatch("hasText|isEmpty")
  }
}

/** A node representing data being passed to an external API. */
class ExternalAPIDataNode extends DataFlow::Node {
  Call call;
  int i;

  ExternalAPIDataNode() {
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
    not exists(DataFlow::Node next | TaintTracking::localTaintStep(this, next)) and
    not exists(DataFlow::Node next | TaintTracking::defaultAdditionalTaintStep(this, next)) and
    // Not a call to a known safe external API
    not call.getCallee() instanceof SafeExternalAPIMethod
  }

  /** Gets the called API `Method`. */
  Method getMethod() { result = call.getCallee() }

  /** Gets the index which is passed untrusted data (where -1 indicates the qualifier). */
  int getIndex() { result = i }

  /** Gets the description of the method being called. */
  string getMethodDescription() {
    result =
      this.getMethod().getDeclaringType().getPackage() + "." + this.getMethod().getQualifiedName()
  }
}

/** A configuration for tracking flow from `RemoteFlowSource`s to `ExternalAPIDataNode`s. */
class UntrustedDataToExternalAPIConfig extends TaintTracking::Configuration {
  UntrustedDataToExternalAPIConfig() { this = "UntrustedDataToExternalAPIConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ExternalAPIDataNode }
}

/** A node representing untrusted data being passed to an external API. */
class UntrustedExternalAPIDataNode extends ExternalAPIDataNode {
  UntrustedExternalAPIDataNode() { any(UntrustedDataToExternalAPIConfig c).hasFlow(_, this) }

  /** Gets a source of untrusted data which is passed to this external API data node. */
  DataFlow::Node getAnUntrustedSource() {
    any(UntrustedDataToExternalAPIConfig c).hasFlow(result, this)
  }
}

private newtype TExternalAPI =
  TExternalAPIParameter(Method m, int index) {
    exists(UntrustedExternalAPIDataNode n |
      m = n.getMethod() and
      index = n.getIndex()
    )
  }

/** An external API which is used with untrusted data. */
class ExternalAPIUsedWithUntrustedData extends TExternalAPI {
  /** Gets a possibly untrusted use of this external API. */
  UntrustedExternalAPIDataNode getUntrustedDataNode() {
    this = TExternalAPIParameter(result.getMethod(), result.getIndex())
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
      this = TExternalAPIParameter(m, index) and
      result =
        m.getDeclaringType().getQualifiedName() + "." + m.getSignature() + " [" + indexString + "]"
    )
  }
}
