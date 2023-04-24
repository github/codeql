/**
 * @name User-controlled bypass of sensitive method
 * @description User-controlled bypassing of sensitive methods may allow attackers to avoid
 *              passing through authentication systems.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id cs/user-controlled-bypass
 * @tags security
 *       external/cwe/cwe-807
 *       external/cwe/cwe-247
 *       external/cwe/cwe-350
 */

import csharp
import semmle.code.csharp.security.dataflow.ConditionalBypassQuery
import ConditionalBypass::PathGraph

from ConditionalBypass::PathNode source, ConditionalBypass::PathNode sink
where ConditionalBypass::flowPath(source, sink)
select sink.getNode(), source, sink, "This condition guards a sensitive $@, but a $@ controls it.",
  sink.getNode().(Sink).getSensitiveMethodCall(), "action", source.getNode(), "user-provided value"
