/**
 * Provides sources and sinks for detecting JWT token signing vulnerabilities.
 */

import java
private import semmle.code.java.dataflow.FlowSources

/** The Java class `com.auth0.jwt.JWT`. */
class Jwt extends RefType {
  Jwt() { this.hasQualifiedName("com.auth0.jwt", "JWT") }
}

/** The Java class `com.auth0.jwt.JWTCreator.Builder`. */
class JwtBuilder extends RefType {
  JwtBuilder() { this.hasQualifiedName("com.auth0.jwt", "JWTCreator$Builder") }
}

/** The Java class `com.auth0.jwt.algorithms.Algorithm`. */
class Algorithm extends RefType {
  Algorithm() { this.hasQualifiedName("com.auth0.jwt.algorithms", "Algorithm") }
}

/**
 * The Java interface `com.auth0.jwt.interfaces.JWTVerifier` or it implementation class
 * `com.auth0.jwt.JWTVerifier`.
 */
class JwtVerifier extends RefType {
  JwtVerifier() {
    this.hasQualifiedName(["com.auth0.jwt", "com.auth0.jwt.interfaces"], "JWTVerifier")
  }
}

/** The secret generation method declared in `com.auth0.jwt.algorithms.Algorithm`. */
class GetSecretMethod extends Method {
  GetSecretMethod() {
    this.getDeclaringType() instanceof Algorithm and
    (
      this.getName().substring(0, 4) = "HMAC" or
      this.getName().substring(0, 5) = "ECDSA" or
      this.getName().substring(0, 3) = "RSA"
    )
  }
}

/** The `require` method of `com.auth0.jwt.JWT`. */
class RequireMethod extends Method {
  RequireMethod() {
    this.getDeclaringType() instanceof Jwt and
    this.hasName("require")
  }
}

/** The `sign` method of `com.auth0.jwt.JWTCreator.Builder`. */
class SignTokenMethod extends Method {
  SignTokenMethod() {
    this.getDeclaringType() instanceof JwtBuilder and
    this.hasName("sign")
  }
}

/** The `verify` method of `com.auth0.jwt.interfaces.JWTVerifier`. */
class VerifyTokenMethod extends Method {
  VerifyTokenMethod() {
    this.getDeclaringType() instanceof JwtVerifier and
    this.hasName("verify")
  }
}

/**
 * A data flow source for JWT token signing vulnerabilities.
 */
abstract class JwtKeySource extends DataFlow::Node { }

/**
 * A data flow sink for JWT token signing vulnerabilities.
 */
abstract class JwtTokenSink extends DataFlow::Node { }

private predicate isTestCode(Expr e) {
  e.getFile().getAbsolutePath().toLowerCase().matches("%test%") and
  not e.getFile().getAbsolutePath().toLowerCase().matches("%ql/test%")
}

/**
 * A hardcoded string literal as a source for JWT token signing vulnerabilities.
 */
class HardcodedKeyStringSource extends JwtKeySource {
  HardcodedKeyStringSource() {
    this.asExpr() instanceof CompileTimeConstantExpr and
    not isTestCode(this.asExpr())
  }
}

/**
 * An expression used to sign JWT tokens as a sink of JWT token signing vulnerabilities.
 */
private class SignTokenSink extends JwtTokenSink {
  SignTokenSink() {
    exists(MethodAccess ma |
      ma.getMethod() instanceof SignTokenMethod and
      this.asExpr() = ma.getArgument(0)
    )
  }
}

/**
 * An expression used to verify JWT tokens as a sink of JWT token signing vulnerabilities.
 */
private class VerifyTokenSink extends JwtTokenSink {
  VerifyTokenSink() {
    exists(MethodAccess ma |
      ma.getMethod() instanceof VerifyTokenMethod and
      this.asExpr() = ma.getQualifier()
    )
  }
}

/**
 * A configuration depicting taint flow for checking JWT token signing vulnerabilities.
 */
class HardcodedJwtKeyConfiguration extends TaintTracking::Configuration {
  HardcodedJwtKeyConfiguration() { this = "Hard-coded JWT Signing Key" }

  override predicate isSource(DataFlow::Node source) { source instanceof JwtKeySource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JwtTokenSink }

  override predicate isAdditionalTaintStep(DataFlow::Node prev, DataFlow::Node succ) {
    exists(MethodAccess ma |
      (
        ma.getMethod() instanceof GetSecretMethod or
        ma.getMethod() instanceof RequireMethod
      ) and
      prev.asExpr() = ma.getArgument(0) and
      succ.asExpr() = ma
    )
  }
}

/** Taint model related to verifying JWT tokens. */
private class VerificationFlowStep extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "com.auth0.jwt.interfaces;Verification;true;build;;;Argument[-1];ReturnValue;taint",
        "com.auth0.jwt.interfaces;Verification;true;" +
          ["acceptLeeway", "acceptExpiresAt", "acceptNotBefore", "acceptIssuedAt", "ignoreIssuedAt"]
          + ";;;Argument[-1];ReturnValue;taint",
        "com.auth0.jwt.interfaces;Verification;true;with" +
          [
            "Issuer", "Subject", "Audience", "AnyOfAudience", "ClaimPresence", "Claim",
            "ArrayClaim", "JWTId"
          ] + ";;;Argument[-1];ReturnValue;taint"
      ]
  }
}
