/**
 * This is a dataflow test using the "default" threat model with the
 * addition of the threat model group "local", but without the
 * "environment" threat model.
 */

import Test
import semmle.go.dataflow.ExternalFlow
import codeql.dataflow.test.ProvenancePathGraph
import ShowProvenance<interpretModelForTest/2, ThreatModelFlow::PathNode, ThreatModelFlow::PathGraph>

from ThreatModelFlow::PathNode source, ThreatModelFlow::PathNode sink
where ThreatModelFlow::flowPath(source, sink)
select source, sink
