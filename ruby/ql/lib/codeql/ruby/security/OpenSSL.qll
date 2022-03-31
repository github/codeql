/**
 * Provides classes modeling parts of the Ruby `OpenSSL` library, which wraps
 * an underlying OpenSSL or LibreSSL C library.
 */

private import internal.CryptoAlgorithmNames
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs
private import codeql.ruby.typetracking.TypeTracker

bindingset[algorithmString]
private string algorithmRegex(string algorithmString) {
  // Algorithms usually appear in names surrounded by characters that are not
  // alphabetical characters in the same case. This handles the upper and lower
  // case cases.
  result =
    "((^|.*[^A-Z])(" + algorithmString + ")([^A-Z].*|$))" +
      // or...
      "|" +
      // For lowercase, we want to be careful to avoid being confused by camelCase
      // hence we require two preceding uppercase letters to be sure of a case switch,
      // or a preceding non-alphabetic character
      "((^|.*[A-Z]{2}|.*[^a-zA-Z])(" + algorithmString.toLowerCase() + ")([^a-z].*|$))"
}

private string rankedInsecureAlgorithm(int i) {
  // In this case we know these are being used for encryption, so we want to match
  // weak hash algorithms and block modes as well.
  result =
    rank[i](string s |
      isWeakEncryptionAlgorithm(s) or isWeakHashingAlgorithm(s) or isWeakBlockMode(s)
    )
}

private string insecureAlgorithmString(int i) {
  i = 1 and result = rankedInsecureAlgorithm(i)
  or
  result = rankedInsecureAlgorithm(i) + "|" + insecureAlgorithmString(i - 1)
}

/**
 * Gets the regular expression used for matching strings that look like they
 * contain an algorithm that is known to be insecure.
 */
private string getInsecureAlgorithmRegex() {
  result = algorithmRegex(insecureAlgorithmString(max(int i | exists(rankedInsecureAlgorithm(i)))))
}

private string rankedSecureAlgorithm(int i) {
  result = rank[i](string s | isStrongEncryptionAlgorithm(s))
}

private string secureAlgorithmString(int i) {
  i = 1 and result = rankedSecureAlgorithm(i)
  or
  result = rankedSecureAlgorithm(i) + "|" + secureAlgorithmString(i - 1)
}

/**
 * Gets a regular expression for matching strings that look like they
 * contain an algorithm that is known to be secure.
 */
string getSecureAlgorithmRegex() {
  result = algorithmRegex(secureAlgorithmString(max(int i | exists(rankedSecureAlgorithm(i)))))
}

/**
 * Names of known ciphers supported by the Ruby `OpenSSL` library, and
 * classification into strong and weak ciphers. Cipher support in practice
 * depends on the underlying `OpenSSL`/`LibreSSL` library.
 */
