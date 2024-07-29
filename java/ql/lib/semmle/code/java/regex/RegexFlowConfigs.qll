/**
 * Defines configurations and steps for handling regexes
 */

import java
import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.security.SecurityTests

private class ExploitableStringLiteral extends StringLiteral {
  ExploitableStringLiteral() { this.getValue().matches(["%+%", "%*%", "%{%}%"]) }
}

/**
 * Holds if `kind` is an external sink kind that is relevant for regex flow.
 * `full` is true if sinks with this kind match against the full string of its
 * input.
 * `strArg` is the index of the argument to methods with this sink kind that
 * contain the string to be matched against, where -1 is the qualifier; or -2
 * if no such argument exists.
 *
 * Note that `regex-use` is deliberately not a possible value for `kind` here,
 * as it is used for regular expression injection sinks that need to be selected
 * separately from existing `regex-use[0]` sinks.
 * TODO: refactor the `regex-use%` sink kind so that the polynomial ReDoS query
 * can also use the `regex-use` sinks.
 */
private predicate regexSinkKindInfo(string kind, boolean full, int strArg) {
  sinkModel(_, _, _, _, _, _, _, kind, _, _) and
  exists(string fullStr, string strArgStr |
    (
      full = true and fullStr = "f"
      or
      full = false and fullStr = ""
    ) and
    (
      strArgStr.toInt() = strArg
      or
      strArg = -2 and
      strArgStr = ""
    )
  |
    kind = "regex-use[" + fullStr + strArgStr + "]"
  )
}

/** A sink that is relevant for regex flow. */
private class RegexFlowSink extends DataFlow::Node {
  boolean full;
  int strArg;

  RegexFlowSink() {
    exists(string kind |
      regexSinkKindInfo(kind, full, strArg) and
      sinkNode(this, kind)
    )
  }

  /** Holds if a regex that flows here is matched against a full string (rather than a substring). */
  predicate matchesFullString() { full = true }

  /** Gets the string expression that a regex that flows here is matched against, if any. */
  Expr getStringArgument() {
    exists(MethodCall ma |
      this.asExpr() = argOf(ma, _) and
      result = argOf(ma, strArg)
    )
  }
}

private Expr argOf(MethodCall ma, int arg) {
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

// TODO: This may be able to be done with models-as-data if query-specific flow steps beome supported.
private class JdkRegexFlowStep extends RegexAdditionalFlowStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodCall ma, Method m, string package, string type, string name, int arg |
      ma.getMethod().getSourceDeclaration().overrides*(m) and
      m.hasQualifiedName(package, type, name) and
      node1.asExpr() = argOf(ma, arg) and
      node2.asExpr() = ma
    |
      package = "java.util.regex" and
      type = "Pattern" and
      (
        name = ["asMatchPredicate", "asPredicate", "matcher"] and
        arg = -1
        or
        name = "compile" and
        arg = 0
      )
      or
      package = "java.util.function" and
      type = "Predicate" and
      name = ["and", "or", "not", "negate"] and
      arg = [-1, 0]
    )
  }
}

private class GuavaRegexFlowStep extends RegexAdditionalFlowStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodCall ma, Method m, string package, string type, string name, int arg |
      ma.getMethod().getSourceDeclaration().overrides*(m) and
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

private module RegexFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof ExploitableStringLiteral }

  predicate isSink(DataFlow::Node node) { node instanceof RegexFlowSink }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(RegexAdditionalFlowStep s).step(node1, node2)
  }

  predicate isBarrier(DataFlow::Node node) {
    node.getEnclosingCallable().getDeclaringType() instanceof NonSecurityTestClass
  }

  int fieldFlowBranchLimit() { result = 1 }
}

private module RegexFlow = DataFlow::Global<RegexFlowConfig>;

/**
 * Holds if `regex` is used as a regex, with the mode `mode` (if known).
 * If regex mode is not known, `mode` will be `"None"`.
 *
 * As an optimisation, only regexes containing an infinite repitition quatifier (`+`, `*`, or `{x,}`)
 * and therefore may be relevant for ReDoS queries are considered.
 */
predicate usedAsRegex(StringLiteral regex, string mode, boolean match_full_string) {
  RegexFlow::flow(DataFlow::exprNode(regex), _) and
  mode = "None" and // TODO: proper mode detection
  (if matchesFullString(regex) then match_full_string = true else match_full_string = false)
}

/**
 * Holds if `regex` is used as a regular expression that is matched against a full string,
 * as though it was implicitly surrounded by ^ and $.
 */
private predicate matchesFullString(StringLiteral regex) {
  exists(RegexFlowSink sink |
    sink.matchesFullString() and
    RegexFlow::flow(DataFlow::exprNode(regex), sink)
  )
}

/**
 * Holds if the string literal `regex` is a regular expression that is matched against the expression `str`.
 *
 * As an optimisation, only regexes containing an infinite repitition quatifier (`+`, `*`, or `{x,}`)
 * and therefore may be relevant for ReDoS queries are considered.
 */
predicate regexMatchedAgainst(StringLiteral regex, Expr str) {
  exists(RegexFlowSink sink |
    str = sink.getStringArgument() and
    RegexFlow::flow(DataFlow::exprNode(regex), sink)
  )
}
