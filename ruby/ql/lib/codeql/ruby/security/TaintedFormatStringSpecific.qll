/**
 * Provides Ruby-specific imports and classes needed for `TaintedFormatStringQuery` and `TaintedFormatStringCustomizations`.
 */

import ruby
import codeql.ruby.DataFlow
import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.ApiGraphs
import codeql.ruby.TaintTracking

/**
 * A call to `printf` or `sprintf`.
 */
abstract class PrintfStyleCall extends DataFlow::CallNode {
  // We assume that most printf-like calls have the signature f(format_string, args...)
  /**
   * Gets the format string of this call.
   */
  DataFlow::Node getFormatString() { result = this.getArgument(0) }

  /**
   * Gets then `n`th formatted argument of this call.
   */
  DataFlow::Node getFormatArgument(int n) { n > 0 and result = this.getArgument(n) }
}

/**
 * A call to `Kernel.printf`.
 */
class KernelPrintfCall extends PrintfStyleCall {
  KernelPrintfCall() {
    this = API::getTopLevelMember("Kernel").getAMethodCall("printf")
    or
    this.asExpr().getExpr() instanceof UnknownMethodCall and
    this.getMethodName() = "printf"
  }

  // Kernel#printf supports two signatures:
  //   printf(io, string, ...)
  //   printf(string, ...)
  override DataFlow::Node getFormatString() { result = this.getArgument([0, 1]) }
}

/**
 * A call to `Kernel.sprintf`.
 */
class KernelSprintfCall extends PrintfStyleCall {
  KernelSprintfCall() {
    this = API::getTopLevelMember("Kernel").getAMethodCall("sprintf")
    or
    this.asExpr().getExpr() instanceof UnknownMethodCall and
    this.getMethodName() = "sprintf"
  }
}

/**
 * A call to `IO#printf`.
 */
class IOPrintfCall extends PrintfStyleCall {
  IOPrintfCall() { this = API::getTopLevelMember("IO").getInstance().getAMethodCall("printf") }
}
