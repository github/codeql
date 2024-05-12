/**
 * Provides classes for modeling cryptographic libraries.
 */

import javascript
import semmle.javascript.Concepts::Cryptography
private import semmle.javascript.security.internal.CryptoAlgorithmNames

/**
 * A key used in a cryptographic algorithm.
 */
abstract class CryptographicKey extends DataFlow::ValueNode { }

/**
 * The creation of a cryptographic key.
 */
abstract class CryptographicKeyCreation extends DataFlow::Node {
  /**
   * Gets the algorithm used to create the key.
   */
  abstract CryptographicAlgorithm getAlgorithm();

  /**
   * Gets the size of the key.
   */
  abstract int getSize();

  /**
   * Gets whether the key is symmetric.
   */
  abstract predicate isSymmetricKey();
}

/**
 * A key used in a cryptographic algorithm, viewed as a `CredentialsNode`.
 */
class CryptographicKeyCredentialsExpr extends CredentialsNode instanceof CryptographicKey {
  override string getCredentialsKind() { result = "key" }
}

// Holds if `algorithm` is an `EncryptionAlgorithm` that uses a block cipher
private predicate isBlockEncryptionAlgorithm(CryptographicAlgorithm algorithm) {
  algorithm instanceof EncryptionAlgorithm and
  not algorithm.(EncryptionAlgorithm).isStreamCipher()
}

/**
 * A model of the asmCrypto library.
 */
private module AsmCrypto {
  private class Apply extends CryptographicOperation::Range instanceof DataFlow::CallNode {
    DataFlow::Node input;
    CryptographicAlgorithm algorithm; // non-functional
    DataFlow::PropRead algorithmSelection;
    private string algorithmName;
    private string methodName;

    Apply() {
      /*
       *      ```
       *      asmCrypto.SHA256.hex(input)
       *      ```
       *      matched as:
       *      ```
       *      asmCrypto.<algorithmName>._(<input>)
       *      ```
       */

      exists(DataFlow::SourceNode asmCrypto |
        asmCrypto = DataFlow::globalVarRef("asmCrypto") and
        algorithm.matchesName(algorithmName) and
        algorithmSelection = asmCrypto.getAPropertyRead(algorithmName) and
        this = algorithmSelection.getAMemberCall(methodName) and
        input = this.getArgument(0)
      )
    }

    override DataFlow::Node getInitialization() { result = algorithmSelection }

    override DataFlow::Node getAnInput() { result = input }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }

    override BlockMode getBlockMode() {
      isBlockEncryptionAlgorithm(this.getAlgorithm()) and
      result.matchesString(algorithmName)
    }

    DataFlow::Node getKey() {
      methodName = ["encrypt", "decrypt"] and
      result = super.getArgument(1)
    }
  }

  private class Key extends CryptographicKey {
    Key() { this = any(Apply apply).getKey() }
  }
}

/**
 * A model of the browserid-crypto library.
 */
private module BrowserIdCrypto {
  private class Key extends CryptographicKey {
    Key() { this = any(Apply apply).getKey() }
  }

  private class Apply extends CryptographicOperation::Range instanceof DataFlow::MethodCallNode {
    CryptographicAlgorithm algorithm; // non-functional
    DataFlow::CallNode keygen;

    Apply() {
      /*
       *      ```
       *      var jwcrypto = require("browserid-crypto");
       *      jwcrypto.generateKeypair({algorithm: 'DSA'}, function() {
       *          jwcrypto.sign(input, key);
       *        });
       *      ```
       *      matched as:
       *      ```
       *      var jwcrypto = require("browserid-crypto");
       *      jwcrypto.generateKeypair({algorithm: <algorithmName>}, function() {
       *          jwcrypto.sign(<input>, <key>);
       *        });
       *      ```
       */

      exists(
        DataFlow::SourceNode mod, DataFlow::Node algorithmNameNode, DataFlow::FunctionNode callback
      |
        mod = DataFlow::moduleImport("browserid-crypto") and
        keygen = mod.getAMemberCall("generateKeypair") and
        algorithmNameNode = keygen.getOptionArgument(0, "algorithm") and
        algorithm.matchesName(algorithmNameNode.getStringValue()) and
        callback = keygen.getCallback(1) and
        this = mod.getAMemberCall("sign")
      )
    }

    override DataFlow::Node getInitialization() { result = keygen }

