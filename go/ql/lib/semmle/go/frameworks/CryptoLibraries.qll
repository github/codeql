/**
 * Provides classes for modeling cryptographic libraries.
 */

import go
import semmle.go.Concepts::Cryptography
private import codeql.concepts.internal.CryptoAlgorithmNames

/**
 * A data flow call node that is an application of a hash operation where the
 * hash algorithm is defined in any earlier initialization node, and the input
 * is the first argument of the call.
 */
abstract class DirectHashOperation extends HashOperation instanceof DataFlow::CallNode {
  override DataFlow::Node getInitialization() { result = this }

  override DataFlow::Node getAnInput() { result = super.getArgument(0) }
}

private module HashConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof HashAlgorithmInit }

  predicate isSink(DataFlow::Node sink) { any() }
}

/** Tracks the flow of hash algorithms. */
module HashFlow = DataFlow::Global<HashConfig>;

/**
 * A data flow node that initializes a block mode and propagates the encryption
 * algorithm from the first argument to the receiver.
 */
abstract class StdLibNewEncrypter extends BlockModeInit {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    node1 = this.getArgument(0) and
    node2 = this.getResult(0)
  }
}

private module EncryptionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof EncryptionAlgorithmInit or
    source instanceof BlockModeInit
  }

  predicate isSink(DataFlow::Node sink) { any() }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(BlockModeInit nbcm).step(node1, node2)
  }
}

/**
 * Tracks algorithms and block cipher modes of operation used for encryption.
 */
module EncryptionFlow = DataFlow::Global<EncryptionConfig>;

private module Crypto {
  private module Aes {
    private class NewCipher extends EncryptionAlgorithmInit {
      NewCipher() {
        exists(Function f | this = f.getACall().getResult(0) |
          f.hasQualifiedName("crypto/aes", "NewCipher")
        )
      }

      override EncryptionAlgorithm getAlgorithm() { result.matchesName("AES") }
    }
  }

  private module Des {
    private class NewCipher extends EncryptionAlgorithmInit {
      NewCipher() {
        exists(Function f | this = f.getACall().getResult(0) |
          f.hasQualifiedName("crypto/des", "NewCipher")
        )
      }

      override EncryptionAlgorithm getAlgorithm() { result.matchesName("DES") }
    }

    private class NewTripleDESCipher extends EncryptionAlgorithmInit {
      NewTripleDESCipher() {
        exists(Function f | this = f.getACall().getResult(0) |
          f.hasQualifiedName("crypto/des", "NewTripleDESCipher")
        )
      }

      override EncryptionAlgorithm getAlgorithm() { result.matchesName("TRIPLEDES") }
    }
  }

  private module Md5 {
    private class Sum extends DirectHashOperation instanceof DataFlow::CallNode {
      Sum() { this.getTarget().hasQualifiedName("crypto/md5", "Sum") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("MD5") }
    }

    private class New extends HashAlgorithmInit instanceof DataFlow::CallNode {
      New() { this.getTarget().hasQualifiedName("crypto/md5", "New") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("MD5") }
    }
  }

  private module Rc4 {
    private class CipherXorKeyStream extends CryptographicOperation::Range instanceof DataFlow::CallNode
    {
      CipherXorKeyStream() {
        this.(DataFlow::MethodCallNode)
            .getTarget()
            .hasQualifiedName("crypto/rc4", "Cipher", "XORKeyStream")
      }

      override DataFlow::Node getInitialization() { result = this }

      override EncryptionAlgorithm getAlgorithm() { result.matchesName("RC4") }

      override DataFlow::Node getAnInput() { result = super.getArgument(1) }

      override BlockMode getBlockMode() { none() }
    }
  }

  /**
   * Cryptographic operations from the `crypto/sha1` package.
   */
  private module Sha1 {
    private class Sum extends DirectHashOperation instanceof DataFlow::CallNode {
      Sum() { this.getTarget().hasQualifiedName("crypto/sha1", "Sum") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA1") }
    }

    private class New extends HashAlgorithmInit instanceof DataFlow::CallNode {
      New() { this.getTarget().hasQualifiedName("crypto/sha1", "New") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA1") }
    }
  }

