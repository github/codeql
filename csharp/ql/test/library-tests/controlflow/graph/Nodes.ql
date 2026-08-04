import csharp
import ControlFlow
import Common

query predicate entryPoint(Callable c, SourceControlFlowElement cfn) {
  c.getEntryPoint().getASuccessor() = cfn.getControlFlowNode()
}
