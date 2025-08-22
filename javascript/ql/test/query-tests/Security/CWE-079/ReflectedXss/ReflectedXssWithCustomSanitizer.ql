//
// Modern version of ReflectedXssWithCustomSanitizer_old.ql
//
import javascript
import semmle.javascript.security.dataflow.ReflectedXssQuery
private import semmle.javascript.security.dataflow.Xss::Shared as SharedXss

class IsVarNameSanitizer extends SharedXss::BarrierGuard, DataFlow::CallNode {
  IsVarNameSanitizer() { this.getCalleeName() = "isVarName" }

  override predicate blocksExpr(boolean outcome, Expr e) {
    outcome = true and
    e = this.getArgument(0).asExpr()
  }
}

from Source source, Sink sink
where ReflectedXssFlow::flow(source, sink)
select sink, "Cross-site scripting vulnerability due to $@.", source, "user-provided value"
