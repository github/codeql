/**
 * @name Hard-coded cryptographic value
 * @description Using hardcoded keys, passwords, salts or initialization
 *              vectors is not secure.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity TODO
 * @precision high
 * @id rust/hardcoded-crytographic-value
 * @tags security
 *       external/cwe/cwe-259
 *       external/cwe/cwe-321
 *       external/cwe/cwe-798
 *       external/cwe/cwe-1204
 */

import rust
import codeql.rust.security.HardcodedCryptographicValueExtensions
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.dataflow.internal.DataFlowImpl

/**
 * A taint-tracking configuration for hardcoded cryptographic value vulnerabilities.
 */
module HardcodedCryptographicValueConfig implements DataFlow::ConfigSig {
  import HardcodedCryptographicValue

  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof Barrier }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    // flow out from reference content at sinks.
    isSink(node) and
    c.getAReadContent() instanceof ReferenceContent
  }
}

module HardcodedCryptographicValueFlow = TaintTracking::Global<HardcodedCryptographicValueConfig>;

import HardcodedCryptographicValueFlow::PathGraph

from
  HardcodedCryptographicValueFlow::PathNode source, HardcodedCryptographicValueFlow::PathNode sink
where HardcodedCryptographicValueFlow::flowPath(source, sink)
select source.getNode(), source, sink, "This hard-coded value is used as $@.", sink,
  sink.getNode().(HardcodedCryptographicValueConfig::Sink).getKind()
