/**
 * Provides classes and predicates for queries that detect timing attacks.
 */
deprecated module;

import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources

/** A method call that produces cryptographic result. */
abstract private class ProduceCryptoCall extends MethodCall {
  Expr output;

  /** Gets the result of cryptographic operation. */
  Expr output() { result = output }

  /** Gets a type of cryptographic operation such as MAC, signature or ciphertext. */
  abstract string getResultType();
}

/** A method call that produces a MAC. */
private class ProduceMacCall extends ProduceCryptoCall {
  ProduceMacCall() {
    this.getMethod().getDeclaringType().hasQualifiedName("javax.crypto", "Mac") and
    (
      this.getMethod().hasStringSignature(["doFinal()", "doFinal(byte[])"]) and this = output
      or
      this.getMethod().hasStringSignature("doFinal(byte[], int)") and this.getArgument(0) = output
    )
  }

  override string getResultType() { result = "MAC" }
}

/** A method call that produces a signature. */
private class ProduceSignatureCall extends ProduceCryptoCall {
  ProduceSignatureCall() {
    this.getMethod().getDeclaringType().hasQualifiedName("java.security", "Signature") and
    (
      this.getMethod().hasStringSignature("sign()") and this = output
      or
      this.getMethod().hasStringSignature("sign(byte[], int, int)") and this.getArgument(0) = output
    )
  }

  override string getResultType() { result = "signature" }
}

/**
 * A config that tracks data flow from initializing a cipher for encryption
 * to producing a ciphertext using this cipher.
 */
private module InitializeEncryptorConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(MethodCall ma |
      ma.getMethod().hasQualifiedName("javax.crypto", "Cipher", "init") and
      ma.getArgument(0).(VarAccess).getVariable().hasName("ENCRYPT_MODE") and
      ma.getQualifier() = source.asExpr()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall ma |
      ma.getMethod().hasQualifiedName("javax.crypto", "Cipher", "doFinal") and
      ma.getQualifier() = sink.asExpr()
    )
  }
}

private module InitializeEncryptorFlow = DataFlow::Global<InitializeEncryptorConfig>;

/** A method call that produces a ciphertext. */
private class ProduceCiphertextCall extends ProduceCryptoCall {
  ProduceCiphertextCall() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType().hasQualifiedName("javax.crypto", "Cipher") and
      (
        m.hasStringSignature(["doFinal()", "doFinal(byte[])", "doFinal(byte[], int, int)"]) and
        this = output
        or
        m.hasStringSignature("doFinal(byte[], int)") and this.getArgument(0) = output
        or
        m.hasStringSignature([
            "doFinal(byte[], int, int, byte[])", "doFinal(byte[], int, int, byte[], int)"
          ]) and
        this.getArgument(3) = output
        or
        m.hasStringSignature("doFinal(ByteBuffer, ByteBuffer)") and
        this.getArgument(1) = output
      )
    ) and
    InitializeEncryptorFlow::flowToExpr(this.getQualifier())
  }

  override string getResultType() { result = "ciphertext" }
}

/** Holds if `fromNode` to `toNode` is a dataflow step that updates a cryptographic operation. */
private predicate updateCryptoOperationStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(MethodCall call, Method m |
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
private predicate createMessageDigestStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(MethodCall ma, Method m | m = ma.getMethod() |
    m.getDeclaringType().hasQualifiedName("java.security", "MessageDigest") and
    m.hasStringSignature("digest()") and
    ma.getQualifier() = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
  or
  exists(MethodCall ma, Method m | m = ma.getMethod() |
    m.getDeclaringType().hasQualifiedName("java.security", "MessageDigest") and
    m.hasStringSignature("digest(byte[], int, int)") and
    ma.getQualifier() = fromNode.asExpr() and
    ma.getArgument(0) = toNode.asExpr()
  )
  or
  exists(MethodCall ma, Method m | m = ma.getMethod() |
    m.getDeclaringType().hasQualifiedName("java.security", "MessageDigest") and
    m.hasStringSignature("digest(byte[])") and
    ma.getArgument(0) = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
}

/** Holds if `fromNode` to `toNode` is a dataflow step that updates a hash. */
private predicate updateMessageDigestStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(MethodCall ma, Method m | m = ma.getMethod() |
    m.hasQualifiedName("java.security", "MessageDigest", "update") and
    ma.getArgument(0) = fromNode.asExpr() and
    ma.getQualifier() = toNode.asExpr()
  )
}

/**
 * A config that tracks data flow from remote user input to a cryptographic operation
 * such as cipher, MAC or signature.
 */
private module UserInputInCryptoOperationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) {
    exists(ProduceCryptoCall call | call.getQualifier() = sink.asExpr())
  }

  predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    updateCryptoOperationStep(fromNode, toNode)
    or
    createMessageDigestStep(fromNode, toNode)
    or
    updateMessageDigestStep(fromNode, toNode)
  }
}

