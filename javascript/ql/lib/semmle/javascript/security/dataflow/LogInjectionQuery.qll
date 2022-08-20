/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input used in log entries.
 */

import javascript

/**
 * A data flow source for user input used in log entries.
 */
abstract class Source extends DataFlow::Node { }

/**
 * A data flow sink for user input used in log entries.
 */
abstract class Sink extends DataFlow::Node { }

/**
 * A sanitizer for malicious user input used in log entries.
 */
abstract class Sanitizer extends DataFlow::Node { }

/**
 * A taint-tracking configuration for untrusted user input used in log entries.
 */
class LogInjectionConfiguration extends TaintTracking::Configuration {
  LogInjectionConfiguration() { this = "LogInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * A source of remote user controlled input.
 */
class RemoteSource extends Source {
  RemoteSource() {
    this instanceof RemoteFlowSource and not this instanceof ClientSideRemoteFlowSource
  }
}

/**
 * An argument to a logging mechanism.
 */
class LoggingSink extends Sink {
  LoggingSink() { this = any(LoggerCall console).getAMessageComponent() }
}

/**
 * A call to `String.prototype.replace` that replaces `\n` is considered to sanitize the replaced string (reduce false positive).
 */
class StringReplaceSanitizer extends Sanitizer {
  StringReplaceSanitizer() {
    exists(string s | this.(StringReplaceCall).replaces(s, "") and s.regexpMatch("\\n"))
  }
}

/**
 * A call to an HTML sanitizer is considered to sanitize the user input.
 */
class HtmlSanitizer extends Sanitizer {
  HtmlSanitizer() { this instanceof HtmlSanitizerCall }
}

/**
 * A call to `JSON.stringify` or similar, seen as sanitizing log output.
 */
class JsonStringifySanitizer extends Sanitizer {
  JsonStringifySanitizer() { this = any(JsonStringifyCall c).getOutput() }
}
