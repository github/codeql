/**
 * @name Missing JWT signature check
 * @description Not checking the JWT signature allows an attacker to forge their own tokens.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/missing-jwt-signature-check
 * @tags security
 *       external/cwe/cwe-347
 */

import java
import semmle.code.java.dataflow.DataFlow

/** The interface `io.jsonwebtoken.JwtParser`. */
class TypeJwtParser extends Interface {
  TypeJwtParser() { this.hasQualifiedName("io.jsonwebtoken", "JwtParser") }
}

/** The interface `io.jsonwebtoken.JwtParser` or a type derived from it. */
class TypeDerivedJwtParser extends RefType {
  TypeDerivedJwtParser() { this.getASourceSupertype*() instanceof TypeJwtParser }
}

/** The interface `io.jsonwebtoken.JwtParserBuilder`. */
class TypeJwtParserBuilder extends Interface {
  TypeJwtParserBuilder() { this.hasQualifiedName("io.jsonwebtoken", "JwtParserBuilder") }
}

/** The interface `io.jsonwebtoken.JwtHandler`. */
class TypeJwtHandler extends Interface {
  TypeJwtHandler() { this.hasQualifiedName("io.jsonwebtoken", "JwtHandler") }
}

/** The class `io.jsonwebtoken.JwtHandlerAdapter`. */
class TypeJwtHandlerAdapter extends Class {
  TypeJwtHandlerAdapter() { this.hasQualifiedName("io.jsonwebtoken", "JwtHandlerAdapter") }
}

/** The `parse(token, handler)` method defined in `JwtParser`. */
private class JwtParserParseHandlerMethod extends Method {
  JwtParserParseHandlerMethod() {
    this.hasName("parse") and
    this.getDeclaringType() instanceof TypeJwtParser and
    this.getNumberOfParameters() = 2
  }
}

/** The `parse(token)`, `parseClaimsJwt(token)` and `parsePlaintextJwt(token)` methods defined in `JwtParser`. */
private class JwtParserInsecureParseMethod extends Method {
  JwtParserInsecureParseMethod() {
    this.hasName(["parse", "parseClaimsJwt", "parsePlaintextJwt"]) and
    this.getNumberOfParameters() = 1 and
    this.getDeclaringType() instanceof TypeJwtParser
  }
}

/** The `on(Claims|Plaintext)Jwt` methods defined in `JwtHandler`. */
private class JwtHandlerOnJwtMethod extends Method {
  JwtHandlerOnJwtMethod() {
    this.hasName(["onClaimsJwt", "onPlaintextJwt"]) and
    this.getNumberOfParameters() = 1 and
    this.getDeclaringType() instanceof TypeJwtHandler
  }
}

/** The `on(Claims|Plaintext)Jwt` methods defined in `JwtHandlerAdapter`. */
private class JwtHandlerAdapterOnJwtMethod extends Method {
  JwtHandlerAdapterOnJwtMethod() {
    this.hasName(["onClaimsJwt", "onPlaintextJwt"]) and
    this.getNumberOfParameters() = 1 and
    this.getDeclaringType() instanceof TypeJwtHandlerAdapter
  }
}

/**
 * Holds if `parseHandlerExpr` is an insecure `JwtHandler`.
 * That is, it overrides a method from `JwtHandlerOnJwtMethod` and the override is not defined on `JwtHandlerAdapter`.
 * `JwtHandlerAdapter`'s overrides are safe since they always throw an exception.
 */
private predicate isInsecureJwtHandler(Expr parseHandlerExpr) {
  exists(RefType t |
    parseHandlerExpr.getType() = t and
    t.getASourceSupertype*() instanceof TypeJwtHandler and
    exists(Method m |
      m = t.getAMethod() and
      m.getASourceOverriddenMethod+() instanceof JwtHandlerOnJwtMethod and
      not m.getSourceDeclaration() instanceof JwtHandlerAdapterOnJwtMethod
    )
  )
}

/**
 * An access to an insecure parsing method.
 * That is, either a call to a `parse(token)`, `parseClaimsJwt(token)` or `parsePlaintextJwt(token)` method or
 * a call to a `parse(token, handler)` method where the `handler` is considered insecure.
 */
