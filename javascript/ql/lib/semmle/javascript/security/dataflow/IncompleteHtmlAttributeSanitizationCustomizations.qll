/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * incomplete HTML sanitization vulnerabilities, as well as extension
 * points for adding your own.
 */

import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources
import semmle.javascript.security.IncompleteBlacklistSanitizer

module IncompleteHtmlAttributeSanitization {
  /**
   * A data flow source for incomplete HTML sanitization vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets a character that may come out of this source.
     */
    abstract string getAnUnsanitizedCharacter();
  }

  /**
   * A data flow sink for incomplete HTML sanitization vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets a character that is dangerous for this sink.
     */
    abstract string getADangerousCharacter();
  }

  /**
   * A sanitizer for incomplete HTML sanitization vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of incompletely sanitized characters, considered as a
   * flow source for incomplete HTML sanitization vulnerabilities.
   */
  class IncompleteHtmlSanitizerAsSource extends Source, HtmlSanitization::IncompleteSanitizer {
    override string getAnUnsanitizedCharacter() {
      result = HtmlSanitization::IncompleteSanitizer.super.getAnUnsanitizedCharacter()
    }
  }

  /**
   * A concatenation that syntactically looks like a definition of an HTML attribute.
   */
  class HtmlAttributeConcatenation extends StringOps::ConcatenationLeaf {
    string lhs;
    string quote;

    HtmlAttributeConcatenation() {
      quote = ["\"", "'"] and
      exists(string prev | prev = this.getPreviousLeaf().getStringValue() |
        lhs = prev.regexpCapture("(?s)(.*)=" + quote + "[^" + quote + "=<>]*", 1)
      ) and
      (
        this.getNextLeaf().getStringValue().regexpMatch(".*" + quote + ".*") or
        this instanceof StringOps::HtmlConcatenationLeaf
      )
    }

    /**
     * Holds if the attribute value is interpreted as JavaScript source code.
     */
    predicate isInterpretedAsJavaScript() { lhs.regexpMatch("(?i)(.* )?on[a-z]+") }

    /**
     * Gets the quote symbol (" or ') that is used to mark the attribute value.
     */
    string getQuote() { result = quote }
  }

  /**
   * A concatenation that syntactically looks like a definition of an
   * HTML attribute, as a sink for incomplete HTML sanitization
   * vulnerabilities.
   */
  class HtmlAttributeConcatenationAsSink extends Sink, DataFlow::ValueNode,
    HtmlAttributeConcatenation {
    override string getADangerousCharacter() {
      this.isInterpretedAsJavaScript() and result = "&"
      or
      result = this.getQuote()
    }
  }

  /**
   * An encoder for potentially malicious characters, as a sanitizer
   * for incomplete HTML sanitization vulnerabilities.
   */
  class EncodingSanitizer extends Sanitizer {
    EncodingSanitizer() {
      this = DataFlow::globalVarRef(["encodeURIComponent", "encodeURI"]).getACall()
    }
  }
}
