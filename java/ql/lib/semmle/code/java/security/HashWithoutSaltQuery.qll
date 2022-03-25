/** Definitions and configurations for the hash without salt query */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.DataFlow2
import semmle.code.java.StringFormat

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

/** An expression that may form part of a concatenation operation. */
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
    exists(MethodAccess ma |
      ma.getMethod().hasQualifiedName("java.io", "ByteArrayOutputStream", "write") and
      this = ma.getArgument(0)
    )
    or
    exists(FormattingCall fc | this = fc.getAnArgument())
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

/** Holds if a password variable flows to the argument `e` of a hashing method without being concatenated with a salt. */
private predicate hashesUnsaltedPassword(Expr e) { any(PasswordToHashConfig c).hasFlowToExpr(e) }

/** A flow state representing a `MessageDigest` object that has been used zero times. */
private class MessageDigestEmpty extends DataFlow::FlowState {
  MessageDigestEmpty() { this = "MessageDigestEmpty" }
}

/** A flow state representing a `MessageDigest` object that has been used once with an unsalted password. */
private class MessageDigestUnsalted extends DataFlow::FlowState {
  MessageDigestUnsalted() { this = "MessageDigestUnsalted" }
}

/**
 * A flow state representing a `MessageDigest` object that is salted,
 * i.e. it has been used more than once, or with a value that is definitely not a password.
 */
private class MessageDigestSallted extends DataFlow::FlowState {
  MessageDigestSallted() { this = "MessageDigestSallted" }
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
  (if hashesUnsaltedPassword(ma.getArgument(0)) then isPassword = true else isPassword = false)
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
  result = DataFlow::getInstanceArgument(ma)
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
 * Holds if there is a state-changing flow step between `node1` and `node2` from a call to `MessageDigest.update`.
 * `isPassword` is true if the newly-added data is likely a password.
 */
private predicate messageDigestFlowStep(
  DataFlow::Node node1, DataFlow::Node node2, boolean isPassword
) {
  exists(MethodAccess ma, int arg |
    messageDigestUpdate(ma, arg, isPassword) and
    node1 = getArg(ma, arg) and
    node2.(DataFlow::PostUpdateNode).getPreUpdateNode() = node1
  )
}

/**
 * Holds if `node` is the qualifier of a call to `MessageDigest.digest`.
 * `hasArg` is true if this call has an argument, and `isPassword` is true if this call could add a password to the digest.
 */
private predicate messageDigestSink(DataFlow::Node node, boolean hasArg, boolean isPassword) {
  exists(MethodAccess ma |
    ma.getMethod().hasQualifiedName("java.security", "MessageDigest", "digest") and
    node.asExpr() = ma.getQualifier() and
    (if ma.getNumArgument() != 0 then hasArg = true else hasArg = false) and
    (if hashesUnsaltedPassword(ma.getArgument(0)) then isPassword = true else isPassword = false)
  )
}

/**
 * A configuration for determining that a `MessageDigest` object is used at least once with a password.
 */
private class MessageDigestUsedOnceConfig extends DataFlow2::Configuration {
  MessageDigestUsedOnceConfig() { this = "MessageDigestUsedOnceConfig" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source.asExpr() instanceof MessageDigestConstructor and
    state instanceof MessageDigestEmpty
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    messageDigestSink(sink, false, _) and
    state instanceof MessageDigestUnsalted
    or
    messageDigestSink(sink, true, true) and
    state instanceof MessageDigestEmpty
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    messageDigestFlowStep(node1, node2, true) and
    state1 instanceof MessageDigestEmpty and
    state2 instanceof MessageDigestUnsalted
  }

  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::Content c) {
    // Allow arbitrary implicit field read steps to allow wrapper methods that may go through fields to work.
    // For example, in a case like:
    // ```
    // class Sha256 {
    //   MessageDigest md;
    //   Sha256() { md = MessageDigest.getInstance("SHA256"); }
    //   void update(byte[] bs) { md.update(bs); }
    //   byte[] digest() { return md.digest(); }
    // }
    //
    // byte[] getHash(String password) {
    //   Sha256 sha256 = new Sha256();
    //   sha256.update(password.getBytes());
    //   return sha256.digest();
    // }
    // ```
    // then the method `Sha256.update` is considered a wrapper method around `MessageDigest.update`;
    // but as it acts on a field of its class then the access path of the `sha256` node includes that field.
    // Since flow state changing steps don't work through access paths, we strip the access path by adding implicit reads.
    this.isAdditionalFlowStep(node, _, _, _) and
    c instanceof DataFlow::FieldContent
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // Allow arbitrary field reads to balance out the implicit reads added above.
    // For example, in the example above, after the call to `update`, there is flow to the `sha256` node
    // at state `MessageDigestUnsalted` with an empty accss path; which we would like to be able to follow through to the field `sha256.md`.
    exists(FieldRead fr | node1 = DataFlow::getFieldQualifier(fr) and node2.asExpr() = fr)
  }
}

/**
 * A configuration that identifies flow in which a `MessageDigest` object is salted; i.e. it is used more than once
 * or used with a non-password input.
 */
private class MessageDigestSaltedConfig extends DataFlow2::Configuration {
  MessageDigestSaltedConfig() { this = "MessageDigestSaltedConfig" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source.asExpr() instanceof MessageDigestConstructor and
    state instanceof MessageDigestEmpty
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    messageDigestSink(sink, _, _) and
    state instanceof MessageDigestSallted
    or
    messageDigestSink(sink, true, true) and
    state instanceof MessageDigestUnsalted
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    messageDigestFlowStep(node1, node2, true) and
    state1 instanceof MessageDigestEmpty and
    state2 instanceof MessageDigestUnsalted
    or
    messageDigestFlowStep(node1, node2, true) and
    state1 instanceof MessageDigestUnsalted and
    state2 instanceof MessageDigestSallted
    or
    messageDigestFlowStep(node1, node2, false) and
    (state1 instanceof MessageDigestEmpty or state1 instanceof MessageDigestUnsalted) and
    state2 instanceof MessageDigestSallted
  }

  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::Content c) {
    // Allow arbitrary implicit field read steps to allow wrapper methods that may go through fields to work.
    // See the comment in `MessageDigestUsedOnceConfig.allowImplicitRead` for an example of why this is necassary.
    this.isAdditionalFlowStep(node, _, _, _) and
    c instanceof DataFlow::FieldContent
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // Allow flow through arbitrary field reads to balance out the implicit reads added above
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
    conf.hasFlowPath(pragma[only_bind_into](source), pragma[only_bind_into](sink)) and
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
predicate passwordHashWithoutSalt(Variable pw, Expr hash) {
  exists(MethodAccess ma, DataFlow::Node mdNode, PasswordVarExpr pwve |
    messageDigestFlowPath(mdNode) and
    localFlowBetween(mdNode, getArg(ma, _)) and
    pwve = pw.getAnAccess() and
    hash = ma.getAnArgument() and
    TaintTracking::localTaint(DataFlow::exprNode(pwve), DataFlow::exprNode(hash))
  )
}
