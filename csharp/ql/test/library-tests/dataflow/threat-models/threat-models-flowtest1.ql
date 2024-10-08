/**
 * This is a dataflow test using the "default" threat model.
 */

import Test
import TestUtilities.ProvenancePathGraph::ShowProvenance<ThreatModel::PathNode, ThreatModel::PathGraph>

from ThreatModel::PathNode source, ThreatModel::PathNode sink
where ThreatModel::flowPath(source, sink)
select source, sink
