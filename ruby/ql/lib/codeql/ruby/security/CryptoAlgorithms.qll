/**
 * Provides classes modeling cryptographic algorithms, separated into strong and weak variants.
 *
 * The classification into strong and weak are based on Wikipedia, OWASP and google (2017).
 */

/**
 * Names of cryptographic algorithms, separated into strong and weak variants.
 *
 * The names are normalized: upper-case, no spaces, dashes or underscores.
 *
 * The names are inspired by the names used in real world crypto libraries.
 *
 * The classification into strong and weak are based on Wikipedia, OWASP and google (2017).
 */
private module AlgorithmNames {
  predicate isStrongBlockMode(string name) { name = ["CCM", "GCM"] }

  predicate isWeakBlockMode(string name) { name = "ECB" }

  predicate isStrongHashingAlgorithm(string name) {
    name =
      [
        "DSA", "ED25519", "ES256", "ECDSA256", "ES384", "ECDSA384", "ES512", "ECDSA512", "SHA2",
        "SHA224", "SHA256", "SHA384", "SHA512", "SHA3", "SHA3224", "SHA3256", "SHA3384", "SHA3512"
      ]
  }

  predicate isWeakHashingAlgorithm(string name) {
    name =
      [
        "HAVEL128", "MD2", "MD4", "MD5", "PANAMA", "RIPEMD", "RIPEMD128", "RIPEMD256", "RIPEMD160",
        "RIPEMD320", "SHA0", "SHA1"
      ]
  }

  predicate isStrongEncryptionAlgorithm(string name) {
    name =
      [
        "AES", "AES128", "AES192", "AES256", "AES512", "AES-128", "AES-192", "AES-256", "AES-512",
        "RSA", "RABBIT", "BLOWFISH", "BF", "ECIES", "CAST", "CAST5", "CAMELLIA", "CAMELLIA128",
        "CAMELLIA192", "CAMELLIA256", "CAMELLIA-128", "CAMELLIA-192", "CAMELLIA-256", "CHACHA",
        "GOST", "GOST89"
      ]
  }

  predicate isWeakEncryptionAlgorithm(string name) {
    name =
      [
        "DES", "3DES", "DES3", "TRIPLEDES", "DESX", "TDEA", "TRIPLEDEA", "ARC2", "RC2", "ARC4",
        "RC4", "ARCFOUR", "ARC5", "RC5"
      ]
  }

  predicate isStrongPasswordHashingAlgorithm(string name) {
    name = ["ARGON2", "PBKDF2", "BCRYPT", "SCRYPT"]
  }

  predicate isWeakPasswordHashingAlgorithm(string name) { name = "EVPKDF" }
}

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

