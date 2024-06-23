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
private predicate mayBeCors(string s) { s.toLowerCase().matches(["%origin%", "%cors%"]) }

/**
 * An argument to a Gorilla's OriginValidator Function taken as a source
 */
class GorillaOriginFuncSource extends RemoteFlowSource::Range {
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
      DataFlow::localFlow(DataFlow::parameterNode(f.getParameter(0)), this)
    )
  }
}

private class MaybeOrigin extends RemoteFlowSource {
  MaybeOrigin() {
    exists(RemoteFlowSource r |
      // Any write where the variables name could suggest it has something to do with cors.
      exists(Write w, Variable v |
        mayBeCors(w.getLhs().getName())
        or
        v.getAWrite() = w and mayBeCors(v.getName())
      |
        w = r.getASuccessor*().asInstruction()
      )
      or
      // Any argument or a receiver whose name could suggest it has something to do with cors.
      exists(DataFlow::CallNode c, DataFlow::ArgumentNode a |
        c.getArgument(_) = r.getASuccessor*()
        or
        c.getReceiver() = r.getASuccessor*() and
        a.argumentOf(c.asExpr(), _)
      |
        mayBeCors([a.getStringValue(), c.getTarget().getName()])
      )
    |
      this = r
    )
  }
}

private module UrlFlow implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof MaybeOrigin }

  predicate isSink(DataFlow::Node node) {
    exists(DataFlow::CallNode mc, DataFlow::ArgumentNode a |
      // Get a call to `strings.HasSuffix(origin, allowedDomain)`
      mc.getTarget().hasQualifiedName("strings", "HasSuffix") and
      a = mc.getArgument(1) and
      // should not match ".domain.com"
      not a.asExpr().(StringLit).getExactValue().matches(".%") and
      not exists(AddExpr w | w.getLeftOperand().getStringValue().matches(".%") |
        DataFlow::localFlow(DataFlow::exprNode(w), a)
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
