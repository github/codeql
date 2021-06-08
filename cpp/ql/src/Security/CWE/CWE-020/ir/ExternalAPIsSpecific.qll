/**
 * Provides IR-specific definitions for use in the `ExternalAPI` library.
 */

import semmle.code.cpp.ir.dataflow.TaintTracking
private import semmle.code.cpp.security.FlowSources
private import semmle.code.cpp.models.interfaces.DataFlow
import SafeExternalAPIFunction

/** A node representing untrusted data being passed to an external API. */
class ExternalAPIDataNode extends DataFlow::Node {
  Call call;
  int i;

  ExternalAPIDataNode() {
    // Argument to call to a function
    (
      this.asExpr() = call.getArgument(i)
      or
      i = -1 and this.asExpr() = call.getQualifier()
    ) and
    exists(Function f |
      f = call.getTarget() and
      // Defined outside the source archive
      not f.hasDefinition() and
      // Not already modeled as a dataflow or taint step
      not f instanceof DataFlowFunction and
      not f instanceof TaintFunction and
      // Not a call to a known safe external API
      not f instanceof SafeExternalAPIFunction
    )
  }

  /** Gets the called API `Function`. */
  Function getExternalFunction() { result = call.getTarget() }

  /** Gets the index which is passed untrusted data (where -1 indicates the qualifier). */
  int getIndex() { result = i }

  /** Gets the description of the function being called. */
  string getFunctionDescription() { result = getExternalFunction().toString() }
}

/** A configuration for tracking flow from `RemoteFlowSource`s to `ExternalAPIDataNode`s. */
class UntrustedDataToExternalAPIConfig extends TaintTracking::Configuration {
  UntrustedDataToExternalAPIConfig() { this = "UntrustedDataToExternalAPIConfigIR" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ExternalAPIDataNode }
}
