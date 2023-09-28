/**
 * @name Database query built from user-controlled sources
 * @description Building a database query from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id js/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 *       external/cwe/cwe-090
 *       external/cwe/cwe-943
 */

import javascript
import semmle.javascript.security.dataflow.SqlInjectionQuery as SqlInjection
import semmle.javascript.security.dataflow.NosqlInjectionQuery as NosqlInjection
import DataFlow::PathGraph

from DataFlow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, string type
where
  (
    cfg instanceof SqlInjection::Configuration and type = "string"
    or
    cfg instanceof NosqlInjection::Configuration and type = "object"
  ) and
  cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This query " + type + " depends on a $@.", source.getNode(),
  "user-provided value"