/**
 * Taint-tracking flow from remote user input to a cryptographic operation
 * such as cipher, MAC or signature.
 */
private module UserInputInCryptoOperationFlow =
  TaintTracking::Global<UserInputInCryptoOperationConfig>;

/** A source that produces result of cryptographic operation. */
class CryptoOperationSource extends DataFlow::Node {
  ProduceCryptoCall call;

  CryptoOperationSource() { call.output() = this.asExpr() }

  /** Holds if remote user input was used in the cryptographic operation. */
  predicate includesUserInput() {
    exists(UserInputInCryptoOperationFlow::PathNode sink |
      UserInputInCryptoOperationFlow::flowPath(_, sink)
    |
      sink.getNode().asExpr() = call.getQualifier()
    )
  }

  /** Gets a method call that produces cryptographic result. */
  ProduceCryptoCall getCall() { result = call }
}

/** Methods that use a non-constant-time algorithm for comparing inputs. */
private class NonConstantTimeEqualsCall extends MethodCall {
  NonConstantTimeEqualsCall() {
    this.getMethod()
        .hasQualifiedName("java.lang", "String", ["equals", "contentEquals", "equalsIgnoreCase"]) or
    this.getMethod().hasQualifiedName("java.nio", "ByteBuffer", ["equals", "compareTo"])
  }
}

/** A static method that uses a non-constant-time algorithm for comparing inputs. */
private class NonConstantTimeComparisonCall extends StaticMethodCall {
  NonConstantTimeComparisonCall() {
    this.getMethod().hasQualifiedName("java.util", "Arrays", ["equals", "deepEquals"]) or
    this.getMethod().hasQualifiedName("java.util", "Objects", "deepEquals") or
    this.getMethod()
        .hasQualifiedName("org.apache.commons.lang3", "StringUtils",
          ["equals", "equalsAny", "equalsAnyIgnoreCase", "equalsIgnoreCase"])
  }
}

/**
 * A config that tracks data flow from remote user input to methods
 * that compare inputs using a non-constant-time algorithm.
 */
private module UserInputInComparisonConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) {
    exists(NonConstantTimeEqualsCall call |
      sink.asExpr() = [call.getAnArgument(), call.getQualifier()]
    )
    or
    exists(NonConstantTimeComparisonCall call | sink.asExpr() = call.getAnArgument())
  }
}

private module UserInputInComparisonFlow = TaintTracking::Global<UserInputInComparisonConfig>;

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
private predicate isNonConstantTimeEqualsCall(Expr firstObject, Expr secondObject) {
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
class NonConstantTimeComparisonSink extends DataFlow::Node {
  Expr anotherParameter;

  NonConstantTimeComparisonSink() {
    (
      isNonConstantTimeEqualsCall(this.asExpr(), anotherParameter)
      or
      isNonConstantTimeComparisonCall(this.asExpr(), anotherParameter)
      or
      existsFailFastCheck(this.asExpr(), anotherParameter)
    ) and
    not looksLikeConstant(anotherParameter)
  }

  /** Holds if remote user input was used in the comparison. */
  predicate includesUserInput() { UserInputInComparisonFlow::flowToExpr(anotherParameter) }
}

/**
 * A configuration that tracks data flow from cryptographic operations
 * to methods that compare data using a non-constant-time algorithm.
 */
module NonConstantTimeCryptoComparisonConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof CryptoOperationSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof NonConstantTimeComparisonSink }
}

module NonConstantTimeCryptoComparisonFlow =
  TaintTracking::Global<NonConstantTimeCryptoComparisonConfig>;