module Ciphers {
  /**
   * Holds if `name` is a known `OpenSSL::Cipher`. Supported ciphers depend on the
   * version of `OpenSSL` or `LibreSSL` specified when installing the `openssl` gem.
   * Ciphers listed here are sourced from OpenSSL 1.1.1 and LibreSSL 3.4.1.
   *
   * In the general case, a name will include the cipher name, the key length,
   * and the block encryption mode.
   *
   * Note that since the cipher name itself always comes first in these names
   * and always uses a "-" to demark to block mode, we can safely uppercase
   * these names when checking against an `algorithmRegex`.
   *
   * See https://ruby-doc.org/stdlib-3.0.1/libdoc/openssl/rdoc/OpenSSL/Cipher.html
   */
  predicate isOpenSSLCipher(string name) {
    name =
      [
        "aes-128-cbc", "aes-128-cbc-hmac-sha1", "aes-128-cbc-hmac-sha256", "aes-128-ccm",
        "aes-128-cfb", "aes-128-cfb1", "aes-128-cfb8", "aes-128-ctr", "aes-128-ecb", "aes-128-gcm",
        "aes-128-ocb", "aes-128-ofb", "aes-128-xts", "aes-192-cbc", "aes-192-ccm", "aes-192-cfb",
        "aes-192-cfb1", "aes-192-cfb8", "aes-192-ctr", "aes-192-ecb", "aes-192-gcm", "aes-192-ocb",
        "aes-192-ofb", "aes-256-cbc", "aes-256-cbc-hmac-sha1", "aes-256-cbc-hmac-sha256",
        "aes-256-ccm", "aes-256-cfb", "aes-256-cfb1", "aes-256-cfb8", "aes-256-ctr", "aes-256-ecb",
        "aes-256-gcm", "aes-256-ocb", "aes-256-ofb", "aes-256-xts", "aes128", "aes192", "aes256",
        "aria-128-cbc", "aria-128-ccm", "aria-128-cfb", "aria-128-cfb1", "aria-128-cfb8",
        "aria-128-ctr", "aria-128-ecb", "aria-128-gcm", "aria-128-ofb", "aria-192-cbc",
        "aria-192-ccm", "aria-192-cfb", "aria-192-cfb1", "aria-192-cfb8", "aria-192-ctr",
        "aria-192-ecb", "aria-192-gcm", "aria-192-ofb", "aria-256-cbc", "aria-256-ccm",
        "aria-256-cfb", "aria-256-cfb1", "aria-256-cfb8", "aria-256-ctr", "aria-256-ecb",
        "aria-256-gcm", "aria-256-ofb", "aria128", "aria192", "aria256", "bf", "bf-cbc", "bf-cfb",
        "bf-ecb", "bf-ofb", "blowfish", "camellia-128-cbc", "camellia-128-cfb", "camellia-128-cfb1",
        "camellia-128-cfb8", "camellia-128-ctr", "camellia-128-ecb", "camellia-128-ofb",
        "camellia-192-cbc", "camellia-192-cfb", "camellia-192-cfb1", "camellia-192-cfb8",
        "camellia-192-ctr", "camellia-192-ecb", "camellia-192-ofb", "camellia-256-cbc",
        "camellia-256-cfb", "camellia-256-cfb1", "camellia-256-cfb8", "camellia-256-ctr",
        "camellia-256-ecb", "camellia-256-ofb", "camellia128", "camellia192", "camellia256", "cast",
        "cast-cbc", "cast5-cbc", "cast5-cfb", "cast5-ecb", "cast5-ofb", "chacha20",
        "chacha20-poly1305", "des", "des-cbc", "des-cfb", "des-cfb1", "des-cfb8", "des-ecb",
        "des-ede", "des-ede-cbc", "des-ede-cfb", "des-ede-ecb", "des-ede-ofb", "des-ede3",
        "des-ede3-cbc", "des-ede3-cfb", "des-ede3-cfb1", "des-ede3-cfb8", "des-ede3-ecb",
        "des-ede3-ofb", "des-ofb", "des3", "desx", "desx-cbc", "id-aes128-CCM", "id-aes128-GCM",
        "id-aes192-CCM", "id-aes192-GCM", "id-aes256-CCM", "id-aes256-GCM", "idea", "idea-cbc",
        "idea-cfb", "idea-ecb", "idea-ofb", "rc2", "rc2-128", "rc2-40", "rc2-40-cbc", "rc2-64",
        "rc2-64-cbc", "rc2-cbc", "rc2-cfb", "rc2-ecb", "rc2-ofb", "rc4", "rc4-40", "rc4-hmac-md5",
        "seed", "seed-cbc", "seed-cfb", "seed-ecb", "seed-ofb", "sm4", "sm4-cbc", "sm4-cfb",
        "sm4-ctr", "sm4-ecb", "sm4-ofb", "AES-128-CBC", "AES-128-CBC-HMAC-SHA1", "AES-128-CFB",
        "AES-128-CFB1", "AES-128-CFB8", "AES-128-CTR", "AES-128-ECB", "AES-128-OFB", "AES-128-XTS",
        "AES-192-CBC", "AES-192-CFB", "AES-192-CFB1", "AES-192-CFB8", "AES-192-CTR", "AES-192-ECB",
        "AES-192-OFB", "AES-256-CBC", "AES-256-CBC-HMAC-SHA1", "AES-256-CFB", "AES-256-CFB1",
        "AES-256-CFB8", "AES-256-CTR", "AES-256-ECB", "AES-256-OFB", "AES-256-XTS", "AES128",
        "AES192", "AES256", "BF", "BF-CBC", "BF-CFB", "BF-ECB", "BF-OFB", "CAMELLIA-128-CBC",
        "CAMELLIA-128-CFB", "CAMELLIA-128-CFB1", "CAMELLIA-128-CFB8", "CAMELLIA-128-ECB",
        "CAMELLIA-128-OFB", "CAMELLIA-192-CBC", "CAMELLIA-192-CFB", "CAMELLIA-192-CFB1",
        "CAMELLIA-192-CFB8", "CAMELLIA-192-ECB", "CAMELLIA-192-OFB", "CAMELLIA-256-CBC",
        "CAMELLIA-256-CFB", "CAMELLIA-256-CFB1", "CAMELLIA-256-CFB8", "CAMELLIA-256-ECB",
        "CAMELLIA-256-OFB", "CAMELLIA128", "CAMELLIA192", "CAMELLIA256", "CAST", "CAST-cbc",
        "CAST5-CBC", "CAST5-CFB", "CAST5-ECB", "CAST5-OFB", "ChaCha", "DES", "DES-CBC", "DES-CFB",
        "DES-CFB1", "DES-CFB8", "DES-ECB", "DES-EDE", "DES-EDE-CBC", "DES-EDE-CFB", "DES-EDE-OFB",
        "DES-EDE3", "DES-EDE3-CBC", "DES-EDE3-CFB", "DES-EDE3-CFB1", "DES-EDE3-CFB8",
        "DES-EDE3-OFB", "DES-OFB", "DES3", "DESX", "DESX-CBC", "GOST 28147-89", "IDEA", "IDEA-CBC",
        "IDEA-CFB", "IDEA-ECB", "IDEA-OFB", "RC2", "RC2-40-CBC", "RC2-64-CBC", "RC2-CBC", "RC2-CFB",
        "RC2-ECB", "RC2-OFB", "RC4", "RC4-40", "RC4-HMAC-MD5", "SM4", "SM4-CBC", "SM4-CFB",
        "SM4-CTR", "SM4-ECB", "SM4-OFB", "chacha", "gost89", "gost89-cnt", "gost89-ecb"
      ]
  }

