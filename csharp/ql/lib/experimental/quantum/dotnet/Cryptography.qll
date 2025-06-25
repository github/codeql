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

/**
 * A call to create on an hash algorithm instance.
 * The hash algorithm is defined by the qualifier.
 */
class HashAlgorithmCreateCall extends Crypto::AlgorithmValueConsumer instanceof CryptographyCreateCall
{
  HashAlgorithmCreateCall() { super.getQualifier().getType() instanceof HashAlgorithmType }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() { result = super.getQualifier() }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }
}

class HashAlgorithmQualifier extends Crypto::HashAlgorithmInstance instanceof Expr {
  HashAlgorithmQualifier() {
    this = any(HashAlgorithmCreateCall c).(CryptographyCreateCall).getQualifier()
  }

  override Crypto::THashType getHashFamily() {
    result = getHashFamily(this.getRawHashAlgorithmName())
  }

  override string getRawHashAlgorithmName() { result = super.getType().getName() }

  override int getFixedDigestLength() {
    hashAlgorithmToFamily(this.getRawHashAlgorithmName(), _, result)
  }
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

  Crypto::THashType getHashFamily() { result = getHashFamily(this.getAlgorithmName()) }

  int getFixedDigestLength() { hashAlgorithmToFamily(this.getAlgorithmName(), _, result) }
}

bindingset[name]
Crypto::THashType getHashFamily(string name) {
  if hashAlgorithmToFamily(name, _, _)
  then hashAlgorithmToFamily(name, result, _)
  else result = Crypto::OtherHashType()
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

class HashUse extends Crypto::AlgorithmValueConsumer instanceof MethodCall {
  HashUse() {
    this.getQualifier().getType() instanceof HashAlgorithmType and
    this.getTarget()
        .hasName([
            "ComputeHash", "ComputeHashAsync", "HashCore", "HashData", "HashDataAsync",
            "TransformBlock", "TransformFinalBlock", "TryComputeHash", "TryHashData",
            "TryHashFinal", "HashFinal"
          ])
  }

  predicate isIntermediate() { super.getTarget().hasName("HashCore") }

  Expr getOutput() {
    not this.isIntermediate() and
    // some functions receive the destination as a parameter
    if
      super.getTarget().getName() = ["TryComputeHash", "TryHashFinal", "TryHashData"]
      or
      super.getTarget().getName() = ["HashData"] and super.getNumberOfArguments() = 2
      or
      super.getTarget().getName() = ["HashDataAsync"] and super.getNumberOfArguments() = 3
    then result = super.getArgument(1)
    else result = this
  }

  Expr getInputArg() {
    result = super.getArgument(0) and result.getType() instanceof ByteArrayOrReadOnlyByteSpanType
  }

  Expr getStreamArg() {
    result = super.getAnArgument() and
    result.getType() instanceof Stream
  }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() { result = super.getQualifier() }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }
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

class AesMode extends Class {
  AesMode() { this.hasFullyQualifiedName("System.Security.Cryptography", ["AesGcm", "AesCcm"]) }
}

class AesModeCreation extends ObjectCreation {
  AesModeCreation() { this.getObjectType() instanceof AesMode }

  Expr getKeyArg() { result = this.getArgument(0) }
}

class AesModeUse extends MethodCall {
  AesModeUse() {
    this.getQualifier().getType() instanceof AesMode and
    this.getTarget().hasName(["Encrypt", "Decrypt"])
  }

  // One-shot API only.
  predicate isIntermediate() { none() }

  Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    if this.isEncrypt()
    then result = Crypto::TEncryptMode()
    else
      if this.isDecrypt()
      then result = Crypto::TDecryptMode()
      else result = Crypto::TUnknownKeyOperationMode()
  }

  predicate isEncrypt() { this.getTarget().getName() = "Encrypt" }

  predicate isDecrypt() { this.getTarget().getName() = "Decrypt" }

  Expr getNonceArg() { result = this.getArgument(0) }

  Expr getMessageArg() { result = this.getArgument(1) }

  Expr getOutputArg() {
    this.isEncrypt() and
    result = this.getArgument(2)
    or
    this.isDecrypt() and
    result = this.getArgument(3)
  }
}

/**
 * A symmetric algorithm class, such as AES or DES.
 */
class SymmetricAlgorithm extends Class {
  SymmetricAlgorithm() {
    this.getABaseType().hasFullyQualifiedName("System.Security.Cryptography", "SymmetricAlgorithm")
  }

  CryptoTransformCreation getCreateTransformCall() { result = this.getAMethod().getACall() }
}

/**
 * A symmetric algorithm creation, such as `Aes.Create()`.
 */
class SymmetricAlgorithmCreation extends MethodCall {
  SymmetricAlgorithmCreation() {
    this.getTarget().hasName("Create") and
    this.getQualifier().getType() instanceof SymmetricAlgorithm
  }

  SymmetricAlgorithm getSymmetricAlgorithm() { result = this.getQualifier().getType() }
}

