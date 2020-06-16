/**
 * Provides class representing the `django.redirect` function.
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintSink`.
 */

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Basic
private import semmle.python.web.django.Shared
private import semmle.python.web.Http

/**
 * Represents an argument to the `django.redirect` function.
 */
class DjangoRedirect extends HttpRedirectTaintSink {
    override string toString() { result = "django.redirect" }

    DjangoRedirect() { this = redirect().getACall().getAnArg() }
}
