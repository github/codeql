/**
 * @name Clear-text storage of sensitive information
 * @description Sensitive information stored without encryption or hashing can expose it to an
 *              attacker.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id py/clear-text-storage-sensitive-data
 * @tags security
 *       external/cwe/cwe-312
 *       external/cwe/cwe-315
 *       external/cwe/cwe-359
 */

import python
private import semmle.python.dataflow.new.DataFlow
import DataFlow::PathGraph
import semmle.python.security.dataflow.CleartextStorageQuery

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink, string classification
where
  config.hasFlowPath(source, sink) and
  classification = source.getNode().(Source).getClassification()
select sink.getNode(), source, sink, "This expression stores $@ as clear text.", source.getNode(),
  "sensitive data (" + classification + ")"
