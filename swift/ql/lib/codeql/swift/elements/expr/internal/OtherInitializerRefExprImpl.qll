private import codeql.swift.generated.expr.OtherInitializerRefExpr

module Impl {
  class OtherInitializerRefExpr extends Generated::OtherInitializerRefExpr {
    override string toStringImpl() { result = this.getInitializer().toStringImpl() }
  }
}
