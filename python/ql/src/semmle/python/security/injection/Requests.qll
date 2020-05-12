/**
 * Provides class and predicates to track external data that
 * may represent malicious requests.
 *
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintKind` and `TaintSink`.
 */

import python
import semmle.python.security.TaintTracking
import semmle.python.security.strings.Untrusted
import semmle.python.security.injection.SSRF

private FunctionObject requestsGet() { result = ModuleObject::named("requests").attr("get") }
private FunctionObject requestsPost() { result = ModuleObject::named("requests").attr("post") }

class RequestsNode extends SSRFSink {
    override string toString() { result = "potential requests SSRF vulnerability" }

    RequestsNode() {
        exists(CallNode call |
            requestsGet().getACall() = call and
            call.getAnArg() = this or
          	requestsPost().getACall() = call and
            call.getAnArg() = this
        )
    }

    override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
