import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources

class CookieSink extends DataFlow::Node {
  string flag;

  CookieSink() {
    exists(Cookie cookie |
      this in [cookie.getNameArg(), cookie.getValueArg()] and
      (
        not cookie.isSecure() and
        flag = "secure"
        or
        not cookie.isHttpOnly() and
        flag = "httponly"
        or
        not cookie.isSameSite() and
        flag = "samesite"
      )
    )
  }

  string getFlag() { result = flag }
}

/**
 * A taint-tracking configuration for detecting Cookie injections.
 */
class CookieInjectionFlowConfig extends TaintTracking::Configuration {
  CookieInjectionFlowConfig() { this = "CookieInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(Cookie c | sink in [c.getNameArg(), c.getValueArg()])
  }
}
