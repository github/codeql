/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input used in log entries.
 */

import java
import semmle.code.java.dataflow.FlowSources

module LogInjection {
  string logLevel() {
    result = "trace" or
    result = "info" or
    result = "warn" or
    result = "error" or
    result = "fatal"
  }

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
    RemoteSource() { this instanceof RemoteFlowSource }
  }

  /**
   * A class of popular logging utilities.
   */
  class LoggingType extends RefType {
    LoggingType() {
      this.hasQualifiedName("org.apache.logging.log4j", "Logger") or
      this.hasQualifiedName("org.slf4j", "Logger")
    }
  }

  /**
   * A method call to a logging mechanism.
   */
  class LoggingCall extends MethodAccess {
    LoggingCall() {
      this.getMethod().getDeclaringType() instanceof LoggingType and
      this.getMethod().hasName(logLevel())
    }
  }

  /**
   * An argument to a logging mechanism.
   */
  class LoggingSink extends Sink {
    LoggingSink() { this.asExpr() = any(LoggingCall console).getAnArgument() }
  }

  class TypeSanitizer extends Sanitizer {
    TypeSanitizer() {
      this.getType() instanceof PrimitiveType or this.getType() instanceof BoxedType
    }
  }
}
