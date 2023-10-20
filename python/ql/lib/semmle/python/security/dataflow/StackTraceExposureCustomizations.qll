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
   * A source of exception info, considered as a flow source.
   */
  class ExceptionInfoAsSource extends Source instanceof ExceptionInfo {
    ExceptionInfoAsSource() {
      // since `traceback.format_exc()` in Python 2 is internally implemented as
      // ```py
      // def format_exc(limit=None):
      //     """Like print_exc() but return a string."""
      //     try:
      //         etype, value, tb = sys.exc_info()
      //         return ''.join(format_exception(etype, value, tb, limit))
      //     finally:
      //         etype = value = tb = None
      // ```
      // any time we would report flow to such from a call to format_exc, we can ALSO report
      // the flow from the `sys.exc_info()` source -- obviously we don't want that.
      //
      //
      // To avoid this, we use the same approach as for sinks in the command injection
      // query (and others).
      not exists(Module traceback |
        traceback.getName() = "traceback" and
        this.getScope().getEnclosingModule() = traceback and
        // do allow this call if we're analyzing traceback.py as part of CPython though
        not exists(traceback.getFile().getRelativePath())
      )
    }
  }

  /**
   * The body of a HTTP response that will be returned from a server, considered as a flow sink.
   */
  class ServerHttpResponseBodyAsSink extends Sink {
    ServerHttpResponseBodyAsSink() { this = any(Http::Server::HttpResponse response).getBody() }
  }
}
