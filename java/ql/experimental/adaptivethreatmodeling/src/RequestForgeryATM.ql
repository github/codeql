/**
 * For internal use only.
 *
 * @name Server-side request forgery (experimental)
 * @description Making web requests based on unvalidated user-input
 *              may cause the server to communicate with malicious servers.
 * @kind path-problem
 * @scored
 * @problem.severity error
 * @security-severity 9.1
 * @precision high
 * @id java/ml-powered/ssrf
 * @tags experimental security
 *       external/cwe/cwe-918
 */

import experimental.adaptivethreatmodeling.RequestForgeryATM
import AtmResultsInfo
import DataFlow::PathGraph

from AtmConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink, float score
where cfg.hasBoostedFlowPath(source, sink, score)
select sink.getNode(), source, sink,
  "(Experimental) Potential server-side request forgery due to a $@.", source.getNode(),
  "user-provided value", score
