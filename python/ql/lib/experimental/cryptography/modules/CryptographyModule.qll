import python
import semmle.python.ApiGraphs
import experimental.cryptography.CryptoArtifact
import experimental.cryptography.CryptoAlgorithmNames
import experimental.cryptography.utils.CallCfgNodeWithTarget
private import experimental.cryptography.utils.Utils as Utils

/**
 * Provides models for the `cryptography` PyPI package.
 * See https://cryptography.io/en/latest/.
 */
// -----------------------------------------------
// Hash Artifacts
// https://cryptography.io/en/latest/hazmat/primitives/cryptographic-hashes/#module-cryptography.hazmat.primitives.hashes
// -----------------------------------------------
module Hashes {
  /**
   * Gets a member access of cryptography.hazmat.primitives.hashes
   * that is a hash algorithm invocation.
   * `hashName` is the name of the hash algorithm.
   */
  // Copying use of nomagic from similar predicate in codeql/main
  pragma[nomagic]
  DataFlow::Node cryptographyMemberHashAlgorithm(API::Node algModule, string hashName) {
    algModule =
      API::moduleImport("cryptography")
          .getMember("hazmat")
          .getMember("primitives")
          .getMember("hashes")
          .getMember(hashName) and
    result = algModule.asSource() and
    // Don't matches known non-hash members
    //   https://github.com/pyca/cryptography/blob/main/src/cryptography/hazmat/primitives/hashes.py#L69-L111
    not hashName in [
        "abc", "already_finalized", "ExtendableOutputFunction", "Hash", "HashAlgorithm",
        "HashContext", "typing", "utils"
      ] and
    // Don't match things like __file__
    not hashName.regexpMatch("_.*")
  }

  /**
   *  Identifies hashing algorithm members (i.e., functions) of the `cryptography` module,
   *  e.g., `cryptography.hazmat.primitives.hashes.SHA256`.
   *    https://cryptography.io/en/latest/hazmat/primitives/cryptographic-hashes/#cryptography.hazmat.primitives.hashes.Hash
   */
  class CryptographyGenericHashAlgorithm extends HashAlgorithm {
    CryptographyGenericHashAlgorithm() { this = cryptographyMemberHashAlgorithm(_, _) }

    override string getName() {
      exists(string rawName | this = cryptographyMemberHashAlgorithm(_, rawName) |
        result = super.normalizeName(rawName)
      )
    }

    API::Node getModule() { this = cryptographyMemberHashAlgorithm(result, _) }
  }
  // NOTE: no need to model hashes used for PBKDF2HMAC (and other similar KDF HMAC), the API requires the specified algorithm
  //       is an instance of `HashAlgorithm` handled by `CryptographyGenericHashArtifact`

  API::CallNode getCryptographyHashInitialisation(CryptographyGenericHashAlgorithm hash) {
    result = API::moduleImport("cryptography")
      .getMember("hazmat")
      .getMember("primitives")
      .getMember("hashes")
      .getMember("Hash")
      .getACall() and
    hash.getModule().getACall().flowsTo(result.getParameter(0).asSink())
  }

  API::CallNode getCryptographyHashOneShot(CryptographyGenericHashAlgorithm hash) {
    result = API::moduleImport("cryptography")
      .getMember("hazmat")
      .getMember("primitives")
      .getMember("hashes")
      .getMember("Hash")
      .getMember("hash")
      .getACall() and
    hash.getModule().getACall().flowsTo(result.getParameter(0, "algorithm").asSink())
  }

  API::CallNode getCryptographyHashOperation(CryptographyGenericHashAlgorithm hash, API::CallNode initialisation) {
    (initialisation = getCryptographyHashInitialisation(hash) and result = initialisation.getAMethodCall("update"))
    or
    (initialisation = getCryptographyHashOneShot(hash) and result = initialisation)
  }

  class CryptographyHashDigestOperation extends CryptographicOperation {
    API::CallNode initialisation;

    CryptographyHashDigestOperation() { this = getCryptographyHashOperation(_, initialisation) }

    override DataFlow::Node getInitialisation() { result = initialisation }

    override DataFlow::Node getAnInput() {
      (initialisation = getCryptographyHashInitialisation(_) and (result = this.getArg(0) or result = this.getArgByName("data")))
      or
      (initialisation = getCryptographyHashOneShot(_) and (result = this.getArg(1) or result = this.getArgByName("data")))
    }

    override CryptographyGenericHashAlgorithm getAlgorithm() { this = getCryptographyHashOperation(result, _) }
  }
}

// https://cryptography.io/en/latest/hazmat/primitives/key-derivation-functions/#module-cryptography.hazmat.primitives.kdf
module KDF {
  DataFlow::Node genericKDFModule(API::Node algModule, string algName) {
    exists(string member |
      algModule =
        API::moduleImport("cryptography")
            .getMember("hazmat")
            .getMember("primitives")
            .getMember("kdf")
            .getMember(member)
            .getMember(algName) and
      result = algModule.asSource() and
      // https://github.com/pyca/cryptography/tree/main/src/cryptography/hazmat/primitives/kdf
      (
        member = "argon2" and algName in ["Argon2d", "Argon2i", "Argon2id"]
        or
        member = "concatkdf" and algName in ["ConcatKDFHash", "ConcatKDFHMAC"]
        or
        member = "hkdf" and algName in ["HKDF", "HKDFExpand"]
        or
        member = "kbkdf" and algName in ["KBKDFCMAC", "KBKDFHMAC"]
        or
        member = "pbkdf2" and algName in ["PBKDF2HMAC"]
        or
        member = "scrypt" and algName in ["Scrypt"]
        or
        member = "x963kdf" and algName in ["X963KDF"]
      )
    )
  }

