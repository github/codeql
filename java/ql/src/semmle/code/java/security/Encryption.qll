import java

class SSLClass extends RefType {
  SSLClass() {
    exists(Class c | this.getASupertype*() = c |
      c.hasQualifiedName("javax.net.ssl", _) or
      c.hasQualifiedName("javax.rmi.ssl", _)
    )
  }
}

class X509TrustManager extends RefType {
  X509TrustManager() { this.hasQualifiedName("javax.net.ssl", "X509TrustManager") }
}

class HttpsURLConnection extends RefType {
  HttpsURLConnection() { hasQualifiedName("javax.net.ssl", "HttpsURLConnection") }
}

class SSLSocketFactory extends RefType {
  SSLSocketFactory() { this.hasQualifiedName("javax.net.ssl", "SSLSocketFactory") }
}

class SSLContext extends RefType {
  SSLContext() { hasQualifiedName("javax.net.ssl", "SSLContext") }
}

class HostnameVerifier extends RefType {
  HostnameVerifier() { hasQualifiedName("javax.net.ssl", "HostnameVerifier") }
}

class HostnameVerifierVerify extends Method {
  HostnameVerifierVerify() {
    hasName("verify") and getDeclaringType().getASupertype*() instanceof HostnameVerifier
  }
}

class TrustManagerCheckMethod extends Method {
  TrustManagerCheckMethod() {
    (this.hasName("checkClientTrusted") or this.hasName("checkServerTrusted")) and
    this.getDeclaringType().getASupertype*() instanceof X509TrustManager
  }
}

class CreateSocket extends Method {
  CreateSocket() {
    hasName("createSocket") and
    getDeclaringType() instanceof SSLSocketFactory
  }
}

class GetSocketFactory extends Method {
  GetSocketFactory() {
    hasName("getSocketFactory") and
    getDeclaringType() instanceof SSLContext
  }
}

class SetConnectionFactoryMethod extends Method {
  SetConnectionFactoryMethod() {
    hasName("setSSLSocketFactory") and
    getDeclaringType().getASupertype*() instanceof HttpsURLConnection
  }
}

class SetHostnameVerifierMethod extends Method {
  SetHostnameVerifierMethod() {
    hasName("setHostnameVerifier") and
    getDeclaringType().getASupertype*() instanceof HttpsURLConnection
  }
}

bindingset[algorithmString]
private string algorithmRegex(string algorithmString) {
  // Algorithms usually appear in names surrounded by characters that are not
  // alphabetical characters in the same case. This handles the upper and lower
  // case cases.
  result = "((^|.*[^A-Z])(" + algorithmString + ")([^A-Z].*|$))" +
      // or...
      "|" +
      // For lowercase, we want to be careful to avoid being confused by camelCase
      // hence we require two preceding uppercase letters to be sure of a case switch,
      // or a preceding non-alphabetic character
      "((^|.*[A-Z]{2}|.*[^a-zA-Z])(" + algorithmString.toLowerCase() + ")([^a-z].*|$))"
}

/** Gets a blacklist of algorithms that are known to be insecure. */
private string algorithmBlacklist() {
  result = "DES" or
  result = "RC2" or
  result = "RC4" or
  result = "RC5" or
  result = "ARCFOUR" // a variant of RC4
}

// These are only bad if they're being used for encryption.
private string hashAlgorithmBlacklist() {
  result = "SHA1" or
  result = "MD5"
}

private string rankedAlgorithmBlacklist(int i) {
  // In this case we know these are being used for encryption, so we want to match
  // weak hash algorithms too.
  result = rank[i](string s | s = algorithmBlacklist() or s = hashAlgorithmBlacklist())
}

private string algorithmBlacklistString(int i) {
  i = 1 and result = rankedAlgorithmBlacklist(i)
  or
  result = rankedAlgorithmBlacklist(i) + "|" + algorithmBlacklistString(i - 1)
}

/** Gets a regex for matching strings that look like they contain a blacklisted algorithm. */
string algorithmBlacklistRegex() {
  result = algorithmRegex(algorithmBlacklistString(max(int i | exists(rankedAlgorithmBlacklist(i)))))
}

