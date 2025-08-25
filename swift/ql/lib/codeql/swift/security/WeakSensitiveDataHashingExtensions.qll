/**
 * Provides classes and predicates for reasoning about use of broken or weak
 * cryptographic hashing algorithms on sensitive data.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow

/**
 * A dataflow sink for weak sensitive data hashing vulnerabilities. That is,
 * a `DataFlow::Node` that is passed into a weak hashing function.
 */
abstract class WeakSensitiveDataHashingSink extends DataFlow::Node {
  /**
   * Gets the name of the hashing algorithm, for display.
   */
  abstract string getAlgorithm();
}

/**
 * A barrier for weak sensitive data hashing vulnerabilities.
 */
abstract class WeakSensitiveDataHashingBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class WeakSensitiveDataHashingAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to weak sensitive data hashing vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

private class WeakSensitiveDataHashingSinks extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // CryptoKit
        ";Insecure.MD5;true;hash(data:);;;Argument[0];weak-hash-input-MD5",
        ";Insecure.MD5;true;update(data:);;;Argument[0];weak-hash-input-MD5",
        ";Insecure.MD5;true;update(bufferPointer:);;;Argument[0];weak-hash-input-MD5",
        ";Insecure.SHA1;true;hash(data:);;;Argument[0];weak-hash-input-SHA1",
        ";Insecure.SHA1;true;update(data:);;;Argument[0];weak-hash-input-SHA1",
        ";Insecure.SHA1;true;update(bufferPointer:);;;Argument[0];weak-hash-input-SHA1",
        // CryptoSwift
        ";MD5;true;calculate(for:);;;Argument[0];weak-hash-input-MD5",
        ";MD5;true;callAsFunction(_:);;;Argument[0];weak-hash-input-MD5",
        ";MD5;true;process(block:currentHash:);;;Argument[0];weak-hash-input-MD5",
        ";MD5;true;update(withBytes:isLast:);;;Argument[0];weak-hash-input-MD5",
        ";SHA1;true;calculate(for:);;;Argument[0];weak-hash-input-SHA1",
        ";SHA1;true;callAsFunction(_:);;;Argument[0];weak-hash-input-SHA1",
        ";SHA1;true;process(block:currentHash:);;;Argument[0];weak-hash-input-SHA1",
        ";SHA1;true;update(withBytes:isLast:);;;Argument[0];weak-hash-input-SHA1",
        ";Digest;true;md5(_:);;;Argument[0];weak-hash-input-MD5",
        ";Digest;true;sha1(_:);;;Argument[0];weak-hash-input-SHA1",
        ";Array;true;md5();;;Argument[-1];weak-hash-input-MD5",
        ";Array;true;sha1();;;Argument[-1];weak-hash-input-SHA1",
        ";Data;true;md5();;;Argument[-1];weak-hash-input-MD5",
        ";Data;true;sha1();;;Argument[-1];weak-hash-input-SHA1",
        ";String;true;md5();;;Argument[-1];weak-hash-input-MD5",
        ";String;true;sha1();;;Argument[-1];weak-hash-input-SHA1",
      ]
  }
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultWeakSenitiveDataHashingSink extends WeakSensitiveDataHashingSink {
  string algorithm;

  DefaultWeakSenitiveDataHashingSink() { sinkNode(this, "weak-hash-input-" + algorithm) }

  override string getAlgorithm() { result = algorithm }
}
