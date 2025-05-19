private import AstImport

class AutomaticVariable extends Expr, TAutomaticVariable {
  final override string toString() { result = this.getName() }

  string getName() { any(Synthesis s).automaticVariableName(this, result) }
}

class MyInvocation extends AutomaticVariable {
  MyInvocation() { this.getName() = "myinvocation" }
}
