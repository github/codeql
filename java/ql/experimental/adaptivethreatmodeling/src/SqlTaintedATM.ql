/**
 * For internal use only.
 *
 * @name Query built from user-controlled sources (experimental)
 * @description Building a SQL or Java Persistence query from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @scored
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id java/ml-powered/sql-injection
 * @tags experimental security
 *       external/cwe/cwe-089
 *       external/cwe/cwe-564
 */

import experimental.adaptivethreatmodeling.SqlTaintedATM
import AtmResultsInfo
import DataFlow::PathGraph

from AtmConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink, float score
where cfg.hasBoostedFlowPath(source, sink, score)
select sink.getNode(), source, sink, "(Experimental) This query depends on a $@.", source.getNode(),
  "user-provided value", score