    override DataFlow::Node getAnInput() { result = super.getArgument(0) }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }

    // not relevant for browserid-crypto
    override BlockMode getBlockMode() { none() }

    DataFlow::Node getKey() { result = super.getArgument(1) }
  }
}

/**
 * A model of the Node.js builtin crypto library.
 */
private module NodeJSCrypto {
  private class InstantiatedAlgorithm extends API::CallNode {
    private string algorithmName;

    InstantiatedAlgorithm() {
      /*
       *       ```
       *       const crypto = require('crypto');
       *       const cipher = crypto.createCipher('aes192', 'a password');
       *       ```
       *       matched as:
       *       ```
       *       const crypto = require('crypto');
       *       const cipher = crypto.createCipher(<algorithmName>, 'a password');
       *       ```
       *       Also matches `createHash`, `createHmac`, `createSign` instead of `createCipher`.
       */

      this =
        API::moduleImport("crypto")
            .getMember("create" + ["Hash", "Hmac", "Sign", "Cipher"])
            .getACall() and
      algorithmName = this.getArgument(0).getStringValue()
    }

    CryptographicAlgorithm getAlgorithm() { result.matchesName(algorithmName) }

    private BlockMode getExplicitBlockMode() { result.matchesString(algorithmName) }

    BlockMode getBlockMode() {
      isBlockEncryptionAlgorithm(this.getAlgorithm()) and
      (
        if exists(this.getExplicitBlockMode())
        then result = this.getExplicitBlockMode()
        else
          // CBC is the default if not explicitly specified
          result = "CBC"
      )
    }
  }

  private class CreateKey extends CryptographicKeyCreation, DataFlow::CallNode {
    boolean symmetric;

    CreateKey() {
      // crypto.generateKey(type, options, callback)
      // crypto.generateKeyPair(type, options, callback)
      // crypto.generateKeyPairSync(type, options)
      // crypto.generateKeySync(type, options)
      exists(string keyType |
        keyType = "Key" and symmetric = true
        or
        keyType = "KeyPair" and symmetric = false
      |
        this = API::moduleImport("crypto").getMember("generate" + keyType + ["", "Sync"]).getACall()
      )
    }

    override CryptographicAlgorithm getAlgorithm() {
      result.matchesName(this.getArgument(0).getStringValue())
    }

    override int getSize() {
      symmetric = true and
      result = this.getOptionArgument(1, "length").getIntValue()
      or
      symmetric = false and
      result = this.getOptionArgument(1, "modulusLength").getIntValue()
    }

    override predicate isSymmetricKey() { symmetric = true }
  }

  private class CreateDiffieHellmanKey extends CryptographicKeyCreation, DataFlow::CallNode {
    // require("crypto").createDiffieHellman(prime_length);
    CreateDiffieHellmanKey() {
      this = DataFlow::moduleMember("crypto", "createDiffieHellman").getACall()
    }

    override CryptographicAlgorithm getAlgorithm() { none() }

    override int getSize() { result = this.getArgument(0).getIntValue() }

    override predicate isSymmetricKey() { none() }
  }

  private class Apply extends CryptographicOperation::Range instanceof DataFlow::MethodCallNode {
    InstantiatedAlgorithm instantiation;

    Apply() { this = instantiation.getAMethodCall(any(string m | m = "update" or m = "write")) }

    override DataFlow::Node getInitialization() { result = instantiation }

    override DataFlow::Node getAnInput() { result = super.getArgument(0) }

    override CryptographicAlgorithm getAlgorithm() { result = instantiation.getAlgorithm() }

    override BlockMode getBlockMode() { result = instantiation.getBlockMode() }
  }

  private class Key extends CryptographicKey {
    Key() {
      this =
        any(InstantiatedAlgorithm i)
            .getReturn()
            .getMember(["setPrivateKey", "sign"])
            .getParameter(0)
            .asSink()
      or
      exists(string name, int index |
        this = API::moduleImport("crypto").getMember(name).getACall().getArgument(index)
      |
        index = 0 and
        (name = "privateDecrypt" or name = "privateEncrypt")
        or
        index = 1 and
        (name = "createCipheriv" or name = "Decipheriv" or name = "createHmac")
      )
    }
  }
}

/**
 * A model of the crypto-js library.
 */
private module CryptoJS {
  private class InstantiatedAlgorithm extends DataFlow::CallNode {
    private string algorithmName;

