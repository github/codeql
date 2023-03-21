/**
 * Provides classes for modeling string formatting libraries.
 */

private import codeql.ruby.AST as Ast
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.core.IO

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

  /** Holds if this call returns the formatted string. */
  predicate returnsFormatted() { any() }
}

/**
 * A call to `Kernel.printf`.
 */
class KernelPrintfCall extends PrintfStyleCall {
  KernelPrintfCall() {
    this = API::getTopLevelMember("Kernel").getAMethodCall("printf")
    or
    this.asExpr().getExpr() instanceof Ast::UnknownMethodCall and
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

  override predicate returnsFormatted() { none() }
}

/**
 * A call to `Kernel.sprintf`.
 */
class KernelSprintfCall extends PrintfStyleCall {
  KernelSprintfCall() {
    this = API::getTopLevelMember("Kernel").getAMethodCall("sprintf")
    or
    this.asExpr().getExpr() instanceof Ast::UnknownMethodCall and
    this.getMethodName() = "sprintf"
  }

  override predicate returnsFormatted() { any() }
}

/**
 * A call to `IO#printf`.
 */
class IOPrintfCall extends PrintfStyleCall {
  IOPrintfCall() {
    this.getReceiver() instanceof IO::IOInstance and this.getMethodName() = "printf"
  }

  override predicate returnsFormatted() { none() }
}

/**
 * A call to `String#%`.
 */
class StringPercentCall extends PrintfStyleCall {
  StringPercentCall() { this.getMethodName() = "%" }

  override DataFlow::Node getFormatString() { result = this.getReceiver() }

  override DataFlow::Node getFormatArgument(int n) {
    exists(CfgNodes::ExprNodes::ArrayLiteralCfgNode arrLit | arrLit = this.getArgument(0).asExpr() |
      result.asExpr() = arrLit.getArgument(n)
    )
    or
    exists(CfgNodes::ExprNodes::HashLiteralCfgNode hashLit |
      hashLit = this.getArgument(0).asExpr()
    |
      n = -2 and // -2 is indicates that the index does not make sense in this context
      result.asExpr() = hashLit.getAKeyValuePair().getValue()
    )
  }

  override predicate returnsFormatted() { any() }
}

private import codeql.ruby.dataflow.FlowSteps
private import codeql.ruby.CFG

/**
 * A step for string interpolation of `pred` into `succ`.
 * E.g.
 * ```rb
 * succ = "foo #{pred} bar"
 * ```
 */
private class StringLiteralFormatStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred.asExpr() = succ.asExpr().(CfgNodes::ExprNodes::StringlikeLiteralCfgNode).getAComponent()
  }
}

/**
 * A taint propagating data flow edge arising from string formatting.
 */
private class StringFormattingTaintStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(PrintfStyleCall call |
      call.returnsFormatted() and
      succ = call
    |
      pred = call.getFormatString()
      or
      pred = call.getFormatArgument(_)
    )
  }
}