  /**
   * Identifies key derivation function members (i.e., functions) of the `cryptography` module
   *  https://cryptography.io/en/latest/hazmat/primitives/key-derivation-functions/#module-cryptography.hazmat.primitives.kdf
   */
  class CryptographyKDFAlgorithm extends KeyDerivationAlgorithm {
    CryptographyKDFAlgorithm() { this = genericKDFModule(_, _) }

    override string getName() {
      exists(string rawName | this = genericKDFModule(_, rawName) |
        // TODO: is HKDFExpand ok to categorize as HKDF?
        result = super.normalizeName(rawName)
      )
    }

    API::Node getModule() { this = genericKDFModule(result, _) }
  }

  API::CallNode getCryptographyKDFInitialisation(CryptographyKDFAlgorithm kdf) {
    result = kdf.getModule().getACall()
  }

  API::CallNode getCryptographyKDFOperation(CryptographyKDFAlgorithm kdf, API::CallNode instance) {
    instance = getCryptographyKDFInitialisation(kdf) and
    result = instance.getAMethodCall(["derive", "derive_into", "verify"])
  }

  class CryptographyKDFOperation extends KeyDerivationOperation {
    API::CallNode instance;

    CryptographyKDFOperation() { this = getCryptographyKDFOperation(_, instance) }

    override KeyDerivationAlgorithm getAlgorithm() { this = getCryptographyKDFOperation(result, instance) }

    override DataFlow::Node getInitialisation() { result = instance }
    override DataFlow::Node getAnInput() { result = this.getArg(0) or result = this.getArgByName("key_material")  }

    override predicate requiresHash() { not this.getAlgorithm().getKDFName() in ["KBKDFCMAC", "ARGON2D", "ARGON2I", "ARGON2ID"] }

    override predicate requiresMode() {
      this.getAlgorithm().getKDFName() in ["KBKDFCMAC", "KBKDFHMAC"]
    }

    override predicate requiresSalt() {
      this.getAlgorithm().getKDFName() in ["PBKDF2HMAC", "CONCATKDFHMAC", "HKDF", "SCRYPT", "ARGON2D", "ARGON2I", "ARGON2ID"]
    }

    override predicate requiresIteration() { this.getAlgorithm().getKDFName() in ["PBKDF2HMAC", "ARGON2D", "ARGON2I", "ARGON2ID"] }

    override predicate requiresLanes() { this.getAlgorithm().getKDFName() in ["ARGON2D", "ARGON2I", "ARGON2ID"] }

    override predicate requiresMemoryCost() { this.getAlgorithm().getKDFName() in ["ARGON2D", "ARGON2I", "ARGON2ID"] }

    override DataFlow::Node getIterationSizeSrc() {
      this.requiresIteration() and
      if this.getAlgorithm().getKDFName() in ["ARGON2D", "ARGON2I", "ARGON2ID"]
      then result = Utils::getUltimateSrcFromApiNode(instance.getKeywordParameter("iterations"))
      else
        // ASSUMPTION: ONLY EVER in arg 3 in PBKDF2HMAC
        result = Utils::getUltimateSrcFromApiNode(instance.getParameter(3, "iterations"))
    }


    override DataFlow::Node getSaltConfigSink() {
      result = this.getSaltConfigSink(_)
    }

    private DataFlow::Node getSaltConfigSink(API::Node apiNode) {
      this.requiresSalt() and result = apiNode.asSink() and
      // ARGON2 variants have it as a keyword-only parameter
      if this.getAlgorithm().getKDFName() in ["ARGON2D", "ARGON2I", "ARGON2ID"]
      then apiNode = instance.getKeywordParameter("salt")
      // SCRYPT has it in arg 1
      else if this.getAlgorithm().getKDFName() = "SCRYPT"
      then apiNode = instance.getParameter(1, "salt")
      else
        // EVERYTHING ELSE that uses salt is in arg 2
        apiNode = instance.getParameter(2, "salt")
    }

    override DataFlow::Node getSaltConfigSrc() {
      result = this.getSaltConfigSrc(_)
    }

    private DataFlow::Node getSaltConfigSrc(API::Node apiNode) {
      exists(getSaltConfigSink(apiNode)) and
      result = Utils::getUltimateSrcFromApiNode(apiNode)
    }

    override DataFlow::Node getHashConfigSrc() {
      this.requiresHash() and
      // ASSUMPTION: ONLY EVER in arg 0
      result = Utils::getUltimateSrcFromApiNode(instance.getParameter(0, "algorithm"))
    }

    override DataFlow::Node getLanesConfigSrc() {
      this.requiresLanes() and
      // ASSUMPTION: ONLY EVER in keyword parameter
      result = Utils::getUltimateSrcFromApiNode(instance.getKeywordParameter("lanes"))
    }

    override DataFlow::Node getMemoryCostConfigSrc() {
      this.requiresMemoryCost() and
      // ASSUMPTION: ONLY EVER in keyword parameter
      result = Utils::getUltimateSrcFromApiNode(instance.getKeywordParameter("memory_cost"))
    }

    // TODO: get encryption algorithm for CBC-based KDF?
    override DataFlow::Node getDerivedKeySizeSrc() {
      if this.getAlgorithm().getKDFName() in ["ARGON2D", "ARGON2I", "ARGON2ID"]
      then result = Utils::getUltimateSrcFromApiNode(instance.getKeywordParameter("length"))
      else if this.getAlgorithm().getKDFName() in ["KBKDFHMAC", "KBKDFCMAC"]
      then result = Utils::getUltimateSrcFromApiNode(instance.getParameter(2, "length"))
      else result = Utils::getUltimateSrcFromApiNode(instance.getParameter(1, "length"))
    }

    override DataFlow::Node getModeSrc() {
      this.requiresMode() and
      // ASSUMPTION: ONLY EVER in arg 1
      result = Utils::getUltimateSrcFromApiNode(instance.getParameter(1, "mode"))
    }
  }
}

