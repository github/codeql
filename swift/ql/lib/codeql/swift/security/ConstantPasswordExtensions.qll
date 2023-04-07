/**
 * Provides classes and predicates for reasoning about constant password
 * vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow

/**
 * A dataflow sink for constant password vulnerabilities. That is,
 * a `DataFlow::Node` of something that is used as a password.
 */
abstract class ConstantPasswordSink extends DataFlow::Node { }

/**
 * A sanitizer for constant password vulnerabilities.
 */
abstract class ConstantPasswordSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 */
class ConstantPasswordAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for paths related to constant password vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A password sink for the CryptoSwift library.
 */
private class DefaultConstantPasswordSink extends ConstantPasswordSink {
  DefaultConstantPasswordSink() {
    // `password` arg in `init` is a sink
    exists(ClassOrStructDecl c, ConstructorDecl f, CallExpr call |
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
    exists(ClassOrStructDecl c, MethodDecl f, CallExpr call |
      c.getName() = ["RNCryptor", "RNEncryptor", "RNDecryptor"] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel(["password", "withPassword", "forPassword"]).getExpr() =
        this.asExpr()
    )
    or
    // RNCryptor (unlabelled arguments)
    exists(MethodDecl f, CallExpr call |
      f.hasQualifiedName("RNCryptor", "keyForPassword(_:salt:settings:)") and
      call.getStaticTarget() = f and
      call.getArgument(0).getExpr() = this.asExpr()
    )
  }
}
