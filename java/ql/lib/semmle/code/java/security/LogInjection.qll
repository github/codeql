/** Provides classes and predicates related to Log Injection vulnerabilities. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow

/** A data flow sink for unvalidated user input that is used to log messages. */
abstract class LogInjectionSink extends DataFlow::Node { }

/**
 * A node that sanitizes a message before logging to avoid log injection.
 */
abstract class LogInjectionSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to the `LogInjectionConfiguration`.
 */
class LogInjectionAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for the `LogInjectionConfiguration` configuration.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

private class DefaultLogInjectionSink extends LogInjectionSink {
  DefaultLogInjectionSink() { sinkNode(this, "logging") }
}

private class DefaultLogInjectionSanitizer extends LogInjectionSanitizer {
  DefaultLogInjectionSanitizer() {
    this.getType() instanceof BoxedType or this.getType() instanceof PrimitiveType
  }
}
