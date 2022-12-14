/**
 * Provides default sources, sinks and sanitizers for detecting
 * "stack trace exposure"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.BarrierGuards
private import ExceptionInfo

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "stack trace exposure"
 * vulnerabilities, as well as extension points for adding your own.
 */
module StackTraceExposure {
  /**
   * A data flow source for "stack trace exposure" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "stack trace exposure" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "stack trace exposure" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * DEPRECATED: Use `Sanitizer` instead.
   *
   * A sanitizer guard for "stack trace exposure" vulnerabilities.
   */
  abstract deprecated class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of exception info, considered as a flow source.
   */
  class ExceptionInfoAsSource extends Source instanceof ExceptionInfo { }

  /**
   * The body of a HTTP response that will be returned from a server, considered as a flow sink.
   */
  class ServerHttpResponseBodyAsSink extends Sink {
    ServerHttpResponseBodyAsSink() { this = any(Http::Server::HttpResponse response).getBody() }
  }
}
