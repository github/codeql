/**
 * @name Extract source summaries
 * @description Extracts source summaries, that is, tuples `(p, lbl, cfg)` representing the fact
 *              that data may flow from a known source for configuration `cfg` to an escaping entry
 *              node of portal `p`, and have flow label `lbl` at that point.
 * @kind source-summary
 * @id js/source-summary-extraction
 */

import Configurations
import PortalEntrySink
import SourceFromAnnotation

from DataFlow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, Portal p
where
  cfg.hasFlowPath(source, sink) and
  p = sink.getNode().(PortalEntrySink).getPortal() and
  // avoid constructing infeasible paths
  sink.getPathSummary().hasCall() = false
select p.toString(), sink.getPathSummary().getEndLabel().toString(), cfg.toString()
