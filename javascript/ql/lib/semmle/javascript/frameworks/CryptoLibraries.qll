/**
 * Provides classes for modeling cryptographic libraries.
 */

import javascript
import semmle.javascript.security.CryptoAlgorithms

/**
 * An application of a cryptographic algorithm.
 */
abstract class CryptographicOperation extends Expr {
  /**
   * Gets the input the algorithm is used on, e.g. the plain text input to be encrypted.
   */
  abstract Expr getInput();

  /**
   * Gets the applied algorithm.
   */
  abstract CryptographicAlgorithm getAlgorithm();
}

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
 * A key used in a cryptographic algorithm, viewed as a `CredentialsExpr`.
 */
class CryptographicKeyCredentialsExpr extends CredentialsExpr {
  CryptographicKeyCredentialsExpr() { this = any(CryptographicKey k).asExpr() }

  override string getCredentialsKind() { result = "key" }
}

/**
 * A model of the asmCrypto library.
 */
private module AsmCrypto {
  private class Apply extends CryptographicOperation {
    Expr input;
    CryptographicAlgorithm algorithm; // non-functional

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

      exists(DataFlow::CallNode mce | this = mce.asExpr() |
        exists(DataFlow::SourceNode asmCrypto, string algorithmName |
          asmCrypto = DataFlow::globalVarRef("asmCrypto") and
          algorithm.matchesName(algorithmName) and
          mce = asmCrypto.getAPropertyRead(algorithmName).getAMemberCall(_) and
          input = mce.getAnArgument().asExpr()
        )
      )
    }

    override Expr getInput() { result = input }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }
  }
}

/**
 * A model of the browserid-crypto library.
 */
private module BrowserIdCrypto {
  private class Key extends CryptographicKey {
    Key() { this = any(Apply apply).getKey() }
  }

  private class Apply extends CryptographicOperation {
    CryptographicAlgorithm algorithm; // non-functional
    MethodCallExpr mce;

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

      this = mce and
      exists(
        DataFlow::SourceNode mod, DataFlow::Node algorithmNameNode, DataFlow::CallNode keygen,
        DataFlow::FunctionNode callback
      |
        mod = DataFlow::moduleImport("browserid-crypto") and
        keygen = mod.getAMemberCall("generateKeypair") and
        algorithmNameNode = keygen.getOptionArgument(0, "algorithm") and
        algorithm.matchesName(algorithmNameNode.getStringValue()) and
        callback = keygen.getCallback(1) and
        this = mod.getAMemberCall("sign").asExpr()
      )
    }

    override Expr getInput() { result = mce.getArgument(0) }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }

    DataFlow::Node getKey() { result.asExpr() = mce.getArgument(1) }
  }
}

/**
 * A model of the Node.js builtin crypto library.
 */
private module NodeJSCrypto {
  private class InstantiatedAlgorithm extends DataFlow::CallNode {
    CryptographicAlgorithm algorithm; // non-functional

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

      exists(DataFlow::SourceNode mod |
        mod = DataFlow::moduleImport("crypto") and
        this = mod.getAMemberCall("create" + ["Hash", "Hmac", "Sign", "Cipher"]) and
        algorithm.matchesName(this.getArgument(0).getStringValue())
      )
    }

