private import rust
private import codeql.rust.controlflow.internal.generated.CfgNodes
private import codeql.rust.controlflow.ControlFlowGraph
private import codeql.rust.controlflow.CfgNodes
private import codeql.rust.internal.CachedStages

private module CfgNodesInput implements InputSig<Location> {
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
  override predicate relevantChild(AstNode child) {
    child = this.getStmtList().getTailExpr()
  }
}

class BreakExprTargetChildMapping extends ParentAstNode, Expr {
  override predicate relevantChild(AstNode child) {
    child.(BreakExpr).getTarget() = this
  }
}

class CallExprChildMapping extends ParentAstNode, CallExpr {
  override predicate relevantChild(AstNode child) {
    child = this.getArgList().getAnArg()
  }
}

class MethodCallExprChildMapping extends ParentAstNode, MethodCallExpr {
  override predicate relevantChild(AstNode child) {
    child = this.getArgList().getAnArg()
  }
}

class StructExprChildMapping extends ParentAstNode, StructExpr {
  override predicate relevantChild(AstNode child) {
    child = this.getStructExprFieldList().getAField().getExpr()
  }
}

class StructPatChildMapping extends ParentAstNode, StructPat {
  override predicate relevantChild(AstNode child) {
    child = this.getStructPatFieldList().getAField().getPat()
  }
}

class MacroCallChildMapping extends ParentAstNode, MacroCall {
  override predicate relevantChild(AstNode child) {
    child = this.getMacroCallExpansion()
  }
}

class FormatArgsExprChildMapping extends ParentAstNode, FormatArgsExpr {
  override predicate relevantChild(AstNode child) {
    child = this.getTemplate()
    or
    child = this.getAnArg().getExpr()
    or
    child =
      any(FormatTemplateVariableAccess v, Format f |
        f = this.getAFormat() and
        (
          v.getArgument() = f.getArgumentRef()
          or
          v.getArgument() = f.getWidthArgument()
          or
          v.getArgument() = f.getPrecisionArgument()
        )
      |
        v
      )
  }
}

class AssignmentExprChildMapping extends ParentAstNode, AssignmentExpr {
  override predicate relevantChild(AstNode child) {
    child.(VariableWriteAccess).getAssignmentExpr() = this
  }
}

private class ChildMappingImpl extends ChildMapping {
  override predicate hasCfgChild(
    AstNode parent, AstNode child, AstCfgNode cfn, AstCfgNode cfnChild
  ) {
    Stages::CfgStage::ref() and
    this.relevantChild(parent, child) and
    cfn.getAstNode() = CfgNodesInput::getDesugared(parent) and
    cfnChild.getAstNode() = CfgNodesInput::getDesugared(child)
  }
}
