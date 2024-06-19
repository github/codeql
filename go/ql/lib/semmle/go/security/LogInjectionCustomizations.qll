/**
 * Provides default sources, sinks, and sanitizers for reasoning about
 * log injection vulnerabilities, as well as extension points for adding your own.
 */

import go

/**
 * Provides extension points for customizing the data-flow tracking configuration for reasoning
 * about log injection.
 */
module LogInjection {
  /**
   * A data flow source for log injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for log injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for log injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * DEPRECATED: Use `ThreatModelFlowSource` or `Source` instead.
   */
  deprecated class UntrustedFlowAsSource = ThreatModelFlowAsSource;

  /** A source of untrusted data, considered as a taint source for log injection. */
  private class ThreatModelFlowAsSource extends Source instanceof ThreatModelFlowSource { }

  /** An argument to a logging mechanism. */
  class LoggerSink extends Sink {
    LoggerSink() { this = any(LoggerCall log).getAMessageComponent() }
  }

  /**
   * An expression that is equivalent to `strings.ReplaceAll(s, old, new)`,
   * where `old` is a newline character, considered as a sanitizer for log
   * injection.
   */
  class ReplaceSanitizer extends StringOps::ReplaceAll, Sanitizer {
    ReplaceSanitizer() { this.getReplacedString() = ["\r", "\n"] }
  }

  /**
   * An argument that is formatted using the `%q` directive, considered as a sanitizer
   * for log injection.
   *
   * This formatting directive replaces newline characters with escape sequences.
   */
  private class SafeFormatArgumentSanitizer extends Sanitizer {
    SafeFormatArgumentSanitizer() {
      exists(StringOps::Formatting::StringFormatCall call, string safeDirective |
        this = call.getOperand(_, safeDirective) and
        // Mark "%q" formats as safe, but not "%#q", which would preserve newline characters.
        safeDirective.regexpMatch("%[^%#]*q")
      )
    }
  }
}
