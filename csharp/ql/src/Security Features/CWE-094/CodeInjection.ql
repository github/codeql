/**
 * @name Improper control of generation of code
 * @description Treating externally controlled strings as code can allow an attacker to execute
 *              malicious code.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id cs/code-injection
 * @tags security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 *       external/cwe/cwe-096
 */

import csharp
import semmle.code.csharp.security.dataflow.CodeInjectionQuery
import CodeInjection::PathGraph

from CodeInjection::PathNode source, CodeInjection::PathNode sink
where CodeInjection::flowPath(source, sink)
select sink.getNode(), source, sink, "This code compilation depends on a $@.", source.getNode(),
  "user-provided value"
