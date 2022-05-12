/**
 * For internal use only.
 *
 * @name Code injection (experimental)
 * @description Interpreting unsanitized user input as code allows a malicious user arbitrary code execution.
 * @kind path-problem
 * @scored
 * @problem.severity error
 * @security-severity 9.3
 * @id js/ml-powered/code-injection
 * @tags experimental security external/cwe/cwe-094 external/cwe/cwe-095 external/cwe/cwe-079 external/cwe/cwe-116
 */

import experimental.adaptivethreatmodeling.CodeInjectionATM
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
  "[Score = " + scoreString + "] This may be a js/code-injection result depending on $@ " +
    getAdditionalAlertInfo(source.getNode(), sink.getNode()), source.getNode(),
  "a user-provided value", score