    CryptographicAlgorithm getAlgorithm() { result = algorithm }
  }

  private class CreateKey extends CryptographicKeyCreation, DataFlow::CallNode {
    boolean symmetric;

    CreateKey() {
      // crypto.generateKey(type, options, callback)
      // crypto.generateKeyPair(type, options, callback)
      // crypto.generateKeyPairSync(type, options)
      // crypto.generateKeySync(type, options)
      exists(DataFlow::SourceNode mod, string keyType |
        keyType = "Key" and symmetric = true
        or
        keyType = "KeyPair" and symmetric = false
      |
        mod = DataFlow::moduleImport("crypto") and
        this = mod.getAMemberCall("generate" + keyType + ["", "Sync"])
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

  private class Apply extends CryptographicOperation, MethodCallExpr {
    InstantiatedAlgorithm instantiation;

    Apply() {
      this = instantiation.getAMethodCall(any(string m | m = "update" or m = "write")).asExpr()
    }

    override Expr getInput() { result = this.getArgument(0) }

    override CryptographicAlgorithm getAlgorithm() { result = instantiation.getAlgorithm() }
  }

  private class Key extends CryptographicKey {
    Key() {
      exists(InstantiatedAlgorithm instantiation, string name |
        name = "setPrivateKey" or
        name = "sign"
      |
        this = instantiation.getAMethodCall(name).getArgument(0)
      )
      or
      exists(DataFlow::SourceNode mod, string name, DataFlow::InvokeNode call, int index |
        mod = DataFlow::moduleImport("crypto") and
        call = mod.getAMemberCall(name) and
        this = call.getArgument(index)
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
  /**
   *  Matches `CryptoJS.<algorithmName>` and `require("crypto-js/<algorithmName>")`
   */
  private DataFlow::SourceNode getAlgorithmExpr(CryptographicAlgorithm algorithm) {
    exists(string algorithmName | algorithm.matchesName(algorithmName) |
      exists(DataFlow::SourceNode mod | mod = DataFlow::moduleImport("crypto-js") |
        result = mod.getAPropertyRead(algorithmName) or
        result = mod.getAPropertyRead("Hmac" + algorithmName) // they prefix Hmac
      )
      or
      exists(DataFlow::SourceNode mod |
        mod = DataFlow::moduleImport("crypto-js/" + algorithmName) and
        result = mod
      )
    )
  }

  private DataFlow::CallNode getEncryptionApplication(Expr input, CryptographicAlgorithm algorithm) {
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

    result = getAlgorithmExpr(algorithm).getAMemberCall("encrypt") and
    input = result.getArgument(0).asExpr()
  }

  private DataFlow::CallNode getDirectApplication(Expr input, CryptographicAlgorithm algorithm) {
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

    result = getAlgorithmExpr(algorithm).getACall() and
    input = result.getArgument(0).asExpr()
  }

  private class Apply extends CryptographicOperation {
    Expr input;
    CryptographicAlgorithm algorithm; // non-functional

    Apply() {
      this = getEncryptionApplication(input, algorithm).asExpr() or
      this = getDirectApplication(input, algorithm).asExpr()
    }

    override Expr getInput() { result = input }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }
  }

  private class Key extends CryptographicKey {
    Key() {
      exists(DataFlow::SourceNode e, CryptographicAlgorithm algorithm |
        e = getAlgorithmExpr(algorithm)
      |
        exists(string name |
          name = "encrypt" or
          name = "decrypt"
        |
          algorithm instanceof EncryptionAlgorithm and
          this = e.getAMemberCall(name).getArgument(1)
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
        getAlgorithmExpr(any(CryptographicAlgorithm algo | algo.getName() = algorithm)).getACall() and
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
  private class Apply extends CryptographicOperation instanceof MethodCallExpr {
    Expr input;
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

      exists(DataFlow::SourceNode mod, string name |
        name = "hash" and algorithm.matchesName("SHA512")
        or
        name = "sign" and algorithm.matchesName("ed25519")
      |
        (mod = DataFlow::moduleImport("nacl") or mod = DataFlow::moduleImport("nacl-fast")) and
        this = mod.getAMemberCall(name).asExpr() and
        super.getArgument(0) = input
      )
    }

    override Expr getInput() { result = input }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }
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
  private DataFlow::CallNode getAlgorithmExpr(CryptographicAlgorithm algorithm) {
    exists(string algorithmName | algorithm.matchesName(algorithmName) |
      result = DataFlow::moduleMember("hash.js", algorithmName).getACall()
      or
      exists(DataFlow::SourceNode mod |
        mod = DataFlow::moduleImport("hash.js/lib/hash/" + algorithmName)
        or
        exists(string size |
          mod = DataFlow::moduleImport("hash.js/lib/hash/sha/" + size) and
          algorithmName = "SHA" + size
        )
      |
        result = mod.getACall()
      )
    )
  }

  private class Apply extends CryptographicOperation instanceof MethodCallExpr {
    Expr input;
    CryptographicAlgorithm algorithm; // non-functional

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

      this = getAlgorithmExpr(algorithm).getAMemberCall("update").asExpr() and
      input = super.getArgument(0)
    }

    override Expr getInput() { result = input }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }
  }
}

/**
 * A model of the forge library.
 */
private module Forge {
  private DataFlow::SourceNode getAnImportNode() {
    result = DataFlow::moduleImport("forge") or
    result = DataFlow::moduleImport("node-forge")
  }

  abstract private class Cipher extends DataFlow::CallNode {
    abstract CryptographicAlgorithm getAlgorithm();
  }

  private class KeyCipher extends Cipher {
    DataFlow::Node key;
    CryptographicAlgorithm algorithm; // non-functional

    KeyCipher() {
      exists(DataFlow::SourceNode mod, string algorithmName |
        mod = getAnImportNode() and
        algorithm.matchesName(algorithmName)
      |
        exists(string createName, string cipherName, string cipherPrefix, string cipherSuffix |
          // `require('forge').cipher.createCipher("3DES-CBC").update("secret", "key");`
          (createName = "createCipher" or createName = "createDecipher") and
          this = mod.getAPropertyRead("cipher").getAMemberCall(createName) and
          this.getArgument(0).asExpr().mayHaveStringValue(cipherName) and
          cipherName = cipherPrefix + "-" + cipherSuffix and
          cipherSuffix = ["CBC", "CFB", "CTR", "ECB", "GCM", "OFB"] and
          algorithmName = cipherPrefix and
          key = this.getArgument(1)
        )
        or
        // `require("forge").rc2.createEncryptionCipher("key").update("secret");`
        exists(string createName |
          createName = "createEncryptionCipher" or createName = "createDecryptionCipher"
        |
          this = mod.getAPropertyRead(algorithmName).getAMemberCall(createName) and
          key = this.getArgument(0)
        )
      )
    }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }

    DataFlow::Node getKey() { result = key }
  }

  private class NonKeyCipher extends Cipher {
    CryptographicAlgorithm algorithm; // non-functional

    NonKeyCipher() {
      exists(string algorithmName | algorithm.matchesName(algorithmName) |
        // require("forge").md.md5.create().update('The quick brown fox jumps over the lazy dog');
        this =
          getAnImportNode()
              .getAPropertyRead("md")
              .getAPropertyRead(algorithmName)
              .getAMemberCall("create")
      )
    }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }
  }

  private class Apply extends CryptographicOperation instanceof MethodCallExpr {
    Expr input;
    CryptographicAlgorithm algorithm; // non-functional

    Apply() {
      exists(Cipher cipher |
        this = cipher.getAMemberCall("update").asExpr() and
        super.getArgument(0) = input and
        algorithm = cipher.getAlgorithm()
      )
    }

    override Expr getInput() { result = input }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }
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
            .getAPropertyRead(any(string s | algorithm.matchesName(s)))
            .getAMemberCall("createEncryptionCipher")
      or
      // var key = forge.random.getBytesSync(16);
      // var cipher = forge.cipher.createCipher('AES-CBC', key);
      this =
        getAnImportNode()
            .getAPropertyRead("cipher")
            .getAMemberCall(["createCipher", "createDecipher"]) and
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
  private class Apply extends CryptographicOperation instanceof CallExpr {
    Expr input;
    CryptographicAlgorithm algorithm;

    Apply() {
      // `require("md5")("message");`
      exists(DataFlow::SourceNode mod |
        mod = DataFlow::moduleImport("md5") and
        algorithm.matchesName("MD5") and
        this = mod.getACall().asExpr() and
        super.getArgument(0) = input
      )
    }

    override Expr getInput() { result = input }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }
  }
}

/**
 * A model of the bcrypt, bcryptjs, bcrypt-nodejs libraries.
 */
private module Bcrypt {
  private class Apply extends CryptographicOperation instanceof MethodCallExpr {
    Expr input;
    CryptographicAlgorithm algorithm;

    Apply() {
      // `require("bcrypt").hash(password);` with minor naming variations
      exists(DataFlow::SourceNode mod, string moduleName, string methodName |
        algorithm.matchesName("BCRYPT") and
        (
          moduleName = "bcrypt" or
          moduleName = "bcryptjs" or
          moduleName = "bcrypt-nodejs"
        ) and
        (
          methodName = "hash" or
          methodName = "hashSync"
        ) and
        mod = DataFlow::moduleImport(moduleName) and
        this = mod.getAMemberCall(methodName).asExpr() and
        super.getArgument(0) = input
      )
    }

    override Expr getInput() { result = input }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }
  }
}

/**
 * A model of the hasha library.
 */
private module Hasha {
  private class Apply extends CryptographicOperation instanceof CallExpr {
    Expr input;
    CryptographicAlgorithm algorithm;

    Apply() {
      // `require('hasha')('unicorn', { algorithm: "md5" });`
      exists(DataFlow::SourceNode mod, string algorithmName, Expr algorithmNameNode |
        mod = DataFlow::moduleImport("hasha") and
        this = mod.getACall().asExpr() and
        super.getArgument(0) = input and
        algorithm.matchesName(algorithmName) and
        super.hasOptionArgument(1, "algorithm", algorithmNameNode) and
        algorithmNameNode.mayHaveStringValue(algorithmName)
      )
    }

    override Expr getInput() { result = input }

    override CryptographicAlgorithm getAlgorithm() { result = algorithm }
  }
}

/**
 * Provides classes for working with the `express-jwt` package (https://github.com/auth0/express-jwt);
 */
private module ExpressJwt {
  private class Key extends CryptographicKey {
    Key() { this = DataFlow::moduleMember("express-jwt", "sign").getACall().getArgument(1) }
  }
}

/**
 * Provides classes for working with the `node-rsa` package (https://www.npmjs.com/package/node-rsa)
 */
private module NodeRsa {
  private class CreateKey extends CryptographicKeyCreation, API::InvokeNode {
    CryptographicAlgorithm algorithm;

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
