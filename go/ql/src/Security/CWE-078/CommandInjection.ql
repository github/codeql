/**
 * @name Command built from user-controlled sources
 * @description Building a system command from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id go/command-injection
 * @tags security
 *       external/cwe/cwe-078
 */

import go
import semmle.go.security.CommandInjection
import DataFlow::PathGraph

from
  CommandInjection::Configuration cfg, CommandInjection::DoubleDashSanitizingConfiguration cfg2,
  DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink) or cfg2.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This command depends on $@.", source.getNode(),
  "a user-provided value"
