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
 * A `#[ctor]` or `#[dtor]` attribute, that is, a source for this query.
 */
class CtorAttr extends Attr {
  string whichAttr;

  CtorAttr() {
    whichAttr = this.getMeta().getPath().getText() and
    whichAttr = ["ctor", "dtor"]
  }

  string getWhichAttr() { result = whichAttr }
}

/**
 * A call into the Rust standard library, that is, a sink for this query.
 */
class StdCall extends Expr {
  StdCall() {
    this.(CallExprBase).getStaticTarget().getCanonicalPath().matches(["std::%", "<std::%"])
  }
}

class PathElement = AstNode;

/**
 * Holds if (`pred`, `succ`) represents a candidate edge for the query that is
 * reachable from a source.
 */
predicate edgesFwd(PathElement pred, PathElement succ) {
  // attribute (source) -> function in macro expansion
  exists(Function f |
    pred.(CtorAttr) = f.getAnAttr() and
    (
      f.getAttributeMacroExpansion().getAnItem() = succ.(Callable)
      or
      // if for some reason the ctor/dtor macro expansion failed, fall back to looking into the unexpanded item
      not f.hasAttributeMacroExpansion() and f = succ.(Callable)
    )
  )
  or
  // [forwards reachable] callable -> enclosed call
  edgesFwd(_, pred) and
  pred = succ.(CallExprBase).getEnclosingCallable()
  or
  // [forwards reachable] call -> target callable
  edgesFwd(_, pred) and
  pred.(CallExprBase).getStaticTarget() = succ
}

/**
 * Holds if (`pred`, `succ`) represents an edge for the query that is reachable
 * from a source and backwards reachable from a sink (adding the backwards
 * reachability constraint reduces the amount of output data produced).
 */
query predicate edges(PathElement pred, PathElement succ) {
  edgesFwd(pred, succ) and
  (
    succ instanceof StdCall // sink
    or
    edges(succ, _) // backwards reachable from a sink
  )
}

from CtorAttr source, StdCall sink
where edges+(source, sink)
select sink, source, sink,
  "Call to " + sink.toString() + " from the standard library in a function with the " +
    source.getWhichAttr() + " attribute."
