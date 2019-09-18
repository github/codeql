//
// Modern version of ReflectedXssWithCustomSanitizer_old.ql
//
import javascript
import semmle.javascript.security.dataflow.ReflectedXss::ReflectedXss

class IsVarNameSanitizer extends TaintTracking::AdditionalSanitizerGuardNode, DataFlow::CallNode {
  IsVarNameSanitizer() { getCalleeName() = "isVarName" }

  override predicate sanitizes(boolean outcome, Expr e) {
    outcome = true and
    e = getArgument(0).asExpr()
  }

  override predicate appliesTo(TaintTracking::Configuration cfg) { cfg instanceof Configuration }
}

from Configuration xss, Source source, Sink sink
where xss.hasFlow(source, sink)
select sink, "Cross-site scripting vulnerability due to $@.", source, "user-provided value"