  /**
   * Gets the canonical cipher name in cases where this isn't simply an
   * upcased version of the provided name. This may be because a default block
   * mode is appended, or due to some other normalization.
   */
  private string getSpecialCanonicalCipherName(string name) {
    name = "AES128" and result = "AES-128-CBC"
    or
    name = "AES192" and result = "AES-192-CBC"
    or
    name = "AES256" and result = "AES-256-CBC"
    or
    name = "BF" and result = "BF-CBC"
    or
    name = "CAMELLIA128" and result = "CAMELLIA-128-CBC"
    or
    name = "CAMELLIA192" and result = "CAMELLIA-192-CBC"
    or
    name = "CAMELLIA256" and result = "CAMELLIA-256-CBC"
    or
    name = "CAST" and result = "CAST5-CBC"
    or
    name = "CAST-cbc" and result = "CAST5-CBC"
    or
    name = "ChaCha" and result = "ChaCha"
    or
    name = "DES" and result = "DES-CBC"
    or
    name = "DES3" and result = "DES-EDE3-CBC"
    or
    name = "DESX" and result = "DESX-CBC"
    or
    name = "GOST 28147-89" and result = "gost89"
    or
    name = "IDEA" and result = "IDEA-CBC"
    or
    name = "RC2" and result = "RC2-CBC"
    or
    name = "SM4" and result = "SM4-CBC"
    or
    name = "aes-128-ccm" and result = "id-aes128-CCM"
    or
    name = "aes-128-gcm" and result = "id-aes128-GCM"
    or
    name = "aes-192-ccm" and result = "id-aes192-CCM"
    or
    name = "aes-192-gcm" and result = "id-aes192-GCM"
    or
    name = "aes-256-ccm" and result = "id-aes256-CCM"
    or
    name = "aes-256-gcm" and result = "id-aes256-GCM"
    or
    name = "aes128" and result = "AES-128-CBC"
    or
    name = "aes192" and result = "AES-192-CBC"
    or
    name = "aes256" and result = "AES-256-CBC"
    or
    name = "bf" and result = "BF-CBC"
    or
    name = "blowfish" and result = "BF-CBC"
    or
    name = "camellia128" and result = "CAMELLIA-128-CBC"
    or
    name = "camellia192" and result = "CAMELLIA-192-CBC"
    or
    name = "camellia256" and result = "CAMELLIA-256-CBC"
    or
    name = "cast" and result = "CAST5-CBC"
    or
    name = "cast-cbc" and result = "CAST5-CBC"
    or
    name = "chacha" and result = "ChaCha"
    or
    name = "des" and result = "DES-CBC"
    or
    name = "des3" and result = "DES-EDE3-CBC"
    or
    name = "desx" and result = "DESX-CBC"
    or
    name = "gost89" and result = "gost89"
    or
    name = "gost89-cnt" and result = "gost89-cnt"
    or
    name = "gost89-ecb" and result = "gost89-ecb"
    or
    name = "id-aes128-CCM" and result = "id-aes128-CCM"
    or
    name = "id-aes128-GCM" and result = "id-aes128-GCM"
    or
    name = "id-aes192-CCM" and result = "id-aes192-CCM"
    or
    name = "id-aes192-GCM" and result = "id-aes192-GCM"
    or
    name = "id-aes256-CCM" and result = "id-aes256-CCM"
    or
    name = "id-aes256-GCM" and result = "id-aes256-GCM"
    or
    name = "idea" and result = "IDEA-CBC"
    or
    name = "rc2" and result = "RC2-CBC"
    or
    name = "sm4" and result = "SM4-CBC"
  }

