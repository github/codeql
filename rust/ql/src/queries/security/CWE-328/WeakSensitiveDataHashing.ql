/**
 * @name Use of a broken or weak cryptographic hashing algorithm on sensitive data
 * @description Using broken or weak cryptographic hashing algorithms can compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id rust/weak-sensitive-data-hashing
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 *       external/cwe/cwe-916
 */

import rust
import codeql.rust.security.WeakSensitiveDataHashingExtensions
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking

/**
 * Provides a taint-tracking configuration for detecting use of a broken or weak
 * cryptographic hash function on sensitive data, that does NOT require a
 * computationally expensive hash function.
 */
module NormalHashFunctionFlow {
  import NormalHashFunction

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Barrier }

    predicate isBarrierIn(DataFlow::Node node) {
      // make sources barriers so that we only report the closest instance
      isSource(node)
    }

    predicate isBarrierOut(DataFlow::Node node) {
      // make sinks barriers so that we only report the closest instance
      isSink(node)
    }
  }

  import TaintTracking::Global<Config>
}

/**
 * Provides a taint-tracking configuration for detecting use of a broken or weak
 * cryptographic hashing algorithm on passwords.
 *
 * Passwords has stricter requirements on the hashing algorithm used (must be
 * computationally expensive to prevent brute-force attacks).
 */
module ComputationallyExpensiveHashFunctionFlow {
  import ComputationallyExpensiveHashFunction

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Barrier }

    predicate isBarrierIn(DataFlow::Node node) {
      // make sources barriers so that we only report the closest instance
      isSource(node)
    }

    predicate isBarrierOut(DataFlow::Node node) {
      // make sinks barriers so that we only report the closest instance
      isSink(node)
    }
  }

  import TaintTracking::Global<Config>
}

/**
 * Global taint-tracking for detecting both variants of "use of a broken or weak
 * cryptographic hashing algorithm on sensitive data" vulnerabilities. The two configurations are
 * merged to generate a combined path graph.
 */
module WeakSensitiveDataHashingFlow =
  DataFlow::MergePathGraph<NormalHashFunctionFlow::PathNode,
    ComputationallyExpensiveHashFunctionFlow::PathNode, NormalHashFunctionFlow::PathGraph,
    ComputationallyExpensiveHashFunctionFlow::PathGraph>;

import WeakSensitiveDataHashingFlow::PathGraph

from
  WeakSensitiveDataHashingFlow::PathNode source, WeakSensitiveDataHashingFlow::PathNode sink,
  string ending, string algorithmName, string classification
where
  NormalHashFunctionFlow::flowPath(source.asPathNode1(), sink.asPathNode1()) and
  algorithmName = sink.getNode().(NormalHashFunction::Sink).getAlgorithmName() and
  classification = source.getNode().(NormalHashFunction::Source).getClassification() and
  ending = "."
  or
  ComputationallyExpensiveHashFunctionFlow::flowPath(source.asPathNode2(), sink.asPathNode2()) and
  algorithmName = sink.getNode().(ComputationallyExpensiveHashFunction::Sink).getAlgorithmName() and
  classification =
    source.getNode().(ComputationallyExpensiveHashFunction::Source).getClassification() and
  (
    sink.getNode().(ComputationallyExpensiveHashFunction::Sink).isComputationallyExpensive() and
    ending = "."
    or
    not sink.getNode().(ComputationallyExpensiveHashFunction::Sink).isComputationallyExpensive() and
    ending =
      " for " + classification +
        " hashing, since it is not a computationally expensive hash function."
  )
select sink.getNode(), source, sink,
  "$@ is used in a hashing algorithm (" + algorithmName + ") that is insecure" + ending,
  source.getNode(), "Sensitive data (" + classification + ")"
