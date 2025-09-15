/**
 * Provides classes and predicates for reasoning about the use of
 * non-HTTPS URLs in Rust code.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.elements.LiteralExprExt
private import codeql.rust.Concepts

/**
 * Provides default sources, sinks and barriers for detecting use of
 * non-HTTPS URLs, as well as extension points for adding your own.
 */
module UseOfHttp {
  /**
   * A data flow source for use of non-HTTPS URLs.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for use of non-HTTPS URLs.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "UseOfHttp" }
  }

  /**
   * A barrier for use of non-HTTPS URLs.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * A string containing an HTTP URL.
   */
  class HttpStringLiteral extends StringLiteralExpr {
    HttpStringLiteral() {
      exists(string s | this.getTextValue() = s |
        // Match HTTP URLs that are not private/local
        s.regexpMatch("\"http://.*\"") and
        not s.regexpMatch("\"http://(localhost|127\\.0\\.0\\.1|192\\.168\\.[0-9]+\\.[0-9]+|10\\.[0-9]+\\.[0-9]+\\.[0-9]+|172\\.16\\.[0-9]+\\.[0-9]+|\\[::1\\]|\\[0:0:0:0:0:0:0:1\\]).*\"")
      )
    }
  }

  /**
   * An HTTP string literal as a source.
   */
  private class HttpStringLiteralAsSource extends Source {
    HttpStringLiteralAsSource() { this.asExpr().getExpr() instanceof HttpStringLiteral }
  }

  /**
   * A sink for use of HTTP URLs from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, "request-url") }
  }
}
