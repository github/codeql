/**
 * Provides a taint-tracking configuration for reasoning about hard-coded
 * symmetric encryption keys.
 */

import csharp
private import semmle.code.csharp.dataflow.internal.ExternalFlow

module HardcodedSymmetricEncryptionKey {
  private import semmle.code.csharp.frameworks.system.security.cryptography.SymmetricAlgorithm

  /** A data flow source for hard-coded symmetric encryption keys. */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for hard-coded symmetric encryption keys. */
  abstract class Sink extends DataFlow::ExprNode {
    /** Gets a description of this sink. */
    abstract string getDescription();
  }

  /** A sanitizer for hard-coded symmetric encryption keys. */
  abstract class Sanitizer extends DataFlow::ExprNode { }

  private class ByteArrayType extends ArrayType {
    ByteArrayType() { this.getElementType() instanceof ByteType }
  }

  private class ByteArrayLiteralSource extends Source {
    ByteArrayLiteralSource() {
      this.asExpr() =
        any(ArrayCreation ac |
          ac.getArrayType() instanceof ByteArrayType and
          ac.hasInitializer()
        )
    }
  }

  private class StringLiteralSource extends Source {
    StringLiteralSource() { this.asExpr() instanceof StringLiteral }
  }

  private class SymmetricAlgorithmSink extends Sink {
    private string kind;

    SymmetricAlgorithmSink() { sinkNode(this, kind) and kind.matches("encryption%") }

    override string getDescription() {
      kind = "encryption-encryptor" and result = "Encryptor(rgbKey, IV)"
      or
      kind = "encryption-decryptor" and result = "Decryptor(rgbKey, IV)"
      or
      kind = "encryption-symmetrickey" and result = "CreateSymmetricKey(IBuffer keyMaterial)"
      or
      kind = "encryption-keyprop" and result = "'Key' property assignment"
    }
  }

  private class CryptographicBuffer extends Class {
    CryptographicBuffer() {
      this.hasFullyQualifiedName("Windows.Security.Cryptography", "CryptographicBuffer")
    }
  }

  /**
   * A taint-tracking configuration for uncontrolled data in path expression vulnerabilities.
   */
  private module HardCodedSymmetricEncryptionConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

    /**
     * Since `CryptographicBuffer` uses native code inside, taint tracking doesn't pass through it.
     * Need to create an additional custom step.
     */
    predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(MethodCall mc, CryptographicBuffer c |
        pred.asExpr() = mc.getAnArgument() and
        mc.getTarget() = c.getAMethod() and
        succ.asExpr() = mc
      )
    }
  }

  /**
   * A taint-tracking module for uncontrolled data in path expression vulnerabilities.
   */
  module HardCodedSymmetricEncryption = TaintTracking::Global<HardCodedSymmetricEncryptionConfig>;
}
