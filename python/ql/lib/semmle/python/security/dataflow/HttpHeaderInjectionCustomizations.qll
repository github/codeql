/**
 * Provides default sources, sinks, and sanitizers for detecting
 * "HTTP Header injection" vulnerabilities, as well as extension
 * points for adding your own.
 */

import python
private import semmle.python.Concepts
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources

/**
 * Provides default sources, sinks, and sanitizers for detecting
 * "HTTP Header injection" vulnerabilities, as well as extension
 * points for adding your own.
 */
module HttpHeaderInjection {
  /**
   * A data flow source for "HTTP Header injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "HTTP Header injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A data flow sanitizer for "HTTP Header injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * A HTTP header write, considered as a flow sink.
   */
  class HeaderWriteAsSink extends Sink {
    HeaderWriteAsSink() {
      exists(Http::Server::ResponseHeaderWrite headerDeclaration |
        this in [headerDeclaration.getNameArg(), headerDeclaration.getValueArg()]
      )
    }
  }
}