module Encryption {
  /**
   * https://cryptography.io/en/latest/hazmat/primitives/aead/#module-cryptography.hazmat.primitives.ciphers.aead
   * https://cryptography.io/en/latest/fernet/
   * https://cryptography.io/en/latest/hazmat/primitives/symmetric-encryption/
   */
  module SymmetricEncryption {
    // https://cryptography.io/en/latest/hazmat/primitives/keywrap/
    module KeyWrap {
      // TODO: what padding mode is used by default?
      DataFlow::Node genericKeyWrapArtifact() {
        exists(string opName |
          result =
            API::moduleImport("cryptography")
                .getMember("hazmat")
                .getMember("primitives")
                .getMember("keywrap")
                .getMember(opName)
                .getACall() and
          opName in [
              "aes_key_wrap", "aes_key_wrap_with_padding", "aes_key_unwrap",
              "aes_key_unwrap_with_padding"
            ]
        )
      }

      class CryptographyKeyWrap extends KeyWrapOperation, SymmetricEncryptionAlgorithm, BlockModeInstance,
        SymmetricCipher
      {
        CryptographyKeyWrap() { this = genericKeyWrapArtifact() }

        override DataFlow::Node getInitialisation() { result = this }

        override DataFlow::Node getAnInput() { none() /* not implemented */ }

        override string getName() {
          //Cryptography Key Wrap Artifact's use ECB block mode by default:
          // https://github.com/pyca/cryptography/blob/main/src/cryptography/hazmat/primitives/keywrap.py#L14
          result = super.normalizeName("ECB")
          or
          // TODO: the actual AES used is dependent on the key size, get key size and set name accordingly
          // Only allowed key sizes:
          //    https://github.com/pyca/cryptography/blob/main/src/cryptography/hazmat/primitives/keywrap.py#L38-L54
          result = super.normalizeName("AES")
        }

        /**
         * ECB mode is effectively no block mode and no IV is associated with this mode.
         */
        override DataFlow::Node getIVOrNonceSrc() { none() }

        override DataFlow::Node getIVOrNonceSink() { none() }

        override SymmetricEncryptionAlgorithm getEncryptionAlgorithm() { result = this }

        override BlockModeInstance getBlockMode() { result = this }

        override CryptographicAlgorithm getAlgorithm() { result = this }
      }
    }

    /**
     * Authenticated Encryption Artifacts
     * https://cryptography.io/en/latest/hazmat/primitives/aead/#module-cryptography.hazmat.primitives.ciphers.aead
     */
    module AuthenticatedEncryption {
      API::Node genericAEADAPINode(string algName) {
        result =
          API::moduleImport("cryptography")
              .getMember("hazmat")
              .getMember("primitives")
              .getMember("ciphers")
              .getMember("aead")
              .getMember(algName) and
        algName in ["AESGCM", "AESCCM", "AESOCB3", "AESSIV", "ChaCha20Poly1305"]
      }

      DataFlow::Node genericAEADArtifact(API::Node algModule, string algName) {
        algModule = genericAEADAPINode(algName) and
        result = algModule.asSource()
      }

      class CryptographyAEAD extends AuthenticatedEncryptionAlgorithm {
        CryptographyAEAD() { this = genericAEADArtifact(_, _) }

        API::Node getMember(string memberName) { result = this.getModule().getMember(memberName) }

        API::Node getModule() { this = genericAEADArtifact(result, _) }

        override string getName() {
          this = genericAEADArtifact(_, result)
        }

        string getBlockModeName() {
          exists(string rawName | genericAEADArtifact(_, rawName) = this |
            result = this.normalizedBlockNames(rawName)
          )
        }

        string getEncryptionName() {
          exists(string rawName | genericAEADArtifact(_, rawName) = this |
            result = this.normalizedEncryptionName(rawName)
          )
        }

        bindingset[rawName]
        string normalizedBlockNames(string rawName) {
          // https://cryptography.io/en/latest/hazmat/primitives/aead/#module-cryptography.hazmat.primitives.ciphers.aead
          if rawName = "AESGCM"
          then result = super.normalizeName("GCM")
          else
            if rawName = "AESCCM"
            then result = super.normalizeName("CCM")
            else
              if rawName = "AESOCB3"
              then result = super.normalizeName("OCB")
              else
                if rawName = "AESSIV"
                then result = super.normalizeName("SIV")
                else result = super.normalizeName(rawName)
        }

        bindingset[rawName]
        string normalizedEncryptionName(string rawName) {
          if rawName.matches("AES%")
          then result = super.normalizeName("AES")
          else result = super.normalizeName(rawName)
        }
      }

      DataFlow::Node genericAEADKeyGen(CryptographyAEAD aead) {
        aead.getMember("generate_key").getACall() = result
      }

      class CryptographyAEADKeyGen extends SymmetricKeyGen {
        CryptographyAEADKeyGen() { this = genericAEADKeyGen(_) }

        override CryptographyAEAD getAlgorithm() { this = genericAEADKeyGen(result) }

        override DataFlow::Node getInitialisation() { result = this }

        override DataFlow::Node getAnInput() { none() /* not implemented */ }

        override int getKeySizeInBits(DataFlow::Node configSrc) {
          if this.getAlgorithm().getAuthenticatedEncryptionName() = "ChaCha20Poly1305 "
          then result = 32 * 8
          else (
            result = configSrc.asExpr().(IntegerLiteral).getValue() and
            configSrc = this.getKeyConfigSrc()
          )
        }

        DataFlow::Node keyBitLengthSrc() {
          result =
            Utils::getUltimateSrcFromApiNode(this.(API::CallNode).getParameter(0, "bit_length"))
        }

        override DataFlow::Node getKeyConfigSrc() {
          result = this.keyBitLengthSrc()
          or
          not exists(this.keyBitLengthSrc()) and result = this
        }
      }

      API::CallNode getCryptographyAEADInstance(CryptographyAEAD aead) {
        result = aead.getModule().getACall()
      }

