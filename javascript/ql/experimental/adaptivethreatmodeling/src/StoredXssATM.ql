/**
 * For internal use only.
 *
 * @name Stored cross-site scripting (experimental)
 * @description Using uncontrolled stored values in HTML allows for a stored cross-site scripting vulnerability.
 * @kind path-problem
 * @scored
 * @problem.severity error
 * @security-severity 6.1
 * @id js/ml-powered/stored-xss
 * @tags experimental security external/cwe/cwe-079 external/cwe/cwe-116
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
  "(Experimental) This may be a js/stored-xss result due to $@ " +
    getAdditionalAlertInfo(source.getNode(), sink.getNode()), source.getNode(),
  " Identified using machine learning"
