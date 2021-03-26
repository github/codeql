/** Provides classes for modeling pointer wrapper types and expressions. */

private import cpp

/** A class that wraps a pointer type. For example, `std::unique_ptr` and `std::shared_ptr`. */
class PointerWrapper extends Class {
  PointerWrapper() { this.hasQualifiedName(["std", "bsl", "boost"], ["shared_ptr", "unique_ptr"]) }
}

/** An expression of a `PointerWrapper` type. */
class PointerWrapperExpr extends Expr {
  PointerWrapperExpr() { this.getUnspecifiedType() instanceof PointerWrapper }

  /** Gets a dereference of the wrapped pointer. */
  Expr getADereference() { result.(OverloadedPointerDereferenceExpr).getExpr() = this }

  /** Gets an access to the wrapped pointer. */
  Expr getAPointerAccess() {
    result.(OverloadedArrowExpr).getExpr() = this
    or
    exists(FunctionCall call | call = result |
      call.getQualifier() = this and
      call.getTarget().hasName("get")
    )
  }
}
