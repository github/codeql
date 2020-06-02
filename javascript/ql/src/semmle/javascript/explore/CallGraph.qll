/**
 * Provides predicates for visualizing the call paths leading to or from a specific function.
 *
 * It defines three predicates: `callEdge`, `isStartOfCallPath` and `isEndOfCallPath`,
 * as well as the `nodes` and `edges` predicates needed for a path problem query.
 *
 * To use this library, make sure the query has `@kind path-problem`
 * and selects columns appropriate for a path problem query.
 * For example:
 * ```
 * import javascript
 * import semmle.javascript.explore.CallGraph
 * import DataFlow
 *
 * from InvokeNode invoke, FunctionNode function
 * where callEdge*(invoke, function)
 *   and isStartOfCallPath(invoke)
 *   and function.getName() = "targetFunction"
 * select invoke, invoke, function, "Call path to 'targetFunction'"
 * ```
 *
 * NOTE: This library should only be used for debugging and exploration, not in production code.
 */

import javascript
private import DataFlow

/**
 * Holds if `pred -> succ` is an edge in the call graph.
 *
 * There are edges from calls to their callees,
 * and from functions to their contained calls and in some cases
 * their inner functions to model functions invoked indirectly
 * by being passed to another call.
 */
predicate callEdge(Node pred, Node succ) {
  exists(InvokeNode invoke, Function f |
    invoke.getACallee() = f and
    pred = invoke and
    succ = f.flow()
    or
    invoke.getContainer() = f and
    pred = f.flow() and
    succ = invoke
  )
  or
  exists(Function inner, Function outer |
    inner.getEnclosingContainer() = outer and
    not inner = outer.getAReturnedExpr() and
    pred = outer.flow() and
    succ = inner.flow()
  )
}

/** Holds if `pred -> succ` is an edge in the call graph. */
query predicate edges = callEdge/2;

/** Holds if `node` is part of the call graph. */
query predicate nodes(Node node) {
  node instanceof InvokeNode or
  node instanceof FunctionNode
}

/** Gets a call in a function that has no known call sites. */
private InvokeNode rootCall() { not any(InvokeNode i).getACallee() = result.getContainer() }

/**
 * Holds if `invoke` should be used as the starting point of a call path.
 */
predicate isStartOfCallPath(InvokeNode invoke) {
  // `invoke` should either be a root call or be part of a cycle with no root.
  // An equivalent requirement is that `invoke` is not reachable from a root.
  not callEdge+(rootCall(), invoke)
}

/** Gets a function that contains no calls to other functions. */
private FunctionNode leafFunction() { not callEdge(result, _) }

/**
 * Holds if `fun` should be used as the end point of a call path.
 */
predicate isEndOfCallPath(FunctionNode fun) {
  // `fun` should either be a leaf function or part of a cycle with no leaves.
  not callEdge+(fun, leafFunction())
}
