import csharp
import ControlFlow
import Internal
import Nodes

class MyFinallySplitControlFlowNode extends ElementNode {
  MyFinallySplitControlFlowNode() {
    exists(FinallySplitting::FinallySplitType type |
      type = this.getASplit().(FinallySplit).getType()
    |
      not type instanceof SuccessorTypes::NormalSuccessor
    )
  }

  TryStmt getTryStmt() { this.getElement() = FinallySplitting::getAFinallyDescendant(result) }
}

from MyFinallySplitControlFlowNode f
select f.getTryStmt(), f
