/**
 * Provides predicates and classes relating to encryption in Java.
 */

import java

class SslClass extends RefType {
  SslClass() {
    exists(Class c | this.getAnAncestor() = c |
      c.hasQualifiedName("javax.net.ssl", _) or
      c.hasQualifiedName("javax.rmi.ssl", _)
    )
  }
}

/** DEPRECATED: Alias for SslClass */
deprecated class SSLClass = SslClass;

class X509TrustManager extends RefType {
  X509TrustManager() { this.hasQualifiedName("javax.net.ssl", "X509TrustManager") }
}

/** The `javax.net.ssl.HttpsURLConnection` class. */
class HttpsUrlConnection extends RefType {
  HttpsUrlConnection() { this.hasQualifiedName("javax.net.ssl", "HttpsURLConnection") }
}

class SslSocketFactory extends RefType {
  SslSocketFactory() { this.hasQualifiedName("javax.net.ssl", "SSLSocketFactory") }
}

/** DEPRECATED: Alias for SslSocketFactory */
deprecated class SSLSocketFactory = SslSocketFactory;

class SslContext extends RefType {
  SslContext() { this.hasQualifiedName("javax.net.ssl", "SSLContext") }
}

/** DEPRECATED: Alias for SslContext */
deprecated class SSLContext = SslContext;

/** The `javax.net.ssl.SslSession` class. */
class SslSession extends RefType {
  SslSession() { this.hasQualifiedName("javax.net.ssl", "SSLSession") }
}

/** DEPRECATED: Alias for SslSession */
deprecated class SSLSession = SslSession;

/** The `javax.net.ssl.SslEngine` class. */
class SslEngine extends RefType {
  SslEngine() { this.hasQualifiedName("javax.net.ssl", "SSLEngine") }
}

/** DEPRECATED: Alias for SslEngine */
deprecated class SSLEngine = SslEngine;

/** The `javax.net.ssl.SslSocket` class. */
class SslSocket extends RefType {
  SslSocket() { this.hasQualifiedName("javax.net.ssl", "SSLSocket") }
}

/** DEPRECATED: Alias for SslSocket */
deprecated class SSLSocket = SslSocket;

/** The `javax.net.ssl.SslParameters` class. */
class SslParameters extends RefType {
  SslParameters() { this.hasQualifiedName("javax.net.ssl", "SSLParameters") }
}

/** DEPRECATED: Alias for SslParameters */
deprecated class SSLParameters = SslParameters;

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

/** The `init` method declared in `javax.crypto.KeyGenerator`. */
class KeyGeneratorInitMethod extends Method {
  KeyGeneratorInitMethod() {
    this.getDeclaringType() instanceof KeyGenerator and
    this.hasName("init")
  }
}

/** The `initialize` method declared in `java.security.KeyPairGenerator`. */
class KeyPairGeneratorInitMethod extends Method {
  KeyPairGeneratorInitMethod() {
    this.getDeclaringType() instanceof KeyPairGenerator and
    this.hasName("initialize")
  }
}

/** The `verify` method of the class `javax.net.ssl.HostnameVerifier`. */
class HostnameVerifierVerify extends Method {
  HostnameVerifierVerify() {
    this.hasName("verify") and
    this.getDeclaringType().getAnAncestor() instanceof HostnameVerifier and
    this.getParameterType(0) instanceof TypeString and
    this.getParameterType(1) instanceof SslSession
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
    this.getDeclaringType() instanceof SslSocketFactory
  }
}

class GetSocketFactory extends Method {
  GetSocketFactory() {
    this.hasName("getSocketFactory") and
    this.getDeclaringType() instanceof SslContext
  }
}

/** The `createSSLEngine` method of the class `javax.net.ssl.SslContext`. */
class CreateSslEngineMethod extends Method {
  CreateSslEngineMethod() {
    this.hasName("createSSLEngine") and
    this.getDeclaringType() instanceof SslContext
  }
}

/** The `setConnectionFactory` method of the class `javax.net.ssl.HttpsURLConnection`. */
class SetConnectionFactoryMethod extends Method {
  SetConnectionFactoryMethod() {
    this.hasName("setSSLSocketFactory") and
    this.getDeclaringType().getAnAncestor() instanceof HttpsUrlConnection
  }
}

