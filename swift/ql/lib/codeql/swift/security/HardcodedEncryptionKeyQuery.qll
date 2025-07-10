/**
 * Provides a taint tracking configuration to find hard-coded encryption
 * key vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.HardcodedEncryptionKeyExtensions

/**
 * An `Expr` that is used to initialize a key.
 */
abstract class KeySource extends Expr { }

/**
 * A literal byte array is a key source.
 */
class ByteArrayLiteralSource extends KeySource {
  ByteArrayLiteralSource() {
    this = any(ArrayExpr arr | arr.getType().getName() = ["Array<UInt8>", "[UInt8]"])
  }
}

/**
 * A string literal is a key source.
 */
class StringLiteralSource extends KeySource instanceof StringLiteralExpr { }

/**
 * A taint configuration from the key source to expressions that use
 * it to initialize a cipher.
 */
module HardcodedKeyConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof KeySource }

  predicate isSink(DataFlow::Node node) { node instanceof HardcodedEncryptionKeySink }

  predicate isBarrier(DataFlow::Node node) { node instanceof HardcodedEncryptionKeyBarrier }

  predicate isBarrierIn(DataFlow::Node node) {
    // make sources barriers so that we only report the closest instance
    isSource(node)
  }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(HardcodedEncryptionKeyAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }
}

module HardcodedKeyFlow = TaintTracking::Global<HardcodedKeyConfig>;
