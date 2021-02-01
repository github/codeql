/**
 * @name Express-Hbs Local File Read and Potential RCE
 * @description Writing user input directly to res.render of ExpressJS used with Hbs can lead to LFR
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/express-hbs-lfr
 * @tags security
 *       external/cwe/cwe-073
 *       external/cwe/cwe-094
 */

import javascript
import DataFlow
import PathGraph
import Express
import semmle.javascript.DynamicPropertyAccess

predicate isUsingHbsEngine() {
  exists(MethodCallExpr method |
    method.getMethodName() = "set" and
    Express::appCreation().flowsToExpr(method.getReceiver()) and
    method.getArgument(1).getStringValue().matches("hbs")
  )
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

from HbsLFRTaint cfg, Node source, Node sink
where cfg.hasFlow(source, sink)
select source, sink
