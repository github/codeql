/**
 * Provides classes for working with the `github.com/square/go-jose`, `github.com/go-jose/go-jose`,
 * and `gopkg.in/square-go-jose.v2` packages.
 */

import go
private import semmle.go.security.HardcodedCredentials

private module GoJose {
  private class GoJoseKey extends HardcodedCredentials::Sink {
    GoJoseKey() {
      exists(Field f |
        f.hasQualifiedName(goJosePackage(), ["Recipient", "SigningKey"], "Key") and
        f.getAWrite().getRhs() = this
      )
    }
  }

  private string goJosePackage() {
    result =
      [
        package("github.com/square/go-jose", ""), package("github.com/go-jose/go-jose", ""),
        "gopkg.in/square/go-jose.v2"
      ]
  }

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

    /** Gets the package names `gopkg.in/square/go-jose/jwt` and `github.com/go-jose/go-jose/jwt`. */
    private string goJoseJwtPackage() {
      result = package(["gopkg.in/square/go-jose", "github.com/go-jose/go-jose"], "jwt")
    }
  }
}
