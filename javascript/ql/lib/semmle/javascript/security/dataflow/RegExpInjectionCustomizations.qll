/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * untrusted user input used to construct regular expressions, as well
 * as extension points for adding your own.
 */

import javascript

module RegExpInjection {
  /**
   * A data flow source for untrusted user input used to construct regular expressions.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a description of this source. */
    string describe() { result = "user-provided value" }
  }

  /**
   * A data flow sink for untrusted user input used to construct regular expressions.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for untrusted user input used to construct regular expressions.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source instanceof ActiveThreatModelSource {
    ActiveThreatModelSourceAsSource() { not this.isClientSideSource() }
  }

  private import IndirectCommandInjectionCustomizations

  /**
   * A read of `process.env`, `process.argv`, and similar, considered as a flow source for regular
   * expression injection.
   */
  class ArgvAsSource extends Source instanceof IndirectCommandInjection::Source {
    override string describe() { result = IndirectCommandInjection::Source.super.describe() }
  }

  /**
   * The source string of a regular expression.
   */
  class RegularExpressionSourceAsSink extends Sink {
    RegularExpressionSourceAsSink() { isInterpretedAsRegExp(this) }
  }

  /**
   * A call to a function whose name suggests that it escapes regular
   * expression meta-characters.
   */
  class RegExpSanitizationCall extends Sanitizer, DataFlow::ValueNode {
    RegExpSanitizationCall() {
      exists(string calleeName, string sanitize, string regexp |
        calleeName = astNode.(CallExpr).getCalleeName() and
        sanitize = "(?:escape|saniti[sz]e)" and
        regexp = "regexp?"
      |
        calleeName.regexpMatch("(?i)(" + sanitize + regexp + ")" + "|(" + regexp + sanitize + ")")
      )
    }
  }

  /**
   * A global regexp replacement involving the `{`, `[`, or `+` meta-character, viewed as a sanitizer for
   * regexp-injection vulnerabilities.
   */
  class MetacharEscapeSanitizer extends Sanitizer, StringReplaceCall {
    MetacharEscapeSanitizer() {
      this.maybeGlobal() and
      (
        RegExp::alwaysMatchesMetaCharacter(this.getRegExp().getRoot(), ["{", "[", "+"])
        or
        // or it's like a wild-card.
        RegExp::isWildcardLike(this.getRegExp().getRoot())
      )
    }
  }
}
