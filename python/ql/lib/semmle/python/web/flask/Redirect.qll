/**
 * Provides class representing the `flask.redirect` function.
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintSink`.
 */

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Basic
import semmle.python.web.flask.General

FunctionValue flask_redirect() { result = Value::named("flask.redirect") }

/**
 * Represents an argument to the `flask.redirect` function.
 */
class FlaskRedirect extends HttpRedirectTaintSink {
  override string toString() { result = "flask.redirect" }

  FlaskRedirect() {
    exists(CallNode call |
      flask_redirect().getACall() = call and
      this = call.getAnArg()
    )
  }
}