  /**
   * Cryptographic operations from the `crypto/sha256` package.
   */
  private module Sha256 {
    private class Sum256 extends DirectHashOperation instanceof DataFlow::CallNode {
      Sum256() { this.getTarget().hasQualifiedName("crypto/sha256", "Sum256") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA256") }
    }

    private class Sum224 extends DirectHashOperation instanceof DataFlow::CallNode {
      Sum224() { this.getTarget().hasQualifiedName("crypto/sha256", "Sum224") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA224") }
    }

    private class New extends HashAlgorithmInit instanceof DataFlow::CallNode {
      New() { this.getTarget().hasQualifiedName("crypto/sha256", "New") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA256") }
    }

    private class New224 extends HashAlgorithmInit instanceof DataFlow::CallNode {
      New224() { this.getTarget().hasQualifiedName("crypto/sha256", "New224") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA224") }
    }
  }

  private module Sha3 {
    private class Sum224 extends DirectHashOperation instanceof DataFlow::CallNode {
      Sum224() { this.getTarget().hasQualifiedName("crypto/sha3", "Sum224") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA3224") }
    }

    private class Sum256 extends DirectHashOperation instanceof DataFlow::CallNode {
      Sum256() { this.getTarget().hasQualifiedName("crypto/sha3", "Sum256") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA3256") }
    }

    private class Sum384 extends DirectHashOperation instanceof DataFlow::CallNode {
      Sum384() { this.getTarget().hasQualifiedName("crypto/sha3", "Sum384") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA3384") }
    }

    private class Sum512 extends DirectHashOperation instanceof DataFlow::CallNode {
      Sum512() { this.getTarget().hasQualifiedName("crypto/sha3", "Sum512") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA3512") }
    }

    private class SumShake128 extends DirectHashOperation instanceof DataFlow::CallNode {
      SumShake128() { this.getTarget().hasQualifiedName("crypto/sha3", "SumSHAKE128") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHAKE128") }
    }

    private class SumShake256 extends DirectHashOperation instanceof DataFlow::CallNode {
      SumShake256() { this.getTarget().hasQualifiedName("crypto/sha3", "SumSHAKE256") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHAKE256") }
    }

    private class New224 extends HashAlgorithmInit instanceof DataFlow::CallNode {
      New224() { this.getTarget().hasQualifiedName("crypto/sha3", "New224") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA3224") }
    }

    private class New256 extends HashAlgorithmInit instanceof DataFlow::CallNode {
      New256() { this.getTarget().hasQualifiedName("crypto/sha3", "New256") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA3256") }
    }

    private class New384 extends HashAlgorithmInit instanceof DataFlow::CallNode {
      New384() { this.getTarget().hasQualifiedName("crypto/sha3", "New384") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA3384") }
    }

    private class New512 extends HashAlgorithmInit instanceof DataFlow::CallNode {
      New512() { this.getTarget().hasQualifiedName("crypto/sha3", "New512") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA3512") }
    }

    private class NewShake128 extends HashAlgorithmInit instanceof DataFlow::CallNode {
      NewShake128() {
        this.getTarget().hasQualifiedName("crypto/sha3", ["NewCSHAKE128", "NewSHAKE128"])
      }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHAKE128") }
    }

    private class NewShake256 extends HashAlgorithmInit instanceof DataFlow::CallNode {
      NewShake256() {
        this.getTarget().hasQualifiedName("crypto/sha3", ["NewCSHAKE256", "NewSHAKE256"])
      }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHAKE256") }
    }

    private class ShakeWrite extends HashOperation instanceof DataFlow::MethodCallNode {
      ShakeWrite() { this.getTarget().hasQualifiedName("crypto/sha3", "SHAKE", "Write") }

      override HashAlgorithmInit getInitialization() { HashFlow::flow(result, super.getReceiver()) }

      override HashingAlgorithm getAlgorithm() { result = this.getInitialization().getAlgorithm() }

      override DataFlow::Node getAnInput() { result = super.getArgument(0) }
    }
  }