  /**
   * Gets the canonical version of `name`, as reported by `OpenSSL::Cipher#name`.
   * No result if `name` is not a known OpenSSL cipher name.
   */
  string getCanonicalCipherName(string name) {
    isOpenSSLCipher(name) and
    (
      result = getSpecialCanonicalCipherName(name)
      or
      not exists(getSpecialCanonicalCipherName(name)) and
      result = name.toUpperCase()
    )
  }

  /**
   * Holds if `name` is the name of an OpenSSL cipher that is known to be weak.
   */
  predicate isWeakOpenSSLCipher(string name) {
    isOpenSSLCipher(name) and
    name.toUpperCase().regexpMatch(getInsecureAlgorithmRegex())
  }

  /**
   * Holds if `name` is the name of an OpenSSL cipher that is known to be strong.
   */
  predicate isStrongOpenSSLCipher(string name) {
    isOpenSSLCipher(name) and
    name.toUpperCase().regexpMatch(getSecureAlgorithmRegex()) and
    // exclude algorithms that include a weak component
    not name.toUpperCase().regexpMatch(getInsecureAlgorithmRegex())
  }
}

private import Ciphers

/**
 * An OpenSSL cipher.
 */
private newtype TOpenSSLCipher =
  MkOpenSSLCipher(string name, boolean isWeak) {
    isStrongOpenSSLCipher(name) and isWeak = false
    or
    isWeakOpenSSLCipher(name) and isWeak = true
  }

/**
 * A known OpenSSL cipher. This may include information about the block
 * encryption mode, which can affect if the cipher is marked as being weak.
 */
class OpenSSLCipher extends MkOpenSSLCipher {
  string name;
  boolean isWeak;

  OpenSSLCipher() { this = MkOpenSSLCipher(name, isWeak) }

  /**
   * Gets a name of this cipher.
   */
  string getName() { result = name }

  /**
   * Gets a name of this cipher in canonical form.
   */
  string getCanonicalName() { result = getCanonicalCipherName(this.getName()) }

  /** Holds if this algorithm is weak. */
  predicate isWeak() { isWeak = true }

  /** Gets a textual representation of this element. */
  string toString() { result = this.getCanonicalName() }

  /** Holds if the specified name represents this cipher. */
  bindingset[candidateName]
  predicate matchesName(string candidateName) {
    this.getCanonicalName() = getCanonicalCipherName(candidateName)
  }

  /** Gets the encryption algorithm used by this cipher. */
  Cryptography::EncryptionAlgorithm getAlgorithm() { result.matchesName(this.getCanonicalName()) }
}

/** `OpenSSL::Cipher` or `OpenSSL::Cipher::Cipher` */
private API::Node cipherApi() {
  result = API::getTopLevelMember("OpenSSL").getMember("Cipher") or
  result = API::getTopLevelMember("OpenSSL").getMember("Cipher").getMember("Cipher")
}

