private import csharp
private import experimental.quantum.Language
private import FlowAnalysis

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

class HashAlgorithmType extends CryptographyType {
  HashAlgorithmType() {
    this.hasName([
        "MD5",
        "RIPEMD160",
        "SHA1",
        "SHA256",
        "SHA384",
        "SHA512",
        "SHA3_256",
        "SHA3_384",
        "SHA3_512"
      ])
  }
}

// This class models Create calls for the ECDsa and RSA classes in .NET.
class CryptographyCreateCall extends MethodCall {
  CryptographyCreateCall() {
    this.getTarget().getName() = "Create" and
    this.getQualifier().getType() instanceof CryptographyType
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

// This class is used to model the `ECDsa.Create(ECParameters)` call
class ECDsaCreateCallWithParameters extends ECDsaCreateCall {
  ECDsaCreateCallWithParameters() { this.getArgument(0).getType() instanceof ECParameters }
}

class ECDsaCreateCallWithECCurve extends ECDsaCreateCall {
  ECDsaCreateCallWithECCurve() { this.getArgument(0).getType() instanceof ECCurve }
}

class RSACreateCall extends CryptographyCreateCall {
  RSACreateCall() { this.getQualifier().getType().hasName("RSA") }
}

class SigningCreateCall extends CryptographyCreateCall {
  SigningCreateCall() {
    this instanceof ECDsaCreateCall or
    this instanceof RSACreateCall
  }
}

class HashAlgorithmCreateCall extends CryptographyCreateCall {
  HashAlgorithmCreateCall() { this.getQualifier().getType() instanceof HashAlgorithmType }
}

class NamedCurvePropertyAccess extends PropertyAccess {
  string curveName;

  NamedCurvePropertyAccess() {
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

  Crypto::THashType getHashFamily() {
    if hashAlgorithmToFamily(this.getAlgorithmName(), _, _)
    then hashAlgorithmToFamily(this.getAlgorithmName(), result, _)
    else result = Crypto::OtherHashType()
  }

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
  // TODO: is there an idiomatic way to add a default type here?
}

class HashAlgorithmNameUser extends MethodCall {
  Expr arg;

  HashAlgorithmNameUser() {
    arg = this.getAnArgument() and
    arg.getType() instanceof HashAlgorithmNameType
  }

  Expr getHashAlgorithmNameUser() { result = arg }
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

private class SignerType extends Type {
  SignerType() {
    this instanceof ECDsaClass or
    this instanceof RSAClass
  }
}

class ByteArrayType extends Type {
  ByteArrayType() { this.getName() = "Byte[]" }
}

class ReadOnlyByteSpanType extends Type {
  ReadOnlyByteSpanType() { this.getName() = "ReadOnlySpan<Byte>" }
}

class ByteArrayOrReadOnlyByteSpanType extends Type {
  ByteArrayOrReadOnlyByteSpanType() {
    this instanceof ByteArrayType or
    this instanceof ReadOnlyByteSpanType
  }
}

class HashUse extends MethodCall {
  HashUse() {
    this.getQualifier().getType() instanceof HashAlgorithmType and
    this.getTarget()
        .getName()
        .matches([
            "ComputeHash", "ComputeHashAsync", "HashCore", "HashData", "HashDataAsync",
            "TransformBlock", "TransformFinalBlock", "TryComputeHash", "TryHashData",
            "TryHashFinal", "HashFinal"
          ])
  }

  predicate isIntermediate() { this.getTarget().hasName("HashCore") }

  Expr getOutputArtifact() {
    not this.isIntermediate() and
    // some functions receive the destination as a parameter
    if
      this.getTarget().getName() = ["TryComputeHash", "TryHashFinal", "TryHashData"]
      or
      this.getTarget().getName() = ["HashData"] and this.getNumberOfArguments() = 2
      or
      this.getTarget().getName() = ["HashDataAsync"] and this.getNumberOfArguments() = 3
    then result = this.getArgument(1)
    else result = this
  }

  Expr getInputArg() {
    result = this.getAnArgument() and result.getType() instanceof ByteArrayOrReadOnlyByteSpanType
  }
  // Expr getStreamArg() {
  //   result = this.getAnArgument() and
  //   result.getType() instanceof Stream
  // }
}

class SignerUse extends MethodCall {
  SignerUse() {
    this.getTarget().getName().matches(["Verify%", "Sign%"]) and
    this.getQualifier().getType() instanceof SignerType
  }

  Expr getMessageArg() {
    // Both Sign and Verify methods take the message as the first argument.
    // Some cases the message is a hash.
    result = this.getArgument(0)
  }

  Expr getSignatureArg() {
    this.isVerifier() and
    (
      result = this.getArgument([1, 3]) and
      result.getType() instanceof ByteArrayOrReadOnlyByteSpanType
    )
  }

  predicate isIntermediate() { none() }

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

private class ECDsaSigner extends SignerUse {
  ECDsaSigner() { this.getQualifier().getType() instanceof ECDsaClass }
}

private class RSASigner extends SignerUse {
  RSASigner() { this.getQualifier().getType() instanceof RSAClass }
}
