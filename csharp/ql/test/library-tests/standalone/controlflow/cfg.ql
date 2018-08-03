import csharp
import semmle.code.csharp.controlflow.ControlFlowGraph

/**
 * A method call where the target is unknown.
 * The purpose of this is to ensure that all MethodCall expressions
 * have a valid `toString()`.
 */
class UnknownCall extends MethodCall
{
  UnknownCall() { not exists(this.getTarget()) }
  
  override string toString() { result = "Call to unknown method" }
}

query predicate edges(ControlFlowNode n1, ControlFlowNode n2) {
  n2 = n1.getASuccessor()
}
