/**
 * Provides class and predicates to track external data that
 * may represent malicious urllib requests.
 *
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintKind` and `TaintSink`.
 */

import python
import semmle.python.security.TaintTracking
import semmle.python.security.strings.Untrusted
import semmle.python.security.injection.SSRF

private FunctionObject urlOpen() { result = ModuleObject::named("urllib.requests").attr("urlopen") }
private FunctionObject urlRequest() { result = ModuleObject::named("urllib.requests").attr("Request") }
private FunctionObject url2Open() { result = ModuleObject::named("urllib2.requests").attr("urlopen") }
private FunctionObject url2Request() { result = ModuleObject::named("urllib2.requests").attr("Request") }

class UrllibNode extends SSRFSink {
    override string toString() { result = "potential urllib(2) SSRF vulnerability" }

    UrllibNode() {
        exists(CallNode call |
            urlOpen().getACall() = call and
            call.getAnArg() = this or
          	urlRequest().getACall() = call and
            call.getAnArg() = this or
            url2Open().getACall() = call and
            call.getAnArg() = this or
          	url2Request().getACall() = call and
            call.getAnArg() = this
        )
    }

    override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
