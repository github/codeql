/**
 * @name Extract sink summaries
 * @description Extracts sink summaries, that is, tuples `(p, lbl, cfg)` representing the fact
 *              that data with flow label `lbl` may flow from a user-controlled exit node of portal
 *              `p` to a known sink for configuration `cfg`.
 * @kind sink-summary
 * @id js/sink-summary-extraction
 */

import Configurations
import PortalExitSource
import SinkFromAnnotation

from DataFlow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, Portal p
where
  cfg.hasFlowPath(source, sink) and
  p = source.getNode().(PortalExitSource).getPortal() and
  // avoid constructing infeasible paths
  sink.(DataFlow::MidPathNode).getPathSummary().hasReturn() = false
select p.toString(), source.(DataFlow::MidPathNode).getPathSummary().getStartLabel().toString(), cfg.toString()