class SymmetricAlgorithmUse extends QualifiableExpr {
  SymmetricAlgorithmUse() {
    this.getQualifier().getType() instanceof SymmetricAlgorithm and
    this.getQualifiedDeclaration()
        .hasName(["CreateEncryptor", "CreateDecryptor", "Key", "IV", "Padding", "Mode"])
  }

  Expr getSymmetricAlgorithm() { result = this.getQualifier() }

  predicate isIntermediate() {
    not this.getQualifiedDeclaration().hasName(["CreateEncryptor", "CreateDecryptor"])
  }

  // The key may be set by assigning it to the `Key` property of the symmetric algorithm.
  predicate isKeyConsumer() {
    this instanceof PropertyWrite and this.getQualifiedDeclaration().getName() = "Key"
  }

  // The IV may be set by assigning it to the `IV` property of the symmetric algorithm.
  predicate isIvConsumer() {
    this instanceof PropertyWrite and this.getQualifiedDeclaration().getName() = "IV"
  }

  // The padding mode may be set by assigning it to the `Padding` property of the symmetric algorithm.
  predicate isPaddingConsumer() {
    this instanceof PropertyWrite and this.getQualifiedDeclaration().getName() = "Padding"
  }

  // The cipher mode may be set by assigning it to the `Mode` property of the symmetric algorithm.
  predicate isModeConsumer() {
    this instanceof PropertyWrite and this.getQualifiedDeclaration().getName() = "Mode"
  }
}

/**
 * A call to `CreateEncryptor` or `CreateDecryptor` on a `SymmetricAlgorithm`.
 */
class CryptoTransformCreation extends MethodCall {
  CryptoTransformCreation() {
    this.getTarget().hasName(["CreateEncryptor", "CreateDecryptor"]) and
    this.getQualifier().getType() instanceof SymmetricAlgorithm
  }

  predicate isEncryptor() { this.getTarget().getName() = "CreateEncryptor" }

  predicate isDecryptor() { this.getTarget().getName() = "CreateDecryptor" }

  Expr getKeyArg() { result = this.getArgument(0) }

  Expr getIvArg() { result = this.getArgument(1) }

  SymmetricAlgorithm getSymmetricAlgorithm() { result = this.getQualifier().getType() }
}

class CryptoStream extends Class {
  CryptoStream() { this.hasFullyQualifiedName("System.Security.Cryptography", "CryptoStream") }
}

class CryptoStreamMode extends MemberConstant {
  CryptoStreamMode() {
    this.getDeclaringType()
        .hasFullyQualifiedName("System.Security.Cryptography", "CryptoStreamMode")
  }

  predicate isRead() { this.getName() = "Read" }

  predicate isWrite() { this.getName() = "Write" }
}

class PaddingMode extends MemberConstant {
  PaddingMode() {
    this.getDeclaringType().hasFullyQualifiedName("System.Security.Cryptography", "PaddingMode")
  }
}

class CipherMode extends MemberConstant {
  CipherMode() {
    this.getDeclaringType().hasFullyQualifiedName("System.Security.Cryptography", "CipherMode")
  }
}

class Stream extends Class {
  Stream() { this.getABaseType().hasFullyQualifiedName("System.IO", "Stream") }
}

/**
 * A `Stream` object creation.
 */
class StreamCreation extends ObjectCreation {
  StreamCreation() { this.getObjectType() instanceof Stream }

  Expr getInputArg() {
    result = this.getAnArgument() and
    result.getType().hasFullyQualifiedName("System", "Byte[]")
  }

  Expr getStreamArg() {
    result = this.getAnArgument() and
    result.getType() instanceof Stream
  }
}

class StreamUse extends MethodCall {
  StreamUse() {
    this.getQualifier().getType() instanceof Stream and
    this.getTarget().hasName(["ToArray", "Write"])
  }

  predicate isIntermediate() { this.getTarget().hasName("Write") }

  Expr getInputArg() {
    this.isIntermediate() and
    result = this.getArgument(0)
  }

  Expr getOutput() {
    not this.isIntermediate() and
    result = this
  }
}

class CryptoStreamCreation extends ObjectCreation {
  CryptoStreamCreation() { this.getObjectType() instanceof CryptoStream }

  Expr getStreamArg() { result = this.getArgument(0) }

  Expr getTransformArg() { result = this.getArgument(1) }

  Expr getModeArg() { result = this.getArgument(2) }

  Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    if CryptoTransformFlow::getCreationFromUse(this.getTransformArg()).isEncryptor()
    then result = Crypto::TEncryptMode()
    else
      if CryptoTransformFlow::getCreationFromUse(this.getTransformArg()).isDecryptor()
      then result = Crypto::TDecryptMode()
      else result = Crypto::TUnknownKeyOperationMode()
  }
}

class CryptoStreamUse extends MethodCall {
  CryptoStreamUse() {
    this.getQualifier().getType() instanceof CryptoStream and
    this.getTarget().hasName(["Write", "FlushFinalBlock", "FlushFinalBlockAsync", "Close"])
  }

  predicate isIntermediate() { this.getTarget().getName() = "Write" }

  Expr getInputArg() {
    this.isIntermediate() and
    result = this.getArgument(0)
  }
}
