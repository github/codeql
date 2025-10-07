/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * untrusted user input used to construct regular expressions, as well
 * as extension points for adding your own.
 */

import javascript
private import codeql.threatmodels.ThreatModels

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
   * Excludes environment variables by default - they require the "environment" threat model.
   */
  private class ActiveThreatModelSourceAsSource extends Source instanceof ActiveThreatModelSource {
    ActiveThreatModelSourceAsSource() {
      not this.isClientSideSource() and
      not this.(ThreatModelSource).getThreatModel() = "environment"
    }
  }

  /**
   * Environment variables as a source when the "environment" threat model is active.
   */
  private class EnvironmentVariableAsSource extends Source instanceof ThreatModelSource {
    EnvironmentVariableAsSource() {
      this.getThreatModel() = "environment" and
      currentThreatModel("environment")
    }

    override string describe() { result = "environment variable" }
  }

  /**
   * Command line arguments as a source for regular expression injection.
   */
  private class CommandLineArgumentAsSource extends Source instanceof CommandLineArguments {
    override string describe() { result = "command-line argument" }
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
