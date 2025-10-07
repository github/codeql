deprecated module;

import java

class PayloadType extends RefType {
  PayloadType() { this.hasQualifiedName("com.auth0.jwt.interfaces", "Payload") }
}

class JwtType extends RefType {
  JwtType() { this.hasQualifiedName("com.auth0.jwt", "JWT") }
}

class JwtVerifierType extends RefType {
  JwtVerifierType() { this.hasQualifiedName("com.auth0.jwt", "JWTVerifier") }
}

/**
 * A Method that returns a Decoded Claim of JWT
 */
class GetPayload extends MethodCall {
  GetPayload() {
    this.getCallee().getDeclaringType() instanceof PayloadType and
    this.getCallee().hasName(["getClaim", "getIssuedAt"])
  }
}

/**
 * A Method that Decode JWT without signature verification
 */
class Decode extends MethodCall {
  Decode() {
    this.getCallee().getDeclaringType() instanceof JwtType and
    this.getCallee().hasName("decode")
  }
}

/**
 * A Method that Decode JWT with signature verification
 */
class Verify extends MethodCall {
  Verify() {
    this.getCallee().getDeclaringType() instanceof JwtVerifierType and
    this.getCallee().hasName("verify")
  }
}
