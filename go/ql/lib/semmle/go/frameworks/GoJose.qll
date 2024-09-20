/**
 * Provides classes for working with the `gopkg.in/square/go-jose` and `github.com/go-jose/go-jose`
 * packages.
 */

import go

private module GoJose {
  /**
   * Provides classes and predicates for working with the `gopkg.in/square/go-jose/jwt` and
   * `github.com/go-jose/go-jose/jwt` packages.
   */
  private module Jwt {
    private import semmle.go.security.MissingJwtSignatureCheckCustomizations::MissingJwtSignatureCheck

    /** The method `JSONWebToken.Claims`. */
    private class GoJoseParseWithClaims extends JwtSafeParse {
      GoJoseParseWithClaims() {
        this.(Method).hasQualifiedName(goJoseJwtPackage(), "JSONWebToken", "Claims")
      }

      override int getTokenArgNum() { result = -1 }
    }

    /**
     * Gets the package names `gopkg.in/square/go-jose/jwt`, `gopkg.in/go-jose/go-jose/jwt`,
     * `github.com/square/go-jose/jwt`, and `github.com/go-jose/go-jose/jwt`.
     */
    private string goJoseJwtPackage() {
      result =
        package([
            "gopkg.in/square/go-jose", "gopkg.in/go-jose/go-jose", "github.com/square/go-jose",
            "github.com/go-jose/go-jose"
          ], "jwt")
    }
  }
}
