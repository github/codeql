/** Provides classes and predicates related to Log Injection vulnerabilities. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.controlflow.Guards

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
    this.getType() instanceof BoxedType or
    this.getType() instanceof PrimitiveType or
    this.getType() instanceof NumericType
  }
}

private class LineBreaksLogInjectionSanitizer extends LogInjectionSanitizer {
  LineBreaksLogInjectionSanitizer() {
    logInjectionSanitizer(this.asExpr())
    or
    this = DataFlow::BarrierGuard<logInjectionGuard/3>::getABarrierNode()
  }
}

/**
 * Holds if the return value of `ma` is sanitized against log injection attacks
 * by removing line breaks from it.
 */
private predicate logInjectionSanitizer(MethodAccess ma) {
  exists(CompileTimeConstantExpr target, CompileTimeConstantExpr replacement |
    ma.getMethod().getDeclaringType() instanceof TypeString and
    target = ma.getArgument(0) and
    replacement = ma.getArgument(1) and
    not replacement.getStringValue().matches(["%\n%", "%\r%"])
  |
    ma.getMethod().hasName("replace") and
    not replacement.getIntValue() = [10, 13] and
    (
      target.getIntValue() = [10, 13] or // 10 == '\n', 13 == '\r'
      target.getStringValue() = ["\n", "\r"]
    )
    or
    ma.getMethod().hasName("replaceAll") and
    (
      // Replace anything not in an allow list
      target.getStringValue().matches("[^%]") and
      not target.getStringValue().matches("%" + ["\n", "\r", "\\n", "\\r", "\\R"] + "%")
      or
      // Replace line breaks
      target.getStringValue() = ["\n", "\r", "\\n", "\\r", "\\R"]
    )
  )
}

/**
 * Holds if `g` guards `e` in branch `branch` against log injection attacks
 * by checking if there are line breaks in `e`.
 */
private predicate logInjectionGuard(Guard g, Expr e, boolean branch) {
  exists(MethodAccess ma, CompileTimeConstantExpr target |
    ma = g and
    target = ma.getArgument(0)
  |
    ma.getMethod().getDeclaringType() instanceof TypeString and
    ma.getMethod().hasName("contains") and
    target.getStringValue() = ["\n", "\r"] and
    e = ma.getQualifier() and
    branch = false
    or
    ma.getMethod().hasName("matches") and
    (
      ma.getMethod().getDeclaringType() instanceof TypeString and
      e = ma.getQualifier()
      or
      ma.getMethod().getDeclaringType().hasQualifiedName("java.util.regex", "Pattern") and
      e = ma.getArgument(1)
    ) and
    (
      // Allow anything except line breaks
      (
        not target.getStringValue().matches("%[^%]%") and
        not target.getStringValue().matches("%" + ["\n", "\r", "\\n", "\\r", "\\R"] + "%")
        or
        target.getStringValue().matches("%[^%" + ["\n", "\r", "\\n", "\\r", "\\R"] + "%]%")
      ) and
      branch = true
      or
      // Disallow line breaks
      (
        not target.getStringValue().matches("%[^%" + ["\n", "\r", "\\n", "\\r", "\\R"] + "%]%") and
        // Assuming a regex containing line breaks is correctly matching line breaks in a string
        target.getStringValue().matches("%" + ["\n", "\r", "\\n", "\\r", "\\R"] + "%")
      ) and
      branch = false
    )
  )
}
