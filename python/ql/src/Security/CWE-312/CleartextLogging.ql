/**
 * @name Clear-text logging of sensitive information
 * @description Logging sensitive information without encryption or hashing can
 *              expose it to an attacker.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id py/clear-text-logging-sensitive-data
 * @tags security
 *       external/cwe/cwe-312
 *       external/cwe/cwe-359
 *       external/cwe/cwe-532
 */

import python
private import semmle.python.dataflow.new.DataFlow
import DataFlow::PathGraph
import semmle.python.security.dataflow.CleartextLoggingQuery

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink, string classification
where
  config.hasFlowPath(source, sink) and
  classification = source.getNode().(Source).getClassification()
select sink.getNode(), source, sink, "$@ is logged here.", source.getNode(),
  "Sensitive data (" + classification + ")"
