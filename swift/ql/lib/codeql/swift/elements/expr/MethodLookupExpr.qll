private import codeql.swift.generated.expr.MethodLookupExpr
private import codeql.swift.elements.expr.MethodLookupExprConstructor
private import codeql.swift.elements.expr.DeclRefExpr
private import codeql.swift.elements.expr.OtherConstructorDeclRefExpr
private import codeql.swift.elements.decl.Decl
private import codeql.swift.elements.decl.MethodDecl
private import codeql.swift.generated.Raw
private import codeql.swift.generated.Synth

class MethodLookupExpr extends Generated::MethodLookupExpr {
  override string toString() { result = "." + this.getMember().toString() }

  override Expr getImmediateBase() {
    result = Synth::convertExprFromRaw(this.getUnderlying().getBase())
  }

  override Decl getImmediateMember() {
    result = this.getMethodRef().(DeclRefExpr).getDecl()
    or
    result = this.getMethodRef().(OtherConstructorDeclRefExpr).getConstructorDecl()
  }

  override Expr getImmediateMethodRef() {
    result = Synth::convertExprFromRaw(this.getUnderlying().getFunction())
  }

  MethodDecl getMethod() { result = this.getMember() }

  cached
  private Raw::SelfApplyExpr getUnderlying() { this = Synth::TMethodLookupExpr(result) }
}
