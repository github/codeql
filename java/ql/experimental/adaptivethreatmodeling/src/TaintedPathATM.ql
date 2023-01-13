/**
 * For internal use only.
 *
 * @name Uncontrolled data used in path expression (experimental)
 * @description Accessing paths influenced by users can allow an attacker to access unexpected resources.
 * @kind path-problem
 * @scored
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id java/ml-powered/path-injection
 * @tags experimental security
 *       external/cwe/cwe-022
 *       external/cwe/cwe-023
 *       external/cwe/cwe-036
 *       external/cwe/cwe-073
 */

import experimental.adaptivethreatmodeling.TaintedPathATM
import AtmResultsInfo
import DataFlow::PathGraph

from AtmConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink, float score
where cfg.hasBoostedFlowPath(source, sink, score)
select sink.getNode(), source, sink, "(Experimental) This path depends on a $@.", source.getNode(),
  "user-provided value", score
