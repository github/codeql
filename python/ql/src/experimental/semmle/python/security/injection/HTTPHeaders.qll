import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources

/**
 * A taint-tracking configuration for detecting HTTP Header injections.
 */
private module HeaderInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(HeaderDeclaration headerDeclaration |
      sink in [headerDeclaration.getNameArg(), headerDeclaration.getValueArg()]
    )
  }
}

/** Global taint-tracking for detecting "HTTP Header injection" vulnerabilities. */
module HeaderInjectionFlow = TaintTracking::Global<HeaderInjectionConfig>;