      Expr getLastElt(List list) {
        exists(int size | size = count(list.getAnElt()) and size > 0 and result = list.getElt(size - 1))
      }

      class CryptographyAEADEncrypt extends AuthenticatedEncryptionOperation {
        API::CallNode aeadInstance;
        string methodName;

        CryptographyAEADEncrypt() {
          aeadInstance = getCryptographyAEADInstance(_) and
          this = aeadInstance.getAMethodCall(methodName)
          and methodName in ["encrypt", "encrypt_into"]
        }

        override DataFlow::Node getInitialisation() { result = this }

        override DataFlow::Node getAnInput() { none() /* not implemented */ }

        override DataFlow::Node getIVOrNonceSrc() {
          result = Utils::getUltimateSrcFromApiNode(this.getIVOrNonceSinkCore())
        }

        override DataFlow::Node getIVOrNonceSink() {
          result = this.getIVOrNonceSinkCore().asSink()
        }

        private API::Node getIVOrNonceSinkCore() {
          if this.getAlgorithmName() = "AESSIV"
          then result = any(API::Node candidate, List aad |
            aad = this.getParameterSource(1, "associated_data").asExpr() and
            candidate.asSink().asExpr() = getLastElt(aad) |
            candidate
          )
          else result = this.getParameter(0, "nonce")
        }

        DataFlow::CallCfgNode getAeadInstance() { result = aeadInstance }

        override CryptographyAEAD getAlgorithm() { aeadInstance = getCryptographyAEADInstance(result) }
      }

      class CryptographyAEADDecrypt extends AuthenticatedEncryptionOperation {
        CryptographyAEAD aeadInstance;
        string methodName;

        CryptographyAEADDecrypt() {
          this = getCryptographyAEADInstance(aeadInstance).getAMethodCall(methodName)
          and methodName in ["decrypt", "decrypt_into"]
        }

        override DataFlow::Node getInitialisation() { result = this }

        override DataFlow::Node getAnInput() { none() /* not implemented */ }

        override DataFlow::Node getIVOrNonceSrc() {
          result = Utils::getUltimateSrcFromApiNode(this.getIVOrNonceSinkCore())
        }

        override DataFlow::Node getIVOrNonceSink() {
          result = this.getIVOrNonceSinkCore().asSink()
        }

        private API::Node getIVOrNonceSinkCore() {
          if this.getAlgorithmName() = "AESSIV"
          then result = any(API::Node candidate, List aad |
            aad = this.getParameterSource(1, "associated_data").asExpr() and
            candidate.asSink().asExpr() = getLastElt(aad) |
            candidate
          )
          else result = this.getParameter(0, "nonce")
        }

        DataFlow::CallCfgNode getAeadInstance() { result = aeadInstance }

        override CryptographyAEAD getAlgorithm() { aeadInstance = getCryptographyAEADInstance(result) }
      }
    }

    /**
     * https://cryptography.io/en/latest/fernet/
     */
    module Fernet {
      DataFlow::Node fernetConstructor() {
        exists(string member | member = ["Fernet", "MultiFernet"] |
          result =
            API::moduleImport("cryptography").getMember("fernet").getMember(member).getACall()
        )
      }

      class CryptographyFernet extends SymmetricPadding, BlockModeInstance, SymmetricEncryptionAlgorithm,
        SymmetricCipher
      {
        CryptographyFernet() { this = fernetConstructor() }

        override string getName() {
          result = super.normalizeName("PKCS7") or
          result = super.normalizeName("AES128") or
          result = super.normalizeName("CBC")
        }

        /**
         * Since the IV/Nonce is dependent on the API, we could attempt a dataflow to derive
         * what it is internal to the library, but instead we take the stance that
         * the IV/Nonce is non-existent/unknown to simplify analyses and to be
         * safe in case of API changes. Uses of this API must therefore be
         * individually assessed for correct IV use.
         *
         * The current API shows the IV is set via os.urandom:
         *    https://github.com/pyca/cryptography/blob/main/src/cryptography/fernet.py
         */
        override DataFlow::Node getIVOrNonceSrc() { none() }

        override DataFlow::Node getIVOrNonceSink() { none() }

        override SymmetricEncryptionAlgorithm getEncryptionAlgorithm() { result = this }

        override BlockModeInstance getBlockMode() { result = this }
      }

      API::CallNode fernetKeyGen(CryptographyFernet fernetCall) {
        result = fernetCall.(API::CallNode).getReturn().getMember("generate_key").getACall()
      }

      /**
       * https://cryptography.io/en/latest/fernet/#cryptography.fernet.Fernet.generate_key
       */
      class FernetKeyGen extends SymmetricKeyGen {
        FernetKeyGen() { this = fernetKeyGen(_) }

        override DataFlow::Node getInitialisation() { result = this }

        override DataFlow::Node getAnInput() { none() /* not implemented */ }

        override DataFlow::Node getKeyConfigSrc() { result = this }

        override int getKeySizeInBits(DataFlow::Node configSrc) {
          // https://github.com/pyca/cryptography/blob/main/src/cryptography/fernet.py#L44
          // requires a 256 bit key, but only uses half of it for 128 bit encryption/signing
          result = 128 and
          configSrc = this
        }

        override CryptographyFernet getAlgorithm() { this = fernetKeyGen(result) }
      }
      // NOTE: not implementing MultiFernet since it operates on Fernet which is already modeled:
      //  https://cryptography.io/en/latest/fernet/#cryptography.fernet.MultiFernet
    }

    // https://cryptography.io/en/latest/hazmat/primitives/symmetric-encryption/#module-cryptography.hazmat.primitives.ciphers.modes
    module GenericCryptoArtifact {
      DataFlow::Node genericBlockMode(string name) {
        // getACall since the typical case is to construct the block mode with initialization values
        // not to pass the mode uninitialized
        result =
          API::moduleImport("cryptography")
              .getMember("hazmat")
              .getMember("primitives")
              .getMember("ciphers")
              .getMember("modes")
              .getMember(name)
              .getACall() and
        not name.regexpMatch("_.*")
      }

