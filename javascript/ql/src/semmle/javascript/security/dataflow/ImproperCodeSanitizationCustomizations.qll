/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * improper code sanitization, as well as extension points for
 * adding your own.
 */

import javascript

/**
 * Classes and predicates for reasoning about improper code sanitization.
 */
module ImproperCodeSanitization {
  /**
   * A data flow source for improper code sanitization.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for improper code sanitization.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for improper code sanitization.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A call to a HTML sanitizer seen as a source for improper code sanitization
   */
  class HtmlSanitizerCallAsSource extends Source {
    HtmlSanitizerCallAsSource() { this instanceof HtmlSanitizerCall }
  }

  /**
   * A call to `JSON.stringify()` seen as a source for improper code sanitization
   */
  class JSONStringifyAsSource extends Source {
    JSONStringifyAsSource() { this instanceof JsonStringifyCall }
  }

  /**
   * A leaf in a string-concatenation, where the string-concatenation constructs code that looks like a function.
   */
  class FunctionStringConstruction extends Sink, StringOps::ConcatenationLeaf {
    FunctionStringConstruction() {
      exists(StringOps::ConcatenationRoot root, int i |
        root.getOperand(i) = this and
        not exists(this.getStringValue())
      |
        exists(StringOps::ConcatenationLeaf functionLeaf |
          functionLeaf = root.getOperand(any(int j | j < i))
        |
          functionLeaf
              .getStringValue()
              .regexpMatch([
                  ".*function( )?([a-zA-Z0-9]+)?( )?\\(.*", ".*eval\\(.*", ".*new Function\\(.*",
                  "(^|.*[^a-zA-Z0-9])\\(.*\\)( )?=>.*"
                ])
        )
      )
    }
  }

  /**
   * A call to `String.prototype.replace` seen as a sanitizer for improper code sanitization.
   * All calls to replace that happens after the initial improper sanitization is seen as a sanitizer.
   */
  class StringReplaceCallAsSanitizer extends Sanitizer, StringReplaceCall { }
}