private class JwtParserInsecureParseMethodAccess extends MethodAccess {
  JwtParserInsecureParseMethodAccess() {
    this.getMethod().getASourceOverriddenMethod*() instanceof JwtParserInsecureParseMethod
    or
    this.getMethod().getASourceOverriddenMethod*() instanceof JwtParserParseHandlerMethod and
    isInsecureJwtHandler(this.getArgument(1))
  }
}

/**
 * Holds if `signingMa` directly or indirectly sets a signing key for `expr`, which is a `JwtParser`.
 * The `setSigningKey` and `setSigningKeyResolver` methods set a signing key for a `JwtParser`.
 * Directly means code like this:
 * ```java
 * Jwts.parser().setSigningKey(key).parse(token);
 * ```
 * Here the signing key is set directly on a `JwtParser`.
 * Indirectly means code like this:
 * ```java
 * Jwts.parserBuilder().setSigningKey(key).build().parse(token);
 * ```
 * In this case, the signing key is set on a `JwtParserBuilder` indirectly setting the key of `JwtParser` that is created by the call to `build`.
 */
private predicate isSigningKeySetter(Expr expr, MethodAccess signingMa) {
  any(SigningToInsecureMethodAccessDataFlow s)
      .hasFlow(DataFlow::exprNode(signingMa), DataFlow::exprNode(expr))
}

/**
 * An expr that is a (sub-type of) `JwtParser` for which a signing key has been set and which is used as
 * the qualifier to a `JwtParserInsecureParseMethodAccess`.
 */
private class JwtParserWithSigningKeyExpr extends Expr {
  MethodAccess signingMa;

  JwtParserWithSigningKeyExpr() {
    this.getType() instanceof TypeDerivedJwtParser and
    isSigningKeySetter(this, signingMa)
  }

  /** Gets the method access that sets the signing key for this parser. */
  MethodAccess getSigningMethodAccess() { result = signingMa }
}

/**
 * Models flow from `SigningKeyMethodAccess`es to qualifiers of `JwtParserInsecureParseMethodAccess`es.
 * This is used to determine whether a `JwtParser` has a signing key set.
 */
private class SigningToInsecureMethodAccessDataFlow extends DataFlow::Configuration {
  SigningToInsecureMethodAccessDataFlow() { this = "SigningToExprDataFlow" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof SigningKeyMethodAccess
  }

  override predicate isSink(DataFlow::Node sink) {
    any(JwtParserInsecureParseMethodAccess ma).getQualifier() = sink.asExpr()
  }

  /** Models the builder style of `JwtParser` and `JwtParserBuilder`. */
  override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    (
      pred.asExpr().getType() instanceof TypeDerivedJwtParser or
      pred.asExpr().getType().(RefType).getASourceSupertype*() instanceof TypeJwtParserBuilder
    ) and
    succ.asExpr().(MethodAccess).getQualifier() = pred.asExpr()
  }
}

/** An access to the `setSigningKey` or `setSigningKeyResolver` method (or an overridden method) defined in `JwtParser` and `JwtParserBuilder`. */
private class SigningKeyMethodAccess extends MethodAccess {
  SigningKeyMethodAccess() {
    exists(Method m |
      m.hasName(["setSigningKey", "setSigningKeyResolver"]) and
      m.getNumberOfParameters() = 1 and
      (
        m.getDeclaringType() instanceof TypeJwtParser or
        m.getDeclaringType() instanceof TypeJwtParserBuilder
      )
    |
      m = this.getMethod().getASourceOverriddenMethod*()
    )
  }
}

/**
 * Holds if the `MethodAccess` `ma` occurs in a test file. A test file is any file that
 * is a direct or indirect child of a directory named `test`, ignoring case.
 */
private predicate isInTestFile(MethodAccess ma) {
  exists(string lowerCasedAbsolutePath |
    lowerCasedAbsolutePath = ma.getLocation().getFile().getAbsolutePath().toLowerCase()
  |
    lowerCasedAbsolutePath.matches("%/test/%") and
    not lowerCasedAbsolutePath
        .matches("%/ql/test/experimental/query-tests/security/CWE-347/%".toLowerCase())
  )
}

from JwtParserInsecureParseMethodAccess ma, JwtParserWithSigningKeyExpr parserExpr
where ma.getQualifier() = parserExpr and not isInTestFile(ma)
select ma, "A signing key is set $@, but the signature is not verified.",
  parserExpr.getSigningMethodAccess(), "here"
