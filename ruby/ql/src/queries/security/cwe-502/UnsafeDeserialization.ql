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
import DataFlow::PathGraph
import codeql.ruby.DataFlow
import codeql.ruby.security.UnsafeDeserializationQuery

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Unsafe deserialization of $@.", source.getNode(), "user input"
