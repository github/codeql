/** Provides predicates to reason about exposure of stack-traces. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.InformationLeak

/**
 * One of the `printStackTrace()` overloads on `Throwable`.
 */
private class PrintStackTraceMethod extends Method {
  PrintStackTraceMethod() {
    this.getDeclaringType()
        .getSourceDeclaration()
        .getASourceSupertype*()
        .hasQualifiedName("java.lang", "Throwable") and
    this.getName() = "printStackTrace"
  }
}

private module ServletWriterSourceToPrintStackTraceMethodFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof XssVulnerableWriterSourceNode }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall ma |
      sink.asExpr() = ma.getAnArgument() and ma.getMethod() instanceof PrintStackTraceMethod
    )
  }
}

private module ServletWriterSourceToPrintStackTraceMethodFlow =
  TaintTracking::Global<ServletWriterSourceToPrintStackTraceMethodFlowConfig>;

/**
 * A call that uses `Throwable.printStackTrace()` on a stream that is connected
 * to external output.
 */
private predicate printsStackToWriter(MethodCall call) {
  exists(PrintStackTraceMethod printStackTrace |
    call.getMethod() = printStackTrace and
    ServletWriterSourceToPrintStackTraceMethodFlow::flowToExpr(call.getAnArgument())
  )
}

/**
 * A `PrintWriter` that wraps a given string writer. This pattern is used
 * in the most common idiom for converting a `Throwable` to a string.
 */
private predicate printWriterOnStringWriter(Expr printWriter, Variable stringWriterVar) {
  printWriter.getType().(Class).hasQualifiedName("java.io", "PrintWriter") and
  stringWriterVar.getType().(Class).hasQualifiedName("java.io", "StringWriter") and
  (
    printWriter.(ClassInstanceExpr).getAnArgument() = stringWriterVar.getAnAccess() or
    printWriterOnStringWriter(printWriter.(VarAccess).getVariable().getInitializer(),
      stringWriterVar)
  )
}

private predicate stackTraceExpr(Expr exception, MethodCall stackTraceString) {
  exists(Expr printWriter, Variable stringWriterVar, MethodCall printStackCall |
    printWriterOnStringWriter(printWriter, stringWriterVar) and
    printStackCall.getMethod() instanceof PrintStackTraceMethod and
    printStackCall.getAnArgument() = printWriter and
    printStackCall.getQualifier() = exception and
    stackTraceString.getQualifier() = stringWriterVar.getAnAccess() and
    stackTraceString.getMethod() instanceof ToStringMethod
  )
}

private module StackTraceStringToHttpResponseSinkFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { stackTraceExpr(_, src.asExpr()) }

  predicate isSink(DataFlow::Node sink) { sink instanceof InformationLeakSink }
}

private module StackTraceStringToHttpResponseSinkFlow =
  TaintTracking::Global<StackTraceStringToHttpResponseSinkFlowConfig>;

/**
 * Holds if `call` writes the data of `stackTrace` to an external stream.
 */
predicate printsStackExternally(MethodCall call, Expr stackTrace) {
  printsStackToWriter(call) and
  call.getQualifier() = stackTrace and
  not call.getQualifier() instanceof SuperAccess
}

/**
 * Holds if `stackTrace` is a stringified stack trace which flows to an external sink.
 */
predicate stringifiedStackFlowsExternally(DataFlow::Node externalExpr, Expr stackTrace) {
  exists(MethodCall stackTraceString |
    stackTraceExpr(stackTrace, stackTraceString) and
    StackTraceStringToHttpResponseSinkFlow::flow(DataFlow::exprNode(stackTraceString), externalExpr)
  )
}
