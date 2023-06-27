import csharp
import ControlFlow
import Common
import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl as Impl
import semmle.code.csharp.controlflow.internal.Splitting as Splitting
import Nodes

query predicate booleanNode(ElementNode e, BooleanSplit split) { split = e.getASplit() }

class MyFinallySplitControlFlowNode extends ElementNode {
  MyFinallySplitControlFlowNode() {
    exists(Splitting::FinallySplitting::FinallySplitType type |
      type = this.getASplit().(FinallySplit).getType()
    |
      not type instanceof SuccessorTypes::NormalSuccessor
    )
  }

  Impl::Statements::TryStmtTree getTryStmt() { this.getAstNode() = result.getAFinallyDescendant() }
}

query predicate finallyNode(MyFinallySplitControlFlowNode f, TryStmt try) { try = f.getTryStmt() }

query predicate entryPoint(Callable c, SourceControlFlowElement cfn) {
  c.getEntryPoint().getASuccessor().getAstNode() = cfn
}
