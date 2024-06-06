/**
 * @name Deserialization of user-controlled data
 * @description Deserializing user-controlled data may allow attackers to execute arbitrary code.
 * @kind path-problem
 * @id py/unsafe-deserialization
 * @problem.severity error
 * @security-severity 9.8
 * @sub-severity high
 * @precision high
 * @tags external/cwe/cwe-502
 *       security
 *       serialization
 */

import python
import semmle.python.security.dataflow.UnsafeDeserializationQuery
import UnsafeDeserializationFlow::PathGraph

from UnsafeDeserializationFlow::PathNode source, UnsafeDeserializationFlow::PathNode sink
where UnsafeDeserializationFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Unsafe deserialization depends on a $@.", source.getNode(),
  "user-provided value"
