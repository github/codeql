/**
 * Implementation of the evaluation-order CFG signature using the existing
 * Python control flow graph.
 */

private import python as Py
import TimerUtils

/** Existing Python CFG implementation of the evaluation-order signature. */
module OldCfg implements EvalOrderCfgSig {
  class CfgNode = Py::ControlFlowNode;

  class BasicBlock = Py::BasicBlock;

  CfgNode scopeGetEntryNode(Py::Scope s) { result = s.getEntryNode() }
}
