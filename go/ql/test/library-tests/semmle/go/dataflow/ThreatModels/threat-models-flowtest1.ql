/**
 * This is a dataflow test using the "default" threat model.
 */

import Test
import ThreatModelFlow::PathGraph

from ThreatModelFlow::PathNode source, ThreatModelFlow::PathNode sink
where ThreatModelFlow::flowPath(source, sink)
select source, sink
