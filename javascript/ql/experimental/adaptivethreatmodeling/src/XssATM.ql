/**
 * For internal use only.
 *
 * @name Client-side cross-site scripting (experimental)
 * @description Writing user input directly to the DOM allows for
 *              a cross-site scripting vulnerability.
 * @kind path-problem
 * @scored
 * @problem.severity error
 * @security-severity 6.1
 * @id js/ml-powered/xss
 * @tags experimental security
 *       external/cwe/cwe-079
 */

import javascript
import ATM::ResultsInfo
import DataFlow::PathGraph
import experimental.adaptivethreatmodeling.XssATM

from AtmConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink, float score
where cfg.hasBoostedFlowPath(source, sink, score)
select sink.getNode(), source, sink,
  "(Experimental) This may be a cross-site scripting vulnerability due to $@. Identified using machine learning.",
  source.getNode(), "a user-provided value", score
