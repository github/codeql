/**
 * @name Using a non-constant-time algorithm for comparing results of a cryptographic operation
 * @description When comparing results of a cryptographic operation, a constant-time algorithm should be used.
 *              Otherwise, attackers may be able to implement a timing attack if they can control input.
 *              A successful attack may result in leaking secrets or authentication bypass.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id java/non-constant-time-crypto-comparison
 * @tags security
 *       external/cwe/cwe-208
 */

import java
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.TaintTracking2
import semmle.code.java.dataflow.DataFlow3
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

/** A method call that produces cryptographic result. */
abstract private class ProduceCryptoCall extends MethodAccess {
  Expr output;

  /** Return the result of cryptographic operation. */
  Expr output() { result = output }
}

/** A method call that produces a MAC. */
private class ProduceMacCall extends ProduceCryptoCall {
  ProduceMacCall() {
    getMethod().getDeclaringType().hasQualifiedName("javax.crypto", "Mac") and
    (
      getMethod().hasStringSignature(["doFinal()", "doFinal(byte[])"]) and this = output
      or
      getMethod().hasStringSignature("doFinal(byte[], int)") and getArgument(0) = output
    )
  }
}

/** A method call that produces a signature. */
private class ProduceSignatureCall extends ProduceCryptoCall {
  ProduceSignatureCall() {
    getMethod().getDeclaringType().hasQualifiedName("java.security", "Signature") and
    (
      getMethod().hasStringSignature("sign()") and this = output
      or
      getMethod().hasStringSignature("sign(byte[], int, int)") and getArgument(0) = output
    )
  }
}

/**
 * A config that tracks data flow from initializing a cipher for encryption
 * to producing a ciphertext using this cipher.
 */
private class InitializeEncryptorConfig extends DataFlow3::Configuration {
  InitializeEncryptorConfig() { this = "InitializeEncryptorConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(MethodAccess ma |
      ma.getMethod().hasQualifiedName("javax.crypto", "Cipher", "init") and
      ma.getArgument(0).(VarAccess).getVariable().hasName("ENCRYPT_MODE") and
      ma.getQualifier() = source.asExpr()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod().hasQualifiedName("javax.crypto", "Cipher", "doFinal") and
      ma.getQualifier() = sink.asExpr()
    )
  }
}

/** A method call that produces a ciphertext. */
private class ProduceCiphertextCall extends ProduceCryptoCall {
  ProduceCiphertextCall() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType().hasQualifiedName("javax.crypto", "Cipher") and
      (
        m.hasStringSignature(["doFinal()", "doFinal(byte[])", "doFinal(byte[], int, int)"]) and
        this = output
        or
        m.hasStringSignature("doFinal(byte[], int)") and getArgument(0) = output
        or
        m.hasStringSignature([
            "doFinal(byte[], int, int, byte[])", "doFinal(byte[], int, int, byte[], int)"
          ]) and
        getArgument(3) = output
        or
        m.hasStringSignature("doFinal(ByteBuffer, ByteBuffer)") and
        getArgument(1) = output
      )
    ) and
    exists(InitializeEncryptorConfig config |
      config.hasFlowTo(DataFlow3::exprNode(this.getQualifier()))
    )
  }
}

/** Holds if `fromNode` to `toNode` is a dataflow step that updates a cryptographic operation. */
private predicate updateCryptoOperationStep(DataFlow2::Node fromNode, DataFlow2::Node toNode) {
  exists(MethodAccess call, Method m |
    m = call.getMethod() and
    call.getQualifier() = toNode.asExpr() and
    call.getArgument(0) = fromNode.asExpr()
  |
    m.hasQualifiedName("java.security", "Signature", "update")
    or
    m.hasQualifiedName("javax.crypto", ["Mac", "Cipher"], "update")
    or
    m.hasQualifiedName("javax.crypto", ["Mac", "Cipher"], "doFinal") and
    not m.hasStringSignature("doFinal(byte[], int)")
  )
}

