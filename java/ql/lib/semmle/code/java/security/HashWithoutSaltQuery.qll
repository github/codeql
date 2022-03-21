/** Definitions and configurations for the hash without salt query */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.DataFlow2

/**
 * Gets a regular expression for matching common names of variables
 * that indicate the value being held is a password.
 */
private string getPasswordRegex() { result = "(?i).*pass(wd|word|code|phrase).*" }

/** Finds variables that hold password information judging by their names. */
private class PasswordVarExpr extends VarAccess {
  PasswordVarExpr() {
    exists(string name | name = this.getVariable().getName().toLowerCase() |
      name.regexpMatch(getPasswordRegex()) and
      not name.matches(["%hash%", "%salt%"]) // Exclude variable names such as `passwordHash` or `saltedPassword`
    )
  }
}

/** An expression that computes a concatenation operation. */
private class ConctSanitizer extends Expr {
  ConctSanitizer() {
    this instanceof AddExpr
    or
    exists(MethodAccess ma |
      ma.getMethod().hasQualifiedName("java.lang", "System", "arraycopy") and
      this = ma.getArgument(0)
    )
    or
    exists(MethodAccess ma |
      ma.getMethod().hasQualifiedName("java.lang", "StringBuilder", "append") and
      this = ma.getArgument(0)
    )
    or
    this.(ConditionalExpr).getAChildExpr() instanceof ConctSanitizer // useSalt?password+":"+salt:password
  }
}

/** Holds if there is a call to an `update` or `digest` method of a `MessageDigest` with qulifier `q` and first argument `a`. */
private predicate messageDigestUpdate(Expr q, Expr a) {
  exists(MethodAccess ma |
    ma.getMethod().hasQualifiedName("java.security", "MessageDigest", ["update", "digest"]) and
    a = ma.getArgument(0) and
    q = ma.getQualifier()
  )
}

/** Configuration tracking flow from a password to a hashing method, without being concatenated with a salt. */
class PasswordToHashConfig extends TaintTracking::Configuration {
  PasswordToHashConfig() { this = "PasswordToHashConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof PasswordVarExpr }

  override predicate isSink(DataFlow::Node sink) { messageDigestUpdate(_, sink.asExpr()) }

  override predicate isSanitizer(DataFlow::Node node) { node.asExpr() instanceof ConctSanitizer }
}

/** Holds if a password variable flows to the argument `e` of a hashing method. */
private predicate passwordFlow(Expr e) { any(PasswordToHashConfig c).hasFlowToExpr(e) }

/** A flow state representing a MessageDigest object that has been used zero times. */
private class HashZero extends DataFlow::FlowState {
  HashZero() { this = "HashZero" }
}

/** A flow state representing a MessageDigest object that has been used once. */
private class HashOne extends DataFlow::FlowState {
  HashOne() { this = "HashOne" }
}

/**
 * A flow state representing a MessageDigest object that is salted,
 * i.e. it has been used more than once, or with a value that is definitely not a password.
 */
private class HashSalted extends DataFlow::FlowState {
  HashSalted() { this = "HashSalted" }
}

/**
 * A configuration for determining that a `MessageDigest` object is used at least once with a password.
 * A `MessageDigest` that is used more than once indicates that a salt is being used.
 */
private class MessageDigestUsedOnceConfig extends DataFlow2::Configuration {
  MessageDigestUsedOnceConfig() { this = "MessageDigestUsedOnceConfig" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source
        .asExpr()
        .(MethodAccess)
        .getMethod()
        .hasQualifiedName("java.security", "MessageDigest", "getInstance") and
    state instanceof HashZero
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    exists(MethodAccess ma |
      ma.getMethod().hasQualifiedName("java.security", "MessageDigest", "digest") and
      sink.asExpr() = ma.getQualifier() and
      (
        if ma.getNumArgument() = 0
        then state instanceof HashOne
        else (
          state instanceof HashZero and
          passwordFlow(ma.getArgument(0))
        )
      )
    )
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    exists(MethodAccess ma |
      ma.getMethod().hasQualifiedName("java.security", "MessageDigest", "update") and
      node1.asExpr() = ma.getQualifier() and
      node2.(DataFlow::PostUpdateNode).getPreUpdateNode() = node1 and
      passwordFlow(ma.getArgument(0)) and
      state1 instanceof HashZero and
      state2 instanceof HashOne
    )
  }
}

/**
 * A configuration that a `MessageDigest` object is salted; i.e. it is used more than once
 * or used with a non password.
 */
private class MessageDigestSaltedConfig extends DataFlow2::Configuration {
  MessageDigestSaltedConfig() { this = "MessageDigestSaltedConfig" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source
        .asExpr()
        .(MethodAccess)
        .getMethod()
        .hasQualifiedName("java.security", "MessageDigest", "getInstance") and
    state instanceof HashZero
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    exists(MethodAccess ma |
      ma.getMethod().hasQualifiedName("java.security", "MessageDigest", "digest") and
      sink.asExpr() = ma.getQualifier() and
      (
        state instanceof HashSalted
        or
        state instanceof HashOne and
        ma.getNumArgument() != 0
      )
    )
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    exists(MethodAccess ma |
      ma.getMethod().hasQualifiedName("java.security", "MessageDigest", "update") and
      node1.asExpr() = ma.getQualifier() and
      node2.(DataFlow::PostUpdateNode).getPreUpdateNode() = node1 and
      (
        if passwordFlow(ma.getArgument(0))
        then (
          state1 instanceof HashZero and
          state2 instanceof HashOne
          or
          state1 instanceof HashOne and
          state2 instanceof HashSalted
        ) else (
          (state1 instanceof HashZero or state1 instanceof HashOne) and
          state2 instanceof HashSalted
        )
      )
    )
  }
}

/** Holds if there is loal dataflow between `node1` and `node2` in either direction. */
private predicate localFlowBetween(DataFlow::Node node1, DataFlow::Node node2) {
  DataFlow::localFlow(node1, node2) or DataFlow::localFlow(node2, node1)
}

/** Holds if the data flow node for `expr` is on a path from a source to a sink of the `MessageDigestUsageConfig` configuration. */
private predicate messageDigestFlowPath(DataFlow::Node node) {
  exists(
    MessageDigestUsedOnceConfig c, DataFlow2::PathNode source, DataFlow2::PathNode sink,
    DataFlow2::PathNode mid
  |
    c.hasFlowPath(source, sink) and
    source.getASuccessor*() = mid and
    mid.getASuccessor*() = sink and
    node = mid.getNode() and
    not exists(
      MessageDigestSaltedConfig c2, DataFlow2::PathNode source2, DataFlow2::PathNode sink2,
      DataFlow2::PathNode mid2
    |
      c2.hasFlowPath(source2, sink2) and
      source2.getASuccessor*() = mid2 and
      mid2.getASuccessor*() = sink2 and
      localFlowBetween(mid.getNode(), mid2.getNode())
    )
  )
}

/** Holds if the password variable `pw` is hashed without a salt at callsite `hash`. */
predicate passwordHashWithoutSalt(Expr pw, Expr hash) {
  exists(MethodAccess ma, DataFlow::Node mdNode |
    messageDigestFlowPath(mdNode) and
    localFlowBetween(mdNode, DataFlow::exprNode([ma.getAnArgument(), ma.getQualifier()])) and
    pw instanceof PasswordVarExpr and
    hash = ma.getAnArgument() and
    TaintTracking::localTaint(DataFlow::exprNode(pw), DataFlow::exprNode(hash))
  )
}
