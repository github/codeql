/**
 * For internal use only.
 *
 * @name Stored cross-site scripting (boosted)
 * @description Using uncontrolled stored values in HTML allows for a stored cross-site scripting vulnerability.
 * @kind path-problem
 * @scored
 * @problem.severity error
 * @security-severity 6.1
 * @id adaptive-threat-modeling/js/stored-xss
 * @tags experimental experimental/atm security external/cwe/cwe-079 external/cwe/cwe-116
 */

import experimental.adaptivethreatmodeling.StoredXssATM
import ATM::ResultsInfo
import DataFlow::PathGraph

from
  DataFlow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, float score,
  string scoreString
where
  cfg.hasFlowPath(source, sink) and
  not isFlowLikelyInBaseQuery(source.getNode(), sink.getNode()) and
  score = getScoreForFlow(source.getNode(), sink.getNode()) and
  scoreString = getScoreStringForFlow(source.getNode(), sink.getNode())
select sink.getNode(), source, sink,
  "[Score = " + scoreString + "] This may be a js/stored-xss result depending on $@ " +
    getAdditionalAlertInfo(source.getNode(), sink.getNode()), source.getNode(),
  "a user-provided value", score
