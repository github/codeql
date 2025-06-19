private import csharp

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
private class ECDsaClass extends Type {
  ECDsaClass() { this.hasFullyQualifiedName("System.Security.Cryptography", "ECDsa") }
}

private class RSAClass extends Type {
  RSAClass() { this.hasFullyQualifiedName("System.Security.Cryptography", "RSA") }
}

// TODO
// class ByteArrayTypeUnionReadOnlyByteSpan extends ArrayType {
//   ByteArrayTypeUnionReadOnlyByteSpan() {
//     this.hasFullyQualifiedName("System", "Byte[]") or
//     this.hasFullyQualifiedName("System", "ReadOnlySpan`1") or
//   }
// }
abstract class DotNetSigner extends MethodCall {
  DotNetSigner() { this.getTarget().getName().matches(["Verify%", "Sign%"]) }

  Expr getMessageArg() {
    // Both Sign and Verify methods take the message as the first argument.
    // Some cases the message is a hash.
    result = this.getArgument(0)
  }

  Expr getSignatureArg() {
    this.isVerifier() and
    // TODO: Should replace getAChild* with the proper two types byte[] and ReadOnlySpan<byte>
    (result = this.getArgument([1, 3]) and result.getType().getAChild*() instanceof ByteType)
  }

  Expr getSignatureOutput() {
    this.isSigner() and
    result = this
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
