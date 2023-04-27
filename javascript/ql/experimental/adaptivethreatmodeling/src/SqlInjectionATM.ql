/**
 * For internal use only.
 *
 * @name SQL database query built from user-controlled sources (experimental)
 * @description Building a database query from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @scored
 * @problem.severity error
 * @security-severity 8.8
 * @id js/ml-powered/sql-injection
 * @tags experimental security
 *       external/cwe/cwe-089
 */

import experimental.adaptivethreatmodeling.SqlInjectionATM
import ATM::ResultsInfo
import DataFlow::PathGraph

from AtmConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink, float score
where cfg.hasBoostedFlowPath(source, sink, score)
select sink.getNode(), source, sink,
  "(Experimental) This may be a database query that depends on $@. Identified using machine learning.",
  source.getNode(), "a user-provided value", score
