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

    HtmlAttributeConcatenation() {
      lhs = this.getPreviousLeaf().getStringValue().regexpCapture("(?s)(.*)=\"[^\"]*", 1) and
      (
        this.getNextLeaf().getStringValue().regexpMatch(".*\".*") or
        this instanceof StringOps::HtmlConcatenationLeaf
      )
    }

    /**
     * Holds if the attribute value is interpreted as JavaScript source code.
     */
    predicate isInterpretedAsJavaScript() { lhs.regexpMatch("(?i)(.* )?on[a-z]+") }
  }

  /**
   * A concatenation that syntactically looks like a definition of an
   * HTML attribute, as a sink for incomplete HTML sanitization
   * vulnerabilities.
   */
  class HtmlAttributeConcatenationAsSink extends Sink, DataFlow::ValueNode,
    HtmlAttributeConcatenation {
    override string getADangerousCharacter() {
      isInterpretedAsJavaScript() and result = "&"
      or
      result = "\""
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
