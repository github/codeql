/**
 * @name Log Injection
 * @description Building log entries from user-controlled sources is vulnerable to
 *              insertion of forged log entries by a malicious user.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/log-injection
 * @tags security
 *       external/cwe/cwe-117
 */

import java
import semmle.code.java.dataflow.FlowSources
import LogInjection::LogInjection
import DataFlow::PathGraph

from LogInjectionConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Outputting $@ to log.", source.getNode(),
  "sensitive information"