/** The `setDefaultConnectionFactory` method of the class `javax.net.ssl.HttpsURLConnection`. */
class SetDefaultConnectionFactoryMethod extends Method {
  SetDefaultConnectionFactoryMethod() {
    this.hasName("setDefaultSSLSocketFactory") and
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

/** The `beginHandshake` method of the class `javax.net.ssl.SslEngine`. */
class BeginHandshakeMethod extends Method {
  BeginHandshakeMethod() {
    this.hasName("beginHandshake") and
    this.getDeclaringType().getAnAncestor() instanceof SslEngine
  }
}

/** The `wrap` method of the class `javax.net.ssl.SslEngine`. */
class SslWrapMethod extends Method {
  SslWrapMethod() {
    this.hasName("wrap") and
    this.getDeclaringType().getAnAncestor() instanceof SslEngine
  }
}

/** The `unwrap` method of the class `javax.net.ssl.SslEngine`. */
class SslUnwrapMethod extends Method {
  SslUnwrapMethod() {
    this.hasName("unwrap") and
    this.getDeclaringType().getAnAncestor() instanceof SslEngine
  }
}

/** The `getSession` method of the class `javax.net.ssl.SslSession`. */
class GetSslSessionMethod extends Method {
  GetSslSessionMethod() {
    this.hasName("getSession") and
    this.getDeclaringType().getAnAncestor() instanceof SslSession
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
      "RSA", "SHA-?256", "SHA-?512", "CCM", "GCM", "AES(?![^a-zA-Z](ECB|CBC/PKCS[57]Padding))",
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
abstract class CryptoAlgoSpec extends Top instanceof Call {
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

  override Expr getAlgoSpec() { result = this.(MethodCall).getArgument(0) }
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

  override Expr getAlgoSpec() { result = this.(MethodCall).getArgument(0) }
}

class JavaxCryptoKeyAgreement extends JavaxCryptoAlgoSpec {
  JavaxCryptoKeyAgreement() {
    exists(Method m | m.getAReference() = this |
      m.getDeclaringType().getQualifiedName() = "javax.crypto.KeyAgreement" and
      m.getName() = "getInstance"
    )
  }

  override Expr getAlgoSpec() { result = this.(MethodCall).getArgument(0) }
}

class JavaxCryptoKeyFactory extends JavaxCryptoAlgoSpec {
  JavaxCryptoKeyFactory() {
    exists(Method m | m.getAReference() = this |
      m.getDeclaringType().getQualifiedName() = "javax.crypto.SecretKeyFactory" and
      m.getName() = "getInstance"
    )
  }

  override Expr getAlgoSpec() { result = this.(MethodCall).getArgument(0) }
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

/** A call to the `getInstance` method declared in `java.security.KeyPairGenerator`. */
class JavaSecurityKeyPairGenerator extends JavaSecurityAlgoSpec {
  JavaSecurityKeyPairGenerator() {
    exists(Method m | m.getAReference() = this |
      m.getDeclaringType() instanceof KeyPairGenerator and
      m.getName() = "getInstance"
    )
  }

  override Expr getAlgoSpec() { result = this.(MethodCall).getArgument(0) }
}

/** The Java class `java.security.AlgorithmParameterGenerator`. */
class AlgorithmParameterGenerator extends RefType {
  AlgorithmParameterGenerator() {
    this.hasQualifiedName("java.security", "AlgorithmParameterGenerator")
  }
}

/** The `init` method declared in `java.security.AlgorithmParameterGenerator`. */
class AlgoParamGeneratorInitMethod extends Method {
  AlgoParamGeneratorInitMethod() {
    this.getDeclaringType() instanceof AlgorithmParameterGenerator and
    this.hasName("init")
  }
}

/** A call to the `getInstance` method declared in `java.security.AlgorithmParameterGenerator`. */
class JavaSecurityAlgoParamGenerator extends JavaSecurityAlgoSpec {
  JavaSecurityAlgoParamGenerator() {
    exists(Method m | m.getAReference() = this |
      m.getDeclaringType() instanceof AlgorithmParameterGenerator and
      m.getName() = "getInstance"
    )
  }

  override Expr getAlgoSpec() { result = this.(MethodCall).getArgument(0) }
}

/** An implementation of the `java.security.spec.AlgorithmParameterSpec` interface. */
abstract class AlgorithmParameterSpec extends RefType { }

/** The Java class `java.security.spec.ECGenParameterSpec`. */
class EcGenParameterSpec extends AlgorithmParameterSpec {
  EcGenParameterSpec() { this.hasQualifiedName("java.security.spec", "ECGenParameterSpec") }
}

/** The Java class `java.security.spec.RSAKeyGenParameterSpec`. */
class RsaKeyGenParameterSpec extends AlgorithmParameterSpec {
  RsaKeyGenParameterSpec() { this.hasQualifiedName("java.security.spec", "RSAKeyGenParameterSpec") }
}

/** The Java class `java.security.spec.DSAGenParameterSpec`. */
class DsaGenParameterSpec extends AlgorithmParameterSpec {
  DsaGenParameterSpec() { this.hasQualifiedName("java.security.spec", "DSAGenParameterSpec") }
}

/** The Java class `javax.crypto.spec.DHGenParameterSpec`. */
class DhGenParameterSpec extends AlgorithmParameterSpec {
  DhGenParameterSpec() { this.hasQualifiedName("javax.crypto.spec", "DHGenParameterSpec") }
}
