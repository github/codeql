/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input used in log entries.
 */

import codeql.ruby.AST
import codeql.ruby.Concepts
import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking
import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.frameworks.Core
private import codeql.ruby.frameworks.data.internal.ApiGraphModels

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
 * A source of remote user controlled input.
 */
class RemoteSource extends Source instanceof RemoteFlowSource { }

/**
 * An input to a logging mechanism.
 */
class LoggingSink extends Sink {
  LoggingSink() { this = any(Logging logging).getAnInput() }
}

private class ExternalLogInjectionSink extends Sink {
  ExternalLogInjectionSink() { this = ModelOutput::getASinkNode("log-injection").asSink() }
}

/**
 * A call to `String#replace` that replaces `\n` is considered to sanitize the replaced string (reduce false positive).
 */
class StringReplaceSanitizer extends Sanitizer {
  StringReplaceSanitizer() {
    exists(string s | this.(StringSubstitutionCall).replaces(s, "") and s.regexpMatch("\\n")) and
    // exclude replacement methods that may not fully sanitize the string
    this.(StringSubstitutionCall).isGlobal()
  }
}

/**
 * A call to `Object#inspect`, considered as a sanitizer.
 * This is because `inspect` will replace newlines in strings with `\n`.
 */
class InspectSanitizer extends Sanitizer {
  InspectSanitizer() { this.(DataFlow::CallNode).getMethodName() = "inspect" }
}

/**
 * A call to an HTML escape method is considered to sanitize its input.
 */
class HtmlEscapingAsSanitizer extends Sanitizer {
  HtmlEscapingAsSanitizer() { this = any(HtmlEscaping esc).getOutput() }
}

private module LogInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for untrusted user input used in log entries.
 */
module LogInjectionFlow = TaintTracking::Global<LogInjectionConfig>;
