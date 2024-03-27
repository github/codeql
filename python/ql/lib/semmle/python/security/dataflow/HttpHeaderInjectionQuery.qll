/**
 * Provides a taint tracking configuration for reasoning about HTTP header injection.
 */

import python
private import semmle.python.Concepts
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources

/**
 * A taint-tracking configuration for detecting HTTP Header injection vulnerabilities.
 */
private module HeaderInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(Http::Server::ResponseHeaderWrite headerDeclaration |
      sink in [headerDeclaration.getNameArg(), headerDeclaration.getValueArg()]
    )
  }
}

/** Global taint-tracking for detecting "HTTP Header injection" vulnerabilities. */
module HeaderInjectionFlow = TaintTracking::Global<HeaderInjectionConfig>;
