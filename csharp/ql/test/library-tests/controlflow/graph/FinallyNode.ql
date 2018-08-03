import csharp
import semmle.code.csharp.controlflow.ControlFlowGraph
import Internal

class MyFinallySplitControlFlowNode extends ControlFlowElementNode {
  MyFinallySplitControlFlowNode() {
    exists(FinallySplitting::FinallySplitType type |
      type = this.getASplit().(FinallySplit).getType() |
      not type instanceof ControlFlowEdgeSuccessor
    )
  }

  TryStmt getTryStmt() {
    this.getElement() = FinallySplitting::getAFinallyDescendant(result)
  }
}

from MyFinallySplitControlFlowNode f
select f.getTryStmt(), f
