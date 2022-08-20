/**
 * Provides AST-specific definitions for use in the `ExternalAPI` library.
 */

import semmle.code.cpp.dataflow.TaintTracking
import semmle.code.cpp.models.interfaces.FlowSource
import semmle.code.cpp.models.interfaces.DataFlow
import SafeExternalAPIFunction

/** A node representing untrusted data being passed to an external API. */
class ExternalApiDataNode extends DataFlow::Node {
  Call call;
  int i;

  ExternalApiDataNode() {
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
      not f instanceof SafeExternalApiFunction
    )
  }

  /** Gets the called API `Function`. */
  Function getExternalFunction() { result = call.getTarget() }

  /** Gets the index which is passed untrusted data (where -1 indicates the qualifier). */
  int getIndex() { result = i }

  /** Gets the description of the function being called. */
  string getFunctionDescription() { result = this.getExternalFunction().toString() }
}

/** DEPRECATED: Alias for ExternalApiDataNode */
deprecated class ExternalAPIDataNode = ExternalApiDataNode;

/** A configuration for tracking flow from `RemoteFlowSource`s to `ExternalApiDataNode`s. */
class UntrustedDataToExternalApiConfig extends TaintTracking::Configuration {
  UntrustedDataToExternalApiConfig() { this = "UntrustedDataToExternalAPIConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(RemoteFlowSourceFunction remoteFlow |
      remoteFlow = source.asExpr().(Call).getTarget() and
      remoteFlow.hasRemoteFlowSource(_, _)
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ExternalApiDataNode }
}

/** DEPRECATED: Alias for UntrustedDataToExternalApiConfig */
deprecated class UntrustedDataToExternalAPIConfig = UntrustedDataToExternalApiConfig;
