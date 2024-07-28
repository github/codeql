/**
 * This is a dataflow test using the "default" threat model.
 */

import Test
import ThreatModel::PathGraph

from ThreatModel::PathNode source, ThreatModel::PathNode sink
where ThreatModel::flowPath(source, sink)
select source, sink
