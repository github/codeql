/**
 * @name Incorrect check on url
 * @description If a CORS policy is configured to accept an origin value obtained from the request data, it can lead to a policy bypass.
 * @kind path-problem
 * @problem.severity warning
 * @id go/cors-bypass
 * @tags security
 *       experimental
 *       external/cwe/cwe-942
 *       external/cwe/cwe-346
 */

import go

bindingset[s]
private predicate mayBeCors(string s) {
  s.toLowerCase().matches(["%origin%", "%cors%"]) and not s.toLowerCase().matches(["%original%"])
}

/**
 * An argument to a Gorilla's OriginValidator Function taken as a source
 */
class GorillaOriginFuncSource extends DataFlow::Node {
  GorillaOriginFuncSource() {
    exists(FuncDef f, DataFlow::CallNode c |
      // Find a func passed to `AllowedOriginValdiator` as a validator.
      // The string parameter supplied to the validator is a remote controlled string supplied in the origin header.
      // `gh.AllowedOriginValidator(func(origin string) bool{})`
      f.getParameter(0).getType() instanceof StringType and
      f.getNumParameter() = 1 and
      c.getTarget().hasQualifiedName("github.com/gorilla/handlers", "AllowedOriginValidator") and
      c.getArgument(0).asExpr() = f
    |
      this = DataFlow::parameterNode(f.getParameter(0))
    )
  }
}

private class MaybeOrigin extends DataFlow::Node {
  MaybeOrigin() {
    exists(RemoteFlowSource r |
      // Any write where the variables name could suggest it has something to do with cors.
      exists(Write w |
        // Take `origin` in `origin := r.Header.Get(header)` as a source.
        mayBeCors(w.getLhs().getName()) and
        TaintTracking::localTaint(r, w.getRhs())
      |
        this = r //or this.asInstruction() = w
      )
      or
      // Take the receiver, call or call arguments as source when any of their names match `maybeCors`
      exists(DataFlow::CallNode c, DataFlow::ArgumentNode a |
        TaintTracking::localTaint(r, a) and
        a.argumentOf(c.asExpr(), _) and
        mayBeCors([a.getStringValue(), c.getTarget().getName()])
      |
        // When argument or receiver is `maybeCors` take them as origin source.
        // When the call name is `maybeCors` take the result as origin source
        // (this = c.getResult(_) or this = a)
        this = r
      )
    )
  }
}

private module UrlFlow implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node instanceof MaybeOrigin or node instanceof GorillaOriginFuncSource
  }

  predicate isSink(DataFlow::Node node) {
    exists(DataFlow::CallNode mc, DataFlow::ArgumentNode a |
      // Get a call to `strings.HasSuffix(origin, allowedDomain)`
      mc.getTarget().hasQualifiedName("strings", "HasSuffix") and
      a = mc.getArgument(1) and
      // should not match ".domain.com" or "domain:port"
      not (
        // Filter ".domain.com"
        a.asExpr().(StringLit).getExactValue().matches(".%")
        or
        // Filter "domain.com:port"
        a.asExpr().(StringLit).getExactValue().matches("%:%")
        or
        exists(AddExpr w |
          // match ".domain"
          w.getLeftOperand().getStringValue().matches(".%")
          or
          // match "str"+ "domain:port"
          w.getRightOperand().getStringValue().matches("%:%")
        |
          DataFlow::localFlow(DataFlow::exprNode(w), a)
        )
      )
    |
      mc.getArgument(0) = node
    )
  }
}

private module Flow = TaintTracking::Global<UrlFlow>;

private import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This can lead to a Cross Origin Resource Sharing(CORS) policy bypass"
