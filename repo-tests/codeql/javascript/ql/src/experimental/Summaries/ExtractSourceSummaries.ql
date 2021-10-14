/**
 * @name Extract source summaries
 * @description Extracts source summaries, that is, tuples `(p, lbl, cfg)` representing the fact
 *              that data may flow from a known source for configuration `cfg` to an escaping entry
 *              node of portal `p`, and have flow label `lbl` at that point.
 * @kind table
 * @id js/source-summary-extraction
 */

import Configurations
import PortalEntrySink
import SourceFromAnnotation

from
  DataFlow::Configuration cfg, DataFlow::SourcePathNode source, DataFlow::SinkPathNode sink,
  Portal p, DataFlow::MidPathNode last
where
  cfg = source.getConfiguration() and
  last = source.getASuccessor*() and
  sink = last.getASuccessor() and
  p = sink.getNode().(PortalEntrySink).getPortal() and
  // avoid constructing infeasible paths
  last.getPathSummary().hasCall() = false
select p.toString(), last.getPathSummary().getEndLabel().toString(), cfg.toString()
