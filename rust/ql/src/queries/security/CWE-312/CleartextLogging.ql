/**
 * @name Cleartext logging of sensitive information
 * @description Logging sensitive information in plaintext can
 *              expose it to an attacker.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id rust/cleartext-logging
 * @tags security
 *       external/cwe/cwe-312
 *       external/cwe/cwe-359
 *       external/cwe/cwe-532
 */

import rust
import codeql.rust.security.CleartextLoggingExtensions
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.dataflow.internal.DataFlowImpl

/**
 * A taint-tracking configuration for cleartext logging vulnerabilities.
 */
module CleartextLoggingConfig implements DataFlow::ConfigSig {
  import CleartextLogging

  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof Barrier }

  predicate isBarrierIn(DataFlow::Node node) {
    // make sources barriers so that we only report the closest instance
    isSource(node)
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    // flow out from tuple content at sinks.
    isSink(node) and
    c.getAReadContent() instanceof TuplePositionContent
  }
}

module CleartextLoggingFlow = TaintTracking::Global<CleartextLoggingConfig>;

import CleartextLoggingFlow::PathGraph

from CleartextLoggingFlow::PathNode source, CleartextLoggingFlow::PathNode sink
where CleartextLoggingFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This operation writes '" + sink.toString() +
    "' to a log file. It may contain unencrypted sensitive data from $@.", source,
  source.getNode().toString()
