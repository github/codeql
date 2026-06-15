/** Provides classes and predicates related to Log Injection vulnerabilities. */
overlay[local?]
module;

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.security.Sanitizers

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
  DefaultLogInjectionSink() { sinkNode(this, "log-injection") }
}

private class DefaultLogInjectionSanitizer extends LogInjectionSanitizer instanceof SimpleTypeSanitizer
{ }

private class LineBreaksLogInjectionSanitizer extends LogInjectionSanitizer {
  LineBreaksLogInjectionSanitizer() {
    logInjectionSanitizer(this.asExpr())
    or
    this = DataFlow::BarrierGuard<logInjectionGuard/3>::getABarrierNode()
  }
}

private predicate stringMethodCall(
  MethodCall mc, CompileTimeConstantExpr arg0, CompileTimeConstantExpr arg1
) {
  mc.getMethod().getDeclaringType() instanceof TypeString and
  arg0 = mc.getArgument(0) and
  arg1 = mc.getArgument(1)
}

private predicate stringMethodArgument(CompileTimeConstantExpr arg) {
  stringMethodCall(_, arg, _) or stringMethodCall(_, _, arg)
}

bindingset[match]
pragma[inline_late]
private predicate stringMethodArgumentValueMatches(CompileTimeConstantExpr const, string match) {
  stringMethodArgument(const) and
  const.getStringValue().matches(match)
}

/**
 * Holds if `e` is sanitized against log injection attacks by removing line
 * breaks from it.
 */
private predicate logInjectionSanitizer(Expr e) {
  exists(MethodCall mc, CompileTimeConstantExpr target, CompileTimeConstantExpr replacement |
    e = mc and
    stringMethodCall(mc, target, replacement) and
    not stringMethodArgumentValueMatches(replacement, ["%\n%", "%\r%"])
  |
    mc.getMethod().hasName("replace") and
    not replacement.getIntValue() = [10, 13] and
    (
      target.getIntValue() = [10, 13] or // 10 == '\n', 13 == '\r'
      target.getStringValue() = ["\n", "\r"]
    )
    or
    mc.getMethod().hasName("replaceAll") and
    (
      // Replace anything not in an allow list
      target.getStringValue().matches("[^%]") and
      not stringMethodArgumentValueMatches(target, "%" + ["\n", "\r", "\\n", "\\r", "\\R"] + "%")
      or
      // Replace line breaks
      target.getStringValue() = ["\n", "\r", "\\n", "\\r", "\\R"]
    )
  )
  or
  exists(RegexMatch rm, CompileTimeConstantExpr target |
    rm instanceof Annotation and
    e = rm.getASanitizedExpr() and
    target = rm.getRegex() and
    regexPreventsLogInjection(target.getStringValue(), true)
  )
}

/**
 * Holds if `g` guards `e` in branch `branch` against log injection attacks
 * by checking if there are line breaks in `e`.
 */
private predicate logInjectionGuard(Guard g, Expr e, boolean branch) {
  exists(MethodCall mc | mc = g |
    mc.getMethod() instanceof StringContainsMethod and
    mc.getArgument(0).(CompileTimeConstantExpr).getStringValue() = ["\n", "\r"] and
    e = mc.getQualifier() and
    branch = false
  )
  or
  exists(RegexMatch rm, CompileTimeConstantExpr target |
    rm = g and
    not rm instanceof Annotation and
    target = rm.getRegex() and
    e = rm.getASanitizedExpr()
  |
    regexPreventsLogInjection(target.getStringValue(), branch)
  )
}

/**
 * Holds if `regex` matches against a pattern that allows anything except
 * line breaks when `branch` is `true`, or a pattern that matches line breaks
 * when `branch` is `false`.
 */
bindingset[regex]
private predicate regexPreventsLogInjection(string regex, boolean branch) {
  // Allow anything except line breaks
  (
    not regex.matches("%[^%]%") and
    not regex.matches("%" + ["\n", "\r", "\\n", "\\r", "\\R"] + "%")
    or
    regex.matches("%[^%" + ["\n", "\r", "\\n", "\\r", "\\R"] + "%]%")
  ) and
  branch = true
  or
  // Disallow line breaks
  (
    not regex.matches("%[^%" + ["\n", "\r", "\\n", "\\r", "\\R"] + "%]%") and
    // Assuming a regex containing line breaks is correctly matching line breaks in a string
    regex.matches("%" + ["\n", "\r", "\\n", "\\r", "\\R"] + "%")
  ) and
  branch = false
}
