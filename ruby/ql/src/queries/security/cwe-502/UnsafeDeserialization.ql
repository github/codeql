/**
 * @name Deserialization of user-controlled data
 * @description Deserializing user-controlled data may allow attackers to
 *              execute arbitrary code.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 9.8
 * @precision high
 * @id rb/unsafe-deserialization
 * @tags security
 *       external/cwe/cwe-502
 */

import ruby
import codeql.ruby.security.UnsafeDeserializationQuery
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Unsafe deserialization depends on a $@.", source.getNode(),
  source.getNode().(UnsafeDeserialization::Source).describe()
