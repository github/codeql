/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * server side request forgery, as well as extension points for adding your own.
 */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.CFG
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.Concepts
private import codeql.ruby.dataflow.Sanitizers
private import codeql.ruby.frameworks.data.internal.ApiGraphModels

/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * server side request forgery, as well as extension points for adding your own.
 */
module ServerSideRequestForgery {
  /**
   * A data flow source for server side request forgery vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for server side request forgery vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for server side request forgery vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of remote user input, considered as a flow source for server side request forgery. */
  class RemoteFlowSourceAsSource extends Source instanceof RemoteFlowSource { }

  /** The URL of an HTTP request, considered as a sink. */
  class HttpRequestAsSink extends Sink {
    HttpRequestAsSink() { exists(Http::Client::Request req | req.getAUrlPart() = this) }
  }

  /** A string interpolation with a fixed prefix, considered as a flow sanitizer. */
  class StringInterpolationAsSanitizer extends PrefixedStringInterpolation, Sanitizer { }

  private class ExternalRequestForgerySink extends Sink {
    ExternalRequestForgerySink() { this = ModelOutput::getASinkNode("request-forgery").asSink() }
  }
}
