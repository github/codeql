/**
 * Provides classes and predicates for reasoning about use of constant salts
 * for password hashing.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow

/**
 * A dataflow sink for constant salt vulnerabilities. That is,
 * a `DataFlow::Node` of something that is used as a salt.
 */
abstract class ConstantSaltSink extends DataFlow::Node { }

/**
 * A barrier for constant salt vulnerabilities.
 */
abstract class ConstantSaltBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class ConstantSaltAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to constant salt vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A sink for the CryptoSwift library.
 */
private class CryptoSwiftSaltSink extends ConstantSaltSink {
  CryptoSwiftSaltSink() {
    // `salt` arg in `init` is a sink
    exists(NominalTypeDecl c, Initializer f, CallExpr call |
      c.getName() = ["HKDF", "PBKDF1", "PBKDF2", "Scrypt"] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel("salt").getExpr() = this.asExpr()
    )
  }
}

/**
 * A sink for the RNCryptor library.
 */
private class RnCryptorSaltSink extends ConstantSaltSink {
  RnCryptorSaltSink() {
    exists(NominalTypeDecl c, Method f, CallExpr call |
      c.getFullName() =
        [
          "RNCryptor", "RNEncryptor", "RNDecryptor", "RNCryptor.EncryptorV3",
          "RNCryptor.DecryptorV3"
        ] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel(["salt", "encryptionSalt", "hmacSalt", "HMACSalt"]).getExpr() =
        this.asExpr()
    )
  }
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultSaltSink extends ConstantSaltSink {
  DefaultSaltSink() { sinkNode(this, "encryption-salt") }
}

/**
 * A barrier for appending, since appending strings to a constant string
 * may (and often does) result in a non-constant string.
 *
 * Ideally, these would not be a barrier when there is flow to *all*
 * inputs.
 */
private class AppendConstantSaltBarrier extends ConstantSaltBarrier {
  AppendConstantSaltBarrier() {
    this.asExpr() = any(AddExpr ae).getAnOperand()
    or
    this.asExpr() = any(AssignAddExpr aae).getAnOperand()
    or
    exists(CallExpr ce |
      ce.getStaticTarget().getName() =
        ["append(_:)", "appending(_:)", "appendLiteral(_:)", "appendInterpolation(_:)"] and
      (
        this.asExpr() = ce.getAnArgument().getExpr() or
        this.asExpr() = ce.getQualifier()
      )
    )
  }
}
