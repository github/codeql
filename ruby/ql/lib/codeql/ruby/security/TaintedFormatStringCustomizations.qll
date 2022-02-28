/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * format injections, as well as extension points for adding your own.
 */

private import ruby
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.ApiGraphs

/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * format injections, as well as extension points for adding your own.
 */
module TaintedFormatString {
  /**
   * A data flow source for format injections.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for format injections.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for format injections.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of remote user input, considered as a flow source for format injection. */
  class RemoteSource extends Source {
    RemoteSource() { this instanceof RemoteFlowSource }
  }

  /**
   * A format argument to a printf-like function, considered as a flow sink for format injection.
   */
  class FormatSink extends Sink {
    FormatSink() {
      exists(PrintfCall printf |
        this = printf.getFormatString() and
        // exclude trivial case where there are no arguments to interpolate
        exists(printf.getFormatArgument(_))
      )
    }
  }

  /**
   * A call to `printf` or `sprintf`.
   */
  abstract class PrintfCall extends DataFlow::CallNode {
    // We assume that most printf-like calls have the signature f(format_string, args...)
    /**
     * Gets the format string of this call.
     */
    DataFlow::Node getFormatString() { result = this.getArgument(0) }

    /**
     * Gets then `n`th formatted argument of this call.
     */
    DataFlow::Node getFormatArgument(int n) { result = this.getArgument(n + 1) }
  }

  /**
   * A call to `Kernel.printf`.
   */
  class KernelPrintfCall extends PrintfCall {
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
  class KernelSprintfCall extends PrintfCall {
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
  class IOPrintfCall extends PrintfCall {
    IOPrintfCall() { this = API::getTopLevelMember("IO").getInstance().getAMethodCall("printf") }
  }
}
