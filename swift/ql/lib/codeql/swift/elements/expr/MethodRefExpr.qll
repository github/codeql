private import codeql.swift.generated.expr.MethodRefExpr
private import codeql.swift.elements.expr.Expr
private import codeql.swift.elements.decl.Decl
private import codeql.swift.elements.decl.AbstractFunctionDecl
private import codeql.swift.generated.Raw
private import codeql.swift.generated.Synth

class MethodRefExpr extends MethodRefExprBase {
  override string toString() { result = "." + this.getMember().toString() }

  override Expr getImmediateBase() {
    result = Synth::convertExprFromRaw(this.getUnderlying().getBase())
  }

  override Decl getImmediateMember() {
    result =
      Synth::convertDeclFromRaw(this.getUnderlying().getFunction().(Raw::DeclRefExpr).getDecl())
  }

  AbstractFunctionDecl getMethod() { result = this.getMember() }

  cached
  private Raw::DotSyntaxCallExpr getUnderlying() { this = Synth::TMethodRefExpr(result) }
}