      // https://cryptography.io/en/latest/hazmat/primitives/symmetric-encryption/#module-cryptography.hazmat.primitives.ciphers.modes
      class CryptographyGenericBlockModeInstance extends BlockModeInstance {
        CryptographyGenericBlockModeInstance() { this = genericBlockMode(_) }

        override string getName() {
          exists(string rawName | this = genericBlockMode(rawName) |
            result = super.normalizeName(rawName)
          )
        }

        override DataFlow::Node getIVOrNonceSrc() {
            result = Utils::getUltimateSrcFromApiNode(this.getIVOrNonceSinkCore())
        }

        override DataFlow::Node getIVOrNonceSink() {
          result = this.getIVOrNonceSinkCore().asSink()
        }

        private API::Node getIVOrNonceSinkCore() {
          exists(string paramName | paramName in ["initialization_vector", "nonce"] |
            result = this.(API::CallNode).getParameter(0, paramName)
          )
        }
      }

      DataFlow::Node genericSymmetricEncryptionArtifact(string name) {
        // getCall since the typical case is to construct the algorithm with initialization values (e.g., keys)
        // not to pass the mode uninitialized
        result =
          API::moduleImport("cryptography")
              .getMember("hazmat")
              .getMember("primitives")
              .getMember("ciphers")
              .getMember("algorithms")
              .getMember(name)
              .getACall() and
        not name.regexpMatch("_.*")
      }

      class CrytographyGenericSymmetricEncryption extends SymmetricEncryptionAlgorithm {
        CrytographyGenericSymmetricEncryption() { this = genericSymmetricEncryptionArtifact(_) }

        override string getName() {
          exists(string rawName | this = genericSymmetricEncryptionArtifact(rawName) |
            result = super.normalizeName(rawName)
          )
        }
      }

      // class CryptographcyGenericSymmetricKeyGen extends SymmetricKeyGen{
      //   CryptographcyGenericSymmetricKeyGen(){
      //     this = genericSymmetricEncryptionArtifact(_)
      //   }
      //   override DataFlow::Node getKeyConfigSrc(){
      //     result = this.(API::CallNode).getParameter(0, "key").getAValueReachingSink()
      //   }
      //   override int getKeySizeInBits(DataFlow::Node configSrc){
      //     // TODO: if/else over all posibilities
      //   }
      //   override string getAlgorithmName() {
      //     exists(SymmetricEncryptionAlgorithm a, string algName |
      //       this = genericSymmetricEncryptionArtifact(algName) and
      //       a = genericSymmetricEncryptionArtifact(algName) and
      //       result = a.normalizeName(algName)
      //     )
      //   }
      // }
      /**
       * Gets a symmetric padding operation:
       *  https://cryptography.io/en/latest/hazmat/primitives/padding/#module-cryptography.hazmat.primitives.padding
       */
      DataFlow::Node genericSymmetricPadding(string name) {
        // getACall since the typical case is to construct the padding with initialization values,
        // not to pass the mode uninitialized
        result =
          API::moduleImport("cryptography")
              .getMember("hazmat")
              .getMember("primitives")
              .getMember("padding")
              .getMember(name)
              .getACall() and
        name != "PaddingContext" and
        not name.regexpMatch("_.*")
      }

      class CryptographyGenericSymmetricPadding extends SymmetricPadding {
        CryptographyGenericSymmetricPadding() { this = genericSymmetricPadding(_) }

        override string getName() {
          exists(string rawName | this = genericSymmetricPadding(rawName) |
            result = super.normalizeName(rawName)
          )
        }
      }

      /**
       * https://cryptography.io/en/latest/hazmat/primitives/symmetric-encryption/#cryptography.hazmat.primitives.ciphers.Cipher
       */
      class CryptographyGenericCipher extends SymmetricCipher {
        CryptographyGenericCipher() {
          this =
            API::moduleImport("cryptography")
                .getMember("hazmat")
                .getMember("primitives")
                .getMember("ciphers")
                .getMember("Cipher")
                .getACall()
        }

        override SymmetricEncryptionAlgorithm getEncryptionAlgorithm() {
          result =
            Utils::getUltimateSrcFromApiNode(this.(API::CallNode).getParameter(0, "algorithm"))
        }

        override BlockModeInstance getBlockMode() {
          result = Utils::getUltimateSrcFromApiNode(this.(API::CallNode).getParameter(1, "mode"))
        }
      }
    }
  }

  module AsymmetricEncryption {
    module RSA {
      /**
       * Returns a member of cryptography asymmetric padding module that is
       * a padding algorithm (filteres out non-padding members)
       */
      DataFlow::CallCfgNode cryptographyAsymmetricPadding(string name) {
        // getACall since the typical case is to construct the padding with initialization values,
        // not to pass the mode uninitialized
        result =
          API::moduleImport("cryptography")
              .getMember("hazmat")
              .getMember("primitives")
              .getMember("asymmetric")
              .getMember("padding")
              .getMember(name)
              .getACall() and
        (
          name = "PKCS1v15" or
          name = "OAEP" or
          name = "PSS"
        )
      }

      /**
       * A cryptography asymmetric padding algorithm.
       */
      class CryptographyAsymmetricPadding extends AsymmetricPadding {
        CryptographyAsymmetricPadding() { this = cryptographyAsymmetricPadding(_) }

        override string getName() {
          exists(string rawName | this = cryptographyAsymmetricPadding(rawName) |
            result = super.normalizeName(rawName)
          )
        }
      }

      API::CallNode getRSAKeyGenCall() {
        result =
          API::moduleImport("cryptography")
              .getMember("hazmat")
              .getMember("primitives")
              .getMember("asymmetric")
              .getMember("rsa")
              .getMember("generate_private_key")
              .getACall()
      }

