/**
 * Provides default sources, sinks and sanitizers for reasoning about unsafe-quoting
 * vulnerabilities, as well as extension points for adding your own.
 */

import go

/**
 * Provides extension points for customizing the taint tracking configuration for reasoning about
 * unsafe-quoting vulnerabilities.
 */
module StringBreak {
  /** A (single or double) quote. */
  class Quote extends string {
    Quote() { this = "'" or this = "\"" }

    /** Gets the type of this quote, either single or double. */
    string getType() { if this = "'" then result = "single" else result = "double" }
  }

  /**
   * A data flow source for unsafe-quoting vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for unsafe-quoting vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /** Gets the quote character for which this is a sink. */
    abstract Quote getQuote();
  }

  /**
   * A sanitizer for unsafe-quoting vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node {
    /** Gets the quote character for which this is a sanitizer. */
    Quote getQuote() { any() }
  }

  /** Holds if `l` contains a `quote` (either single or double). */
  private predicate containsQuote(StringOps::ConcatenationLeaf l, Quote quote) {
    quote = l.getStringValue().regexpFind("['\"]", _, _)
  }

  /** A call to `json.Marshal`, considered as a taint source for unsafe quoting. */
  class JsonMarshalAsSource extends Source {
    JsonMarshalAsSource() {
      exists(MarshalingFunction jsonMarshal | jsonMarshal.getFormat() = "JSON" |
        this = jsonMarshal.getOutput().getNode(jsonMarshal.getACall())
      )
    }
  }

  /** A string concatenation with quotes, considered as a taint sink for unsafe quoting. */
  class StringConcatenationAsSink extends Sink {
    Quote quote;

    StringConcatenationAsSink() {
      exists(StringOps::ConcatenationLeaf lf | lf.asNode() = this |
        containsQuote(lf.getPreviousLeaf(), quote) and
        containsQuote(lf.getNextLeaf(), quote)
      )
    }

    override Quote getQuote() { result = quote }
  }

  /** A call to `json.Unmarshal`, considered as a sanitizer for unsafe quoting. */
  class UnmarshalSanitizer extends Sanitizer {
    UnmarshalSanitizer() {
      exists(UnmarshalingFunction jsonUnmarshal | jsonUnmarshal.getFormat() = "JSON" |
        this = jsonUnmarshal.getOutput().getNode(jsonUnmarshal.getACall())
      )
    }
  }

  /**
   * An expression that is equivalent to `strings.ReplaceAll(s, old, new)`,
   * considered as a sanitizer for unsafe quoting.
   */
  class ReplaceSanitizer extends StringOps::ReplaceAll, Sanitizer {
    Quote quote;

    ReplaceSanitizer() { this.getReplacedString().matches("%" + quote + "%") }

    override Quote getQuote() { result = quote }
  }
}
