private import AstImport

class AutomaticVariable extends Expr, TAutomaticVariable {
  final override string toString() { result = this.getLowerCaseName() }

  string getLowerCaseName() { any(Synthesis s).automaticVariableName(this, result) }

  bindingset[result]
  pragma[inline_late]
  string getAName() { result.toLowerCase() = this.getLowerCaseName() }
}

class MyInvocation extends AutomaticVariable {
  MyInvocation() { this.getLowerCaseName() = "myinvocation" }
}
