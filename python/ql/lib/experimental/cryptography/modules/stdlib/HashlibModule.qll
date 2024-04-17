import python
import semmle.python.ApiGraphs
import experimental.cryptography.CryptoArtifact
private import experimental.cryptography.utils.Utils as Utils
private import experimental.cryptography.CryptoAlgorithmNames

/**
 * `hashlib` is a ptyhon standard library module for hashing algorithms.
 *    https://docs.python.org/3/library/hashlib.html
 * This is an abstract class to reference all hashlib artifacts.
 */
// -----------------------------------------------
// Hash Artifacts
// -----------------------------------------------
module Hashes {
  /**
   * Represents a hash algorithm used by `hashlib.new`, where the hash algorithm is a string in the first argument.
   */
  class HashlibNewHashAlgorithm extends HashAlgorithm {
    HashlibNewHashAlgorithm() {
      this =
        Utils::getUltimateSrcFromApiNode(API::moduleImport("hashlib")
              .getMember("new")
              .getACall()
              .getParameter(0, "name"))
    }

    override string getName() {
      result = super.normalizeName(this.asExpr().(StringLiteral).getText())
      or
      // if not a known/static string, assume from an outside source and the algorithm is UNKNOWN
      not this.asExpr() instanceof StringLiteral and result = unknownAlgorithm()
    }
  }

  /**
   * Identifies hashlib.pbdkf2_hmac calls, identifying the hash algorithm used
   * in the hmac (matching kdf is handled separately by `HashlibPbkdf2HMACArtifact`).
   *
   *   https://docs.python.org/3/library/hashlib.html#hashlib.pbkdf2_hmac
   */
  class HashlibPbkdf2HMACHashAlgorithm extends HashAlgorithm {
    HashlibPbkdf2HMACHashAlgorithm() {
      this =
        Utils::getUltimateSrcFromApiNode(API::moduleImport("hashlib")
              .getMember("pbkdf2_hmac")
              .getACall()
              .getParameter(0, "hash_name"))
    }

    override string getName() {
      result = super.normalizeName(this.asExpr().(StringLiteral).getText())
      or
      // if not a known/static string, assume from an outside source and the algorithm is UNKNOWN
      not this.asExpr() instanceof StringLiteral and result = unknownAlgorithm()
    }
  }

  /**
   *  Gets a call to `hashlib.file_digest` where the hash algorithm is the first argument in `digest`
   * `nameSrc` is the source of the first argument.
   *
   *    https://docs.python.org/3/library/hashlib.html#hashlib.file_digest
   *
   *  NOTE: the digest argument can be, in addition to a string,
   *  a callable that returns a hash object or a hash constructor.
   *  These cases are not considered here since they would be detected separately.
   *  Specifically, other non-string cases are themselves considered sources for alerts, e.g.,
   *  references to hashlib.sha512 is found by `HashlibMemberAlgorithm`.
   *  The only exception is if the source is not a string constant or HashlibMemberAlgorithm.
   *  In these cases, the algorithm is considered 'UNKNOWN'.
   */
  class HashlibFileDigestAlgorithm extends HashAlgorithm {
    HashlibFileDigestAlgorithm() {
      this =
        Utils::getUltimateSrcFromApiNode(API::moduleImport("hashlib")
              .getMember("file_digest")
              .getACall()
              .getParameter(1, "digest")) and
      // Ignore sources that are hash constructors, allow `HashlibMemberAlgorithm` to detect these
      this != hashlibMemberHashAlgorithm(_) and
      // Ignore sources that are HMAC objects, to be handled by HmacModule
      this != API::moduleImport("hmac").getMember("new").getACall() and
      this != API::moduleImport("hmac").getMember("HMAC").getACall()
    }

    override string getName() {
      // Name is a string constant or consider the name unknown
      // NOTE: we are excluding hmac.new and hmac.HMAC constructor calls so we are expecting
      //      a string or an outside configuration only
      result = super.normalizeName(this.asExpr().(StringLiteral).getText())
      or
      not this.asExpr() instanceof StringLiteral and
      result = unknownAlgorithm()
    }
  }

  /**
   * Gets a member access of hashlib that is an algorithm invocation.
   * `hashName` is the name of the hash algorithm.
   *
   * Note: oringally a variant of this predicate was in codeql/github/main
   *       to a predicate to avoid a bad join order.
   */
  // Copying use of nomagic from similar predicate in codeql/main
  pragma[nomagic]
  DataFlow::Node hashlibMemberHashAlgorithm(string hashName) {
    result = API::moduleImport("hashlib").getMember(hashName).asSource() and
    // Don't matches known non-hash members
    not hashName in [
        "new", "pbkdf2_hmac", "algorithms_available", "algorithms_guaranteed", "file_digest"
      ] and
    // Don't match things like __file__
    not hashName.regexpMatch("_.*")
  }

