/**
 * @name Database query built from user-controlled sources with additional heuristic sources
 * @description Building a database query from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id js/sql-injection-more-sources
 * @tags experimental
 *       security
 *       external/cwe/cwe-089
 *       external/cwe/cwe-090
 *       external/cwe/cwe-943
 */

import javascript
import semmle.javascript.security.dataflow.SqlInjectionQuery as SqlInjection
import semmle.javascript.security.dataflow.NosqlInjectionQuery as NosqlInjection
import DataFlow::PathGraph
import semmle.javascript.heuristics.AdditionalSources

from DataFlow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where
  (
    cfg instanceof SqlInjection::Configuration or
    cfg instanceof NosqlInjection::Configuration
  ) and
  cfg.hasFlowPath(source, sink) and
  source.getNode() instanceof HeuristicSource
select sink.getNode(), source, sink, "This query depends on a $@.", source.getNode(),
  "user-provided value"
