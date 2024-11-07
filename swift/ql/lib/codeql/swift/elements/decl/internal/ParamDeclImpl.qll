private import codeql.swift.generated.decl.ParamDecl
private import codeql.swift.elements.Callable

module Impl {
  class ParamDecl extends Generated::ParamDecl {
    /** Gets the function which declares this parameter. */
    Callable getDeclaringFunction() { result.getAParam() = this }

    /**
     * Gets the index of this parameter in its declaring function's parameter list,
     * or -1 if this is `self`.
     */
    int getIndex() { exists(Callable func | func.getParam(result) = this) }
  }

  /** A `self` parameter. */
  class SelfParamDecl extends ParamDecl {
    Callable call;

    SelfParamDecl() { call.getSelfParam() = this }

    override Callable getDeclaringFunction() { result = call }

    override int getIndex() { result = -1 }
  }
}