  /**
   *  Identifies hashing algorithm members (i.e., functions) of the `hashlib` module,
   *  e.g., `hashlib.sha512`.
   */
  class HashlibMemberAlgorithm extends HashAlgorithm {
    HashlibMemberAlgorithm() { this = hashlibMemberHashAlgorithm(_) }

    override string getName() {
      exists(string rawName |
        result = super.normalizeName(rawName) and this = hashlibMemberHashAlgorithm(rawName)
      )
    }
  }
}

// -----------------------------------------------
// Key Derivation Functions
// -----------------------------------------------
module KDF {
  // NOTE: Only finds the params of `pbkdf2_hmac` that are non-optional
  //       dk_len is optional, i.e., can be None, and if addressed in this predicate
  //       would result in an unsatisfiable predicate.
  predicate hashlibPBDKF2HMACKDFRequiredParams(
    HashlibPbkdf2HMACOperation kdf, API::Node hashParam, API::Node saltParam,
    API::Node iterationParam
  ) {
    kdf.getParameter(0, "hash_name") = hashParam and
    kdf.getParameter(2, "salt") = saltParam and
    kdf.getParameter(3, "iterations") = iterationParam
  }

  predicate hashlibPBDKF2HMACKDFOptionalParams(HashlibPbkdf2HMACOperation kdf, API::Node keylenParam) {
    kdf.getParameter(4, "dklen") = keylenParam
  }

  /**
   * Identifies kery derivation function hashlib.pbdkf2_hmac accesses.
   *   https://docs.python.org/3/library/hashlib.html#hashlib.pbkdf2_hmac
   */
  class HashlibPbkdf2HMACOperation extends KeyDerivationAlgorithm, KeyDerivationOperation {
    HashlibPbkdf2HMACOperation() {
      this = API::moduleImport("hashlib").getMember("pbkdf2_hmac").getACall()
    }

    override string getName() { result = super.normalizeName("pbkdf2_hmac") }

    override DataFlow::Node getIterationSizeSrc() {
      exists(API::Node it | hashlibPBDKF2HMACKDFRequiredParams(this, _, _, it) |
        result = Utils::getUltimateSrcFromApiNode(it)
      )
    }

    override DataFlow::Node getSaltConfigSrc() {
      exists(API::Node s | hashlibPBDKF2HMACKDFRequiredParams(this, _, s, _) |
        result = Utils::getUltimateSrcFromApiNode(s)
      )
    }

    override DataFlow::Node getHashConfigSrc() {
      exists(API::Node h | hashlibPBDKF2HMACKDFRequiredParams(this, h, _, _) |
        result = Utils::getUltimateSrcFromApiNode(h)
      )
    }

    override DataFlow::Node getDerivedKeySizeSrc() {
      exists(API::Node dk | hashlibPBDKF2HMACKDFOptionalParams(this, dk) |
        result = Utils::getUltimateSrcFromApiNode(dk)
      )
    }

    // TODO: if DK is none, then the length is based on the hash type, if hash length not known, must call this unknown
    //    The issue is the src is what we model not the size
    //    For now, we are not modeling this and are relying on the fact that the accepted hashes are of accepted length.
    //    I.e., any query looking at length will ignore cases where it is unknown
    override KeyDerivationAlgorithm getAlgorithm() { result = this }

    override predicate requiresHash() { any() }

    override predicate requiresMode() { none() }

    override predicate requiresSalt() { any() }

    override predicate requiresIteration() { any() }
  }

  // TODO: better modeling of scrypt
  /**
   * Identifies key derivation fucntion hashlib.scrypt accesses.
   */
  class HashlibScryptAlgorithm extends KeyDerivationAlgorithm, KeyDerivationOperation {
    HashlibScryptAlgorithm() { this = API::moduleImport("hashlib").getMember("scrypt").getACall() }

    override string getName() { result = super.normalizeName("scrypt") }

    override DataFlow::Node getIterationSizeSrc() { none() }

    override DataFlow::Node getSaltConfigSrc() {
      // TODO: need to address getting salt from params, unsure how this works in CodeQL
      // since the signature is defined as hashlib.scrypt(password, *, salt, n, r, p, maxmem=0, dklen=64)
      // What position is 'salt' then such that we can reliably extract it?
      none()
    }

    override DataFlow::Node getHashConfigSrc() { none() }

    override DataFlow::Node getDerivedKeySizeSrc() {
      //TODO: see comment for getSaltConfigSrc above
      none()
    }

    override KeyDerivationAlgorithm getAlgorithm() { result = this }

    override predicate requiresHash() { none() }

    override predicate requiresMode() { none() }

    override predicate requiresSalt() { any() }

    override predicate requiresIteration() { none() }
  }
}
