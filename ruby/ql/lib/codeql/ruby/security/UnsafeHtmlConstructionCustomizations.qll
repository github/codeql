/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * HTML constructed from library input vulnerabilities, as
 * well as extension points for adding your own.
 */

private import ruby
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.core.Gem::Gem as Gem
private import codeql.ruby.security.XSS::ReflectedXss as ReflectedXss
private import codeql.ruby.typetracking.TypeTracking

/**
 * Module containing sources, sinks, and sanitizers for HTML constructed from library input.
 */
module UnsafeHtmlConstruction {
  /** A source for HTML constructed from library input vulnerabilities. */
  abstract class Source extends DataFlow::Node { }

  /** An input parameter to a gem seen as a source. */
  private class LibraryInputAsSource extends Source instanceof DataFlow::ParameterNode {
    LibraryInputAsSource() { this = Gem::getALibraryInput() }
  }

  /** A sink for HTML constructed from library input vulnerabilities. */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the node for the XSS sink the HTML flows to.
     */
    abstract DataFlow::Node getXssSink();

    /**
     * Gets the type of sink.
     */
    abstract string getSinkType();
  }

  /** A sanitizer for HTML constructed from library input vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A sanitizer from the reflected-xss query, which is also a sanitizer for unsafe HTML construction. */
  private class ReflectedXssSanitizers extends Sanitizer instanceof ReflectedXss::Sanitizer { }

  /** Gets a node that eventually ends up in the XSS `sink`. */
  private DataFlow::Node getANodeThatEndsInXssSink(ReflectedXss::Sink sink) {
    result = getANodeThatEndsInXssSink(TypeBackTracker::end(), sink)
  }

  /** Gets a node that is eventually ends up in the XSS `sink`, type-tracked with `t`. */
  private DataFlow::LocalSourceNode getANodeThatEndsInXssSink(
    TypeBackTracker t, ReflectedXss::Sink sink
  ) {
    t.start() and
    result = sink.getALocalSource()
    or
    exists(TypeBackTracker t2 | result = getANodeThatEndsInXssSink(t2, sink).backtrack(t2, t))
  }

  /**
   * A component of a string-literal (e.g. `"foo #{sink}"`),
   * where the resulting string ends up being used in an XSS sink.
   */
  private class StringFormatAsSink extends Sink {
    ReflectedXss::Sink s;

    StringFormatAsSink() {
      exists(Ast::StringlikeLiteral lit |
        any(DataFlow::Node n | n.asExpr().getExpr() = lit) = getANodeThatEndsInXssSink(s) and
        this.asExpr().getExpr() = lit.getComponent(_)
      )
    }

    override DataFlow::Node getXssSink() { result = s }

    override string getSinkType() { result = "string interpolation" }
  }

  private import codeql.ruby.security.TaintedFormatStringSpecific as TaintedFormat

  /**
   * An argument to a printf-style call,
   * where the resulting string ends up being used in an XSS sink.
   */
  private class TaintedFormatStringAsSink extends Sink {
    ReflectedXss::Sink s;

    TaintedFormatStringAsSink() {
      exists(TaintedFormat::PrintfStyleCall call |
        call = getANodeThatEndsInXssSink(s) and
        this = [call.getFormatArgument(_), call.getFormatString()]
      )
    }

    override DataFlow::Node getXssSink() { result = s }

    override string getSinkType() { result = "string format" }
  }
}
