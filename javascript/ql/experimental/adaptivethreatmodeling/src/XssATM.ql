/**
 * For internal use only.
 *
 * @name Client-side cross-site scripting (boosted)
 * @description Writing user input directly to the DOM allows for
 *              a cross-site scripting vulnerability.
 * @kind path-problem
 * @scored
 * @problem.severity error
 * @security-severity 6.1
 * @id adaptive-threat-modeling/js/xss
 * @tags experimental experimental/atm security
 */

import javascript
import ATM::ResultsInfo
import DataFlow::PathGraph
import experimental.adaptivethreatmodeling.XssATM

from
  DataFlow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, float score,
  string scoreString
where
  cfg.hasFlowPath(source, sink) and
  not isFlowLikelyInBaseQuery(source.getNode(), sink.getNode()) and
  score = getScoreForFlow(source.getNode(), sink.getNode()) and
  scoreString = getScoreStringForFlow(source.getNode(), sink.getNode())
select sink.getNode(), source, sink,
  "[Score = " + scoreString + "] This may be a js/xss result depending on $@ " +
    getAdditionalAlertInfo(source.getNode(), sink.getNode()), source.getNode(),
  "a user-provided value", score
