/**
 * @name Uncontrolled command line
 * @description Using locally controlled strings in a command line may allow a malicious
 *              user to change the meaning of the command.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id cs/local-command-line-injection
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import csharp
import semmle.code.csharp.security.dataflow.LocalCommandInjectionQuery
import LocalCommandInjection::PathGraph

from LocalCommandInjection::PathNode source, LocalCommandInjection::PathNode sink
where LocalCommandInjection::flowPath(source, sink)
select sink.getNode(), source, sink, "This command line depends on a $@.", source.getNode(),
  "user-provided value and leads to command injection."