/** Gets a whitelist of algorithms that are known to be secure. */
private string algorithmWhitelist() {
  result = "RSA" or
  result = "SHA256" or
  result = "SHA512" or
  result = "CCM" or
  result = "GCM" or
  result = "AES" or
  result = "Blowfish" or
  result = "ECIES"
}

private string rankedAlgorithmWhitelist(int i) { result = rank[i](algorithmWhitelist()) }

private string algorithmWhitelistString(int i) {
  i = 1 and result = rankedAlgorithmWhitelist(i)
  or
  result = rankedAlgorithmWhitelist(i) + "|" + algorithmWhitelistString(i - 1)
}

/** Gets a regex for matching strings that look like they contain a whitelisted algorithm. */
string algorithmWhitelistRegex() {
  result = algorithmRegex(algorithmWhitelistString(max(int i | exists(rankedAlgorithmWhitelist(i)))))
}

/**
 * Any use of a cryptographic element that specifies an encryption
 * algorithm. For example, methods returning ciphers, decryption methods,
 * constructors of cipher classes, etc.
 */
abstract class CryptoAlgoSpec extends Top {
  CryptoAlgoSpec() { this instanceof Call }

  abstract Expr getAlgoSpec();
}

abstract class JavaxCryptoAlgoSpec extends CryptoAlgoSpec { }

class JavaxCryptoCipher extends JavaxCryptoAlgoSpec {
  JavaxCryptoCipher() {
    exists(Method m | m.getAReference() = this |
      m.getDeclaringType().getQualifiedName() = "javax.crypto.Cipher" and
      m.getName() = "getInstance"
    )
  }

  override Expr getAlgoSpec() { result = this.(MethodAccess).getArgument(0) }
}

class JavaxCryptoSecretKey extends JavaxCryptoAlgoSpec {
  JavaxCryptoSecretKey() {
    exists(Constructor c | c.getAReference() = this |
      c.getDeclaringType().getQualifiedName() = "javax.crypto.spec.SecretKeySpec"
    )
  }

  override Expr getAlgoSpec() {
    exists(ConstructorCall c | c = this |
      if c.getNumArgument() = 2 then result = c.getArgument(1) else result = c.getArgument(3)
    )
  }
}

class JavaxCryptoKeyGenerator extends JavaxCryptoAlgoSpec {
  JavaxCryptoKeyGenerator() {
    exists(Method m | m.getAReference() = this |
      m.getDeclaringType().getQualifiedName() = "javax.crypto.KeyGenerator" and
      m.getName() = "getInstance"
    )
  }

  override Expr getAlgoSpec() { result = this.(MethodAccess).getArgument(0) }
}

class JavaxCryptoKeyAgreement extends JavaxCryptoAlgoSpec {
  JavaxCryptoKeyAgreement() {
    exists(Method m | m.getAReference() = this |
      m.getDeclaringType().getQualifiedName() = "javax.crypto.KeyAgreement" and
      m.getName() = "getInstance"
    )
  }

  override Expr getAlgoSpec() { result = this.(MethodAccess).getArgument(0) }
}

class JavaxCryptoKeyFactory extends JavaxCryptoAlgoSpec {
  JavaxCryptoKeyFactory() {
    exists(Method m | m.getAReference() = this |
      m.getDeclaringType().getQualifiedName() = "javax.crypto.SecretKeyFactory" and
      m.getName() = "getInstance"
    )
  }

  override Expr getAlgoSpec() { result = this.(MethodAccess).getArgument(0) }
}

abstract class JavaSecurityAlgoSpec extends CryptoAlgoSpec { }

class JavaSecurityMessageDigest extends JavaSecurityAlgoSpec {
  JavaSecurityMessageDigest() {
    exists(Constructor c | c.getAReference() = this |
      c.getDeclaringType().getQualifiedName() = "java.security.MessageDigest"
    )
  }

  override Expr getAlgoSpec() { result = this.(ConstructorCall).getArgument(0) }
}

class JavaSecuritySignature extends JavaSecurityAlgoSpec {
  JavaSecuritySignature() {
    exists(Constructor c | c.getAReference() = this |
      c.getDeclaringType().getQualifiedName() = "java.security.Signature"
    )
  }

  override Expr getAlgoSpec() { result = this.(ConstructorCall).getArgument(0) }
}
