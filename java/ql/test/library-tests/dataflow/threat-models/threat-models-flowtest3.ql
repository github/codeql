/**
 * This is a dataflow test using the "default" threat model with the
 * addition of the threat model group "local".
 */

import Test
import codeql.dataflow.test.ProvenancePathGraph
import semmle.code.java.dataflow.ExternalFlow
import ShowProvenance<interpretModelForTest/2, ThreatModel::PathNode, ThreatModel::PathGraph>

from ThreatModel::PathNode source, ThreatModel::PathNode sink
where ThreatModel::flowPath(source, sink)
select source, sink
