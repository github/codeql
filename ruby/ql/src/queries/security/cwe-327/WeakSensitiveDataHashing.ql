/**
 * @name Use of a broken or weak cryptographic hashing algorithm on sensitive data
 * @description Using broken or weak cryptographic hashing algorithms can compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id rb/weak-sensitive-data-hashing
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 *       external/cwe/cwe-916
 */

import ruby
import codeql.ruby.security.WeakSensitiveDataHashingQuery
import codeql.ruby.TaintTracking
import WeakSensitiveDataHashing::Config::PathGraph

from
  WeakSensitiveDataHashing::Config::PathNode source,
  WeakSensitiveDataHashing::Config::PathNode sink, string ending, string algorithmName,
  string classification
where
  NormalHashFunction::flowPath(source.asPathNode1(), sink.asPathNode1()) and
  algorithmName = sink.getNode().(NormalHashFunction::Sink).getAlgorithmName() and
  classification = source.getNode().(NormalHashFunction::Source).getClassification() and
  ending = "."
  or
  ComputationallyExpensiveHashFunction::flowPath(source.asPathNode2(), sink.asPathNode2()) and
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
