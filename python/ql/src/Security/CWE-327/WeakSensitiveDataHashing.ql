/**
 * @name Use of a broken or weak cryptographic hashing algorithm on sensitive data
 * @description Using broken or weak cryptographic hashing algorithms can compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id py/weak-sensitive-data-hashing
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 *       external/cwe/cwe-916
 */

import python
import semmle.python.security.dataflow.WeakSensitiveDataHashingQuery
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import DataFlow::PathGraph

from
  DataFlow::PathNode source, DataFlow::PathNode sink, string ending, string algorithmName,
  string classification
where
  exists(NormalHashFunction::Configuration config |
    config.hasFlowPath(source, sink) and
    algorithmName = sink.getNode().(NormalHashFunction::Sink).getAlgorithmName() and
    classification = source.getNode().(NormalHashFunction::Source).getClassification() and
    ending = "."
  )
  or
  exists(ComputationallyExpensiveHashFunction::Configuration config |
    config.hasFlowPath(source, sink) and
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
  )
select sink.getNode(), source, sink,
  "$@ is used in a hashing algorithm (" + algorithmName + ") that is insecure" + ending,
  source.getNode(), "Sensitive data (" + classification + ")"
