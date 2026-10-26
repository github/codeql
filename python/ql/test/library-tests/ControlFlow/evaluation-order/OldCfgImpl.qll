/**
 * Implementation of the evaluation-order CFG signature using the existing
 * Python control flow graph.
 */

private import python as PY
import TimerUtils

/** Existing Python CFG implementation of the evaluation-order signature. */
module OldCfg implements EvalOrderCfgSig {
  class CfgNode = PY::ControlFlowNode;

  class BasicBlock = PY::BasicBlock;

  CfgNode scopeGetEntryNode(PY::Scope s) { result = s.getEntryNode() }
}