private module OpenSSL {
  /**
   * A known `OpenSSL::Cipher`. Supported ciphers depend on the version of
   * `OpenSSL` installed on a system. In the general case, a name will include
   * the cipher name, the key length, and the block encryption mode.
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
        "AES-128-CBC", "AES-128-CBC-HMAC-SHA1", "AES-128-CFB", "AES-128-CFB1", "AES-128-CFB8",
        "AES-128-CTR", "AES-128-ECB", "AES-128-OFB", "AES-128-XTS", "AES-192-CBC", "AES-192-CFB",
        "AES-192-CFB1", "AES-192-CFB8", "AES-192-CTR", "AES-192-ECB", "AES-192-OFB", "AES-256-CBC",
        "AES-256-CBC-HMAC-SHA1", "AES-256-CFB", "AES-256-CFB1", "AES-256-CFB8", "AES-256-CTR",
        "AES-256-ECB", "AES-256-OFB", "AES-256-XTS", "AES128", "AES192", "AES256", "BF", "BF-CBC",
        "BF-CFB", "BF-ECB", "BF-OFB", "CAMELLIA-128-CBC", "CAMELLIA-128-CFB", "CAMELLIA-128-CFB1",
        "CAMELLIA-128-CFB8", "CAMELLIA-128-ECB", "CAMELLIA-128-OFB", "CAMELLIA-192-CBC",
        "CAMELLIA-192-CFB", "CAMELLIA-192-CFB1", "CAMELLIA-192-CFB8", "CAMELLIA-192-ECB",
        "CAMELLIA-192-OFB", "CAMELLIA-256-CBC", "CAMELLIA-256-CFB", "CAMELLIA-256-CFB1",
        "CAMELLIA-256-CFB8", "CAMELLIA-256-ECB", "CAMELLIA-256-OFB", "CAMELLIA128", "CAMELLIA192",
        "CAMELLIA256", "CAST", "CAST-cbc", "CAST5-CBC", "CAST5-CFB", "CAST5-ECB", "CAST5-OFB",
        "ChaCha", "DES", "DES-CBC", "DES-CFB", "DES-CFB1", "DES-CFB8", "DES-ECB", "DES-EDE",
        "DES-EDE-CBC", "DES-EDE-CFB", "DES-EDE-OFB", "DES-EDE3", "DES-EDE3-CBC", "DES-EDE3-CFB",
        "DES-EDE3-CFB1", "DES-EDE3-CFB8", "DES-EDE3-OFB", "DES-OFB", "DES3", "DESX", "DESX-CBC",
        "GOST 28147-89", "RC2", "RC2-40-CBC", "RC2-64-CBC", "RC2-CBC", "RC2-CFB", "RC2-ECB",
        "RC2-OFB", "RC4", "RC4-40", "RC4-HMAC-MD5", "aes-128-cbc", "aes-128-cbc-hmac-sha1",
        "aes-128-cfb", "aes-128-cfb1", "aes-128-cfb8", "aes-128-ctr", "aes-128-ecb", "aes-128-gcm",
        "aes-128-ofb", "aes-128-xts", "aes-192-cbc", "aes-192-cfb", "aes-192-cfb1", "aes-192-cfb8",
        "aes-192-ctr", "aes-192-ecb", "aes-192-gcm", "aes-192-ofb", "aes-256-cbc",
        "aes-256-cbc-hmac-sha1", "aes-256-cfb", "aes-256-cfb1", "aes-256-cfb8", "aes-256-ctr",
        "aes-256-ecb", "aes-256-gcm", "aes-256-ofb", "aes-256-xts", "aes128", "aes192", "aes256",
        "bf", "bf-cbc", "bf-cfb", "bf-ecb", "bf-ofb", "blowfish", "camellia-128-cbc",
        "camellia-128-cfb", "camellia-128-cfb1", "camellia-128-cfb8", "camellia-128-ecb",
        "camellia-128-ofb", "camellia-192-cbc", "camellia-192-cfb", "camellia-192-cfb1",
        "camellia-192-cfb8", "camellia-192-ecb", "camellia-192-ofb", "camellia-256-cbc",
        "camellia-256-cfb", "camellia-256-cfb1", "camellia-256-cfb8", "camellia-256-ecb",
        "camellia-256-ofb", "camellia128", "camellia192", "camellia256", "cast", "cast-cbc",
        "cast5-cbc", "cast5-cfb", "cast5-ecb", "cast5-ofb", "chacha", "des", "des-cbc", "des-cfb",
        "des-cfb1", "des-cfb8", "des-ecb", "des-ede", "des-ede-cbc", "des-ede-cfb", "des-ede-ofb",
        "des-ede3", "des-ede3-cbc", "des-ede3-cfb", "des-ede3-cfb1", "des-ede3-cfb8",
        "des-ede3-ofb", "des-ofb", "des3", "desx", "desx-cbc", "gost89", "gost89-cnt", "gost89-ecb",
        "id-aes128-GCM", "id-aes192-GCM", "id-aes256-GCM", "rc2", "rc2-40-cbc", "rc2-64-cbc",
        "rc2-cbc", "rc2-cfb", "rc2-ecb", "rc2-ofb", "rc4", "rc4-40", "rc4-hmac-md5"
      ]
  }

  predicate isWeakOpenSSLCipher(string name) {
    isOpenSSLCipher(name) and
    name.toUpperCase().regexpMatch(getInsecureAlgorithmRegex())
  }

  predicate isStrongOpenSSLCipher(string name) {
    isOpenSSLCipher(name) and
    name.toUpperCase().regexpMatch(getSecureAlgorithmRegex()) and
    // exclude algorithms that include a weak component
    not name.toUpperCase().regexpMatch(getInsecureAlgorithmRegex())
  }
}

private import AlgorithmNames
private import OpenSSL

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
 * A cryptographic algorithm.
 */
private newtype TCryptographicAlgorithm =
  MkHashingAlgorithm(string name, boolean isWeak) {
    isStrongHashingAlgorithm(name) and isWeak = false
    or
    isWeakHashingAlgorithm(name) and isWeak = true
  } or
  MkEncryptionAlgorithm(string name, boolean isWeak) {
    isStrongEncryptionAlgorithm(name) and isWeak = false
    or
    isWeakEncryptionAlgorithm(name) and isWeak = true
  } or
  MkPasswordHashingAlgorithm(string name, boolean isWeak) {
    isStrongPasswordHashingAlgorithm(name) and isWeak = false
    or
    isWeakPasswordHashingAlgorithm(name) and isWeak = true
  } or
  MkOpenSSLCipher(string name, boolean isWeak) {
    isStrongOpenSSLCipher(name) and isWeak = false
    or
    isWeakOpenSSLCipher(name) and isWeak = true
  }

/**
 * A cryptographic algorithm.
 */
abstract class CryptographicAlgorithm extends TCryptographicAlgorithm {
  /** Gets a textual representation of this element. */
  string toString() { result = getName() }

