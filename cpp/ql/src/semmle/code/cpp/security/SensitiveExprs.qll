import cpp

private string suspicious() {
  result = "%password%" or
  result = "%passwd%" or
  result = "%account%" or
  result = "%accnt%" or
  result = "%trusted%"
}

private string nonSuspicious() {
  result = "%hashed%" or
  result = "%encrypted%" or
  result = "%crypt%"
}

abstract class SensitiveExpr extends Expr { }

class SensitiveVarAccess extends SensitiveExpr {
  SensitiveVarAccess() {
    this instanceof VariableAccess and
    exists(string s | this.toString().toLowerCase() = s |
      s.matches(suspicious()) and
      not s.matches(nonSuspicious())
    )
  }
}

class SensitiveCall extends SensitiveExpr {
  SensitiveCall() {
    this instanceof FunctionCall and
    exists(string s | this.toString().toLowerCase() = s |
      s.matches(suspicious()) and
      not s.matches(nonSuspicious())
    )
  }
}
