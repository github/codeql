/**
 * @id cpp/nist-pqc/pqc-vulnerable-algorithms-cng
 * @name Usage of PQC vulnerable algorithms
 * @description Usage of PQC vulnerable algorithms.
 * @microsoft.severity important
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @tags security
 *       pqc
 *       nist
 */

import cpp
import DataFlow::PathGraph
import WindowsCng
import WindowsCngPQCVulnerableUsage

from BCryptConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "PQC vulnerable algorithm $@ in use has been detected.",
  source.getNode().asExpr(), source.getNode().asExpr().toString()
