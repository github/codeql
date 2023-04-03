/**
 * Provides a taint tracking configuration to find use of constant salts
 * for password hashing.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSteps
import codeql.swift.security.ConstantSaltExtensions

/**
 * A constant salt is created through either a byte array or string literals.
 */
class ConstantSaltSource extends Expr {
  ConstantSaltSource() {
    this = any(ArrayExpr arr | arr.getType().getName() = "Array<UInt8>") or
    this instanceof StringLiteralExpr or
    this instanceof NumberLiteralExpr
  }
}

/**
 * A class for all ways to use a constant salt.
 */
class ConstantSaltSink extends Expr {
  ConstantSaltSink() {
    // `salt` arg in `init` is a sink
    exists(ClassOrStructDecl c, ConstructorDecl f, CallExpr call |
      c.getName() = ["HKDF", "PBKDF1", "PBKDF2", "Scrypt"] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel("salt").getExpr() = this
    )
    or
    // RNCryptor
    exists(ClassOrStructDecl c, MethodDecl f, CallExpr call |
      c.getName() = ["RNCryptor", "RNEncryptor", "RNDecryptor"] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel(["salt", "encryptionSalt", "hmacSalt", "HMACSalt"]).getExpr() = this
    )
  }
}

/**
 * A taint configuration from the source of constants salts to expressions that use
 * them to initialize password-based encryption keys.
 */
module ConstantSaltConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof ConstantSaltSource }

  predicate isSink(DataFlow::Node node) { node.asExpr() instanceof ConstantSaltSink }
}

module ConstantSaltFlow = TaintTracking::Global<ConstantSaltConfig>;
