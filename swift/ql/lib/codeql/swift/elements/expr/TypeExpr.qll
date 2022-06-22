private import codeql.swift.generated.expr.TypeExpr

class TypeExpr extends TypeExprBase {
  override string toString() { result = this.getTypeRepr().toString() }
}