/** Holds if `fromNode` to `toNode` is a dataflow step that creates a hash. */
private predicate createMessageDigestStep(DataFlow2::Node fromNode, DataFlow2::Node toNode) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    m.getDeclaringType().hasQualifiedName("java.security", "MessageDigest") and
    m.hasStringSignature("digest()") and
    ma.getQualifier() = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
  or
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    m.getDeclaringType().hasQualifiedName("java.security", "MessageDigest") and
    m.hasStringSignature("digest(byte[], int, int)") and
    ma.getQualifier() = fromNode.asExpr() and
    ma.getArgument(0) = toNode.asExpr()
  )
  or
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    m.getDeclaringType().hasQualifiedName("java.security", "MessageDigest") and
    m.hasStringSignature("digest(byte[])") and
    ma.getArgument(0) = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
}

/** Holds if `fromNode` to `toNode` is a dataflow step that updates a hash. */
private predicate updateMessageDigestStep(DataFlow2::Node fromNode, DataFlow2::Node toNode) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    m.hasQualifiedName("java.security", "MessageDigest", "update") and
    ma.getArgument(0) = fromNode.asExpr() and
    ma.getQualifier() = toNode.asExpr()
  )
}

/**
 * A config that tracks data flow from remote user input to a cryptographic operation
 * such as cipher, MAC or signature.
 */
private class UserInputInCryptoOperationConfig extends TaintTracking2::Configuration {
  UserInputInCryptoOperationConfig() { this = "UserInputInCryptoOperationConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(ProduceCryptoCall call | call.getQualifier() = sink.asExpr())
  }

  override predicate isAdditionalTaintStep(DataFlow2::Node fromNode, DataFlow2::Node toNode) {
    updateCryptoOperationStep(fromNode, toNode)
    or
    createMessageDigestStep(fromNode, toNode)
    or
    updateMessageDigestStep(fromNode, toNode)
  }
}

/** A source that produces result of cryptographic operation. */
private class CryptoOperationSource extends DataFlow::Node {
  Expr cryptoOperation;

  CryptoOperationSource() {
    exists(ProduceCryptoCall call | call.output() = this.asExpr() |
      cryptoOperation = call.getQualifier()
    )
  }

  /** Holds if remote user input was used in the cryptographic operation. */
  predicate includesUserInput() {
    exists(
      DataFlow2::PathNode source, DataFlow2::PathNode sink, UserInputInCryptoOperationConfig config
    |
      config.hasFlowPath(source, sink)
    |
      sink.getNode().asExpr() = cryptoOperation
    )
  }
}

/** Methods that use a non-constant-time algorithm for comparing inputs. */
private class NonConstantTimeEqualsCall extends MethodAccess {
  NonConstantTimeEqualsCall() {
    getMethod()
        .hasQualifiedName("java.lang", "String", ["equals", "contentEquals", "equalsIgnoreCase"]) or
    getMethod().hasQualifiedName("java.nio", "ByteBuffer", ["equals", "compareTo"])
  }
}

/** Static methods that use a non-constant-time algorithm for comparing inputs. */
private class NonConstantTimeComparisonCall extends StaticMethodAccess {
  NonConstantTimeComparisonCall() {
    getMethod().hasQualifiedName("java.util", "Arrays", ["equals", "deepEquals"]) or
    getMethod().hasQualifiedName("java.util", "Objects", "deepEquals") or
    getMethod()
        .hasQualifiedName("org.apache.commons.lang3", "StringUtils",
          ["equals", "equalsAny", "equalsAnyIgnoreCase", "equalsIgnoreCase"])
  }
}

/**
 * A config that tracks data flow from remote user input to methods
 * that compare inputs using a non-constant-time algorithm.
 */
private class UserInputInComparisonConfig extends TaintTracking2::Configuration {
  UserInputInComparisonConfig() { this = "UserInputInComparisonConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(NonConstantTimeEqualsCall call |
      sink.asExpr() = [call.getAnArgument(), call.getQualifier()]
    )
    or
    exists(NonConstantTimeComparisonCall call | sink.asExpr() = call.getAnArgument())
  }
}

