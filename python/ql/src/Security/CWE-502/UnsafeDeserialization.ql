/**
 * @name Deserializing untrusted input
 * @description Deserializing user-controlled data may allow attackers to execute arbitrary code.
 * @kind path-problem
 * @id py/unsafe-deserialization
 * @problem.severity error
 * @sub-severity high
 * @precision high
 * @tags external/cwe/cwe-502
 *       security
 *       serialization
 */

import python
import semmle.python.security.dataflow.UnsafeDeserialization
import DataFlow::PathGraph

from UnsafeDeserializationConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Deserializing of $@.", source.getNode(), "untrusted input"
