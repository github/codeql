private import codeql.swift.generated.decl.ParamDecl
private import codeql.swift.elements.decl.AbstractFunctionDecl
private import codeql.swift.elements.expr.AbstractClosureExpr


class ParamDecl extends ParamDeclBase {
  /** Gets the function which declares this parameter. */
  AbstractFunctionDecl getDeclaringFunction() { result.getAParam() = this }

  /** Gets the index of this parameter in its declaring function's parameter list. */
  int getIndex() {
    exists(AbstractFunctionDecl func | func.getParam(result) = this)
    or
    exists(AbstractClosureExpr expr | expr.getParam(result) = this)
  }
}
