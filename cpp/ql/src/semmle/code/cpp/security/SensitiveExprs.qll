import cpp

bindingset[s]
private predicate suspicious(string s) {
  (
    s.matches("%password%") or
    s.matches("%passwd%") or
    s.matches("%account%") or
    s.matches("%accnt%") or
    s.matches("%trusted%")
  ) and
  not (
    s.matches("%hashed%") or
    s.matches("%encrypted%") or
    s.matches("%crypt%")
  )
}

class SensitiveVariable extends Variable {
  SensitiveVariable() { suspicious(getName().toLowerCase()) }
}

class SensitiveFunction extends Function {
  SensitiveFunction() { suspicious(getName().toLowerCase()) }
}

class SensitiveExpr extends Expr {
  SensitiveExpr() {
    this.(VariableAccess).getTarget() instanceof SensitiveVariable or
    this.(FunctionCall).getTarget() instanceof SensitiveFunction
  }
}