      API::CallNode getRSAKeyLoadCall() {
        result =
          API::moduleImport("cryptography")
              .getMember("hazmat")
              .getMember("primitives")
              .getMember("serialization")
              .getMember("load_pem_private_key")
              .getACall()
      }

      API::Node getRSAPrivateKey() {
        result = getRSAKeyGenCall().getReturn()
        or
        result = getRSAKeyLoadCall().getReturn()
      }

      API::Node getRSAPublicKey() {
        result = getRSAPrivateKey().getMember("public_key").getACall().getReturn()
      }

      DataFlow::Node getRSASignCall() { result = getRSAPrivateKey().getMember("sign").getACall() }

      DataFlow::Node getRSAVerifyCall() {
        result = getRSAPublicKey().getMember("verify").getACall()
      }

      DataFlow::Node getRSAEncryptCall() {
        result = getRSAPublicKey().getMember("encrypt").getACall()
      }

      DataFlow::Node getRSADecryptCall() {
        result = getRSAPrivateKey().getMember("decrypt").getACall()
      }

      /**
       * Finds the parameter DataFlow::Node representing padding for all RSA operations
       * that accept a padding parameter.
       */
      API::Node getRSAPaddingParameter(API::CallNode c) {
        c = getRSASignCall() and result = c.(API::CallNode).getParameter(1, "padding")
        or
        c = getRSAVerifyCall() and result = c.(API::CallNode).getParameter(2, "padding")
        or
        c = getRSAEncryptCall() and result = c.(API::CallNode).getParameter(1, "padding")
        or
        c = getRSADecryptCall() and result = c.(API::CallNode).getParameter(1, "padding")
      }

      predicate isRSAPaddingCall(API::CallNode c) {
        c = getRSASignCall() or
        c = getRSAVerifyCall() or
        c = getRSAEncryptCall() or
        c = getRSADecryptCall()
      }

      /**
       * All unknown padding algorithms determined by
       * tracing RSA operations that accept a padding parameter back to their source.
       * If the source is not `cryptographyAsymmetricPadding`, then mark it as unknown.
       */
      class UnknownRSAOperationAsymmetricPadding extends AsymmetricPadding {
        UnknownRSAOperationAsymmetricPadding() {
          // Either the padding parameter is known and it isn't a member of cryptographyAsymmetricPadding
          // or the padding parameter does not exist, and the operation itself will be considered the
          // source of an unknown padding algorithm.
          exists(API::CallNode c, API::Node p | isRSAPaddingCall(c) |
            p = getRSAPaddingParameter(c) and
            this = Utils::getUltimateSrcFromApiNode(p) and
            not this = cryptographyAsymmetricPadding(_)
            or
            not exists(getRSAPaddingParameter(c)) and
            this = c
          )
        }

        override string getName() { result = unknownAlgorithm() }
      }

      /**
       * The result of a RSA key generation operation
       */
      class CryptographyRSAKeyGen extends AsymmetricKeyGen, AsymmetricEncryptionAlgorithm {
        CryptographyRSAKeyGen() { this = getRSAKeyGenCall() }

        override DataFlow::Node getInitialisation() { result = this }

        override DataFlow::Node getAnInput() { none() /* not implemented */ }

        override DataFlow::Node getKeyConfigSrc() {
          result =
            Utils::getUltimateSrcFromApiNode(this.(API::CallNode).getParameter(1, "key_size"))
        }

        override int getKeySizeInBits(DataFlow::Node configSrc) {
          result = configSrc.asExpr().(IntegerLiteral).getValue() and
          configSrc = this.getKeyConfigSrc()
        }

        override AsymmetricEncryptionAlgorithm getAlgorithm() { result = this }

        override string getName() { result = super.normalizeName("RSA") }
      }

      /**
       * Identifies an RSA operation or artifact.
       *  https://cryptography.io/en/latest/hazmat/primitives/asymmetric/rsa/#module-cryptography.hazmat.primitives.asymmetric.rsa
       * Since the use of such an operation or artifact infers the algorithm all
       * operations/artifacts are identified as an RSA algorithm
       */
      class CryptographyRSAAlgorithm extends AsymmetricEncryptionAlgorithm {
        CryptographyRSAAlgorithm() {
          this =
            API::moduleImport("cryptography")
                .getMember("hazmat")
                .getMember("primitives")
                .getMember("asymmetric")
                .getMember("rsa")
                .getAMember*()
                .asSource()
        }

        override string getName() { result = super.normalizeName("RSA") }
      }
    }

    module EllipticCurve {
      /**
       * Gets a call to an elliptic curve key generation operation
       */
      DataFlow::Node getEllipticCurveKeyGenCall() {
        result =
          API::moduleImport("cryptography")
              .getMember("hazmat")
              .getMember("primitives")
              .getMember("asymmetric")
              .getMember("ec")
              .getMember("generate_private_key")
              .getACall()
      }

      /**
       * Gets a predefined curve class constructor call from
       * `cryptography.hazmat.primitives.asymmetric.ec`
       * https://cryptography.io/en/latest/hazmat/primitives/asymmetric/ec/#elliptic-curves
       */
      DataFlow::Node predefinedCurveClass(string curveName) {
        // getACall since the typical case is to construct the curve with initialization values,
        // not to pass the mode uninitialized
        result =
          API::moduleImport("cryptography")
              .getMember("hazmat")
              .getMember("primitives")
              .getMember("asymmetric")
              .getMember("ec")
              .getMember(curveName)
              .getACall() and
        curveName =
          [
            "SECP256R1", "SECP384R1", "SECP521R1", "SECP224R1", "SECP192R1", "SECP256K1",
            "BrainpoolP256R1", "BrainpoolP384R1", "BrainpoolP512R1", "SECT571K1", "SECT409K1",
            "SECT283K1", "SECT233K1", "SECT163K1", "SECT571R1", "SECT409R1", "SECT283R1",
            "SECT233R1", "SECT163R2"
          ]
      }

