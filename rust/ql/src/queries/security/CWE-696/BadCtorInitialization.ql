/**
 * @name Bad 'ctor' initialization
 * @description Calling functions in the Rust std library from a ctor or dtor function is not safe.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id rust/ctor-initialization
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-696
 *       external/cwe/cwe-665
 */

import rust

/**
 * A `#[ctor]` or `#[dtor]` attribute.
 */
class CtorAttr extends Attr {
  string whichAttr;

  CtorAttr() {
    whichAttr = this.getMeta().getPath().getPart().getNameRef().getText() and
    whichAttr = ["ctor", "dtor"]
  }

  string getWhichAttr() { result = whichAttr }
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

class PathElement = AstNode;

query predicate edges(PathElement pred, PathElement succ) {
  // starting edge
  exists(CtorAttr ctor, Function f, StdCall call |
    f.getAnAttr() = ctor and
    call.getEnclosingCallable() = f and
    pred = ctor and // source
    succ = call // sink
  )
  // or
  // transitive edge
  // TODO
}

from CtorAttr ctor, StdCall call
where edges*(ctor, call)
select call, ctor, call, "Call to $@ in a function with the " + ctor.getWhichAttr() + " attribute.",
  call, call.toString()
