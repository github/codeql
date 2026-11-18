/**
 * Definitions for tracking taint steps through the Guava framework.
 */
overlay[local?]
module;

import java
import Collections
private import semmle.code.java.dataflow.DataFlow

private DataFlow::Node getALocalOriginNode(Expr expr) {
  DataFlow::localFlow(result, DataFlow::exprNode(expr)) and
  not DataFlow::localFlowStep(_, result)
}

private Expr getUniqueLocalOrigin(Expr expr) {
  result = unique(DataFlow::Node src | src = getALocalOriginNode(expr)).asExpr()
}

/** A call to `CharMatcher.anyOf`. */
private class CharMatcherAnyOfCall extends MethodCall {
  CharMatcherAnyOfCall() {
    this.getMethod().hasQualifiedName("com.google.common.base", "CharMatcher", "anyOf")
  }
}

/** A call to `CharMatcher.noneOf`. */
private class CharMatcherNoneOfCall extends MethodCall {
  CharMatcherNoneOfCall() {
    this.getMethod().hasQualifiedName("com.google.common.base", "CharMatcher", "noneOf")
  }
}

/** A call that tests a string using a character-set `CharMatcher`. */
private class CharMatcherCharacterSetMatch extends MethodCall, StringCharacterSetMatch::Range {
  CharMatcherCharacterSetMatch() {
    this.getMethod()
        .hasQualifiedName("com.google.common.base", "CharMatcher",
          ["matchesAllOf", "matchesAnyOf", "matchesNoneOf"]) and
    (
      this.getMethod().hasName(["matchesAnyOf", "matchesNoneOf"]) and
      getUniqueLocalOrigin(this.getQualifier()) instanceof CharMatcherAnyOfCall
      or
      this.getMethod().hasName("matchesAllOf") and
      getUniqueLocalOrigin(this.getQualifier()) instanceof CharMatcherNoneOfCall
    )
  }

  override Expr getInputString() { result = this.getArgument(0) }

  override Expr getMatchExpression() {
    result = getUniqueLocalOrigin(this.getQualifier()).(MethodCall).getArgument(0)
  }

  override predicate hasMatchingCharacterOnBranch(boolean branch) {
    this.getMethod().hasName("matchesAnyOf") and branch = true
    or
    this.getMethod().hasName("matchesNoneOf") and branch = false
    or
    this.getMethod().hasName("matchesAllOf") and
    branch = false
  }

  override string getName() { result = "CharMatcher." + this.getMethod().getName() }
}

/** A call to `CharMatcher.replaceFrom`. */
private class CharMatcherReplaceFromCall extends MethodCall, StringReplacement::Range {
  CharMatcherReplaceFromCall() {
    this.getMethod().hasQualifiedName("com.google.common.base", "CharMatcher", "replaceFrom")
  }

  override Expr getInputString() { result = this.getArgument(0) }

  override Expr getMatchExpression() {
    result = getUniqueLocalOrigin(this.getQualifier()).(CharMatcherAnyOfCall).getArgument(0)
  }

  override Expr getReplacement() { result = this.getArgument(1) }

  override predicate matchExpressionIsCharacterSet() { any() }

  override string getName() { result = "CharMatcher.replaceFrom" }
}

/** A call to `CharMatcher.removeFrom`. */
private class CharMatcherRemoveFromCall extends MethodCall, StringRemoval::Range {
  CharMatcherRemoveFromCall() {
    this.getMethod().hasQualifiedName("com.google.common.base", "CharMatcher", "removeFrom")
  }

  override Expr getInputString() { result = this.getArgument(0) }

  override Expr getMatchExpression() {
    result = getUniqueLocalOrigin(this.getQualifier()).(CharMatcherAnyOfCall).getArgument(0)
  }

  override predicate matchExpressionIsCharacterSet() { any() }

  override string getName() { result = "CharMatcher.removeFrom" }
}
