/** Provides classes for working with JSON Web Token (JWT) libraries. */

import java
private import semmle.code.java.dataflow.DataFlow

/** A method access that assigns signing keys to a JWT parser. */
class JwtParserWithInsecureParseSource extends DataFlow::Node {
  JwtParserWithInsecureParseSource() {
    exists(MethodAccess ma, Method m |
      m.getDeclaringType().getAnAncestor() instanceof TypeJwtParser or
      m.getDeclaringType().getAnAncestor() instanceof TypeJwtParserBuilder
    |
      this.asExpr() = ma and
      ma.getMethod() = m and
      m.hasName(["setSigningKey", "setSigningKeyResolver"])
    )
  }
}

/**
 * The qualifier of an insecure parsing method.
 * That is, either the qualifier of a call to the `parse(token)`,
 * `parseClaimsJwt(token)` or `parsePlaintextJwt(token)` methods or
 * the qualifier of a call to a `parse(token, handler)` method
 * where the `handler` is considered insecure.
 */
class JwtParserWithInsecureParseSink extends DataFlow::Node {
  MethodAccess insecureParseMa;

  JwtParserWithInsecureParseSink() {
    insecureParseMa.getQualifier() = this.asExpr() and
    exists(Method m |
      insecureParseMa.getMethod() = m and
      m.getDeclaringType().getAnAncestor() instanceof TypeJwtParser and
      m.hasName(["parse", "parseClaimsJwt", "parsePlaintextJwt"]) and
      (
        m.getNumberOfParameters() = 1
        or
        isInsecureJwtHandler(insecureParseMa.getArgument(1))
      )
    )
  }

  /** Gets the method access that does the insecure parsing. */
  MethodAccess getParseMethodAccess() { result = insecureParseMa }
}

/**
 * A unit class for adding additional flow steps.
 *
 * Extend this class to add additional flow steps that should apply to the `MissingJwtSignatureCheckConf`.
 */
class JwtParserWithInsecureParseAdditionalFlowStep extends Unit {
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/** A set of additional flow steps to consider when working with JWT parsing related data flows. */
private class DefaultJwtParserWithInsecureParseAdditionalFlowStep extends JwtParserWithInsecureParseAdditionalFlowStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    jwtParserStep(node1.asExpr(), node2.asExpr())
  }
}

/** Models the builder style of `JwtParser` and `JwtParserBuilder`. */
private predicate jwtParserStep(Expr parser, MethodAccess ma) {
  (
    parser.getType().(RefType).getASourceSupertype*() instanceof TypeJwtParser or
    parser.getType().(RefType).getASourceSupertype*() instanceof TypeJwtParserBuilder
  ) and
  ma.getQualifier() = parser
}

/**
 * Holds if `parseHandlerExpr` is an insecure `JwtHandler`.
 * That is, it overrides a method from `JwtHandlerOnJwtMethod` and
 * the override is not defined on `JwtHandlerAdapter`.
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

/** The interface `io.jsonwebtoken.JwtParser`. */
private class TypeJwtParser extends Interface {
  TypeJwtParser() { this.hasQualifiedName("io.jsonwebtoken", "JwtParser") }
}

/** The interface `io.jsonwebtoken.JwtParserBuilder`. */
private class TypeJwtParserBuilder extends Interface {
  TypeJwtParserBuilder() { this.hasQualifiedName("io.jsonwebtoken", "JwtParserBuilder") }
}

/** The interface `io.jsonwebtoken.JwtHandler`. */
private class TypeJwtHandler extends Interface {
  TypeJwtHandler() { this.hasQualifiedName("io.jsonwebtoken", "JwtHandler") }
}

/** The class `io.jsonwebtoken.JwtHandlerAdapter`. */
private class TypeJwtHandlerAdapter extends Class {
  TypeJwtHandlerAdapter() { this.hasQualifiedName("io.jsonwebtoken", "JwtHandlerAdapter") }
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
