/**
 * @name Bad 'ctor' initialization
 * @description TODO
 * @kind path-problem
 * @problem.severity error
 * @ security-severity TODO
 * @ precision TODO
 * @id rust/ctor-initialization
 * @tags security
 *       external/cwe/cwe-696
 *       external/cwe/cwe-665
 */

import rust

/**
 * A `#[ctor]` or `#[dtor]` attribute.
 */
class CtorAttr extends Attr {
  CtorAttr() { this.getMeta().getPath().getPart().getNameRef().getText() = ["ctor", "dtor"] }
}

/**
 * A call into the Rust standard library.
 */
class StdCall extends Expr {
  StdCall() {
    this.(CallExpr).getExpr().(PathExpr).getPath().getResolvedCrateOrigin() = "lang:std" or
    this.(MethodCallExpr).getResolvedCrateOrigin() = "lang:std"
  }
}

from CtorAttr ctor, Function f, StdCall call
where
  f.getAnAttr() = ctor and
  call.getEnclosingCallable() = f
select f.getName(), "This function has the $@ attribute but calls $@ in the standard library.",
  ctor, ctor.toString(), call, call.toString()