    InstantiatedAlgorithm() {
      /*
       *       ```
       *       const crypto = require("crypto-js");
       *       const cipher = crypto.algo.SHA256.create();
       *       ```
       *       matched as:
       *       ```
       *       const crypto = require("crypto-js");
       *       const cipher = crypto.algo.<algorithmName>.create();
       *       ```
       */

      this =
        API::moduleImport("crypto-js")
            .getMember("algo")
            .getMember(algorithmName)
            .getMember("create")
            .getACall() and
      not isStrongPasswordHashingAlgorithm(algorithmName)
    }

    CryptographicAlgorithm getAlgorithm() { result.matchesName(algorithmName) }

    private BlockMode getExplicitBlockMode() { result.matchesString(algorithmName) }

    BlockMode getBlockMode() {
      isBlockEncryptionAlgorithm(this.getAlgorithm()) and
      (
        if exists(this.getExplicitBlockMode())
        then result = this.getExplicitBlockMode()
        else
          // CBC is the default if not explicitly specified
          result = "CBC"
      )
    }
  }

  /**
   *  Matches `CryptoJS.<algorithmName>` and `require("crypto-js/<algorithmName>")`
   */
  private API::Node getAlgorithmNode(CryptographicAlgorithm algorithm) {
    exists(string algorithmName | algorithm.matchesName(algorithmName) |
      result = API::moduleImport("crypto-js").getMember([algorithmName, "Hmac" + algorithmName])
      or
      result = API::moduleImport("crypto-js/" + algorithmName)
    )
  }

  private API::CallNode getEncryptionApplication(
    API::Node input, API::Node algorithmNode, CryptographicAlgorithm algorithm
  ) {
    /*
     *    ```
     *    var CryptoJS = require("crypto-js");
     *    CryptoJS.AES.encrypt('my message', 'secret key 123');
     *    ```
     *    Matched as:
     *    ```
     *    var CryptoJS = require("crypto-js");
     *    CryptoJS.<algorithmName>.encrypt(<input>, 'secret key 123');
     *    ```
     *    Also matches where `CryptoJS.<algorithmName>` has been replaced by `require("crypto-js/<algorithmName>")`
     */

    algorithmNode = getAlgorithmNode(algorithm) and
    result = algorithmNode.getMember("encrypt").getACall() and
    input = result.getParameter(0)
  }

  private API::CallNode getDirectApplication(
    API::Node input, API::Node algorithmNode, CryptographicAlgorithm algorithm
  ) {
    /*
     *    ```
     *    var CryptoJS = require("crypto-js");
     *    CryptoJS.SHA1("Message", "Key");
     *    ```
     *    Matched as:
     *    ```
     *    var CryptoJS = require("crypto-js");
     *    CryptoJS.<algorithmName>(<input>, "Key");
     *    ```
     *    An `Hmac`-prefix of <algorithmName> is ignored.
     *    Also matches where `CryptoJS.<algorithmName>` has been replaced by `require("crypto-js/<algorithmName>")`
     */

    algorithmNode = getAlgorithmNode(algorithm) and
    result = algorithmNode.getACall() and
    input = result.getParameter(0)
  }

  private API::CallNode getUpdatedApplication(API::Node input, InstantiatedAlgorithm instantiation) {
    /*
     *    ```
     *    var CryptoJS = require("crypto-js");
     *    var hash = CryptoJS.algo.SHA256.create();
     *    hash.update('message');
     *    hash.update('password');
     *    var hashInHex = hash.finalize();
     *    ```
     *    Matched as:
     *    ```
     *    var CryptoJS = require("crypto-js");
     *    var hash = CryptoJS.algo.<algorithmName>.create();
     *    hash.update(<input>);
     *    hash.update(<input>);
     *    var hashInHex = hash.finalize();
     *    ```
     *    Also matches where `CryptoJS.algo.<algorithmName>` has been
     *    replaced by `require("crypto-js/<algorithmName>")`
     */

    result = instantiation.getAMemberCall("update") and
    input = result.getParameter(0)
  }

  private class Apply extends CryptographicOperation::Range instanceof API::CallNode {
    API::Node input;
    CryptographicAlgorithm algorithm; // non-functional
    DataFlow::Node instantiation;

