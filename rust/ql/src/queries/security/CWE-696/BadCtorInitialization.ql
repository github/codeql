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
    this.(CallExpr).getFunction().(PathExpr).getPath().getResolvedCrateOrigin() = "lang:std" or
    this.(MethodCallExpr).getResolvedCrateOrigin() = "lang:std"
  }
}

class PathElement = AstNode;

query predicate edges(PathElement pred, PathElement succ) {
  // starting edge (`#[ctor]` / `#[dtor]` attribute to call)
  exists(CtorAttr ctor, Function f, CallExprBase call |
    f.getAnAttr() = ctor and
    call.getEnclosingCallable() = f and
    pred = ctor and
    succ = call
  )
  or
  // transitive edge (call to call)
  exists(Function f |
    edges(_, pred) and
    pred.(CallExprBase).getStaticTarget() = f and
    succ.(CallExprBase).getEnclosingCallable() = f
  )
}

from CtorAttr ctor, StdCall call
where edges*(ctor, call)
select call, ctor, call,
  "Call to " + call.toString() + " in a function with the " + ctor.getWhichAttr() + " attribute."
