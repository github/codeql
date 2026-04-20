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
    string toString() { result = NewControlFlowNode.super.toString() }

    Py::Location getLocation() { result = NewControlFlowNode.super.getLocation() }

    Py::AstNode getNode() {
      result = CfgImpl::astNodeToPyNode(NewControlFlowNode.super.getAstNode())
    }

    CfgNode getASuccessor() { result = NewControlFlowNode.super.getASuccessor() }

    CfgNode getAnExceptionalSuccessor() {
      result = NewControlFlowNode.super.getAnExceptionSuccessor()
    }

    Py::Scope getScope() { result = NewControlFlowNode.super.getEnclosingCallable().asScope() }

    BasicBlock getBasicBlock() { result = NewControlFlowNode.super.getBasicBlock() }
  }

  class BasicBlock instanceof NewBasicBlock {
    string toString() { result = NewBasicBlock.super.toString() }

    CfgNode getNode(int n) { result = NewBasicBlock.super.getNode(n) }

    predicate reaches(BasicBlock bb) { this = bb or this.strictlyReaches(bb) }

    predicate strictlyReaches(BasicBlock bb) { NewBasicBlock.super.getASuccessor+() = bb }

    predicate strictlyDominates(BasicBlock bb) { NewBasicBlock.super.strictlyDominates(bb) }
  }

  CfgNode scopeGetEntryNode(Py::Scope s) {
    result instanceof CfgImpl::ControlFlow::EntryNode and
    result.getScope() = s
  }
}