    Apply() {
      exists(API::Node algorithmNode |
        this = getEncryptionApplication(input, algorithmNode, algorithm)
        or
        this = getDirectApplication(input, algorithmNode, algorithm)
      |
        instantiation = algorithmNode.asSource()
      )
      or
      this = getUpdatedApplication(input, instantiation) and
      algorithm = instantiation.(InstantiatedAlgorithm).getAlgorithm()
    }

    override DataFlow::Node getInitialization() { result = instantiation }

    override DataFlow::Node getAnInput() { result = input.asSink() }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }

    // e.g. CryptoJS.AES.encrypt("msg", "key", { mode: CryptoJS.mode.<modeString> })
    private BlockMode getExplicitBlockMode() {
      exists(string modeString |
        API::moduleImport("crypto-js").getMember("mode").getMember(modeString).asSource() =
          super.getParameter(2).getMember("mode").asSink()
      |
        result.matchesString(modeString)
      )
    }

    override BlockMode getBlockMode() {
      isBlockEncryptionAlgorithm(this.getAlgorithm()) and
      (
        if exists(this.getExplicitBlockMode())
        then result = this.getExplicitBlockMode()
        else
          // CBC is the default if not explicitly specified
          result = "CBC"
      )
    }
  }

  private class Key extends CryptographicKey {
    Key() {
      exists(API::Node e, CryptographicAlgorithm algorithm | e = getAlgorithmNode(algorithm) |
        exists(string name |
          name = "encrypt" or
          name = "decrypt"
        |
          algorithm instanceof EncryptionAlgorithm and
          this = e.getMember(name).getACall().getArgument(1)
        )
        or
        algorithm instanceof HashingAlgorithm and
        this = e.getACall().getArgument(1)
      )
    }
  }

  private class CreateKey extends CryptographicKeyCreation, DataFlow::CallNode {
    string algorithm;
    int optionArg;

    CreateKey() {
      // var key = CryptoJS.PBKDF2(password, salt, { keySize: 8 });
      this =
        getAlgorithmNode(any(CryptographicAlgorithm algo | algo.getName() = algorithm)).getACall() and
      optionArg = 2
      or
      // var key = CryptoJS.algo.PBKDF2.create({ keySize: 8 });
      this =
        DataFlow::moduleMember("crypto-js", "algo")
            .getAPropertyRead(algorithm)
            .getAMethodCall("create") and
      optionArg = 0
    }

    override CryptographicAlgorithm getAlgorithm() { result.matchesName(algorithm) }

    override int getSize() {
      result = this.getOptionArgument(optionArg, "keySize").getIntValue() * 32 // size is in words
      or
      result = this.getArgument(optionArg).getIntValue() * 32 // size is in words
    }

    override predicate isSymmetricKey() { any() }
  }
}

/**
 * A model of the TweetNaCl library.
 */
private module TweetNaCl {
  private class Apply extends CryptographicOperation::Range instanceof DataFlow::CallNode {
    DataFlow::Node input;
    CryptographicAlgorithm algorithm;

    Apply() {
      /*
       *      ```
       *      require("nacl").sign('my message');
       *      ```
       *      Matched as:
       *      ```
       *      require("nacl").sign(<input>);
       *      ```
       *      Also matches the "hash" method name, and the "nacl-fast" module.
       */

      exists(string name |
        name = "hash" and algorithm.matchesName("SHA512")
        or
        name = "sign" and algorithm.matchesName("ed25519")
      |
        this = API::moduleImport(["nacl", "nacl-fast"]).getMember(name).getACall() and
        super.getArgument(0) = input
      )
    }

    override DataFlow::Node getInitialization() { result = this }

    override DataFlow::Node getAnInput() { result = input }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }

    // No block ciphers implemented
    override BlockMode getBlockMode() { none() }
  }
}

/**
 * A model of the hash.js library.
 */
private module HashJs {
  /**
   *  Matches:
   * - `require("hash.js").<algorithmName>`()
   * - `require("hash.js/lib/hash/<algorithmName>")`()
   * - `require("hash.js/lib/hash/sha/<sha-algorithm-suffix>")`()
   */
  private DataFlow::CallNode getAlgorithmNode(CryptographicAlgorithm algorithm) {
    exists(string algorithmName | algorithm.matchesName(algorithmName) |
      result = API::moduleImport("hash.js").getMember(algorithmName).getACall()
      or
      result = API::moduleImport("hash.js/lib/hash/" + algorithmName).getACall()
      or
      exists(string size |
        result = API::moduleImport("hash.js/lib/hash/sha/" + size).getACall() and
        algorithmName = "SHA" + size
      )
    )
  }

