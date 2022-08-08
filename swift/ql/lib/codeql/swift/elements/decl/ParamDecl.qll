private import codeql.swift.generated.decl.ParamDecl
private import codeql.swift.elements.Callable

class ParamDecl extends ParamDeclBase {
  /** Gets the function which declares this parameter. */
  Callable getDeclaringFunction() { result.getAParam() = this }

  /** Gets the index of this parameter in its declaring function's parameter list. */
  int getIndex() { exists(Callable func | func.getParam(result) = this) }
}
