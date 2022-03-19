/**
 * Provides class representing the `bottle.redirect` function.
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintSink`.
 */

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Basic
import semmle.python.web.bottle.General

deprecated FunctionValue bottle_redirect() { result = theBottleModule().attr("redirect") }

/**
 * An argument to the `bottle.redirect` function.
 */
deprecated class BottleRedirect extends TaintSink {
  override string toString() { result = "bottle.redirect" }

  BottleRedirect() {
    exists(CallNode call |
      bottle_redirect().getACall() = call and
      this = call.getAnArg()
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof StringKind }
}