  private module Sha512 {
    private class Sum384 extends DirectHashOperation instanceof DataFlow::CallNode {
      Sum384() { this.getTarget().hasQualifiedName("crypto/sha512", "Sum384") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA384") }
    }

    private class Sum512 extends DirectHashOperation instanceof DataFlow::CallNode {
      Sum512() { this.getTarget().hasQualifiedName("crypto/sha512", "Sum512") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA512") }
    }

    private class Sum512_224 extends DirectHashOperation instanceof DataFlow::CallNode {
      Sum512_224() { this.getTarget().hasQualifiedName("crypto/sha512", "Sum512_224") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA512224") }
    }

    private class Sum512_256 extends DirectHashOperation instanceof DataFlow::CallNode {
      Sum512_256() { this.getTarget().hasQualifiedName("crypto/sha512", "Sum512_256") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA512256") }
    }

    private class New extends HashAlgorithmInit instanceof DataFlow::CallNode {
      New() { this.getTarget().hasQualifiedName("crypto/sha512", "New") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA512") }
    }

    private class New384 extends HashAlgorithmInit instanceof DataFlow::CallNode {
      New384() { this.getTarget().hasQualifiedName("crypto/sha512", "New384") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA384") }
    }

    private class New512_224 extends HashAlgorithmInit instanceof DataFlow::CallNode {
      New512_224() { this.getTarget().hasQualifiedName("crypto/sha512", "New512_224") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA512224") }
    }

    private class New512_256 extends HashAlgorithmInit instanceof DataFlow::CallNode {
      New512_256() { this.getTarget().hasQualifiedName("crypto/sha512", "New512_256") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("SHA512256") }
    }
  }

  private module Cipher {
    private class NewCbcEncrypter extends StdLibNewEncrypter {
      NewCbcEncrypter() { this.getTarget().hasQualifiedName("crypto/cipher", "NewCBCEncrypter") }

      override BlockMode getMode() { result = "CBC" }
    }

    private class NewCfbEncrypter extends StdLibNewEncrypter {
      NewCfbEncrypter() { this.getTarget().hasQualifiedName("crypto/cipher", "NewCFBEncrypter") }

      override BlockMode getMode() { result = "CFB" }
    }

    private class NewCtr extends StdLibNewEncrypter {
      NewCtr() { this.getTarget().hasQualifiedName("crypto/cipher", "NewCTR") }

      override BlockMode getMode() { result = "CTR" }
    }

    private class NewGcm extends StdLibNewEncrypter {
      NewGcm() {
        exists(string name | this.getTarget().hasQualifiedName("crypto/cipher", name) |
          name = ["NewGCM", "NewGCMWithNonceSize", "NewGCMWithRandomNonce", "NewGCMWithTagSize"]
        )
      }

      override BlockMode getMode() { result = "GCM" }
    }

    private class NewOfb extends StdLibNewEncrypter {
      NewOfb() { this.getTarget().hasQualifiedName("crypto/cipher", "NewOFB") }

      override BlockMode getMode() { result = "OFB" }
    }

    private class AeadSeal extends EncryptionMethodCall {
      AeadSeal() {
        this.(DataFlow::MethodCallNode)
            .getTarget()
            .hasQualifiedName("crypto/cipher", "AEAD", "Seal") and
        inputArg = 2
      }
    }

    private class BlockEncrypt extends EncryptionMethodCall {
      BlockEncrypt() {
        this.(DataFlow::MethodCallNode)
            .getTarget()
            .hasQualifiedName("crypto/cipher", "Block", "Encrypt") and
        inputArg = 1
      }
    }

    private class BlockModeCryptBlocks extends EncryptionMethodCall {
      BlockModeCryptBlocks() {
        this.(DataFlow::MethodCallNode)
            .getTarget()
            .hasQualifiedName("crypto/cipher", "BlockMode", "CryptBlocks") and
        inputArg = 1
      }
    }

    private class StreamXorKeyStream extends EncryptionMethodCall {
      StreamXorKeyStream() {
        this.(DataFlow::MethodCallNode)
            .getTarget()
            .hasQualifiedName("crypto/cipher", "Stream", "XORKeyStream") and
        inputArg = 1
      }
    }

