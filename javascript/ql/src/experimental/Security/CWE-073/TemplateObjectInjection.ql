/**
 * @name Template Object Injection
 * @description Instantiating a template using a user-controlled object is vulnerable to local file read and potential remote code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/template-object-injection
 * @tags security
 *       external/cwe/cwe-073
 *       external/cwe/cwe-094
 */

import javascript
import DataFlow
import PathGraph

predicate isUsingHbsEngine() {
  Express::appCreation().getAMethodCall("set").getArgument(1).mayHaveStringValue("hbs")
}

class HbsLFRTaint extends TaintTracking::Configuration {
  HbsLFRTaint() { this = "HbsLFRTaint" }

  override predicate isSource(Node node) { node instanceof RemoteFlowSource }

  override predicate isSink(Node node) {
    exists(MethodCallExpr mc |
      Express::isResponse(mc.getReceiver()) and
      mc.getMethodName() = "render" and
      node.asExpr() = mc.getArgument(1) and
      isUsingHbsEngine()
    )
  }
}

from HbsLFRTaint cfg, PathNode source, PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Template object injection due to $@.", source.getNode(),
  "user-provided value"
