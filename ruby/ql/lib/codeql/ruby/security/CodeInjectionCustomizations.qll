private import ruby
private import codeql.ruby.DataFlow
private import codeql.ruby.Concepts
private import codeql.ruby.Frameworks
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.dataflow.BarrierGuards

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "Code injection" vulnerabilities, as well as extension points for
 * adding your own.
 */
module CodeInjection {
  /**
   * A data flow source for "Code injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "Code injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer guard for "Code injection" vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * A call that evaluates its arguments as Ruby code, considered as a flow sink.
   */
  class CodeExecutionAsSink extends Sink {
    CodeExecutionAsSink() { this = any(CodeExecution c).getCode() }
  }
}
