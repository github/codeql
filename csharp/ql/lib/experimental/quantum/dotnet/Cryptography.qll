private import csharp
private import experimental.quantum.Language

// This class models Create calls for the ECDsa and RSA classes in .NET.
class CryptographyCreateCall extends MethodCall {
  CryptographyCreateCall() {
    this.getTarget().getName() = "Create" and
    this.getQualifier().getType().hasFullyQualifiedName("System.Security.Cryptography", _)
  }

  Expr getAlgorithmArg() {
    this.hasNoArguments() and result = this
    or
    result = this.(ECDsaCreateCallWithParameters).getArgument(0)
    or
    result = this.(ECDsaCreateCallWithECCurve).getArgument(0)
  }

  Expr getKeyConsumer() {
    this.hasNoArguments() and result = this
    or
    result = this.(ECDsaCreateCallWithParameters).getArgument(0)
    or
    result = this.(ECDsaCreateCallWithECCurve)
  }

}

class ECDsaCreateCall extends CryptographyCreateCall {
  ECDsaCreateCall() { this.getQualifier().getType().hasName("ECDsa") }
}

class RSACreateCall extends CryptographyCreateCall {
  RSACreateCall() { this.getQualifier().getType().hasName("RSA") }
}

class CryptographyType extends Type {
  CryptographyType() { this.hasFullyQualifiedName("System.Security.Cryptography", _) }
}

class ECParameters extends CryptographyType {
  ECParameters() { this.hasName("ECParameters") }
}

class RSAParameters extends CryptographyType {
  RSAParameters() { this.hasName("RSAParameters") }
}

class ECCurve extends CryptographyType {
  ECCurve() { this.hasName("ECCurve") }
}

// This class is used to model the `ECDsa.Create(ECParameters)` call
class ECDsaCreateCallWithParameters extends ECDsaCreateCall {
  ECDsaCreateCallWithParameters() { this.getArgument(0).getType() instanceof ECParameters }
}

class ECDsaCreateCallWithECCurve extends ECDsaCreateCall {
  ECDsaCreateCallWithECCurve() { this.getArgument(0).getType() instanceof ECCurve }
}

class SigningNamedCurvePropertyAccess extends PropertyAccess {
  string curveName;

  SigningNamedCurvePropertyAccess() {
    super.getType().getName() = "ECCurve" and
    eccurveNameMapping(super.getProperty().toString().toUpperCase(), curveName)
  }

  string getCurveName() { result = curveName }
}

class HashAlgorithmNameType extends CryptographyType {
  HashAlgorithmNameType() { this.hasName("HashAlgorithmName") }
}

class HashAlgorithmName extends PropertyAccess {
  string algorithmName;

  HashAlgorithmName() {
    this.getType() instanceof HashAlgorithmNameType and
    this.getProperty().getName() = algorithmName
  }

  string getAlgorithmName() { result = algorithmName }

  Crypto::THashType getHashFamily() { hashAlgorithmToFamily(this.getAlgorithmName(), result, _) }

  int getFixedDigestLength() { hashAlgorithmToFamily(this.getAlgorithmName(), _, result) }
}

private predicate hashAlgorithmToFamily(
  string hashName, Crypto::THashType hashFamily, int digestLength
) {
  hashName = "MD5" and hashFamily = Crypto::MD5() and digestLength = 128
  or
  hashName = "SHA1" and hashFamily = Crypto::SHA1() and digestLength = 160
  or
  hashName = "SHA256" and hashFamily = Crypto::SHA2() and digestLength = 256
  or
  hashName = "SHA384" and hashFamily = Crypto::SHA2() and digestLength = 384
  or
  hashName = "SHA512" and hashFamily = Crypto::SHA2() and digestLength = 512
  or
  hashName = "SHA3_256" and hashFamily = Crypto::SHA3() and digestLength = 256
  or
  hashName = "SHA3_384" and hashFamily = Crypto::SHA3() and digestLength = 384
  or
  hashName = "SHA3_512" and hashFamily = Crypto::SHA3() and digestLength = 512
  // Q: is there an idiomatic way to add a default type here?
}

class HashAlgorithmUser extends MethodCall {
  Expr arg;

  HashAlgorithmUser() {
    arg = this.getAnArgument() and
    arg.getType() instanceof HashAlgorithmNameType
  }

  Expr getHashAlgorithmUser() { result = arg }
}

/**
 * Private predicate mapping NIST names to SEC names and leaving all others the same.
 */
bindingset[nist]
private predicate eccurveNameMapping(string nist, string secp) {
  if nist.matches("NIST%")
  then
    nist = "NISTP256" and secp = "secp256r1"
    or
    nist = "NISTP384" and secp = "secp384r1"
    or
    nist = "NISTP521" and secp = "secp521r1"
  else secp = nist
}

// OPERATION INSTANCES
private class ECDsaClass extends CryptographyType {
  ECDsaClass() { this.hasName("ECDsa") }
}

private class RSAClass extends CryptographyType {
  RSAClass() { this.hasName("RSA") }
}

class ByteArrayType extends Type {
  ByteArrayType() { this.getName() = "Byte[]" }
}

class ReadOnlyByteSpanType extends Type {
  ReadOnlyByteSpanType() { this.getName() = "ReadOnlySpan<Byte>" }
}

class DotNetSigner extends MethodCall {
  DotNetSigner() { this.getTarget().getName().matches(["Verify%", "Sign%"]) }

  Expr getMessageArg() {
    // Both Sign and Verify methods take the message as the first argument.
    // Some cases the message is a hash.
    result = this.getArgument(0)
  }

  Expr getSignatureArg() {
    this.isVerifier() and
    (
      result = this.getArgument([1, 3]) and
      (
        result.getType() instanceof ByteArrayType or
        result.getType() instanceof ReadOnlyByteSpanType
      )
    )
  }

  Expr getSignatureOutput() {
    this.isSigner() and
    result = this
  }

  Expr getHashAlgorithmArg() {
    // Get the hash algorithm argument if it has the correct type.
    result = this.getAnArgument() and result.getType() instanceof HashAlgorithmNameType
  }

  predicate isSigner() { this.getTarget().getName().matches("Sign%") }

  predicate isVerifier() { this.getTarget().getName().matches("Verify%") }
}

private class ECDsaSigner extends DotNetSigner {
  ECDsaSigner() { this.getQualifier().getType() instanceof ECDsaClass }
}

private class RSASigner extends DotNetSigner {
  RSASigner() { this.getQualifier().getType() instanceof RSAClass }
}
