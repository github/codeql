/**
 * @name Cryptographic Operations
 * @description List all cryptographic operations found in the database.
 * @kind problem
 * @problem.severity info
 * @id rust/summary/cryptographic-operations
 * @tags summary
 */

import rust
import codeql.rust.Concepts
import codeql.rust.security.WeakSensitiveDataHashingExtensions

/**
 * Gets the type of cryptographic algorithm `alg`.
 */
string getAlgorithmType(Cryptography::CryptographicAlgorithm alg) {
  alg instanceof Cryptography::EncryptionAlgorithm and result = "EncryptionAlgorithm"
  or
  alg instanceof Cryptography::HashingAlgorithm and result = "HashingAlgorithm"
  or
  alg instanceof Cryptography::PasswordHashingAlgorithm and result = "PasswordHashingAlgorithm"
}

/**
 * Gets a feature of cryptographic algorithm `alg`.
 */
string getAlgorithmFeature(Cryptography::CryptographicAlgorithm alg) {
  alg.isWeak() and result = "WEAK"
}

/**
 * Gets a description of cryptographic algorithm `alg`.
 */
string describeAlgorithm(Cryptography::CryptographicAlgorithm alg) {
  result =
    getAlgorithmType(alg) + " " + alg.getName() + " " + concat(getAlgorithmFeature(alg), ", ")
}

/**
 * Gets a feature of cryptographic operation `op`.
 */
string getOperationFeature(Cryptography::CryptographicOperation op) {
  result = "inputs:" + strictcount(op.getAnInput()).toString() or
  result = "blockmodes:" + strictcount(op.getBlockMode()).toString()
}

/**
 * Gets a description of cryptographic operation `op`.
 */
string describeOperation(Cryptography::CryptographicOperation op) {
  result = describeAlgorithm(op.getAlgorithm()) + " " + concat(getOperationFeature(op), ", ")
  or
  not exists(op.getAlgorithm()) and
  result = "(unknown) " + concat(getOperationFeature(op), ", ")
}

from Cryptography::CryptographicOperation operation
select operation, describeOperation(operation)
