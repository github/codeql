private import codeql.swift.generated.expr.CaptureListExpr
private import codeql.swift.elements.decl.VarDecl
private import codeql.swift.elements.pattern.NamedPattern

class CaptureListExpr extends Generated::CaptureListExpr {
  override string toString() { result = this.getClosureBody().toString() }

  override VarDecl getVariable(int index) {
    result = this.getBindingDecl(index).getPattern(0).(NamedPattern).getVarDecl()
  }
}
