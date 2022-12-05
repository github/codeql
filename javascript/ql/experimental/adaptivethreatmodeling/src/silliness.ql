/**
 * For internal use only.
 *
 * @kind path-problem
 * @scored
 * @problem.severity error
 * @security-severity 8.8
 * @id js/ml-powered/silliness
 */

import javascript
import experimental.adaptivethreatmodeling.SqlInjectionATM
import experimental.adaptivethreatmodeling.PromptConfiguration
import ATM::ResultsInfo
import DataFlow::PathGraph

from AtmConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink, float score
where cfg.hasBoostedFlowPath(source, sink, score)
select sink.getNode(), source, sink,
  "(Experimental) This may be a database query that depends on $@. Identified using machine learning.",
  source.getNode(), "a user-provided value", score