/** Holds if `expr` looks like a constant. */
private predicate looksLikeConstant(Expr expr) {
  expr.isCompileTimeConstant()
  or
  expr.(VarAccess).getVariable().isFinal() and expr.getType() instanceof TypeString
}

/**
 * Holds if `firstObject` and `secondObject` are compared using a method
 * that does not use a constant-time algorithm, for example, `String.equals()`.
 */
private predicate isNonConstantEqualsCall(Expr firstObject, Expr secondObject) {
  exists(NonConstantTimeEqualsCall call |
    firstObject = call.getQualifier() and
    secondObject = call.getAnArgument()
    or
    firstObject = call.getAnArgument() and
    secondObject = call.getQualifier()
  )
}

/**
 * Holds if `firstInput` and `secondInput` are compared using a static method
 * that does not use a constant-time algorithm, for example, `Arrays.equals()`.
 */
private predicate isNonConstantTimeComparisonCall(Expr firstInput, Expr secondInput) {
  exists(NonConstantTimeComparisonCall call |
    firstInput = call.getArgument(0) and secondInput = call.getArgument(1)
    or
    firstInput = call.getArgument(1) and secondInput = call.getArgument(0)
  )
}

/**
 * Holds if there is a fast-fail check while comparing `firstArray` and `secondArray`.
 */
private predicate existsFailFastCheck(Expr firstArray, Expr secondArray) {
  exists(
    Guard guard, EqualityTest eqTest, boolean branch, Stmt fastFailingStmt,
    ArrayAccess firstArrayAccess, ArrayAccess secondArrayAccess
  |
    guard = eqTest and
    // For `==` false branch is fail fast; for `!=` true branch is fail fast
    branch = eqTest.polarity().booleanNot() and
    (
      fastFailingStmt instanceof ReturnStmt or
      fastFailingStmt instanceof BreakStmt or
      fastFailingStmt instanceof ThrowStmt
    ) and
    guard.controls(fastFailingStmt.getBasicBlock(), branch) and
    DataFlow::localExprFlow(firstArrayAccess, eqTest.getLeftOperand()) and
    DataFlow::localExprFlow(secondArrayAccess, eqTest.getRightOperand())
  |
    firstArrayAccess.getArray() = firstArray and secondArray = secondArrayAccess
    or
    secondArrayAccess.getArray() = firstArray and secondArray = firstArrayAccess
  )
}

/** A sink that compares input using a non-constant-time algorithm. */
private class NonConstantTimeComparisonSink extends DataFlow::Node {
  Expr anotherParameter;

  NonConstantTimeComparisonSink() {
    (
      isNonConstantEqualsCall(this.asExpr(), anotherParameter)
      or
      isNonConstantTimeComparisonCall(this.asExpr(), anotherParameter)
      or
      existsFailFastCheck(this.asExpr(), anotherParameter)
    ) and
    not looksLikeConstant(anotherParameter)
  }

  /** Holds if remote user input was used in the comparison. */
  predicate includesUserInput() {
    exists(UserInputInComparisonConfig config |
      config.hasFlowTo(DataFlow2::exprNode(anotherParameter))
    )
  }
}

/**
 * A configuration that tracks data flow from cryptographic operations
 * to methods that compare data using a non-constant-time algorithm.
 */
private class NonConstantTimeCryptoComparisonConfig extends TaintTracking::Configuration {
  NonConstantTimeCryptoComparisonConfig() { this = "NonConstantTimeCryptoComparisonConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof CryptoOperationSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof NonConstantTimeComparisonSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, NonConstantTimeCryptoComparisonConfig conf
where
  conf.hasFlowPath(source, sink) and
  (
    source.getNode().(CryptoOperationSource).includesUserInput() or
    sink.getNode().(NonConstantTimeComparisonSink).includesUserInput()
  )
select sink.getNode(), source, sink,
  "Using a non-constant-time algorithm for comparing results of a cryptographic operation."
