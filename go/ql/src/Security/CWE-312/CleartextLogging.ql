/**
 * @name Clear-text logging of sensitive information
 * @description Logging sensitive information without encryption or hashing can
 *              expose it to an attacker.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id go/clear-text-logging
 * @tags security
 *       external/cwe/cwe-312
 *       external/cwe/cwe-315
 *       external/cwe/cwe-359
 */

import go
import semmle.go.security.CleartextLogging
import CleartextLogging::Flow::PathGraph

from CleartextLogging::Flow::PathNode source, CleartextLogging::Flow::PathNode sink
where CleartextLogging::Flow::flowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to a logging call.", source.getNode(),
  "Sensitive data returned by " + source.getNode().(CleartextLogging::Source).describe()
