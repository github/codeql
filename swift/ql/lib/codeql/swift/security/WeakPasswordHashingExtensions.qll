/**
 * Provides classes and predicates for reasoning about use of inappropriate
 * cryptographic hashing algorithms on passwords.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.security.WeakSensitiveDataHashingExtensions

/**
 * A dataflow sink for weak password hashing vulnerabilities. That is,
 * a `DataFlow::Node` that is passed into a weak password hashing function.
 */
abstract class WeakPasswordHashingSink extends DataFlow::Node {
  /**
   * Gets the name of the hashing algorithm, for display.
   */
  abstract string getAlgorithm();
}

/**
 * A barrier for weak password hashing vulnerabilities.
 */
abstract class WeakPasswordHashingBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class WeakPasswordHashingAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to weak password hashing vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A sink inherited from weak sensitive data hashing. Password hashing has
 * stronger requirements than sensitive data hashing, since (in addition to
 * its particular qualities) a password *is* sensitive data. Thus, any sink
 * for the weak sensitive data hashing query is a sink for weak password
 * hashing as well.
 */
private class InheritedWeakPasswordHashingSink extends WeakPasswordHashingSink instanceof WeakSensitiveDataHashingSink
{
  override string getAlgorithm() { result = this.(WeakSensitiveDataHashingSink).getAlgorithm() }
}

private class WeakSensitiveDataHashingSinks extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // CryptoKit
        // (SHA-256, SHA-384 and SHA-512 are all variants of the SHA-2 algorithm)
        ";SHA256;true;hash(data:);;;Argument[0];weak-password-hash-input-SHA256",
        ";SHA256;true;update(data:);;;Argument[0];weak-password-hash-input-SHA256",
        ";SHA256;true;update(bufferPointer:);;;Argument[0];weak-password-hash-input-SHA256",
        ";SHA384;true;hash(data:);;;Argument[0];weak-password-hash-input-SHA384",
        ";SHA384;true;update(data:);;;Argument[0];weak-password-hash-input-SHA384",
        ";SHA384;true;update(bufferPointer:);;;Argument[0];weak-password-hash-input-SHA384",
        ";SHA512;true;hash(data:);;;Argument[0];weak-password-hash-input-SHA512",
        ";SHA512;true;update(data:);;;Argument[0];weak-password-hash-input-SHA512",
        ";SHA512;true;update(bufferPointer:);;;Argument[0];weak-password-hash-input-SHA512",
        // CryptoSwift
        ";SHA2;true;calculate(for:);;;Argument[0];weak-password-hash-input-SHA2",
        ";SHA2;true;callAsFunction(_:);;;Argument[0];weak-password-hash-input-SHA2",
        ";SHA2;true;process64(block:currentHash:);;;Argument[0];weak-password-hash-input-SHA2",
        ";SHA2;true;process32(block:currentHash:);;;Argument[0];weak-password-hash-input-SHA2",
        ";SHA2;true;update(withBytes:isLast:);;;Argument[0];weak-password-hash-input-SHA2",
        ";SHA3;true;calculate(for:);;;Argument[0];weak-password-hash-input-SHA2",
        ";SHA3;true;callAsFunction(_:);;;Argument[0];weak-password-hash-input-SHA2",
        ";SHA3;true;process(block:currentHash:);;;Argument[0];weak-password-hash-input-SHA2",
        ";SHA3;true;update(withBytes:isLast:);;;Argument[0];weak-password-hash-input-SHA2",
        ";Digest;true;sha2(_:variant:);;;Argument[0];weak-password-hash-input-SHA2",
        ";Digest;true;sha3(_:variant:);;;Argument[0];weak-password-hash-input-SHA3",
        ";Digest;true;sha224(_:);;;Argument[0];weak-password-hash-input-SHA224",
        ";Digest;true;sha256(_:);;;Argument[0];weak-password-hash-input-SHA256",
        ";Digest;true;sha384(_:);;;Argument[0];weak-password-hash-input-SHA384",
        ";Digest;true;sha512(_:);;;Argument[0];weak-password-hash-input-SHA512",
        ";Array;true;sha2(_:);;;Argument[-1];weak-password-hash-input-SHA2",
        ";Array;true;sha3(_:);;;Argument[-1];weak-password-hash-input-SHA3",
        ";Array;true;sha224();;;Argument[-1];weak-password-hash-input-SHA224",
        ";Array;true;sha256();;;Argument[-1];weak-password-hash-input-SHA256",
        ";Array;true;sha384();;;Argument[-1];weak-password-hash-input-SHA384",
        ";Array;true;sha512();;;Argument[-1];weak-password-hash-input-SHA512",
        ";Data;true;sha2(_:);;;Argument[-1];weak-password-hash-input-SHA2",
        ";Data;true;sha3(_:);;;Argument[-1];weak-password-hash-input-SHA3",
        ";Data;true;sha224();;;Argument[-1];weak-password-hash-input-SHA224",
        ";Data;true;sha256();;;Argument[-1];weak-password-hash-input-SHA256",
        ";Data;true;sha384();;;Argument[-1];weak-password-hash-input-SHA384",
        ";Data;true;sha512();;;Argument[-1];weak-password-hash-input-SHA512",
        ";String;true;sha2(_:);;;Argument[-1];weak-password-hash-input-SHA2",
        ";String;true;sha3(_:);;;Argument[-1];weak-password-hash-input-SHA3",
        ";String;true;sha224();;;Argument[-1];weak-password-hash-input-SHA224",
        ";String;true;sha256();;;Argument[-1];weak-password-hash-input-SHA256",
        ";String;true;sha384();;;Argument[-1];weak-password-hash-input-SHA384",
        ";String;true;sha512();;;Argument[-1];weak-password-hash-input-SHA512",
      ]
  }
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultWeakPasswordHashingSink extends WeakPasswordHashingSink {
  string algorithm;

  DefaultWeakPasswordHashingSink() { sinkNode(this, "weak-password-hash-input-" + algorithm) }

  override string getAlgorithm() { result = algorithm }
}

/**
 * A barrier for weak password hashing, when it occurs inside of
 * certain cryptographic algorithms as part of their design.
 */
class WeakPasswordHashingImplementationBarrier extends WeakPasswordHashingBarrier {
  WeakPasswordHashingImplementationBarrier() {
    this.asParameter()
        .getDeclaringFunction()
        .(Function)
        .getDeclaringDecl*()
        .(NominalTypeDecl)
        .getName() = ["HMAC", "PBKDF1", "PBKDF2"]
  }
}
