/**
 * For internal use only.
 *
 * @name Uncontrolled data used in path expression (boosted)
 * @description Accessing paths influenced by users can allow an attacker to access
 *              unexpected resources.
 * @kind path-problem
 * @scored
 * @problem.severity error
 * @security-severity 7.5
 * @id adaptive-threat-modeling/js/path-injection
 * @tags experimental experimental/atm security
 */

import ATM::ResultsInfo
import DataFlow::PathGraph
import experimental.adaptivethreatmodeling.TaintedPathATM

from
  DataFlow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, float score,
  string scoreString
where
  cfg.hasFlowPath(source, sink) and
  not isFlowLikelyInBaseQuery(source.getNode(), sink.getNode()) and
  score = getScoreForFlow(source.getNode(), sink.getNode()) and
  scoreString = getScoreStringForFlow(source.getNode(), sink.getNode())
select sink.getNode(), source, sink,
  "[Score = " + scoreString + "] This may be a js/path-injection result depending on $@ " +
    getAdditionalAlertInfo(source.getNode(), sink.getNode()), source.getNode(),
  "a user-provided value", score