  /**
   * Gets the normalized name of this algorithm (upper-case, no spaces, dashes or underscores).
   */
  abstract string getName();

  /**
   * Holds if the name of this algorithm matches `name` modulo case,
   * white space, dashes, underscores, and anything after a dash in the name
   * (to ignore modes of operation, such as CBC or ECB).
   */
  bindingset[name]
  predicate matchesName(string name) {
    [name.toUpperCase(), name.toUpperCase().regexpCapture("^(\\w+)(?:-.*)?$", 1)]
        .regexpReplaceAll("[-_ ]", "") = getName()
  }

  /**
   * Holds if this algorithm is weak.
   */
  abstract predicate isWeak();
}

/**
 * A hashing algorithm such as `MD5` or `SHA512`.
 */
class HashingAlgorithm extends MkHashingAlgorithm, CryptographicAlgorithm {
  string name;
  boolean isWeak;

  HashingAlgorithm() { this = MkHashingAlgorithm(name, isWeak) }

  override string getName() { result = name }

  override predicate isWeak() { isWeak = true }
}

/**
 * An encryption algorithm such as `DES` or `AES512`.
 */
class EncryptionAlgorithm extends MkEncryptionAlgorithm, CryptographicAlgorithm {
  string name;
  boolean isWeak;

  EncryptionAlgorithm() { this = MkEncryptionAlgorithm(name, isWeak) }

  override string getName() { result = name }

  override predicate isWeak() { isWeak = true }
}

/**
 * A password hashing algorithm such as `PBKDF2` or `SCRYPT`.
 */
class PasswordHashingAlgorithm extends MkPasswordHashingAlgorithm, CryptographicAlgorithm {
  string name;
  boolean isWeak;

  PasswordHashingAlgorithm() { this = MkPasswordHashingAlgorithm(name, isWeak) }

  override string getName() { result = name }

  override predicate isWeak() { isWeak = true }
}

/**
 * A known OpenSSL cipher. This may include information about the block
 * encryption mode, which can affect if the cipher is marked as being weak.
 */
class OpenSSLCipher extends MkOpenSSLCipher, CryptographicAlgorithm {
  string name;
  boolean isWeak;

  OpenSSLCipher() { this = MkOpenSSLCipher(name, isWeak) }

  override string getName() { result = name }

  override predicate isWeak() { isWeak = true }
}
