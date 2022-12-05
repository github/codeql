/**
 * For internal use only.
 *
 * @name DOM text reinterpreted as HTML (experimental)
 * @description Reinterpreting text from the DOM as HTML can lead
 *              to a cross-site scripting vulnerability.
 * @kind path-problem
 * @scored
 * @problem.severity error
 * @security-severity 6.1
 * @id js/ml-powered/xss-through-dom
 * @tags experimental security
 *       external/cwe/cwe-079 external/cwe/cwe-116
 */

import javascript
import ATM::ResultsInfo
import DataFlow::PathGraph
import experimental.adaptivethreatmodeling.XssThroughDomATM

from AtmConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink, float score
where cfg.hasBoostedFlowPath(source, sink, score)
select sink.getNode(), source, sink,
  "(Experimental) $@ may be reinterpreted as HTML without escaping meta-characters. Identified using machine learning.",
  source.getNode(), "DOM text", score
