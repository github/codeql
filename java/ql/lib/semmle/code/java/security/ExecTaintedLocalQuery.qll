/** Provides a taint-tracking configuration to reason about use of externally controlled strings for command injection vulnerabilities. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.ExternalProcess
private import semmle.code.java.security.CommandArguments
private import semmle.code.java.security.Sanitizers

/** A taint-tracking configuration to reason about use of externally controlled strings to make command line commands. */
module ExecTaintedLocalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof ArgumentToExec }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof SimpleTypeSanitizer
    or
    isSafeCommandArgument(node.asExpr())
  }
}

/**
 * Taint-tracking flow for use of externally controlled strings to make command line commands.
 */
module ExecTaintedLocalFlow = TaintTracking::Global<ExecTaintedLocalConfig>;
