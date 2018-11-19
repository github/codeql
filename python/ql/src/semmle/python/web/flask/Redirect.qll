/** Provides class representing the `flask.redirect` function.
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintSink`.
 */
import python

import semmle.python.security.TaintTracking
import semmle.python.security.strings.Basic
import semmle.python.web.flask.General

FunctionObject flask_redirect() {
    result = theFlaskModule().getAttribute("redirect")
}

/**
 * Represents an argument to the `flask.redirect` function.
 */
class FlaskRedirect extends TaintSink {

    override string toString() {
        result = "flask.redirect"
    }

    FlaskRedirect() {
        exists(CallNode call |
            flask_redirect().getACall() = call and
            this = call.getAnArg()
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof StringKind
    }

}
