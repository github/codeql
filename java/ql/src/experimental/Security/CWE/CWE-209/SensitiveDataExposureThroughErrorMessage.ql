/**
 * @name Information exposure through a error message
 * @description Information from a error message propagates to an external user.
 *              Error messages can unintentionally reveal implementation details
 *              that are useful to an attacker for developing a subsequent exploit.
 * @kind problem
 * @problem.severity error
 * @security-severity 5.4
 * @precision high
 * @id java/error-message-exposure
 * @tags security
 *       external/cwe/cwe-209
 *       experimental
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.StackTraceExposureQuery
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

from Expr externalExpr, Expr errorInformation
where
  getMessageFlowsExternally(DataFlow::exprNode(externalExpr), DataFlow::exprNode(errorInformation))
select externalExpr, "$@ can be exposed to an external user.", errorInformation, "Error information"