      /**
       * Gets calls to EllipticCurvePublicNumbers
       * https://cryptography.io/en/latest/hazmat/primitives/asymmetric/ec/#cryptography.hazmat.primitives.asymmetric.ec.EllipticCurvePublicNumbers
       */
      DataFlow::Node getEllipticCurvePublicNumbersCall() {
        result =
          API::moduleImport("cryptography")
              .getMember("hazmat")
              .getMember("primitives")
              .getMember("asymmetric")
              .getMember("ec")
              .getMember("EllipticCurvePublicNumbers")
              .getACall()
      }

      /**
       * Gets calls to derive_private_key
       * https://cryptography.io/en/latest/hazmat/primitives/asymmetric/ec/#cryptography.hazmat.primitives.asymmetric.ec.derive_private_key
       */
      DataFlow::Node getEllipticCurveDerivePrivateKeyCall() {
        result =
          API::moduleImport("cryptography")
              .getMember("hazmat")
              .getMember("primitives")
              .getMember("asymmetric")
              .getMember("ec")
              .getMember("derive_private_key")
              .getACall()
      }

      /**
       * An elliptic curve key generation operation
       */
      class CryptographyEllipticCurveKeyGen extends AsymmetricKeyGen {
        CryptographyEllipticCurveKeyGen() { this = getEllipticCurveKeyGenCall() }

        override DataFlow::Node getInitialisation() { result = this }

        override DataFlow::Node getAnInput() { none() /* not implemented */ }

        override DataFlow::Node getKeyConfigSrc() {
          result = Utils::getUltimateSrcFromApiNode(this.(API::CallNode).getParameter(0, "curve"))
        }

        override EllipticCurveAlgorithm getAlgorithm() { result = this.getKeyConfigSrc() }

        override int getKeySizeInBits(DataFlow::Node configSrc) {
          // TODO/NOTE: there is a general issue if config sources are defined as calls vs general dataflow nodes
          //            The issue is if defined asSource, a call may be seen as the source, hence, this predicate
          //            and others like it, will not resolve, since there is no satisfying configSrc (there is a mismatch
          //            as observed is a call, and the Curve is actually defined using `asSource`.)
          //            We need to find a generalized solution to be able to have both cases happen and rely upon
          //            getting algorithms consistently.
          isEllipticCurveAlgorithm(configSrc.(EllipticCurveAlgorithm).getCurveName(), result)
        }
      }

      /**
       * Any operation that takes in a Curve, trace the curve back to its ultimate source
       * and if it is not a known curve, the curve is considered unknown an a member of this class.
       */
      class CryptographyUnknownEllipticCurve extends EllipticCurveAlgorithm {
        CryptographyUnknownEllipticCurve() {
          (
            Utils::getUltimateSrcFromApiNode(getEllipticCurvePublicNumbersCall()
                  .(API::CallNode)
                  .getParameter(2, "curve")) = this
            or
            Utils::getUltimateSrcFromApiNode(getEllipticCurveKeyGenCall()
                  .(API::CallNode)
                  .getParameter(0, "curve")) = this
            or
            Utils::getUltimateSrcFromApiNode(getEllipticCurveDerivePrivateKeyCall()
                  .(API::CallNode)
                  .getParameter(1, "curve")) = this
          ) and
          not predefinedCurveClass(_) = this
        }

        override string getName() { result = unknownAlgorithm() }
      }

      /**
       * An elliptic curve as defined in this cryptography.hazmat.primitives.asymmetric.ec module.
       * Includes all members of the module thata are elliptic curves (filters out non-curve members)
       */
      class CryptographyEllipticCurveAlgorithm extends EllipticCurveAlgorithm {
        CryptographyEllipticCurveAlgorithm() { this = predefinedCurveClass(_) }

        override string getName() {
          exists(string rawName | this = predefinedCurveClass(rawName) |
            result = super.normalizeName(rawName)
          )
        }
      }
    }

    module DiffieHellman {
      /**
       * Any diffie-hellman module operation or artifact.
       *  https://cryptography.io/en/latest/hazmat/primitives/asymmetric/dh/#diffie-hellman-key-exchange
       *
       * Since the algorithm is hidden within all operations, all operations are identified by this class.
       */
      class CryptographyDiffieHellmanAlgorithm extends KeyExchangeAlgorithm {
        CryptographyDiffieHellmanAlgorithm() {
          this =
            API::moduleImport("cryptography")
                .getMember("hazmat")
                .getMember("primitives")
                .getMember("asymmetric")
                .getMember("dh")
                .getAMember*()
                .asSource()
        }

        override string getName() { result = super.normalizeName("DiffieHellman") }
      }

      class CrytographyDiffieHellmanKeyGen extends AsymmetricKeyGen, KeyExchangeAlgorithm {
        CrytographyDiffieHellmanKeyGen() {
          this =
            API::moduleImport("cryptography")
                .getMember("hazmat")
                .getMember("primitives")
                .getMember("asymmetric")
                .getMember("dh")
                .getMember("generate_parameters")
                .getACall()
        }

        override DataFlow::Node getInitialisation() { result = this }

        override DataFlow::Node getAnInput() { none() /* not implemented */ }

        override string getName() { result = super.normalizeName("DiffieHellman") }

        override DataFlow::Node getKeyConfigSrc() {
          result =
            Utils::getUltimateSrcFromApiNode(this.(API::CallNode).getParameter(1, "key_size"))
        }

        override int getKeySizeInBits(DataFlow::Node configSrc) {
          result = configSrc.asExpr().(IntegerLiteral).getValue() and
          configSrc = this.getKeyConfigSrc()
        }

        override KeyExchangeAlgorithm getAlgorithm() { result = this }
      }

