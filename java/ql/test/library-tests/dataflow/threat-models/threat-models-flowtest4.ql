/**
 * This is a dataflow test using "all" threat models.
 */

import Test
import codeql.dataflow.test.ProvenancePathGraph
import semmle.code.java.dataflow.ExternalFlow
import ShowProvenance<interpretModelForTest/2, ThreatModel::PathNode, ThreatModel::PathGraph>

from ThreatModel::PathNode source, ThreatModel::PathNode sink
where ThreatModel::flowPath(source, sink)
select source, sink
