/**
 * This is a dataflow test using the "default" threat model with the
 * addition of "environment" and "commandargs".
 */

import Test
import TestUtilities.ProvenancePathGraph::ShowProvenance<ThreatModel::PathNode, ThreatModel::PathGraph>

from ThreatModel::PathNode source, ThreatModel::PathNode sink
where ThreatModel::flowPath(source, sink)
select source, sink
