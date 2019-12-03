import cpp

bindingset[s]
private predicate suspicious(string s) {
  (
    s.matches("%password%") or
    s.matches("%passwd%") or
    s.matches("%account%") or
    s.matches("%accnt%") or
    s.matches("%trusted%")
  ) and not (
    s.matches("%hashed%") or
    s.matches("%encrypted%") or
    s.matches("%crypt%")
  )
}

abstract class SensitiveExpr extends Expr { }

class SensitiveVarAccess extends SensitiveExpr {
  SensitiveVarAccess() {
    suspicious(this.(VariableAccess).getTarget().getName().toLowerCase())
  }
}

class SensitiveCall extends SensitiveExpr {
  SensitiveCall() {
    suspicious(this.(FunctionCall).getTarget().getName().toLowerCase())
  }
}
