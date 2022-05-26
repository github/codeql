/**
 * For internal use only.
 *
 * @name Uncontrolled data used in path expression (experimental)
 * @description Accessing paths influenced by users can allow an attacker to access
 *              unexpected resources.
 * @kind path-problem
 * @scored
 * @problem.severity error
 * @security-severity 7.5
 * @id js/ml-powered/path-injection
 * @tags experimental security
 *       external/cwe/cwe-022
 *       external/cwe/cwe-023
 *       external/cwe/cwe-036
 *       external/cwe/cwe-073
 *       external/cwe/cwe-099
 */

import ATM::ResultsInfo
import DataFlow::PathGraph
import experimental.adaptivethreatmodeling.TaintedPathATM

from DataFlow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, float score
where
  cfg.hasFlowPath(source, sink) and
  not isFlowLikelyInBaseQuery(source.getNode(), sink.getNode()) and
  score = getScoreForFlow(source.getNode(), sink.getNode())
select sink.getNode(), source, sink,
  "(Experimental) This may be a path that depends on $@. Identified using machine learning.",
  source.getNode(), "a user-provided value", score
