/**
 * Defines configurations and steps for handling regexes
 */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.DataFlow2
private import semmle.code.java.dataflow.DataFlow3
private import RegexFlowModels

private class RegexCompileFlowConf extends DataFlow2::Configuration {
  RegexCompileFlowConf() { this = "RegexCompileFlowConfig" }

  override predicate isSource(DataFlow::Node node) { node.asExpr() instanceof StringLiteral }

  override predicate isSink(DataFlow::Node node) { sinkNode(node, "regex-compile") }
}

/**
 * Holds if `s` is used as a regex, with the mode `mode` (if known).
 * If regex mode is not known, `mode` will be `"None"`.
 */
predicate usedAsRegex(StringLiteral s, string mode) {
  any(RegexCompileFlowConf c).hasFlow(DataFlow2::exprNode(s), _) and
  mode = "None" // TODO: proper mode detection
}

/**
 * A method access that can match a regex against a string
 */
abstract class RegexMatchMethodAccess extends MethodAccess {
  string package;
  string type;
  string name;
  int regexArg;
  int stringArg;
  Method m;

  RegexMatchMethodAccess() {
    this.getMethod().overrides*(m) and
    m.hasQualifiedName(package, type, name) and
    regexArg in [-1 .. m.getNumberOfParameters() - 1] and
    stringArg in [-1 .. m.getNumberOfParameters() - 1]
  }

  /** Gets the argument of this call that the regex to be matched against flows into. */
  Expr getRegexArg() { result = argOf(this, regexArg) }

  /** Gets the argument of this call that the string being matched flows into. */
  Expr getStringArg() { result = argOf(this, stringArg) }
}

private Expr argOf(MethodAccess ma, int arg) {
  arg = -1 and result = ma.getQualifier()
  or
  result = ma.getArgument(arg)
}

/**
 * A unit class for adding additional regex flow steps.
 *
 * Extend this class to add additional flow steps that should apply to regex flow configurations.
 */
class RegexAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for regex flow configurations.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

// TODO: can this be done with the models-as-data framework?
private class JdkRegexMatchMethodAccess extends RegexMatchMethodAccess {
  JdkRegexMatchMethodAccess() {
    package = "java.util.regex" and
    type = "Pattern" and
    (
      name = "matcher" and regexArg = -1 and stringArg = 0
      or
      name = "matches" and regexArg = 0 and stringArg = 1
      or
      name = "split" and regexArg = 0 and stringArg = 1
      or
      name = "splitAsStream" and regexArg = 0 and stringArg = 1
    )
    or
    package = "java.lang" and
    type = "String" and
    name = ["matches", "split"] and
    regexArg = 0 and
    stringArg = -1
    or
    package = "java.util" and
    type = "Predicate" and
    name = "test" and
    regexArg = -1 and
    stringArg = 0
  }
}

private class JdkRegexFlowStep extends RegexAdditionalFlowStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodAccess ma, Method m, string package, string type, string name, int arg |
      ma.getMethod().overrides*(m) and
      m.hasQualifiedName(package, type, name) and
      node1.asExpr() = argOf(ma, arg) and
      node2.asExpr() = ma
    |
      package = "java.util.regex" and
      type = "Pattern" and
      (
        name = ["asMatchPredicate", "asPredicate"] and
        arg = -1
        or
        name = "compile" and
        arg = 0
      )
      or
      package = "java.util" and
      type = "Predicate" and
      name = ["and", "or", "not", "negate"] and
      arg = [-1, 0]
    )
  }
}

private class GuavaRegexMatchMethodAccess extends RegexMatchMethodAccess {
  GuavaRegexMatchMethodAccess() {
    package = "com.google.common.collect" and
    regexArg = -1 and
    stringArg = 0 and
    type = ["Splitter", "Splitter$MapSplitter"] and
    name = ["split", "splitToList"]
  }
}

private class GuavaRegexFlowStep extends RegexAdditionalFlowStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodAccess ma, Method m, string package, string type, string name, int arg |
      ma.getMethod().overrides*(m) and
      m.hasQualifiedName(package, type, name) and
      node1.asExpr() = argOf(ma, arg) and
      node2.asExpr() = ma
    |
      package = "com.google.common.base" and
      type = "Splitter" and
      (
        name = "on" and
        m.getParameterType(0).(RefType).hasQualifiedName("java.util.regex", "Pattern") and
        arg = 0
        or
        name = "withKeyValueSeparator" and
        m.getParameterType(0).(RefType).hasQualifiedName("com.google.common.base", "Splitter") and
        arg = 0
        or
        name = "onPattern" and
        arg = 0
        or
        name = ["limit", "omitEmptyStrings", "trimResults", "withKeyValueSeparator"] and
        arg = -1
      )
    )
  }
}

private class RegexMatchFlowConf extends DataFlow2::Configuration {
  RegexMatchFlowConf() { this = "RegexMatchFlowConf" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof StringLiteral }

  override predicate isSink(DataFlow::Node sink) {
    exists(RegexMatchMethodAccess ma | sink.asExpr() = ma.getRegexArg())
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(RegexAdditionalFlowStep s).step(node1, node2)
  }
}

/**
 * Holds if the string literal `regex` is a regular expression that is matched against the expression `str`.
 */
predicate regexMatchedAgainst(StringLiteral regex, Expr str) {
  exists(
    DataFlow::Node src, DataFlow::Node sink, RegexMatchMethodAccess ma, RegexMatchFlowConf conf
  |
    src.asExpr() = regex and
    sink.asExpr() = ma.getRegexArg() and
    conf.hasFlow(src, sink) and
    str = ma.getStringArg()
  )
}
