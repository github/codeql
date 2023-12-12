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

  /** A source of untrusted data, considered as a taint source for log injection. */
  class UntrustedFlowAsSource extends Source instanceof UntrustedFlowSource { }

  /** An argument to a logging mechanism. */
  class LoggerSink extends Sink {
    LoggerSink() {
      exists(LoggerCall call |
        this = call.getAMessageComponent() and
        // exclude arguments to `call` which have a safe format argument, which
        // aren't caught by SafeFormatArgumentSanitizer as that sanitizes the
        // result of the call.
        not safeFormatArgument(this, call)
      )
    }
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
   * Holds if `arg` is an argument to `call` that is formatted using the `%q`
   * directive. This formatting directive replaces newline characters with
   * escape sequences, so `arg` would not be a sink for log injection.
   */
  private predicate safeFormatArgument(
    DataFlow::Node arg, StringOps::Formatting::StringFormatCall call
  ) {
    exists(string safeDirective |
      // Mark "%q" formats as safe, but not "%#q", which would preserve newline characters.
      safeDirective.regexpMatch("%[^%#]*q")
    |
      arg = call.getOperand(_, safeDirective)
    )
  }

  /**
   * An argument that is formatted using the `%q` directive, considered as a sanitizer
   * for log injection.
   *
   * This formatting directive replaces newline characters with escape sequences.
   */
  private class SafeFormatArgumentSanitizer extends Sanitizer {
    SafeFormatArgumentSanitizer() {
      exists(DataFlow::Node arg, StringOps::Formatting::StringFormatCall call |
        safeFormatArgument(arg, call)
      |
        this = call.getAResult()
      )
    }
  }
}