  private class Apply extends CryptographicOperation::Range instanceof DataFlow::CallNode {
    DataFlow::Node input;
    CryptographicAlgorithm algorithm; // non-functional
    DataFlow::CallNode init;

    Apply() {
      /*
       *      ```
       *      var hash = require("hash.js");
       *      hash.sha512().update('my message', 'secret key 123');
       *      ```
       *      Matched as:
       *      ```
       *      var hash = require("hash.js");
       *      hash.<algorithmName>().update('my message', 'secret key 123');
       *      ```
       *      Also matches where `hash.<algorithmName>()` has been replaced by a more specific require a la `require("hash.js/lib/hash/sha/512")`
       */

      init = getAlgorithmNode(algorithm) and
      this = init.getAMemberCall("update") and
      input = super.getArgument(0)
    }

    override DataFlow::Node getInitialization() { result = init }

    override DataFlow::Node getAnInput() { result = input }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }

    // not relevant for hash.js
    override BlockMode getBlockMode() { none() }
  }
}

/**
 * A model of the forge library.
 */
private module Forge {
  private API::Node getAnImportNode() { result = API::moduleImport(["forge", "node-forge"]) }

  abstract private class Cipher extends DataFlow::CallNode {
    abstract CryptographicAlgorithm getAlgorithm();
  }

  private class KeyCipher extends Cipher {
    DataFlow::Node key;
    CryptographicAlgorithm algorithm; // non-functional
    private string blockModeString;

    KeyCipher() {
      exists(string algorithmName | algorithm.matchesName(algorithmName) |
        exists(string cipherName, string cipherPrefix |
          // `require('forge').cipher.createCipher("3DES-CBC").update("secret", "key");`
          this =
            getAnImportNode()
                .getMember("cipher")
                .getMember(["createCipher", "createDecipher"])
                .getACall() and
          this.getArgument(0).mayHaveStringValue(cipherName) and
          cipherName = cipherPrefix + "-" + blockModeString and
          blockModeString = ["CBC", "CFB", "CTR", "ECB", "GCM", "OFB"] and
          algorithmName = cipherPrefix and
          key = this.getArgument(1)
        )
        or
        // `require("forge").rc2.createEncryptionCipher("key").update("secret");`
        this =
          getAnImportNode()
              .getMember(algorithmName)
              .getMember(["createEncryptionCipher", "createDecryptionCipher"])
              .getACall() and
        key = this.getArgument(0) and
        blockModeString = algorithmName
      )
    }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }

    DataFlow::Node getKey() { result = key }

    BlockMode getBlockMode() {
      isBlockEncryptionAlgorithm(this.getAlgorithm()) and
      result.matchesString(blockModeString)
    }
  }

  private class NonKeyCipher extends Cipher {
    CryptographicAlgorithm algorithm; // non-functional

    NonKeyCipher() {
      exists(string algorithmName | algorithm.matchesName(algorithmName) |
        // require("forge").md.md5.create().update('The quick brown fox jumps over the lazy dog');
        this =
          getAnImportNode().getMember("md").getMember(algorithmName).getMember("create").getACall()
        or
        // require("forge").sha512.sha256.create().update('The quick brown fox jumps over the lazy dog');
        this =
          getAnImportNode()
              .getMember("md")
              .getMember(algorithmName)
              .getAMember()
              .getMember("create")
              .getACall()
      )
    }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }
  }

  private class Apply extends CryptographicOperation::Range instanceof DataFlow::CallNode {
    DataFlow::Node input;
    CryptographicAlgorithm algorithm; // non-functional
    private Cipher cipher;

    Apply() {
      this = cipher.getAMemberCall("update") and
      super.getArgument(0) = input and
      algorithm = cipher.getAlgorithm()
    }

    override DataFlow::Node getInitialization() { result = cipher }

    override DataFlow::Node getAnInput() { result = input }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }

    override BlockMode getBlockMode() { result = cipher.(KeyCipher).getBlockMode() }
  }

  private class Key extends CryptographicKey {
    Key() { this = any(KeyCipher cipher).getKey() }
  }

  private class CreateKey extends CryptographicKeyCreation, DataFlow::CallNode {
    CryptographicAlgorithm algorithm;

    CreateKey() {
      // var cipher = forge.rc2.createEncryptionCipher(key, 128);
      this =
        getAnImportNode()
            .getMember(any(string s | algorithm.matchesName(s)))
            .getMember("createEncryptionCipher")
            .getACall()
      or
      // var key = forge.random.getBytesSync(16);
      // var cipher = forge.cipher.createCipher('AES-CBC', key);
      this =
        getAnImportNode()
            .getMember("cipher")
            .getMember(["createCipher", "createDecipher"])
            .getACall() and
      algorithm.matchesName(this.getArgument(0).getStringValue())
    }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }

    override int getSize() {
      result = this.getArgument(1).getIntValue()
      or
      exists(DataFlow::CallNode call | call.getCalleeName() = ["getBytes", "getBytesSync"] |
        this.getArgument(1).getALocalSource() = call and
        result = call.getArgument(0).getIntValue() * 8 // bytes to bits
      )
    }

    override predicate isSymmetricKey() { any() }
  }
}

