import csharp
import ControlFlow
import Common
import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl as Impl
import semmle.code.csharp.controlflow.internal.Splitting as Splitting
import Nodes

query predicate entryPoint(Callable c, SourceControlFlowElement cfn) {
  c.getEntryPoint().getASuccessor().getAstNode() = cfn
}
