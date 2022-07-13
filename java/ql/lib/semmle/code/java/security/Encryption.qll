/**
 * Provides predicates and classes relating to encryption in Java.
 */

import java

class SSLClass extends RefType {
  SSLClass() {
    exists(Class c | this.getAnAncestor() = c |
      c.hasQualifiedName("javax.net.ssl", _) or
      c.hasQualifiedName("javax.rmi.ssl", _)
    )
  }
}

class X509TrustManager extends RefType {
  X509TrustManager() { this.hasQualifiedName("javax.net.ssl", "X509TrustManager") }
}

/** The `javax.net.ssl.HttpsURLConnection` class. */
class HttpsUrlConnection extends RefType {
  HttpsUrlConnection() { this.hasQualifiedName("javax.net.ssl", "HttpsURLConnection") }
}

/** DEPRECATED: Alias for HttpsUrlConnection */
deprecated class HttpsURLConnection = HttpsUrlConnection;

class SSLSocketFactory extends RefType {
  SSLSocketFactory() { this.hasQualifiedName("javax.net.ssl", "SSLSocketFactory") }
}

class SSLContext extends RefType {
  SSLContext() { this.hasQualifiedName("javax.net.ssl", "SSLContext") }
}

/** The `javax.net.ssl.SSLSession` class. */
class SSLSession extends RefType {
  SSLSession() { this.hasQualifiedName("javax.net.ssl", "SSLSession") }
}

/** The `javax.net.ssl.SSLEngine` class. */
class SSLEngine extends RefType {
  SSLEngine() { this.hasQualifiedName("javax.net.ssl", "SSLEngine") }
}

/** The `javax.net.ssl.SSLSocket` class. */
class SSLSocket extends RefType {
  SSLSocket() { this.hasQualifiedName("javax.net.ssl", "SSLSocket") }
}

/** The `javax.net.ssl.SSLParameters` class. */
class SSLParameters extends RefType {
  SSLParameters() { this.hasQualifiedName("javax.net.ssl", "SSLParameters") }
}

class HostnameVerifier extends RefType {
  HostnameVerifier() { this.hasQualifiedName("javax.net.ssl", "HostnameVerifier") }
}

/** The Java class `javax.crypto.KeyGenerator`. */
class KeyGenerator extends RefType {
  KeyGenerator() { this.hasQualifiedName("javax.crypto", "KeyGenerator") }
}

/** The Java class `java.security.KeyPairGenerator`. */
class KeyPairGenerator extends RefType {
  KeyPairGenerator() { this.hasQualifiedName("java.security", "KeyPairGenerator") }
}

/** The `verify` method of the class `javax.net.ssl.HostnameVerifier`. */
class HostnameVerifierVerify extends Method {
  HostnameVerifierVerify() {
    this.hasName("verify") and
    this.getDeclaringType().getAnAncestor() instanceof HostnameVerifier and
    this.getParameterType(0) instanceof TypeString and
    this.getParameterType(1) instanceof SSLSession
  }
}

class TrustManagerCheckMethod extends Method {
  TrustManagerCheckMethod() {
    (this.hasName("checkClientTrusted") or this.hasName("checkServerTrusted")) and
    this.getDeclaringType().getAnAncestor() instanceof X509TrustManager
  }
}

class CreateSocket extends Method {
  CreateSocket() {
    this.hasName("createSocket") and
    this.getDeclaringType() instanceof SSLSocketFactory
  }
}

class GetSocketFactory extends Method {
  GetSocketFactory() {
    this.hasName("getSocketFactory") and
    this.getDeclaringType() instanceof SSLContext
  }
}

/** The `createSSLEngine` method of the class `javax.net.ssl.SSLContext`. */
class CreateSslEngineMethod extends Method {
  CreateSslEngineMethod() {
    this.hasName("createSSLEngine") and
    this.getDeclaringType() instanceof SSLContext
  }
}

class SetConnectionFactoryMethod extends Method {
  SetConnectionFactoryMethod() {
    this.hasName("setSSLSocketFactory") and
    this.getDeclaringType().getAnAncestor() instanceof HttpsUrlConnection
  }
}

class SetHostnameVerifierMethod extends Method {
  SetHostnameVerifierMethod() {
    this.hasName("setHostnameVerifier") and
    this.getDeclaringType().getAnAncestor() instanceof HttpsUrlConnection
  }
}

