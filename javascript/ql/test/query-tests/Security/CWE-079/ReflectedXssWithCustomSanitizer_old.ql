//
// This is a test for https://lgtm.com/blog/etherpad_CVE-2018-6835
//

import javascript
import semmle.javascript.security.dataflow.ReflectedXss

class IsVarNameSanitizer extends TaintTracking::SanitizingGuard, CallExpr {
  IsVarNameSanitizer() {
    getCalleeName() = "isVarName"
  }

  override predicate sanitizes(TaintTracking::Configuration cfg, boolean outcome, Expr e) {
    cfg instanceof XssDataFlowConfiguration and
    outcome = true and
    e = getArgument(0)
  }
}

from XssDataFlowConfiguration xss, DataFlow::Node source, DataFlow::Node sink
where xss.flowsFrom(sink, source)
select sink, "Cross-site scripting vulnerability due to $@.",
       source, "user-provided value"
