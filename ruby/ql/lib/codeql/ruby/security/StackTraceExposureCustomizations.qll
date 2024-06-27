/**
 * Provides default sources, sinks and sanitizers for detecting stack trace
 * exposure vulnerabilities, as well as extension points for adding your own.
 */

private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.SSA
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.frameworks.core.Kernel

/**
 * Provides default sources, sinks and sanitizers for detecting stack trace
 * exposure vulnerabilities, as well as extension points for adding your own.
 */
module StackTraceExposure {
  /** A data flow source for stack trace exposure vulnerabilities. */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for stack trace exposure vulnerabilities. */
  abstract class Sink extends DataFlow::Node { }

  /** A data flow sanitizer for stack trace exposure vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A call to `backtrace` or `backtrace_locations` on a `rescue` variable,
   * considered as a flow source.
   */
  class BacktraceCall extends Source, DataFlow::CallNode {
    BacktraceCall() {
      exists(DataFlow::SsaDefinitionNode ssaDef |
        ssaDef.getDefinition().(Ssa::WriteDefinition).getWriteAccess().getAstNode() =
          any(RescueClause rc).getVariableExpr() and
        ssaDef.(DataFlow::LocalSourceNode).flowsTo(this.getReceiver())
      ) and
      this.getMethodName() = ["backtrace", "backtrace_locations"]
    }
  }

  /**
   * A call to `Kernel#caller`, considered as a flow source.
   */
  class KernelCallerCall extends Source instanceof Kernel::KernelMethodCall {
    KernelCallerCall() { super.getMethodName() = "caller" }
  }

  /**
   * The body of an HTTP response that will be returned from a server,
   * considered as a flow sink.
   */
  class ServerHttpResponseBodyAsSink extends Sink {
    ServerHttpResponseBodyAsSink() { this = any(Http::Server::HttpResponse response).getBody() }
  }
}
