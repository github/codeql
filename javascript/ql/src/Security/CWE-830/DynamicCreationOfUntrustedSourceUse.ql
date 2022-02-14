/**
 * @name Dynamic creation of untrusted source use
 * @description Finds dynamically created DOM elements that may use
 *  behaviour from http-URLs without integrity checks.
 * @kind path-problem
 * @problem.severity error
 * @tags security
 * @id js/dynamic-creation-of-untrusted-source-use
 */

import javascript
import DataFlow::PathGraph

predicate isCreateElementNode(DataFlow::CallNode call, string name) {
  call = DataFlow::globalVarRef("document").getAMethodCall("createElement") and
  call.getArgument(0).getStringValue().toLowerCase() = name
}

predicate isCreateScriptNodeWoIntegrityCheck(DataFlow::CallNode call) {
  isCreateElementNode(call, "script") and
  not exists(DataFlow::Node rhs | isScriptPropWrite(call, "integrity", rhs))
}

predicate isScriptPropWrite(
  DataFlow::CallNode createElementCall, string propName, DataFlow::Node rhs
) {
  exists(DataFlow::PropWrite assignment |
    isCreateElementNode(createElementCall, "script") and
    assignment.writes(createElementCall.getALocalUse(), propName, rhs)
  )
}

class DynamicCreationOfUntrustedSourceUseCfg extends TaintTracking::Configuration {
  DynamicCreationOfUntrustedSourceUseCfg() { this = "DynamicCreationOfUntrustedSourceUseCfg" }

  override predicate isSource(DataFlow::Node source) {
    exists(StringLiteral s | source = s.flow() |
      s.getValue() = ["http:", "//"] + any(string rest) // TODO match HTTP HtTp etc
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::CallNode createElementCall |
      isScriptPropWrite(createElementCall, "src", sink) and
      isCreateScriptNodeWoIntegrityCheck(createElementCall)
      or
      exists(DataFlow::CallNode iframeCreateCall, DataFlow::PropWrite srcWrite |
        isCreateElementNode(iframeCreateCall, "iframe") and
        srcWrite.getRhs() = sink and
        srcWrite.getBase() = iframeCreateCall.getALocalUse()
      )
    )
  }
}

from DynamicCreationOfUntrustedSourceUseCfg cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Illegal flow from $@.", source.getNode(), "here"
