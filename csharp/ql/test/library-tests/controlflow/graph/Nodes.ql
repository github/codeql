import csharp
import ControlFlow
import Common
import Internal
import Nodes

query predicate booleanNode(ElementNode e, BooleanSplit split) { split = e.getASplit() }

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

query predicate finallyNode(MyFinallySplitControlFlowNode f, TryStmt try) { try = f.getTryStmt() }

query predicate entryPoint(Callable c, SourceControlFlowElement cfn) {
  c.getEntryPoint().getASuccessor().getElement() = cfn
}
