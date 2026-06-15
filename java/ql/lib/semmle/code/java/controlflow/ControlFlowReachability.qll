/**
 * Provides an implementation of local (intraprocedural) control flow reachability.
 */
overlay[local?]
module;

import java
private import codeql.controlflow.ControlFlowReachability
private import semmle.code.java.dataflow.SSA
private import semmle.code.java.controlflow.Guards as Guards

private module ControlFlowInput implements InputSig<Location, ControlFlowNode, BasicBlock> {
  private import java as J
  import Ssa

  AstNode getEnclosingAstNode(ControlFlowNode node) { node.getAstNode() = result }

  class AstNode = ExprParent;

  AstNode getParent(AstNode node) {
    result = node.(Expr).getParent() or
    result = node.(Stmt).getParent()
  }

  class FinallyBlock extends AstNode {
    FinallyBlock() { any(TryStmt try).getFinally() = this }
  }

  class Expr = J::Expr;

  class GuardValue = Guards::GuardValue;

  predicate ssaControlsBranchEdge(SsaDefinition def, BasicBlock bb1, BasicBlock bb2, GuardValue v) {
    Guards::Guards_v3::ssaControlsBranchEdge(def, bb1, bb2, v)
  }

  predicate ssaControls(SsaDefinition def, BasicBlock bb, GuardValue v) {
    Guards::Guards_v3::ssaControls(def, bb, v)
  }

  import Guards::Guards_v3::InternalUtil
}

module ControlFlowReachability = Make<Location, Cfg, ControlFlowInput>;
