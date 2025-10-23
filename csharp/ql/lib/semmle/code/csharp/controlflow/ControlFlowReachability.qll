/**
 * Provides an implementation of local (intraprocedural) control flow reachability.
 */

import csharp
private import codeql.controlflow.ControlFlowReachability
private import semmle.code.csharp.controlflow.BasicBlocks
private import semmle.code.csharp.controlflow.Guards as Guards
private import semmle.code.csharp.ExprOrStmtParent

private module ControlFlowInput implements
  InputSig<Location, ControlFlow::Node, ControlFlow::BasicBlock>
{
  private import csharp as CS

  AstNode getEnclosingAstNode(ControlFlow::Node node) {
    node.getAstNode() = result
    or
    not exists(node.getAstNode()) and result = node.getEnclosingCallable()
  }

  class AstNode = ExprOrStmtParent;

  AstNode getParent(AstNode node) { result = node.getParent() }

  class FinallyBlock extends AstNode {
    FinallyBlock() { any(TryStmt try).getFinally() = this }
  }

  class Expr = CS::Expr;

  class SourceVariable = Ssa::SourceVariable;

  class SsaDefinition = Ssa::Definition;

  class SsaExplicitWrite extends SsaDefinition instanceof Ssa::ExplicitDefinition {
    Expr getValue() { result = super.getADefinition().getSource() }
  }

  class SsaPhiDefinition = Ssa::PhiNode;

  class SsaUncertainWrite = Ssa::UncertainDefinition;

  class GuardValue = Guards::GuardValue;

  predicate ssaControlsBranchEdge(SsaDefinition def, BasicBlock bb1, BasicBlock bb2, GuardValue v) {
    Guards::Guards::ssaControlsBranchEdge(def, bb1, bb2, v)
  }

  predicate ssaControls(SsaDefinition def, BasicBlock bb, GuardValue v) {
    Guards::Guards::ssaControls(def, bb, v)
  }

  import Guards::Guards::InternalUtil
}

module ControlFlowReachability = Make<Location, Cfg, ControlFlowInput>;
