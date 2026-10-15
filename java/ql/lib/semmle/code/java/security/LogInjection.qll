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

private class ExternalLogInjectionSanitizer extends LogInjectionSanitizer {
  ExternalLogInjectionSanitizer() { barrierNode(this, "log-injection") }
}

private class LineBreaksLogInjectionSanitizer extends LogInjectionSanitizer {
  LineBreaksLogInjectionSanitizer() {
    logInjectionSanitizer(this.asExpr())
    or
    this = DataFlow::BarrierGuard<logInjectionGuard/3>::getABarrierNode()
  }
}

bindingset[match]
pragma[inline_late]
private predicate stringOrCharValueMatches(CompileTimeConstantExpr const, string match) {
  const.getStringOrCharValue().matches(match)
}

private predicate containsLineBreak(CompileTimeConstantExpr const) {
  stringOrCharValueMatches(const, ["%\n%", "%\r%"])
}

private predicate containsBothLineBreaks(CompileTimeConstantExpr const) {
  stringOrCharValueMatches(const, "%\n%") and stringOrCharValueMatches(const, "%\r%")
}

private predicate regexRemovesLineBreaks(CompileTimeConstantExpr target) {
  // Replace anything not in an allow list
  target.getStringValue().matches("[^%]") and
  not stringOrCharValueMatches(target, "%" + ["\n", "\r", "\\n", "\\r", "\\R"] + "%")
  or
  // Replace line breaks
  target.getStringValue() = ["\n", "\r", "\\n", "\\r", "\\R"]
}

private predicate replacementRemovesLineBreaks(
  StringReplacement replacement, CompileTimeConstantExpr target
) {
  target = replacement.getMatchExpression() and
  (
    replacement.matchExpressionIsCharacterSet() and containsBothLineBreaks(target)
    or
    replacement.matchExpressionIsRegex() and regexRemovesLineBreaks(target)
    or
    not replacement.matchExpressionIsCharacterSet() and
    not replacement.matchExpressionIsRegex() and
    target.getStringOrCharValue() = ["\n", "\r"]
  )
}

private predicate removalRemovesLineBreaks(StringRemoval removal, CompileTimeConstantExpr target) {
  target = removal.getMatchExpression() and
  (
    removal.matchExpressionIsCharacterSet() and containsBothLineBreaks(target)
    or
    removal.matchExpressionIsRegex() and regexRemovesLineBreaks(target)
    or
    not removal.matchExpressionIsCharacterSet() and
    not removal.matchExpressionIsRegex() and
    target.getStringOrCharValue() = ["\n", "\r"]
  )
}

/**
 * Holds if `e` is sanitized against log injection attacks by removing line
 * breaks from it.
 */
private predicate logInjectionSanitizer(Expr e) {
  replacementRemovesLineBreaks(e, _) and
  exists(CompileTimeConstantExpr replacement |
    replacement = e.(StringReplacement).getReplacement() and
    exists(replacement.getStringOrCharValue()) and
    not containsLineBreak(replacement)
  )
  or
  removalRemovesLineBreaks(e, _)
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