private class BlockMode extends string {
  BlockMode() { this = ["ECB", "CBC", "GCM", "CCM", "CFB", "OFB", "CTR"] }
}

private newtype TCipherMode =
  TStreamCipher() or
  TBlockMode(BlockMode blockMode)

/**
 * Represents the mode used by this stream cipher.
 * If this cipher uses a block encryption algorithm, then this is a specific
 * block mode.
 */
private class CipherMode extends TCipherMode {
  private BlockMode getBlockMode() { this = TBlockMode(result) }

  /** Gets a textual representation of this node. */
  string toString() {
    result = this.getBlockMode()
    or
    this = TStreamCipher() and result = "<stream cipher>"
  }

  /**
   * Holds if the string `s`, after normalization, represents the block mode
   * used by this cipher.
   */
  bindingset[s]
  predicate isBlockMode(string s) { this.getBlockMode() = s.toUpperCase() }

  /** Holds if this cipher mode is a weak block mode. */
  predicate isWeak() { isWeakBlockMode(this.getBlockMode()) }
}

private string getStringArgument(DataFlow::CallNode call, int i) {
  result = call.getArgument(i).asExpr().getConstantValue().getStringlikeValue()
}

private int getIntArgument(DataFlow::CallNode call, int i) {
  result = call.getArgument(i).asExpr().getConstantValue().getInt()
}

/**
 * Holds if `call` is a call to `OpenSSL::Cipher.new` that instantiates a
 * `cipher` instance with mode `cipherMode`.
 */
private predicate cipherInstantiationGeneric(
  DataFlow::CallNode call, OpenSSLCipher cipher, CipherMode cipherMode
) {
  exists(string cipherName | cipher.matchesName(cipherName) |
    // `OpenSSL::Cipher.new('<cipherName>')`
    call = cipherApi().getAnInstantiation() and
    cipherName = getStringArgument(call, 0) and
    // CBC is used by default
    cipherMode.isBlockMode("CBC")
  )
}

/**
 * Holds if `call` is a call to `OpenSSL::Cipher::AES.new` or
 * `OpenSSL::Cipher::AES{128,192,256}.new` that instantiates an AES `cipher` instance
 * with mode `cipherMode`.
 */
private predicate cipherInstantiationAES(
  DataFlow::CallNode call, OpenSSLCipher cipher, CipherMode cipherMode
) {
  exists(string cipherName | cipher.matchesName(cipherName) |
    // `OpenSSL::Cipher::AES` instantiations
    call = cipherApi().getMember("AES").getAnInstantiation() and
    exists(string keyLength, string blockMode |
      // `OpenSSL::Cipher::AES.new('<keyLength-blockMode>')
      exists(string arg0 |
        arg0 = getStringArgument(call, 0) and
        keyLength = arg0.splitAt("-", 0) and
        blockMode = arg0.splitAt("-", 1).toUpperCase()
      )
      or
      // `OpenSSL::Cipher::AES.new(<keyLength>, '<blockMode>')`
      keyLength = getIntArgument(call, 0).toString() and
      blockMode = getStringArgument(call, 1).toUpperCase()
    |
      cipherName = "AES-" + keyLength + "-" + blockMode and
      cipherMode.isBlockMode(blockMode)
    )
    or
    // Modules for AES with specific key lengths
    exists(string mod, string blockAlgo | mod = ["AES128", "AES192", "AES256"] |
      call = cipherApi().getMember(mod).getAnInstantiation() and
      // Canonical representation is `AES-<keyLength>`
      blockAlgo = "AES-" + mod.suffix(3) and
      exists(string blockMode |
        if exists(getStringArgument(call, 0))
        then
          // `OpenSSL::Cipher::<blockAlgo>.new('<blockMode>')`
          blockMode = getStringArgument(call, 0).toUpperCase()
        else
          // `OpenSSL::Cipher::<blockAlgo>.new` uses CBC by default
          blockMode = "CBC"
      |
        cipherName = blockAlgo + "-" + blockMode and
        cipherMode.isBlockMode(blockMode)
      )
    )
  )
}

/**
 * Holds if `call` is a call that instantiates an OpenSSL cipher using a module
 * specific to a block encryption algorithm, e.g. Blowfish, DES, etc.
 */
