/**
 * Implementation of the evaluation-order CFG signature using the new
 * shared control flow graph from AstNodeImpl.
 */

private import python as Py
import TimerUtils
private import semmle.python.controlflow.internal.AstNodeImpl as CfgImpl
private import codeql.controlflow.SuccessorType

private class NewControlFlowNode = CfgImpl::ControlFlowNode;

private class NewBasicBlock = CfgImpl::BasicBlock;

/** New (shared) CFG implementation of the evaluation-order signature. */
module NewCfg implements EvalOrderCfgSig {
  class CfgNode instanceof NewControlFlowNode {
    // We must pick a *unique* representative CFG node for each AST node. The
    // shared CFG has several nodes per AST node (before / in-post-order / after
    // / after-value splits), but the timer test framework keys annotations on
    // `getNode()` and assumes one CFG node per annotated AST node. Without a
    // filter, an annotated `f()` would map to both `f()` and `After f()`, which
    // breaks two framework invariants: (1) the "no shared reachable" check
    // requires that two distinct nodes sharing a timestamp be mutually
    // unreachable (true/false branches of a condition), but `Before f()`,
    // `f()` and `After f()` share the annotation's timestamp *and* lie on one
    // linear path; and (2) the annotation walk (`nextTimerAnnotation`) halts at
    // the first reachable representative, so a second node for the same AST
    // node would stall the walk on the same timestamp instead of advancing to
    // the next evaluation event.
    //
    // We use the "after" node (`isAfter`) rather than the canonical `injects`
    // node, because `injects` represents short-circuit / conditional
    // expressions (`and`/`or`/`not`/ternary) by their *before* node, placing
    // them ahead of their operands — wrong for evaluation order. `isAfter`
    // instead picks the post-evaluation node: the merged before/after node for
    // simple leaves, the `TAfterNode` for post-order expressions, and the
    // `AfterValueNode`(s) for pre-order conditionals, all positioned after the
    // operands. The two value-split nodes of a conditional are genuinely
    // distinct evaluation outcomes (handled by `getATrueSuccessor` /
    // `getAFalseSuccessor`), so they do not violate the uniqueness assumption.
    CfgNode() { NewControlFlowNode.super.isAfter(_) }

    string toString() { result = NewControlFlowNode.super.toString() }

    Py::Location getLocation() { result = NewControlFlowNode.super.getLocation() }

    Py::AstNode getNode() {
      result = CfgImpl::astNodeToPyNode(NewControlFlowNode.super.getAstNode())
    }

    CfgNode getASuccessor() { nextCfgNode(this, result) }

    CfgNode getATrueSuccessor() {
      NewControlFlowNode.super.isAfterTrue(_) and
      // Only where there's also a false branch (true boolean split)
      exists(NewControlFlowNode other | other.isAfterFalse(NewControlFlowNode.super.getAstNode())) and
      nextCfgNodeFrom(this, result)
    }

    CfgNode getAFalseSuccessor() {
      NewControlFlowNode.super.isAfterFalse(_) and
      // Only where there's also a true branch (true boolean split)
      exists(NewControlFlowNode other | other.isAfterTrue(NewControlFlowNode.super.getAstNode())) and
      nextCfgNodeFrom(this, result)
    }

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
