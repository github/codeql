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
private class ConcatSanitizer extends Expr {
  ConcatSanitizer() {
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
    this.(ConditionalExpr).getAChildExpr() instanceof ConcatSanitizer // useSalt?password+":"+salt:password
  }
}

/** A configuration tracking flow from a password to a hashing method, without being concatenated with a salt. */
class PasswordToHashConfig extends TaintTracking::Configuration {
  PasswordToHashConfig() { this = "PasswordToHashConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof PasswordVarExpr }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod().hasQualifiedName("java.security", "MessageDigest", ["update", "digest"]) and
      sink.asExpr() = ma.getArgument(0)
    )
  }

  override predicate isSanitizer(DataFlow::Node node) { node.asExpr() instanceof ConcatSanitizer }
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

/** A call to the method `MessageDigest.getInstance`. */
private class MessageDigestConstructor extends MethodAccess {
  MessageDigestConstructor() {
    this.getMethod().hasQualifiedName("java.security", "MessageDigest", "getInstance")
  }
}

/**
 * Holds if `ma` is a call to `MessageDigest.update`, either directly or through wrapper methods.
 * `arg` is the index of the parameter that is a `messageDigest` object, or -1 for the qualifier.
 * `isPassword` is true if this call could be used on a password variable.
 */
private predicate messageDigestUpdate(MethodAccess ma, int arg, boolean isPassword) {
  ma.getMethod().hasQualifiedName("java.security", "MessageDigest", "update") and
  arg = -1 and
  (if passwordFlow(ma.getArgument(0)) then isPassword = true else isPassword = false)
  or
  exists(MethodAccess ma2, int arg2 |
    ma2.getEnclosingCallable() = ma.getMethod() and
    messageDigestUpdate(ma2, arg2, isPassword) and
    DataFlow::localFlow(getParam(ma.getMethod(), arg), getArg(ma2, arg2))
  )
}

/** Gets the `arg`th argument of `ma`, where -1 is the (possibly implicit) qualifier */
private DataFlow::Node getArg(MethodAccess ma, int arg) {
  arg >= 0 and
  result.asExpr() = ma.getArgument(arg)
  or
  arg = -1 and
  result.asExpr() = ma.getQualifier()
  or
  arg = -1 and
  not ma.hasQualifier() and
  result.(DataFlow::InstanceAccessNode).getInstanceAccess().isImplicitMethodQualifier(ma)
}

/** Gets the `arg`th parameter of `m`, where -1 is the qualifier, or a field read of the qualifier. */
private DataFlow::Node getParam(Method m, int arg) {
  result.(DataFlow::ParameterNode).isParameterOf(m, arg)
  or
  arg = -1 and
  exists(FieldRead fr |
    fr.getEnclosingCallable() = m and
    (fr.hasQualifier() implies fr.getQualifier() instanceof ThisAccess) and
    result.asExpr() = fr
  )
}

/**
 * A configuration for determining that a `MessageDigest` object is used at least once with a password.
 */
private class MessageDigestUsedOnceConfig extends DataFlow2::Configuration {
  MessageDigestUsedOnceConfig() { this = "MessageDigestUsedOnceConfig" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source.asExpr() instanceof MessageDigestConstructor and
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
    exists(MethodAccess ma, int arg |
      messageDigestUpdate(ma, arg, true) and
      node1 = getArg(ma, arg) and
      node2.(DataFlow::PostUpdateNode).getPreUpdateNode() = node1 and
      state1 instanceof HashZero and
      state2 instanceof HashOne
    )
  }

  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::Content c) {
    // allow arbitrary implicit field read steps to allow wrapper methods that may go through fields to work
    this.isAdditionalFlowStep(node, _, _, _) and
    c instanceof DataFlow::FieldContent
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // allow arbitrary field reads to balance out the implicit reads added above
    exists(FieldRead fr | node1 = DataFlow::getFieldQualifier(fr) and node2.asExpr() = fr)
  }
}

/**
 * A configuration that a `MessageDigest` object is salted; i.e. it is used more than once
 * or used with a non password.
 */
private class MessageDigestSaltedConfig extends DataFlow2::Configuration {
  MessageDigestSaltedConfig() { this = "MessageDigestSaltedConfig" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source.asExpr() instanceof MessageDigestConstructor and
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
    exists(MethodAccess ma, int arg, boolean isPassword |
      messageDigestUpdate(ma, arg, isPassword) and
      node1 = getArg(ma, arg) and
      node2.(DataFlow::PostUpdateNode).getPreUpdateNode() = node1 and
      (
        if isPassword = true
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

  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::Content c) {
    // allow arbitrary implicit field read steps to allow wrapper methods that may go through fields to work
    this.isAdditionalFlowStep(node, _, _, _) and
    c instanceof DataFlow::FieldContent
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // allow flow through arbitrary field reads to balance out the implicit reads added above
    exists(FieldRead fr | node1 = DataFlow::getFieldQualifier(fr) and node2.asExpr() = fr)
  }
}

/** Holds if there is loal dataflow between `node1` and `node2` in either direction. */
private predicate localFlowBetween(DataFlow::Node node1, DataFlow::Node node2) {
  DataFlow::localFlow(node1, node2) or DataFlow::localFlow(node2, node1)
}

/** Holds if `node` is a midpoint on a flow path from a source to a sink of `conf`. */
private predicate flowPathMidPoint(DataFlow2::Configuration conf, DataFlow::Node node) {
  exists(DataFlow2::PathNode source, DataFlow2::PathNode sink, DataFlow2::PathNode mid |
    conf.hasFlowPath(source, sink) and
    source.getASuccessor*() = mid and
    mid.getASuccessor*() = sink and
    node = mid.getNode()
  )
}

/** Holds if `node` is on a path of a MessageDigest object that is used exactly once. */
private predicate messageDigestFlowPath(DataFlow::Node node) {
  flowPathMidPoint(any(MessageDigestUsedOnceConfig c), node) and
  not exists(DataFlow::Node node2 |
    flowPathMidPoint(any(MessageDigestSaltedConfig c), node2) and
    localFlowBetween(node, node2)
  )
}

/** Holds if the password variable `pw` is hashed without a salt at callsite `hash`. */
predicate passwordHashWithoutSalt(Expr pw, Expr hash) {
  exists(MethodAccess ma, DataFlow::Node mdNode, Expr md |
    md = [ma.getAnArgument(), ma.getQualifier()] and
    messageDigestFlowPath(mdNode) and
    localFlowBetween(mdNode, DataFlow::exprNode(md)) and
    pw instanceof PasswordVarExpr and
    hash = ma.getAnArgument() and
    TaintTracking::localTaint(DataFlow::exprNode(pw), DataFlow::exprNode(hash))
  )
}
