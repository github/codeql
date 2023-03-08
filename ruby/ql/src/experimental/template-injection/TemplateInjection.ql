/**
 * @name Server-side template injection
 * @description Building a server-side template from user-controlled sources is vulnerable to
 *              insertion of malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id rb/server-side-template-injection
 * @tags security
 *       external/cwe/cwe-94
 */

import codeql.ruby.DataFlow
import codeql.ruby.security.TemplateInjectionQuery
import DataFlow::PathGraph

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This template depends on a $@.", source.getNode(),
  "user-provided value"