/**
 * A model of the md5 library.
 */
private module Md5 {
  private class Apply extends CryptographicOperation::Range instanceof DataFlow::CallNode {
    DataFlow::Node input;
    CryptographicAlgorithm algorithm;

    Apply() {
      // `require("md5")("message");`
      algorithm.matchesName("MD5") and
      this = API::moduleImport("md5").getACall() and
      super.getArgument(0) = input
    }

    override DataFlow::Node getInitialization() { result = this }

    override DataFlow::Node getAnInput() { result = input }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }

    // not relevant for md5
    override BlockMode getBlockMode() { none() }
  }
}

/**
 * A model of the bcrypt, bcryptjs, bcrypt-nodejs libraries.
 */
private module Bcrypt {
  private class Apply extends CryptographicOperation::Range instanceof DataFlow::CallNode {
    DataFlow::Node input;
    CryptographicAlgorithm algorithm;
    API::Node init;

    Apply() {
      // `require("bcrypt").hash(password);` with minor naming variations
      algorithm.matchesName("BCRYPT") and
      init = API::moduleImport(["bcrypt", "bcryptjs", "bcrypt-nodejs"]) and
      this = init.getMember(["hash", "hashSync"]).getACall() and
      super.getArgument(0) = input
    }

    override DataFlow::Node getInitialization() { result = init.asSource() }

    override DataFlow::Node getAnInput() { result = input }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }

    // not relevant for bcrypt
    override BlockMode getBlockMode() { none() }
  }
}

/**
 * A model of the hasha library.
 */
private module Hasha {
  private class Apply extends CryptographicOperation::Range instanceof DataFlow::CallNode {
    DataFlow::Node input;
    CryptographicAlgorithm algorithm;

    Apply() {
      // `require('hasha')('unicorn', { algorithm: "md5" });`
      exists(string algorithmName |
        this = API::moduleImport("hasha").getACall() and
        super.getArgument(0) = input and
        algorithm.matchesName(algorithmName) and
        super.getOptionArgument(1, "algorithm").mayHaveStringValue(algorithmName)
      )
    }

    override DataFlow::Node getInitialization() { result = this }

    override DataFlow::Node getAnInput() { result = input }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }

    // not relevant for hasha
    override BlockMode getBlockMode() { none() }
  }
}

/**
 * Provides classes for working with the `express-jwt` package (https://github.com/auth0/express-jwt);
 */
private module ExpressJwt {
  private class Key extends CryptographicKey {
    Key() { this = API::moduleImport("express-jwt").getMember("sign").getACall().getArgument(1) }
  }
}

/**
 * Provides classes for working with the `node-rsa` package (https://www.npmjs.com/package/node-rsa)
 */
private module NodeRsa {
  private class CreateKey extends CryptographicKeyCreation, API::InvokeNode {
    CreateKey() {
      this = API::moduleImport("node-rsa").getAnInstantiation()
      or
      this = API::moduleImport("node-rsa").getInstance().getMember("generateKeyPair").getACall()
    }

    override CryptographicAlgorithm getAlgorithm() { result.matchesName("rsa") }

    override int getSize() {
      result = this.getArgument(0).getIntValue()
      or
      result = this.getOptionArgument(0, "b").getIntValue()
    }

    override predicate isSymmetricKey() { none() }
  }
}
