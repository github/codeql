import python
import experimental.semmle.python.Concepts
import semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources

class CookieSink extends DataFlow::Node {
  string flag;

  CookieSink() {
    exists(Http::Server::CookieWrite cookie |
      this in [cookie.getNameArg(), cookie.getValueArg(), cookie.getHeaderArg()] and
      (
        cookie.getSecureFlag() = false and
        flag = "secure"
        or
        cookie.getHttpOnlyFlag() = false and
        flag = "httponly"
        or
        cookie.getSameSiteFlag() = false and
        flag = "samesite"
      )
    )
  }

  string getFlag() { result = flag }
}

/**
 * A taint-tracking configuration for detecting Cookie injections.
 */
private module CookieInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(Http::Server::CookieWrite c |
      sink in [c.getNameArg(), c.getValueArg(), c.getHeaderArg()]
    )
  }
}

/** Global taint-tracking for detecting "Cookie injections" vulnerabilities. */
module CookieInjectionFlow = TaintTracking::Global<CookieInjectionConfig>;