private predicate cipherInstantiationSpecific(
  DataFlow::CallNode call, OpenSSLCipher cipher, CipherMode cipherMode
) {
  exists(string cipherName | cipher.matchesName(cipherName) |
    // Block ciphers with dedicated modules
    exists(string blockAlgo | blockAlgo = ["BF", "CAST5", "DES", "IDEA", "RC2"] |
      call = cipherApi().getMember(blockAlgo).getAnInstantiation() and
      exists(string blockMode |
        if exists(getStringArgument(call, 0))
        then
          // `OpenSSL::Cipher::<blockAlgo>.new('<blockMode>')`
          blockMode = getStringArgument(call, 0).toUpperCase()
        else
          // `OpenSSL::Cipher::<blockAlgo>.new` uses CBC by default
          blockMode = "CBC"
      |
        cipherName = blockAlgo + "-" + blockMode and
        cipherMode.isBlockMode(blockMode)
      )
    )
  )
}

/**
 * Holds if `call` is a call to `OpenSSL::Cipher::RC4.new` or an RC4 `cipher`
 * instance with mode `cipherMode`.
 */
private predicate cipherInstantiationRC4(
  DataFlow::CallNode call, OpenSSLCipher cipher, CipherMode cipherMode
) {
  exists(string cipherName | cipher.matchesName(cipherName) |
    // RC4 stream cipher
    call = cipherApi().getMember("RC4").getAnInstantiation() and
    cipherMode = TStreamCipher() and
    (
      if exists(getStringArgument(call, 0))
      then cipherName = "RC4-" + getStringArgument(call, 0).toUpperCase()
      else cipherName = "RC4"
    )
  )
}

/** A call to `OpenSSL::Cipher.new` or similar. */
private class CipherInstantiation extends DataFlow::CallNode {
  private OpenSSLCipher cipher;
  private CipherMode cipherMode;

  CipherInstantiation() {
    cipherInstantiationGeneric(this, cipher, cipherMode) or
    cipherInstantiationAES(this, cipher, cipherMode) or
    cipherInstantiationSpecific(this, cipher, cipherMode) or
    cipherInstantiationRC4(this, cipher, cipherMode)
  }

  /** Gets the `OpenSSLCipher` associated with this instance. */
  OpenSSLCipher getCipher() { result = cipher }

  /** Gets the mode used by this cipher, if applicable. */
  CipherMode getCipherMode() { result = cipherMode }
}

private DataFlow::LocalSourceNode cipherInstance(
  TypeTracker t, OpenSSLCipher cipher, CipherMode cipherMode
) {
  t.start() and
  result.(CipherInstantiation).getCipher() = cipher and
  result.(CipherInstantiation).getCipherMode() = cipherMode
  or
  exists(TypeTracker t2 | result = cipherInstance(t2, cipher, cipherMode).track(t2, t))
}

/** A node with flow from `OpenSSL::Cipher.new`. */
private class CipherNode extends DataFlow::Node {
  private OpenSSLCipher cipher;
  private CipherMode cipherMode;

  CipherNode() { cipherInstance(TypeTracker::end(), cipher, cipherMode).flowsTo(this) }

  /** Gets the cipher associated with this node. */
  OpenSSLCipher getCipher() { result = cipher }

  /** Gets the cipher associated with this node. */
  CipherMode getCipherMode() { result = cipherMode }
}

/** An operation using the OpenSSL library that uses a cipher. */
private class CipherOperation extends Cryptography::CryptographicOperation::Range,
  DataFlow::CallNode {
  private CipherNode cipherNode;
  private DataFlow::Node input;

  CipherOperation() {
    // cipher instantiation is counted as a cipher operation with no input
    cipherNode = this and cipherNode instanceof CipherInstantiation
    or
    this.getReceiver() = cipherNode and
    this.getMethodName() = "update" and
    input = this.getArgument(0)
  }

  override Cryptography::EncryptionAlgorithm getAlgorithm() {
    result = cipherNode.getCipher().getAlgorithm()
  }

  override DataFlow::Node getAnInput() { result = input }

  override predicate isWeak() {
    cipherNode.getCipher().isWeak() or
    cipherNode.getCipherMode().isWeak()
  }
}
