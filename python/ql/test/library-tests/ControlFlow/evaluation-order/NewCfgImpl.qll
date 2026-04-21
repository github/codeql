/**
 * Implementation of the evaluation-order CFG signature using the new
 * shared control flow graph from AstNodeImpl.
 */

private import python as Py
import TimerUtils
private import semmle.python.controlflow.internal.AstNodeImpl as CfgImpl

private class NewControlFlowNode = CfgImpl::ControlFlowNode;

private class NewBasicBlock = CfgImpl::BasicBlock;

/** New (shared) CFG implementation of the evaluation-order signature. */
module NewCfg implements EvalOrderCfgSig {
  class CfgNode instanceof NewControlFlowNode {
    // Only include the unique representative node for each AST node,
    // filtering out synthetic before/after/entry/exit/additional nodes.
    CfgNode() { NewControlFlowNode.super.injects(_) }

    string toString() { result = NewControlFlowNode.super.toString() }

    Py::Location getLocation() { result = NewControlFlowNode.super.getLocation() }

    Py::AstNode getNode() {
      result = CfgImpl::astNodeToPyNode(NewControlFlowNode.super.getAstNode())
    }

    CfgNode getASuccessor() { nextCfgNode(this, result) }

    CfgNode getAnExceptionalSuccessor() {
      exists(NewControlFlowNode mid |
        mid = NewControlFlowNode.super.getAnExceptionSuccessor() and
        nextCfgNodeFrom(mid, result)
      )
    }

    Py::Scope getScope() { result = NewControlFlowNode.super.getEnclosingCallable().asScope() }

    BasicBlock getBasicBlock() {
      exists(NewBasicBlock bb, int i | bb.getNode(i) = this and result = bb)
    }
  }

  /**
   * Holds if `next` is the nearest CfgNode reachable from `n` via
   * one or more raw CFG successor edges, skipping non-CfgNode intermediaries.
   */
  private predicate nextCfgNodeFrom(NewControlFlowNode n, CfgNode next) {
    next = n.getASuccessor()
    or
    exists(NewControlFlowNode mid |
      mid = n.getASuccessor() and
      not mid instanceof CfgNode and
      nextCfgNodeFrom(mid, next)
    )
  }

  /**
   * Holds if `next` is the nearest CfgNode successor of `n`,
   * skipping synthetic intermediate nodes.
   */
  private predicate nextCfgNode(CfgNode n, CfgNode next) { nextCfgNodeFrom(n, next) }

  class BasicBlock instanceof NewBasicBlock {
    string toString() { result = NewBasicBlock.super.toString() }

    CfgNode getNode(int n) { result = NewBasicBlock.super.getNode(n) }

    predicate reaches(BasicBlock bb) { this = bb or this.strictlyReaches(bb) }

    predicate strictlyReaches(BasicBlock bb) { NewBasicBlock.super.getASuccessor+() = bb }

    predicate strictlyDominates(BasicBlock bb) { NewBasicBlock.super.strictlyDominates(bb) }
  }

  CfgNode scopeGetEntryNode(Py::Scope s) {
    exists(CfgImpl::ControlFlow::EntryNode entry |
      entry.getEnclosingCallable().asScope() = s and
      nextCfgNodeFrom(entry, result)
    )
  }
}
