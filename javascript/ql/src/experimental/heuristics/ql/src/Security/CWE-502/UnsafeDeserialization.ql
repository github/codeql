/**
 * @name Deserialization of user-controlled data with additional heuristic sources
 * @description Deserializing user-controlled data may allow attackers to
 *              execute arbitrary code.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 9.8
 * @precision high
 * @id js/unsafe-deserialization-more-sources
 * @tags experimental
 *       security
 *       external/cwe/cwe-502
 */

import javascript
import semmle.javascript.security.dataflow.UnsafeDeserializationQuery
import UnsafeDeserializationFlow::PathGraph
import semmle.javascript.heuristics.AdditionalSources

from UnsafeDeserializationFlow::PathNode source, UnsafeDeserializationFlow::PathNode sink
where
  UnsafeDeserializationFlow::flowPath(source, sink) and source.getNode() instanceof HeuristicSource
select sink.getNode(), source, sink, "Unsafe deserialization depends on a $@.", source.getNode(),
  "user-provided value"
