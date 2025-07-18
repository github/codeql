/**
 * Provides classes modeling security-relevant aspects of the `rsa` PyPI package.
 * See https://stuvel.eu/python-rsa-doc/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `rsa` PyPI package.
 * See https://stuvel.eu/python-rsa-doc/.
 */
private module Rsa {
  /**
   * A call to `rsa.newkeys`
   *
   * See https://stuvel.eu/python-rsa-doc/reference.html#rsa.newkeys
   */
  class RsaNewkeysCall extends Cryptography::PublicKey::KeyGeneration::RsaRange,
    DataFlow::CallCfgNode
  {
    RsaNewkeysCall() { this = API::moduleImport("rsa").getMember("newkeys").getACall() }

    override DataFlow::Node getKeySizeArg() {
      result in [this.getArg(0), this.getArgByName("nbits")]
    }
  }

  /**
   * A call to `rsa.encrypt`
   *
   * See https://stuvel.eu/python-rsa-doc/reference.html#rsa.encrypt
   */
  class RsaEncryptCall extends Cryptography::CryptographicOperation::Range instanceof DataFlow::CallCfgNode
  {
    RsaEncryptCall() { this = API::moduleImport("rsa").getMember("encrypt").getACall() }

    override DataFlow::Node getInitialization() { result = this }

    override Cryptography::CryptographicAlgorithm getAlgorithm() { result.getName() = "RSA" }

    override DataFlow::Node getAnInput() {
      result in [super.getArg(0), super.getArgByName("message")]
    }

    override Cryptography::BlockMode getBlockMode() { none() }
  }

  /**
   * A call to `rsa.decrypt`
   *
   * See https://stuvel.eu/python-rsa-doc/reference.html#rsa.decrypt
   */
  class RsaDecryptCall extends Cryptography::CryptographicOperation::Range instanceof DataFlow::CallCfgNode
  {
    RsaDecryptCall() { this = API::moduleImport("rsa").getMember("decrypt").getACall() }

    override DataFlow::Node getInitialization() { result = this }

    override Cryptography::CryptographicAlgorithm getAlgorithm() { result.getName() = "RSA" }

    override DataFlow::Node getAnInput() {
      result in [super.getArg(0), super.getArgByName("crypto")]
    }

    override Cryptography::BlockMode getBlockMode() { none() }
  }

  /**
   * A call to `rsa.sign`, which both hashes and signs in the input message.
   *
   * See https://stuvel.eu/python-rsa-doc/reference.html#rsa.sign
   */
  class RsaSignCall extends Cryptography::CryptographicOperation::Range instanceof DataFlow::CallCfgNode
  {
    RsaSignCall() { this = API::moduleImport("rsa").getMember("sign").getACall() }

    override DataFlow::Node getInitialization() { result = this }

    override Cryptography::CryptographicAlgorithm getAlgorithm() {
      // signature part
      result.getName() = "RSA"
      or
      // hashing part
      exists(StringLiteral str, DataFlow::Node hashNameArg |
        hashNameArg in [super.getArg(2), super.getArgByName("hash_method")] and
        DataFlow::exprNode(str) = hashNameArg.getALocalSource() and
        result.matchesName(str.getText())
      )
    }

    override DataFlow::Node getAnInput() {
      result in [super.getArg(0), super.getArgByName("message")]
    }

    override Cryptography::BlockMode getBlockMode() { none() }
  }

  /**
   * A call to `rsa.verify`
   *
   * See https://stuvel.eu/python-rsa-doc/reference.html#rsa.verify
   */
  class RsaVerifyCall extends Cryptography::CryptographicOperation::Range instanceof DataFlow::CallCfgNode
  {
    RsaVerifyCall() { this = API::moduleImport("rsa").getMember("verify").getACall() }

    override DataFlow::Node getInitialization() { result = this }

    override Cryptography::CryptographicAlgorithm getAlgorithm() {
      // note that technically there is also a hashing operation going on but we don't
      // know what algorithm is used up front, since it is encoded in the signature
      result.getName() = "RSA"
    }

    override DataFlow::Node getAnInput() {
      result in [super.getArg(0), super.getArgByName("message")]
      or
      result in [super.getArg(1), super.getArgByName("signature")]
    }

    override Cryptography::BlockMode getBlockMode() { none() }
  }

  /**
   * A call to `rsa.compute_hash`
   *
   * See https://stuvel.eu/python-rsa-doc/reference.html#rsa.compute_hash
   */
  class RsaComputeHashCall extends Cryptography::CryptographicOperation::Range instanceof DataFlow::CallCfgNode
  {
    RsaComputeHashCall() { this = API::moduleImport("rsa").getMember("compute_hash").getACall() }

    override DataFlow::Node getInitialization() { result = this }

    override Cryptography::CryptographicAlgorithm getAlgorithm() {
      exists(StringLiteral str, DataFlow::Node hashNameArg |
        hashNameArg in [super.getArg(1), super.getArgByName("method_name")] and
        DataFlow::exprNode(str) = hashNameArg.getALocalSource() and
        result.matchesName(str.getText())
      )
    }

    override DataFlow::Node getAnInput() {
      result in [super.getArg(0), super.getArgByName("message")]
    }

    override Cryptography::BlockMode getBlockMode() { none() }
  }

  /**
   * A call to `rsa.sign_hash`
   *
   * See https://stuvel.eu/python-rsa-doc/reference.html#rsa.sign_hash
   */
  class RsaSignHashCall extends Cryptography::CryptographicOperation::Range instanceof DataFlow::CallCfgNode
  {
    RsaSignHashCall() { this = API::moduleImport("rsa").getMember("sign_hash").getACall() }

    override DataFlow::Node getInitialization() { result = this }

    override Cryptography::CryptographicAlgorithm getAlgorithm() { result.getName() = "RSA" }

    override DataFlow::Node getAnInput() {
      result in [super.getArg(0), super.getArgByName("hash_value")]
    }

    override Cryptography::BlockMode getBlockMode() { none() }
  }
}
