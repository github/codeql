/**
 * @name Extract flow step summaries
 * @description Extracts flow step summaries, that is, tuples `(p1, lbl1, p2, lbl2, cfg)`
 *              representing the fact that data with flow label `lbl1` may flow from a
 *              user-controlled exit node of portal `p1` to an escaping entry node of portal `p2`,
 *              and have label `lbl2` at that point. Moreover, the path from `p1` to `p2` contains
 *              no sanitizers specified by configuration `cfg`.
 * @kind table
 * @id js/step-summary-extraction
 */

import Configurations
import PortalExitSource
import PortalEntrySink

from
  TaintTracking::Configuration cfg, DataFlow::SourcePathNode source, DataFlow::SinkPathNode sink,
  Portal p1, Portal p2, DataFlow::FlowLabel lbl1, DataFlow::FlowLabel lbl2,
  DataFlow::MidPathNode last
where
  cfg = source.getConfiguration() and
  last = source.getASuccessor*() and
  sink = last.getASuccessor() and
  p1 = source.getNode().(PortalExitSource).getPortal() and
  p2 = sink.getNode().(PortalEntrySink).getPortal() and
  lbl1 = last.getPathSummary().getStartLabel() and
  lbl2 = last.getPathSummary().getEndLabel() and
  // avoid constructing infeasible paths
  last.getPathSummary().hasCall() = false and
  last.getPathSummary().hasReturn() = false and
  // restrict to steps flow function parameters to returns
  p1.(ParameterPortal).getBasePortal() = p2.(ReturnPortal).getBasePortal() and
  // restrict to data/taint flow
  lbl1 instanceof DataFlow::StandardFlowLabel
select p1.toString(), lbl1.toString(), p2.toString(), lbl2.toString(), cfg.toString()
