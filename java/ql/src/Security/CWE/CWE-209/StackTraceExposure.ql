/**
 * @name Information exposure through a stack trace
 * @description Information from a stack trace propagates to an external user.
 *              Stack traces can unintentionally reveal implementation details
 *              that are useful to an attacker for developing a subsequent exploit.
 * @kind problem
 * @problem.severity error
 * @security-severity 5.4
 * @precision high
 * @id java/stack-trace-exposure
 * @tags security
 *       external/cwe/cwe-209
 *       external/cwe/cwe-497
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.StackTraceExposureQuery
private import semmle.code.java.dataflow.DataFlowFiltering

private module ServletWriterSourceToPrintStackTraceMethodFlow =
  TaintTracking::Global<FilteredConfig<ServletWriterSourceToPrintStackTraceMethodFlowConfig>>;

private predicate printsStackToWriter(MethodCall call) {
  exists(PrintStackTraceMethod printStackTrace |
    call.getMethod() = printStackTrace and
    ServletWriterSourceToPrintStackTraceMethodFlow::flowToExpr(call.getAnArgument())
  )
}

predicate printsStackExternally(MethodCall call, Expr stackTrace) {
  printsStackToWriter(call) and
  call.getQualifier() = stackTrace and
  not call.getQualifier() instanceof SuperAccess
}

private module StackTraceStringToHttpResponseSinkFlow =
  TaintTracking::Global<FilteredConfig<StackTraceStringToHttpResponseSinkFlowConfig>>;

predicate stringifiedStackFlowsExternally(DataFlow::Node externalExpr, Expr stackTrace) {
  exists(MethodCall stackTraceString |
    stackTraceExpr(stackTrace, stackTraceString) and
    StackTraceStringToHttpResponseSinkFlow::flow(DataFlow::exprNode(stackTraceString), externalExpr)
  )
}

from Expr externalExpr, Expr errorInformation
where
  printsStackExternally(externalExpr, errorInformation) or
  stringifiedStackFlowsExternally(DataFlow::exprNode(externalExpr), errorInformation)
select externalExpr, "$@ can be exposed to an external user.", errorInformation, "Error information"
