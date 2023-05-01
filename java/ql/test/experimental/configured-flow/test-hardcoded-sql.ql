/**
 * @name Testing the threat model
 * @kind path-problem
 * @problem.severity warning
 * @precision low
 * @id java/threat-model-hardcoded-sql
 * @tags security
 */

import TestHardcoded
import ThreatModel::PathGraph

from ThreatModel::PathNode source, ThreatModel::PathNode sink
where ThreatModel::flowPath(source, sink)
select sink.getNode(), source, sink, "This is some kind of threat model thingy $@.",
  source.getNode(), "Source of that thingy"
