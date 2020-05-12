/**
 * Provides class and predicates to track external data that
 * may represent malicious httplib requests.
 *
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintKind` and `TaintSink`.
 */

import python
import semmle.python.security.TaintTracking
import semmle.python.security.strings.Untrusted
import semmle.python.security.injection.SSRF

private FunctionObject httpConnection() { result = ModuleObject::named("httplib").attr("HTTPConnection") }

class HttplibNode extends SSRFSink {
    override string toString() { result = "potential httplib SSRF vulnerability" }

    HttplibNode() {
        exists(CallNode call |
            httpConnection().getACall() = call and
            call.getAnArg() = this
        )
    }

    override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
