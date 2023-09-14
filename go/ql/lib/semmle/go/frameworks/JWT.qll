/** Provides models of commonly used functions in common JWT packages. */

import go

/**
 * Provides models of commonly used functions in common JWT packages.
 */
module JWT {
  string packageLestrrat() { result = package("github.com/lestrrat-go/jwx/v2/jwt", "") }

  string packageLestrratv1() { result = package("github.com/lestrrat-go/jwx/jwt", "") }

  string packagePathModern() {
    result = package(["github.com/golang-jwt/jwt/v5", "github.com/golang-jwt/jwt/v4"], "")
  }

  string packagePathOld() { result = package("github.com/golang-jwt/jwt", "") }

  class NewParser extends Function {
    /**
     * Call in golang-jwt to create new parser.
     */
    NewParser() { this.hasQualifiedName(packagePathModern(), "NewParser") }
  }

  class WithValidMethods extends Function {
    /**
     * Call to WithValidMethods in golang-jwt to specify allowed algorithms.
     */
    WithValidMethods() { this.hasQualifiedName(packagePathModern(), "WithValidMethods") }
  }

  class SafeJwtParserMethod extends Method {
    /**
     * Methods to parse token that check token signature.
     */
    SafeJwtParserMethod() {
      this.hasQualifiedName(packagePathModern(), "Parser", ["Parse", "ParseWithClaims"])
    }
  }

  class SafeJwtParserFunc extends Function {
    /**
     * Functions to parse token that check token signature.
     */
    SafeJwtParserFunc() {
      this.hasQualifiedName([packagePathModern(), packagePathOld()], ["Parse", "ParseWithClaims"])
    }
  }

  class UnafeJwtParserMethod extends Method {
    /**
     * Methods to parse token that don't token signature.
     */
    UnafeJwtParserMethod() {
      this.hasQualifiedName(packagePathModern(), "Parser", "ParseUnverified")
    }
  }

  class LestrratParse extends Function {
    /**
     * v2 Function to parse token that check token signature.
     */
    LestrratParse() { this.hasQualifiedName(packageLestrrat(), "Parse") }
  }

  class LestrratParsev1 extends Function {
    /**
     * v1 Function to parse token that check token signature.
     */
    LestrratParsev1() { this.hasQualifiedName(packageLestrratv1(), "Parse") }
  }

  class LestrratVerify extends Function {
    /**
     * Funciton included as parse option to verify token.
     */
    LestrratVerify() { this.hasQualifiedName(packageLestrratv1(), "WithVerify") }
  }

  class LestrratParseInsecure extends Function {
    /**
     * Funciton to parse token that don't check signature.
     */
    LestrratParseInsecure() { this.hasQualifiedName(packageLestrrat(), "ParseInsecure") }
  }
}
