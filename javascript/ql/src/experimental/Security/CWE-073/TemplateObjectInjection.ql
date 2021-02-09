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
import DataFlow::PathGraph
import semmle.javascript.security.TaintedObject

class TemplateObjInjectionConfig extends TaintTracking::Configuration {
  TemplateObjInjectionConfig() { this = "TemplateObjInjectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    TaintedObject::isSource(source, label)
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    label = TaintedObject::label() and
    exists(MethodCallExpr mc |
      Express::isResponse(mc.getReceiver()) and
      mc.getMethodName() = "render" and
      sink.asExpr() = mc.getArgument(1)
    )
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof TaintedObject::SanitizerGuard
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    TaintedObject::step(src, trg, inlbl, outlbl)
  }
}

from DataFlow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Template object injection due to $@.", source.getNode(),
  "user-provided value"
