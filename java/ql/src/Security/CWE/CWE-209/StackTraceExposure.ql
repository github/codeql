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
import semmle.code.java.security.InformationLeak

/**
 * One of the `printStackTrace()` overloads on `Throwable`.
 */
class PrintStackTraceMethod extends Method {
  PrintStackTraceMethod() {
    this.getDeclaringType()
        .getSourceDeclaration()
        .getASourceSupertype*()
        .hasQualifiedName("java.lang", "Throwable") and
    this.getName() = "printStackTrace"
  }
}

module ServletWriterSourceToPrintStackTraceMethodFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof XssVulnerableWriterSource }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getAnArgument() and ma.getMethod() instanceof PrintStackTraceMethod
    )
  }
}

module ServletWriterSourceToPrintStackTraceMethodFlow =
  TaintTracking::Global<ServletWriterSourceToPrintStackTraceMethodFlowConfig>;

/**
 * A call that uses `Throwable.printStackTrace()` on a stream that is connected
 * to external output.
 */
predicate printsStackToWriter(MethodAccess call) {
  exists(PrintStackTraceMethod printStackTrace |
    call.getMethod() = printStackTrace and
    ServletWriterSourceToPrintStackTraceMethodFlow::flowToExpr(call.getAnArgument())
  )
}

/**
 * A `PrintWriter` that wraps a given string writer. This pattern is used
 * in the most common idiom for converting a `Throwable` to a string.
 */
predicate printWriterOnStringWriter(Expr printWriter, Variable stringWriterVar) {
  printWriter.getType().(Class).hasQualifiedName("java.io", "PrintWriter") and
  stringWriterVar.getType().(Class).hasQualifiedName("java.io", "StringWriter") and
  (
    printWriter.(ClassInstanceExpr).getAnArgument() = stringWriterVar.getAnAccess() or
    printWriterOnStringWriter(printWriter.(VarAccess).getVariable().getInitializer(),
      stringWriterVar)
  )
}

predicate stackTraceExpr(Expr exception, MethodAccess stackTraceString) {
  exists(Expr printWriter, Variable stringWriterVar, MethodAccess printStackCall |
    printWriterOnStringWriter(printWriter, stringWriterVar) and
    printStackCall.getMethod() instanceof PrintStackTraceMethod and
    printStackCall.getAnArgument() = printWriter and
    printStackCall.getQualifier() = exception and
    stackTraceString.getQualifier() = stringWriterVar.getAnAccess() and
    stackTraceString.getMethod() instanceof ToStringMethod
  )
}

module StackTraceStringToHttpResponseSinkFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { stackTraceExpr(_, src.asExpr()) }

  predicate isSink(DataFlow::Node sink) { sink instanceof InformationLeakSink }
}

module StackTraceStringToHttpResponseSinkFlow =
  TaintTracking::Global<StackTraceStringToHttpResponseSinkFlowConfig>;

/**
 * A write of stack trace data to an external stream.
 */
predicate printsStackExternally(MethodAccess call, Expr stackTrace) {
  printsStackToWriter(call) and
  call.getQualifier() = stackTrace and
  not call.getQualifier() instanceof SuperAccess
}

/**
 * A stringified stack trace flows to an external sink.
 */
predicate stringifiedStackFlowsExternally(DataFlow::Node externalExpr, Expr stackTrace) {
  exists(MethodAccess stackTraceString |
    stackTraceExpr(stackTrace, stackTraceString) and
    StackTraceStringToHttpResponseSinkFlow::flow(DataFlow::exprNode(stackTraceString), externalExpr)
  )
}

class GetMessageFlowSource extends MethodAccess {
  GetMessageFlowSource() {
    exists(Method method |
      method = this.getMethod() and
      method.hasName("getMessage") and
      method.hasNoParameters() and
      method.getDeclaringType().hasQualifiedName("java.lang", "Throwable")
    )
  }
}

module GetMessageFlowSourceToHttpResponseSinkFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof GetMessageFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof InformationLeakSink }
}

module GetMessageFlowSourceToHttpResponseSinkFlow =
  TaintTracking::Global<GetMessageFlowSourceToHttpResponseSinkFlowConfig>;

/**
 * A call to `getMessage()` that then flows to a servlet response.
 */
predicate getMessageFlowsExternally(DataFlow::Node externalExpr, GetMessageFlowSource getMessage) {
  GetMessageFlowSourceToHttpResponseSinkFlow::flow(DataFlow::exprNode(getMessage), externalExpr)
}

from Expr externalExpr, Expr errorInformation
where
  printsStackExternally(externalExpr, errorInformation) or
  stringifiedStackFlowsExternally(DataFlow::exprNode(externalExpr), errorInformation) or
  getMessageFlowsExternally(DataFlow::exprNode(externalExpr), errorInformation)
select externalExpr, "$@ can be exposed to an external user.", errorInformation, "Error information"
