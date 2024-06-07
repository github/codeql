private import codeql.swift.generated.expr.OtherInitializerRefExpr

class OtherInitializerRefExpr extends Generated::OtherInitializerRefExpr {
  override string toString() { result = this.getInitializer().toString() }
}