/** The `setDefaultHostnameVerifier` method of the class `javax.net.ssl.HttpsURLConnection`. */
class SetDefaultHostnameVerifierMethod extends Method {
  SetDefaultHostnameVerifierMethod() {
    this.hasName("setDefaultHostnameVerifier") and
    this.getDeclaringType().getAnAncestor() instanceof HttpsUrlConnection
  }
}

/** The `beginHandshake` method of the class `javax.net.ssl.SSLEngine`. */
class BeginHandshakeMethod extends Method {
  BeginHandshakeMethod() {
    this.hasName("beginHandshake") and
    this.getDeclaringType().getAnAncestor() instanceof SSLEngine
  }
}

/** The `wrap` method of the class `javax.net.ssl.SSLEngine`. */
class SslWrapMethod extends Method {
  SslWrapMethod() {
    this.hasName("wrap") and
    this.getDeclaringType().getAnAncestor() instanceof SSLEngine
  }
}

/** The `unwrap` method of the class `javax.net.ssl.SSLEngine`. */
class SslUnwrapMethod extends Method {
  SslUnwrapMethod() {
    this.hasName("unwrap") and
    this.getDeclaringType().getAnAncestor() instanceof SSLEngine
  }
}

/** The `getSession` method of the class `javax.net.ssl.SSLSession`. */
class GetSslSessionMethod extends Method {
  GetSslSessionMethod() {
    this.hasName("getSession") and
    this.getDeclaringType().getAnAncestor() instanceof SSLSession
  }
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

/**
 * Gets the name of an algorithm that is known to be insecure.
 */
string getAnInsecureAlgorithmName() {
  result =
    [
      "DES", "RC2", "RC4", "RC5",
      // ARCFOUR is a variant of RC4
      "ARCFOUR",
      // Encryption mode ECB like AES/ECB/NoPadding is vulnerable to replay and other attacks
      "ECB",
      // CBC mode of operation with PKCS#5 or PKCS#7 padding is vulnerable to padding oracle attacks
      "AES/CBC/PKCS[57]Padding"
    ]
}

/**
 * Gets the name of a hash algorithm that is insecure if it is being used for
 * encryption.
 */
string getAnInsecureHashAlgorithmName() {
  result = "SHA1" or
  result = "MD5"
}

private string rankedInsecureAlgorithm(int i) {
  // In this case we know these are being used for encryption, so we want to match
  // weak hash algorithms too.
  result =
    rank[i](string s | s = getAnInsecureAlgorithmName() or s = getAnInsecureHashAlgorithmName())
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
string getInsecureAlgorithmRegex() {
  result = algorithmRegex(insecureAlgorithmString(max(int i | exists(rankedInsecureAlgorithm(i)))))
}

/**
 * Gets the name of an algorithm that is known to be secure.
 */
string getASecureAlgorithmName() {
  result =
    [
      "RSA", "SHA256", "SHA512", "CCM", "GCM", "AES(?![^a-zA-Z](ECB|CBC/PKCS[57]Padding))",
      "Blowfish", "ECIES"
    ]
}

private string rankedSecureAlgorithm(int i) { result = rank[i](getASecureAlgorithmName()) }

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
      m.getDeclaringType() instanceof KeyGenerator and
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
      c.getDeclaringType().hasQualifiedName("java.security", "MessageDigest")
    )
    or
    exists(Method m | m.getAReference() = this |
      m.getDeclaringType().hasQualifiedName("java.security", "MessageDigest") and
      m.getName() = "getInstance"
    )
  }

  override Expr getAlgoSpec() { result = this.(Call).getArgument(0) }
}

class JavaSecuritySignature extends JavaSecurityAlgoSpec {
  JavaSecuritySignature() {
    exists(Constructor c | c.getAReference() = this |
      c.getDeclaringType().getQualifiedName() = "java.security.Signature"
    )
  }

  override Expr getAlgoSpec() { result = this.(ConstructorCall).getArgument(0) }
}

/** A method call to the Java class `java.security.KeyPairGenerator`. */
class JavaSecurityKeyPairGenerator extends JavaxCryptoAlgoSpec {
  JavaSecurityKeyPairGenerator() {
    exists(Method m | m.getAReference() = this |
      m.getDeclaringType() instanceof KeyPairGenerator and
      m.getName() = "getInstance"
    )
  }

  override Expr getAlgoSpec() { result = this.(MethodAccess).getArgument(0) }
}