      class CryptographyX25519 extends KeyExchangeAlgorithm, AsymmetricKeyGen,
        EllipticCurveAlgorithm
      {
        CryptographyX25519() {
          this =
            API::moduleImport("cryptography")
                .getMember("hazmat")
                .getMember("primitives")
                .getMember("asymmetric")
                .getMember("x25519")
                .getAMember*()
                .asSource()
        }

        override DataFlow::Node getInitialisation() { result = this }

        override DataFlow::Node getAnInput() { none() /* not implemented */ }

        override string getName() {
          result = super.normalizeName("DiffieHellman")
          or
          result = super.normalizeName("Curve25519")
        }

        override DataFlow::Node getKeyConfigSrc() { result = this }

        override int getKeySizeInBits(DataFlow::Node configSrc) {
          isEllipticCurveAlgorithm(this.getCurveName(), result) and
          configSrc = this
        }

        override CryptographicAlgorithm getAlgorithm() { result = this }
      }

      /**
       * Identifies the key exchange algorithm from x448 API:
       *  https://cryptography.io/en/latest/hazmat/primitives/asymmetric/x448/#x448
       *
       * Modeling as both an operation and algorithm because the algorithm is hidden
       * within all operations. All operations are therefore modeled by this class.
       */
      class CryptographyX448 extends KeyExchangeAlgorithm, AsymmetricKeyGen, EllipticCurveAlgorithm {
        CryptographyX448() {
          this =
            API::moduleImport("cryptography")
                .getMember("hazmat")
                .getMember("primitives")
                .getMember("asymmetric")
                .getMember("x448")
                .getAMember*()
                .asSource()
        }

        override DataFlow::Node getInitialisation() { result = this }

        override DataFlow::Node getAnInput() { none() /* not implemented */ }

        override string getName() {
          result = super.normalizeName("DiffieHellman")
          or
          result = super.normalizeName("Curve448")
        }

        override DataFlow::Node getKeyConfigSrc() { result = this }

        override int getKeySizeInBits(DataFlow::Node configSrc) {
          isEllipticCurveAlgorithm(this.getCurveName(), result) and
          configSrc = this
        }

        override CryptographicAlgorithm getAlgorithm() { result = this }
      }
    }

    module Signing {
      class CryptographyDSAKeyGen extends AsymmetricKeyGen, SigningAlgorithm {
        CryptographyDSAKeyGen() {
          exists(string op | op = ["generate_private_key", "generate_parameters"] |
            this =
              API::moduleImport("cryptography")
                  .getMember("hazmat")
                  .getMember("primitives")
                  .getMember("asymmetric")
                  .getMember("dsa")
                  .getMember(op)
                  .getACall()
          )
        }

        override DataFlow::Node getInitialisation() { result = this }

        override DataFlow::Node getAnInput() { none() /* not implemented */ }

        override DataFlow::Node getKeyConfigSrc() {
          result =
            Utils::getUltimateSrcFromApiNode(this.(API::CallNode).getParameter(0, "key_size"))
        }

        override int getKeySizeInBits(DataFlow::Node configSrc) {
          result = configSrc.asExpr().(IntegerLiteral).getValue() and
          configSrc = this.getKeyConfigSrc()
        }

        override SigningAlgorithm getAlgorithm() { result = this }

        override string getName() { result = super.normalizeName("DSA") }
      }

      /**
       * Identifies the signing algorithm from the ed25519 signing API:
       *  https://cryptography.io/en/latest/hazmat/primitives/asymmetric/ed25519/#ed25519-signing
       *
       * Modeling as both an operation and algorithm because the algorithm is hidden
       * within all operations. All operations are therefore modeled by this class.
       */
      class CryptographyED25519 extends SigningAlgorithm, AsymmetricKeyGen, EllipticCurveAlgorithm {
        CryptographyED25519() {
          this =
            API::moduleImport("cryptography")
                .getMember("hazmat")
                .getMember("primitives")
                .getMember("asymmetric")
                .getMember("ed25519")
                .getAMember*()
                .asSource()
        }

        override DataFlow::Node getInitialisation() { result = this }

        override DataFlow::Node getAnInput() { none() /* not implemented */ }

        override string getName() {
          result = super.normalizeName("EDDSA")
          or
          result = super.normalizeName("Curve25519")
        }

        override DataFlow::Node getKeyConfigSrc() { result = this }

        override int getKeySizeInBits(DataFlow::Node configSrc) {
          isEllipticCurveAlgorithm(this.getCurveName(), result) and
          configSrc = this
        }

        override CryptographicAlgorithm getAlgorithm() { result = this }
      }

      /**
       * Identifies the signing algorithm from the ed448 signing API:
       * https://cryptography.io/en/latest/hazmat/primitives/asymmetric/ed448/#ed448-signing
       *
       * Modeling as both an operation and algorithm because the algorithm is hidden
       * within all operations. All operations are therefore modeled by this class.
       */
      class CryptographyED448 extends SigningAlgorithm, AsymmetricKeyGen, EllipticCurveAlgorithm {
        CryptographyED448() {
          this =
            API::moduleImport("cryptography")
                .getMember("hazmat")
                .getMember("primitives")
                .getMember("asymmetric")
                .getMember("ed448")
                .getAMember*()
                .asSource()
        }

        override DataFlow::Node getInitialisation() { result = this }

        override DataFlow::Node getAnInput() { none() /* not implemented */ }

        override string getName() {
          result = super.normalizeName("EDDSA")
          or
          result = super.normalizeName("Curve448")
        }

        override DataFlow::Node getKeyConfigSrc() { result = this }

        override int getKeySizeInBits(DataFlow::Node configSrc) {
          isEllipticCurveAlgorithm(this.getCurveName(), result) and
          configSrc = this
        }

        override CryptographicAlgorithm getAlgorithm() { result = this }
      }
    }
  }
}
