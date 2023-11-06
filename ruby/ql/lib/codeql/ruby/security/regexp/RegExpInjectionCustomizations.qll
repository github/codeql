/**
 * Provides default sources, sinks and sanitizers for reasoning about regexp
 * injection vulnerabilities, as well as extension points for adding your own.
 */

private import codeql.ruby.AST
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
   * A data flow sanitized for regexp injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /** A regexp literal, considered as a flow sink. */
  class RegExpLiteralAsSink extends Sink {
    RegExpLiteralAsSink() { this.asExpr().getExpr() instanceof RegExpLiteral }
  }

  /**
   * The first argument of a call to `Regexp.new` or `Regexp.compile`,
   * considered as a flow sink.
   */
  class ConstructedRegExpAsSink extends Sink {
    ConstructedRegExpAsSink() {
      exists(API::Node regexp, DataFlow::CallNode callNode |
        regexp = API::getTopLevelMember("Regexp") and
        (callNode = regexp.getAnInstantiation() or callNode = regexp.getAMethodCall("compile")) and
        this = callNode.getArgument(0)
      )
    }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizer extends Sanitizer, StringConstCompareBarrier { }

  /**
   * An inclusion check against an array of constant strings, considered as a
   * sanitizer-guard.
   */
  class StringConstArrayInclusionCallAsSanitizer extends Sanitizer,
    StringConstArrayInclusionCallBarrier
  { }

  /**
   * A call to `Regexp.escape` (or its alias, `Regexp.quote`), considered as a
   * sanitizer.
   */
  class RegexpEscapeSanitization extends Sanitizer {
    RegexpEscapeSanitization() {
      this = API::getTopLevelMember("Regexp").getAMethodCall(["escape", "quote"])
    }
  }
}
