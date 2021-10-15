private import ruby
private import codeql.ruby.DataFlow
private import codeql.ruby.Concepts
private import codeql.ruby.Frameworks
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.dataflow.BarrierGuards
private import codeql.ruby.ApiGraphs

/**
 * Provides default sources, sinks and sanitizers for detecting
 * regexp injection vulnerabilities, as well as extension points for
 * adding your own.
 */
module RegExpInjection {
  /**
   * A data flow source for regexp injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for regexp injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer guard for regexp injection vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /** A regexp literal, considered as a flow sink. */
  class RegExpLiteralAsSink extends Sink {
    RegExpLiteralAsSink() { this.asExpr().getExpr() instanceof RegExpLiteral }
  }

  /**
   * The first argument of a call to `Regexp.new`, considered as a flow sink.
   */
  class ConstructedRegExpAsSink extends Sink {
    ConstructedRegExpAsSink() {
      exists(DataFlow::CallNode c |
        c = API::getTopLevelMember("Regexp").getAnInstantiation() and
        this = c.getArgument(0)
      )
    }
  }
}
