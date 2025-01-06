private import rust
private import codeql.rust.controlflow.internal.generated.CfgNodes
private import codeql.rust.controlflow.internal.ControlFlowGraphImpl as CfgImpl
private import codeql.rust.controlflow.ControlFlowGraph
private import codeql.rust.controlflow.BasicBlocks
private import codeql.rust.controlflow.CfgNodes
private import codeql.rust.internal.CachedStages

private predicate isPostOrder(AstNode n) {
  n instanceof Expr and
  not n instanceof LetExpr
  or
  n instanceof OrPat
  or
  n instanceof IdentPat
  or
  n instanceof LiteralPat
  or
  n instanceof Param
}

private module CfgNodesInput implements InputSig<Location> {
  private import codeql.rust.controlflow.ControlFlowGraph as Cfg

  class CfgNode = AstCfgNode;

  private AstNode desugar(AstNode n) {
    result = n.(ParenPat).getPat()
    or
    result = n.(ParenExpr).getExpr()
  }

  AstNode getDesugared(AstNode n) {
    result = getDesugared(desugar(n))
    or
    not exists(desugar(n)) and
    result = n
  }
}

import MakeCfgNodes<Location, CfgNodesInput>

class MatchExprChildMapping extends ParentAstNode, MatchExpr {
  override predicate relevantChild(AstNode child) {
    child = this.getAnArm().getPat()
    or
    child = this.getAnArm().getGuard().getCondition()
    or
    child = this.getAnArm().getExpr()
  }
}

class BlockExprChildMapping extends ParentAstNode, BlockExpr {
  override predicate relevantChild(AstNode child) { child = this.getStmtList().getTailExpr() }
}

class BreakExprTargetChildMapping extends ParentAstNode, Expr {
  override predicate relevantChild(AstNode child) { child.(BreakExpr).getTarget() = this }
}

class CallExprBaseChildMapping extends ParentAstNode, CallExprBase {
  override predicate relevantChild(AstNode child) { child = this.getArgList().getAnArg() }
}

class RecordExprChildMapping extends ParentAstNode, RecordExpr {
  override predicate relevantChild(AstNode child) {
    child = this.getRecordExprFieldList().getAField().getExpr()
  }
}

class RecordPatChildMapping extends ParentAstNode, RecordPat {
  override predicate relevantChild(AstNode child) {
    child = this.getRecordPatFieldList().getAField().getPat()
  }
}

class MacroCallChildMapping extends ParentAstNode, MacroCall {
  override predicate relevantChild(AstNode child) { child = this.getExpanded() }
}

class FormatArgsExprChildMapping extends ParentAstNode, CfgImpl::ExprTrees::FormatArgsExprTree {
  override predicate relevantChild(AstNode child) { child = this.getChildNode(_) }
}

private class ChildMappingImpl extends ChildMapping {
  /** Gets a CFG node for `child`, where `child` is a relevant child node of `parent`. */
  private CfgNode getRelevantChildCfgNode(AstNode parent, AstNode child) {
    this.relevantChild(parent, child) and
    result = CfgNodesInput::getDesugared(child).getACfgNode()
  }

  pragma[nomagic]
  private BasicBlock getARelevantBasicBlock(AstNode parent) {
    result.getANode().getAstNode() = parent or
    result.getANode() = this.getRelevantChildCfgNode(parent, _)
  }

  /**
   * Holds if CFG node `cfnChild` can reach basic block `bb`, without going
   * through an intermediate block that contains a CFG node for `parent` or
   * any other relevant child of `parent`.
   */
  pragma[nomagic]
  predicate childNodeReachesBasicBlock(
    AstNode parent, AstNode child, CfgNode cfnChild, BasicBlock bb
  ) {
    exists(BasicBlock bb0 |
      cfnChild = this.getRelevantChildCfgNode(parent, child) and
      bb0.getANode() = cfnChild
    |
      bb = bb0
      or
      not bb0.getANode().getAstNode() = parent and
      if isPostOrder(parent) then bb = bb0.getASuccessor() else bb = bb0.getAPredecessor()
    )
    or
    exists(BasicBlock mid |
      this.childNodeReachesBasicBlock(parent, child, cfnChild, mid) and
      not mid = this.getARelevantBasicBlock(parent) and
      if isPostOrder(parent) then bb = mid.getASuccessor() else bb = mid.getAPredecessor()
    )
  }

  /**
   * Holds if CFG node `cfnChild` can reach CFG node `cfnParent`, without going
   * through an intermediate block that contains a CFG node for `parent`.
   */
  pragma[nomagic]
  predicate childNodeReachesParentNode(
    AstNode parent, CfgNode cfnParent, AstNode child, CfgNode cfnChild
  ) {
    // `cfnChild` can reach `cfnParent` directly
    exists(BasicBlock bb |
      this.childNodeReachesBasicBlock(parent, child, cfnChild, bb) and
      cfnParent.getAstNode() = parent
    |
      cfnParent = bb.getANode()
      or
      if isPostOrder(parent)
      then cfnParent = bb.getASuccessor().getANode()
      else cfnParent = bb.getAPredecessor().getANode()
    )
    or
    // `cfnChild` can reach `cfnParent` by going via another relevant child
    exists(CfgNode cfnOtherChild |
      this.childNodeReachesParentNode(parent, cfnParent, _, cfnOtherChild) and
      exists(BasicBlock bb |
        this.childNodeReachesBasicBlock(parent, child, cfnChild, bb) and
        bb.getANode() = cfnOtherChild
      )
    )
  }

  override predicate hasCfgChild(AstNode parent, AstNode child, AstCfgNode cfn, AstCfgNode cfnChild) {
    Stages::CfgStage::ref() and
    this.childNodeReachesParentNode(parent, cfn, child, cfnChild)
  }
}
