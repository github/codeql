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

  /**
   * A function in golang-jwt to create new parser.
   */
  class NewParser extends Function {
    NewParser() { this.hasQualifiedName(packagePathModern(), "NewParser") }
  }

  /**
   * A function in golang-jwt to specify allowed algorithms.
   */
  class WithValidMethods extends Function {
    WithValidMethods() { this.hasQualifiedName(packagePathModern(), "WithValidMethods") }
  }

  /**
   * The methods to parse token that check token signature.
   */
  class SafeJwtParserMethod extends Method {
    SafeJwtParserMethod() {
      this.hasQualifiedName(packagePathModern(), "Parser", ["Parse", "ParseWithClaims"])
    }
  }

  /**
   * The function to parse token that check token signature.
   */
  class SafeJwtParserFunc extends Function {
    SafeJwtParserFunc() {
      this.hasQualifiedName([packagePathModern(), packagePathOld()], ["Parse", "ParseWithClaims"])
    }
  }

  /**
   * The methods to parse token that don't token signature.
   */
  class UnafeJwtParserMethod extends Method {
    UnafeJwtParserMethod() {
      this.hasQualifiedName(packagePathModern(), "Parser", "ParseUnverified")
    }
  }

  /**
   * A v2 Function to parse token that check token signature.
   */
  class LestrratParse extends Function {
    LestrratParse() { this.hasQualifiedName(packageLestrrat(), "Parse") }
  }

  /**
   * A v1 Function to parse token that check token signature.
   */
  class LestrratParsev1 extends Function {
    LestrratParsev1() { this.hasQualifiedName(packageLestrratv1(), "Parse") }
  }

  /**
   * A function included as parse option to verify token.
   */
  class LestrratVerify extends Function {
    LestrratVerify() { this.hasQualifiedName(packageLestrratv1(), "WithVerify") }
  }

  /**
   * The function to parse token that doesn't check signature.
   */
  class LestrratParseInsecure extends Function {
    LestrratParseInsecure() { this.hasQualifiedName(packageLestrrat(), "ParseInsecure") }
  }
}
