/**
 * Provides Ruby-specific imports and classes needed for `TaintedFormatStringQuery` and `TaintedFormatStringCustomizations`.
 */

import ruby
import codeql.ruby.DataFlow
import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.ApiGraphs
import codeql.ruby.TaintTracking
private import codeql.ruby.frameworks.Files::IO
private import codeql.ruby.controlflow.CfgNodes

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
  DataFlow::Node getFormatArgument(int n) { n >= 0 and result = this.getArgument(n + 1) }
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
  override DataFlow::Node getFormatString() {
    // Because `printf` has two different signatures, we can't be sure which
    // argument is the format string, so we use a heuristic:
    // If the first argument has a string value, then we assume it is the format string.
    // Otherwise we treat both the first and second args as the format string.
    if this.getArgument(0).getExprNode().getConstantValue().isString(_)
    then result = this.getArgument(0)
    else result = this.getArgument([0, 1])
  }
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
  IOPrintfCall() { this.getReceiver() instanceof IOInstance and this.getMethodName() = "printf" }
}
