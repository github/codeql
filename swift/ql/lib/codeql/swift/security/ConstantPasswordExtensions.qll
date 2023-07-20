/**
 * Provides classes and predicates for reasoning about constant password
 * vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow

/**
 * A dataflow sink for constant password vulnerabilities. That is,
 * a `DataFlow::Node` of something that is used as a password.
 */
abstract class ConstantPasswordSink extends DataFlow::Node { }

/**
 * A barrier for constant password vulnerabilities.
 */
abstract class ConstantPasswordBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class ConstantPasswordAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to constant password vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A password sink for the CryptoSwift library.
 */
private class CryptoSwiftPasswordSink extends ConstantPasswordSink {
  CryptoSwiftPasswordSink() {
    // `password` arg in `init` is a sink
    exists(NominalTypeDecl c, Initializer f, CallExpr call |
      c.getName() = ["HKDF", "PBKDF1", "PBKDF2", "Scrypt"] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel("password").getExpr() = this.asExpr()
    )
  }
}

/**
 * A password sink for the RNCryptor library.
 */
private class RnCryptorPasswordSink extends ConstantPasswordSink {
  RnCryptorPasswordSink() {
    // RNCryptor (labelled arguments)
    exists(NominalTypeDecl c, Method f, CallExpr call |
      c.getFullName() =
        [
          "RNCryptor", "RNEncryptor", "RNDecryptor", "RNCryptor.EncryptorV3",
          "RNCryptor.DecryptorV3"
        ] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel(["password", "withPassword", "forPassword"]).getExpr() =
        this.asExpr()
    )
    or
    // RNCryptor (unlabelled arguments)
    exists(Method f, CallExpr call |
      f.hasQualifiedName("RNCryptor", "keyForPassword(_:salt:settings:)") and
      call.getStaticTarget() = f and
      call.getArgument(0).getExpr() = this.asExpr()
    )
  }
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultPasswordSink extends ConstantPasswordSink {
  DefaultPasswordSink() { sinkNode(this, "encryption-password") }
}
