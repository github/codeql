private import codeql.swift.generated.expr.MethodLookupExpr
private import codeql.swift.elements.expr.internal.MethodLookupExprConstructor
private import codeql.swift.elements.expr.DeclRefExpr
private import codeql.swift.elements.expr.OtherInitializerRefExpr
private import codeql.swift.elements.decl.Decl
private import codeql.swift.elements.decl.Method
private import codeql.swift.generated.Raw
private import codeql.swift.generated.Synth

module Impl {
  class MethodLookupExpr extends Generated::MethodLookupExpr {
    override string toString() { result = "." + this.getMember().toString() }

    override Expr getImmediateBase() {
      result = Synth::convertExprFromRaw(this.getUnderlying().getBase())
    }

    override Decl getMember() {
      result = this.getMethodRef().(DeclRefExpr).getDecl()
      or
      result = this.getMethodRef().(OtherInitializerRefExpr).getInitializer()
    }

    override Expr getImmediateMethodRef() {
      result = Synth::convertExprFromRaw(this.getUnderlying().getFunction())
    }

    Method getMethod() { result = this.getMember() }

    cached
    private Raw::SelfApplyExpr getUnderlying() { this = Synth::TMethodLookupExpr(result) }
  }
}
