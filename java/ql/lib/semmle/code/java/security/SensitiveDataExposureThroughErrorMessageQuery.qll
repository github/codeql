/** Provides predicates to reason about exposure of error messages. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.InformationLeak

/**
 * A get message source node.
 */
private class GetMessageFlowSource extends ApiSourceNode {
  GetMessageFlowSource() {
    exists(Method method | this.asExpr().(MethodCall).getMethod() = method |
      method.hasName("getMessage") and
      method.hasNoParameters() and
      method.getDeclaringType().hasQualifiedName("java.lang", "Throwable")
    )
  }
}

private module GetMessageFlowSourceToHttpResponseSinkFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof GetMessageFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof InformationLeakSink }
}

private module GetMessageFlowSourceToHttpResponseSinkFlow =
  TaintTracking::Global<GetMessageFlowSourceToHttpResponseSinkFlowConfig>;

/**
 * Holds if there is a call to `getMessage()` that then flows to a servlet response.
 */
predicate getMessageFlowsExternally(DataFlow::Node externalExpr, GetMessageFlowSource getMessage) {
  GetMessageFlowSourceToHttpResponseSinkFlow::flow(getMessage, externalExpr)
}
