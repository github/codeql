/**
 * @name User controlled environment injection
 * @description full control on creating environment variables from user controlled data is not secure
 * @kind path-problem
 * @id js/envinjection
 * @problem.severity error
 * @security-severity 7.5
 * @precision medium
 * @tags security
 *       external/cwe/cwe-089
 */

import javascript
import DataFlow::PathGraph

/** A taint tracking configuration for unsafe environment injection. */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "envInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    NodeJSLib::process()
        .getAPropertyRead("env")
        .asExpr()
        .getParent()
        .(IndexExpr)
        .getAChildExpr()
        .(VarRef) = sink.asExpr()
    or
    sink = API::moduleImport("process").getMember("env").getAMember().asSink()
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::InvokeNode ikn |
      ikn = DataFlow::globalVarRef("Object").getAMemberInvocation("keys")
    |
      pred = ikn.getArgument(0) and
      (
        succ = ikn.getAChainedMethodCall(["filter", "map"]) or
        succ = ikn or
        succ = ikn.getAChainedMethodCall("forEach").getABoundCallbackParameter(0, 0)
      )
    )
  }
}

from
  Configuration cfg, Configuration cfg2, DataFlow::PathNode source, DataFlow::PathNode sink,
  DataFlow::PathNode sink2
where
  cfg.hasFlowPath(source, sink) and
  sink.getNode() = API::moduleImport("process").getMember("env").getAMember().asSink() and
  cfg2.hasFlowPath(source, sink2) and
  sink.getNode().asExpr() =
    NodeJSLib::process()
        .getAPropertyRead("env")
        .asExpr()
        .getParent()
        .(IndexExpr)
        .getAChildExpr()
        .(VarRef)
select sink.getNode(), source, sink, "this environment variable assignment is $@.",
  source.getNode(), "user controllable"
