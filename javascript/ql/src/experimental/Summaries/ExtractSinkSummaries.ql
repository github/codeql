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

from
  DataFlow::Configuration cfg, DataFlow::SourcePathNode source, DataFlow::SinkPathNode sink,
  Portal p, DataFlow::MidPathNode last
where
  cfg = source.getConfiguration() and
  last = source.getASuccessor*() and
  sink = last.getASuccessor() and
  p = source.getNode().(PortalExitSource).getPortal() and
  // avoid constructing infeasible paths
  last.getPathSummary().hasReturn() = false
select p.toString(), last.getPathSummary().getStartLabel().toString(), cfg.toString()
