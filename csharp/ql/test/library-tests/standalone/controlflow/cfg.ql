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

class UnknownLocalVariableDeclExpr extends LocalVariableDeclAndInitExpr {
  UnknownLocalVariableDeclExpr() { not exists(this.getVariable().getType().getName()) }

  override string toString() { result = "(unknown type) " + this.getName() }
}

query predicate edges(ControlFlow::Node n1, ControlFlow::Node n2) { n2 = n1.getASuccessor() }
