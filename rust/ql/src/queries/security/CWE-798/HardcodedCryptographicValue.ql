/**
 * @name Hard-coded cryptographic value
 * @description Using hard-coded keys, passwords, salts or initialization
 *              vectors is not secure.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 9.8
 * @precision high
 * @id rust/hard-coded-cryptographic-value
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
 * A taint-tracking configuration for hard-coded cryptographic value vulnerabilities.
 */
module HardcodedCryptographicValueConfig implements DataFlow::ConfigSig {
  import HardcodedCryptographicValue

  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof Barrier }

  predicate isBarrierIn(DataFlow::Node node) {
    // make sources barriers so that we only report the closest instance
    // (this combined with sources for `ArrayListExpr` means we only get one source in
    //  case like `[0, 0, 0, 0]`)
    isSource(node)
  }

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
  sink.getNode().(HardcodedCryptographicValueConfig::Sink).getKind().getDescription()
