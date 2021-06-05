/**
 * Provides classes for working with the jjwt framework.
 */

import java

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
class JwtParserParseHandlerMethod extends Method {
  JwtParserParseHandlerMethod() {
    this.hasName("parse") and
    this.getDeclaringType() instanceof TypeJwtParser and
    this.getNumberOfParameters() = 2
  }
}

/** The `parse(token)`, `parseClaimsJwt(token)` and `parsePlaintextJwt(token)` methods defined in `JwtParser`. */
class JwtParserInsecureParseMethod extends Method {
  JwtParserInsecureParseMethod() {
    this.hasName(["parse", "parseClaimsJwt", "parsePlaintextJwt"]) and
    this.getNumberOfParameters() = 1 and
    this.getDeclaringType() instanceof TypeJwtParser
  }
}

/** The `on(Claims|Plaintext)Jwt` methods defined in `JwtHandler`. */
class JwtHandlerOnJwtMethod extends Method {
  JwtHandlerOnJwtMethod() {
    this.hasName(["onClaimsJwt", "onPlaintextJwt"]) and
    this.getNumberOfParameters() = 1 and
    this.getDeclaringType() instanceof TypeJwtHandler
  }
}

/** The `on(Claims|Plaintext)Jwt` methods defined in `JwtHandlerAdapter`. */
class JwtHandlerAdapterOnJwtMethod extends Method {
  JwtHandlerAdapterOnJwtMethod() {
    this.hasName(["onClaimsJwt", "onPlaintextJwt"]) and
    this.getNumberOfParameters() = 1 and
    this.getDeclaringType() instanceof TypeJwtHandlerAdapter
  }
}

/** The interface `io.jsonwebtoken.JwtParserBuilder` or a type derived from it. */
class TypeDerivedJwtParserBuilder extends RefType {
  TypeDerivedJwtParserBuilder() { this.getASourceSupertype*() instanceof TypeJwtParserBuilder }
}

/**
 * The `setSigningKey(byte[] key)` and `setSigningKey(String base64EncodedKeyBytes)` methods
 * defined in `JwtParser` or `JwtParserBuilder`.
 */
class SetSigningKeyMethod extends Method {
  SetSigningKeyMethod() {
    this.hasName("setSigningKey") and
    this.getNumberOfParameters() = 1 and
    (
      this.getDeclaringType() instanceof TypeDerivedJwtParser or
      this.getDeclaringType() instanceof TypeDerivedJwtParserBuilder
    )
  }
}
