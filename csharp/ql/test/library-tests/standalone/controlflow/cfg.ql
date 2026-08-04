import csharp

/**
 * A method call where the target is unknown.
 * The purpose of this is to ensure that all MethodCall expressions
 * have a valid `toString()`.
 */
class UnknownCall extends Call {
  UnknownCall() { not exists(this.getTarget()) }

  override string toString() { result = "Call (unknown target)" }
}

query predicate edges(ControlFlowNode n1, ControlFlowNode n2) {
  not n1.getAstNode().fromLibrary() and n2 = n1.getASuccessor()
}
