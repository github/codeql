import python
import semmle.python.ApiGraphs
import experimental.cryptography.CryptoArtifact
private import experimental.cryptography.utils.Utils as Utils
private import experimental.cryptography.CryptoAlgorithmNames
private import experimental.cryptography.modules.stdlib.HashlibModule as HashlibModule

/**
 * `hmac` is a ptyhon standard library module for key-based hashing algorithms.
 *    https://docs.python.org/3/library/hmac.html
 */
// -----------------------------------------------
// Hash Artifacts
// -----------------------------------------------
module Hashes {
  class GenericHmacHashCall extends API::CallNode {
    GenericHmacHashCall() {
      this = API::moduleImport("hmac").getMember("new").getACall() or
      this = API::moduleImport("hmac").getMember("HMAC").getACall() or
      this = API::moduleImport("hmac").getMember("digest").getACall()
    }
  }

  DataFlow::Node getDigestModParamSrc(GenericHmacHashCall call) {
    result = Utils::getUltimateSrcFromApiNode(call.(API::CallNode).getParameter(2, "digestmod"))
  }

  /**
   * This class captures the common behavior for all HMAC operations:
   *    hmac.HMAC     https://docs.python.org/3/library/hmac.html#hmac.HMAC
   *    hmac.new      https://docs.python.org/3/library/hmac.html#hmac.new
   *    hmac.digest   https://docs.python.org/3/library/hmac.html#hmac.digest
   * These operations commonly set the algorithm as a string in the third argument (`digestmod`)
   * of the operation itself.
   *
   * NOTE: `digestmod` is the digest name, digest constructor or module for the HMAC object to use, however
   *    this class only identifies string names. The other forms are found by CryptopgraphicArtifacts,
   *    modeled in `HmacHMACConsArtifact` and `Hashlib.qll`, specifically through hashlib.new and
   *    direct member accesses (e.g., hashlib.md5).
   *
   * Where no `digestmod` exists, the algorithm is assumed to be `md5` per the docs found here:
   *  https://docs.python.org/3/library/hmac.html#hmac.new
   *
   * Where `digestmod` exists but is not a string and not a hashlib algorithm, it is assumed
   * to be `UNKNOWN`. Note this includes cases wheere the digest is provided as a `A module supporting PEP 247.`
   * Such modules are currently not modeled.
   */
  class HmacGenericAlgorithm extends HashAlgorithm {
    HmacGenericAlgorithm() {
      exists(GenericHmacHashCall c |
        if not exists(getDigestModParamSrc(c)) then this = c else this = getDigestModParamSrc(c)
      ) and
      // Ignore case where the algorithm is a hashlib algorithm, rely on `HashlibMemberAlgorithm` to catch these cases
      not this instanceof HashlibModule::Hashes::HashlibMemberAlgorithm
      // NOTE: the docs say the digest can be `A module supporting PEP 247.`, however, this is not modeled, and will be considered UNKNOWN
    }

    override string getName() {
      // when the this is a generic hmac call
      // it means the algorithm parameter was not identified, assume the default case of 'md5' (per the docs)
      if this instanceof GenericHmacHashCall
      then result = super.normalizeName("MD5")
      else (
        // Else get the string name, if its a string constant, or UNKNOWN if otherwise
        result = super.normalizeName(this.asExpr().(StringLiteral).getText())
        or
        not this.asExpr() instanceof StringLiteral and result = unknownAlgorithm()
      )
    }
  }
}
