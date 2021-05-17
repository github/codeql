/** Provides classes for working with JWT libraries. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow

/**
 * An expr that is a (sub-type of) `JwtParser` for which a signing key has been set
 */
class JwtParserWithSigningKeyExpr extends Expr {
  MethodAccess signingMa;

  JwtParserWithSigningKeyExpr() { isSigningKeySetter(this, signingMa) }

  /** Gets the method access that sets the signing key for this parser. */
  MethodAccess getSigningMethodAccess() { result = signingMa }
}

/**
 * The qualifier of an insecure parsing method.
 * That is, either the qualifier of a call to a `parse(token)`, `parseClaimsJwt(token)` or `parsePlaintextJwt(token)` method or
 * the qualifier of a call to a `parse(token, handler)` method where the `handler` is considered insecure.
 */
class JwtParserWithInsecureParseSink extends DataFlow::Node {
  MethodAccess insecureParseMa;

  JwtParserWithInsecureParseSink() {
    insecureParseMa.getQualifier() = this.asExpr() and
    (
      sinkNode(this, "jwt-insecure-parse")
      or
      sinkNode(this, "jwt-insecure-parse-handler") and
      isInsecureJwtHandler(insecureParseMa.getArgument(1))
    )
  }

  /** Gets the method access that does the insecure parsing. */
  MethodAccess getParseMethodAccess() { result = insecureParseMa }
}

/**
 * Holds if `signingMa` directly or indirectly sets a signing key for `expr`, which is a `JwtParser`.
 * The `setSigningKey` and `setSigningKeyResolver` methods set a signing key for a `JwtParser`.
 *
 * Directly means code like this (the signing key is set directly on a `JwtParser`):
 * ```java
 * Jwts.parser().setSigningKey(key).parse(token);
 * ```
 *
 * Indirectly means code like this (the signing key is set on a `JwtParserBuilder` indirectly setting the key of `JwtParser` that is created by the call to `build`):
 * ```java
 * Jwts.parserBuilder().setSigningKey(key).build().parse(token);
 * ```
 */
private predicate isSigningKeySetter(Expr expr, MethodAccess signingMa) {
  any(SigningToInsecureMethodAccessDataFlow s)
      .hasFlow(DataFlow::exprNode(signingMa), DataFlow::exprNode(expr))
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

/** CSV source models representing methods that assign signing keys to a JWT parser. */
private class SigningKeySourceModel extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        "io.jsonwebtoken;JwtParser;true;setSigningKey;;;ReturnValue;jwt-signing-key",
        "io.jsonwebtoken;JwtParser;true;setSigningKeyResolver;;;ReturnValue;jwt-signing-key",
        "io.jsonwebtoken;JwtParserBuilder;true;setSigningKey;;;ReturnValue;jwt-signing-key",
        "io.jsonwebtoken;JwtParserBuilder;true;setSigningKeyResolver;;;ReturnValue;jwt-signing-key"
      ]
  }
}

/** CSV sink models representing qualifiers of methods that parse a JWT insecurely. */
private class InsecureJwtParseSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "io.jsonwebtoken;JwtParser;true;parse;(String);;Argument[-1];jwt-insecure-parse",
        "io.jsonwebtoken;JwtParser;true;parseClaimsJwt;;;Argument[-1];jwt-insecure-parse",
        "io.jsonwebtoken;JwtParser;true;parsePlaintextJwt;;;Argument[-1];jwt-insecure-parse"
      ]
  }
}

/** CSV sink models representing qualifiers of methods that insecurely parse a JWT with a handler */
private class InsecureJwtParseHandlerSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "io.jsonwebtoken;JwtParser;true;parse;(String,JwtHandler<T>);;Argument[-1];jwt-insecure-parse-handler"
      ]
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
 * Models flow from signing keys assignements to qualifiers of JWT insecure parsers.
 * This is used to determine whether a `JwtParser` has a signing key set.
 */
private class SigningToInsecureMethodAccessDataFlow extends DataFlow::Configuration {
  SigningToInsecureMethodAccessDataFlow() { this = "SigningToExprDataFlow" }

  override predicate isSource(DataFlow::Node source) { sourceNode(source, "jwt-signing-key") }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JwtParserWithInsecureParseSink }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    jwtParserStep(node1.asExpr(), node2.asExpr())
  }
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