    private class StreamReader extends EncryptionOperation {
      StreamReader() {
        lookThroughPointerType(this.getType()).hasQualifiedName("crypto/cipher", "StreamReader") and
        exists(DataFlow::Write w, DataFlow::Node base, Field f |
          f.hasQualifiedName("crypto/cipher", "StreamReader", "S") and
          w.writesField(base, f, encryptionFlowTarget) and
          DataFlow::localFlow(base, this)
        ) and
        exists(DataFlow::Write w, DataFlow::Node base, Field f |
          f.hasQualifiedName("crypto/cipher", "StreamReader", "R") and
          w.writesField(base, f, inputNode) and
          DataFlow::localFlow(base, this)
        )
      }
    }

    /**
     * Limitation: StreamWriter wraps a Writer, so we need to look forward to
     * where the Writer is written to. Currently this is done using local flow,
     * so it only works within one function.
     */
    private class StreamWriter extends EncryptionOperation {
      StreamWriter() {
        lookThroughPointerType(this.getType()).hasQualifiedName("crypto/cipher", "StreamWriter") and
        inputNode = this and
        exists(DataFlow::Write w, DataFlow::Node base, Field f |
          w.writesField(base, f, encryptionFlowTarget) and
          f.hasQualifiedName("crypto/cipher", "StreamWriter", "S")
        |
          base = this or
          TaintTracking::localTaint(base, this.(DataFlow::PostUpdateNode).getPreUpdateNode())
        )
      }
    }
  }
}

private module Hash {
  private class HashSum extends HashOperation instanceof DataFlow::MethodCallNode {
    HashSum() { this.getTarget().implements("hash", "Hash", "Sum") }

    override HashAlgorithmInit getInitialization() { HashFlow::flow(result, super.getReceiver()) }

    override HashingAlgorithm getAlgorithm() { result = this.getInitialization().getAlgorithm() }

    override DataFlow::Node getAnInput() { result = super.getArgument(0) }
  }
}

private DataFlow::Node getANonIoWriterPredecessor(DataFlow::Node node) {
  node.getType().implements("io", "Writer") and
  exists(DataFlow::Node pre | TaintTracking::localTaintStep(pre, node) |
    if pre.getType().implements("io", "Writer")
    then result = getANonIoWriterPredecessor(pre)
    else result = pre
  )
}

/**
 * Taint flowing to an `io.Writer` (such as `hash.Hash` or `*sha3.SHAKE`) via
 * its implementation of the `io.Writer` interface.
 */
private class FlowToIoWriter extends HashOperation instanceof DataFlow::Node {
  HashAlgorithmInit init;
  DataFlow::Node input;

  FlowToIoWriter() {
    this.getType().implements("io", "Writer") and
    HashFlow::flow(init, this) and
    // If we have `h.Write(taint)` or `io.WriteString(h, taint)` then it's
    // the post-update node of `h` that gets tainted.
    exists(DataFlow::PostUpdateNode pun | pun.getPreUpdateNode() = this |
      input = getANonIoWriterPredecessor(pun)
    )
  }

  override HashAlgorithmInit getInitialization() { result = init }

  override HashingAlgorithm getAlgorithm() { result = this.getInitialization().getAlgorithm() }

  override DataFlow::Node getAnInput() { result = input }
}

/**
 * Currently only weak algorithms from the `golang.org/x/crypto` module are
 * modeled here.
 */
private module GolangOrgXCrypto {
  private module Md4 {
    private class New extends HashAlgorithmInit instanceof DataFlow::CallNode {
      New() { this.getTarget().hasQualifiedName("golang.org/x/crypto/md4", "New") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("MD4") }
    }
  }

  private module Ripemd160 {
    private class New extends HashAlgorithmInit instanceof DataFlow::CallNode {
      New() { this.getTarget().hasQualifiedName("golang.org/x/crypto/ripemd160", "New") }

      override HashingAlgorithm getAlgorithm() { result.matchesName("RIPEMD160") }
    }
  }
}
