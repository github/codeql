/**
 * Provides classes and predicates for working with the `github.com/golang-jwt/jwt` and
 * `github.com/dgrijalva/jwt-go` packages.
 */

import go
private import semmle.go.security.MissingJwtSignatureCheckCustomizations::MissingJwtSignatureCheck

/** The function `jwt.Parse` or the method `Parser.Parse`. */
private class GolangJwtParse extends JwtSafeParse {
  GolangJwtParse() {
    this.hasQualifiedName(golangJwtPackage(), "Parse")
    or
    this.(Method).hasQualifiedName(golangJwtPackage(), "Parser", "Parse")
  }

  override int getTokenArgNum() { result = 0 }
}

/** The function `jwt.ParseWithClaims` or the method `Parser.ParseWithClaims`. */
private class GolangJwtParseWithClaims extends JwtSafeParse {
  GolangJwtParseWithClaims() {
    this.hasQualifiedName(golangJwtPackage(), "ParseWithClaims")
    or
    this.(Method).hasQualifiedName(golangJwtPackage(), "Parser", "ParseWithClaims")
  }

  override int getTokenArgNum() { result = 0 }
}

/** The function `jwt.ParseFromRequest`. */
private class GolangJwtParseFromRequest extends JwtSafeParse {
  GolangJwtParseFromRequest() {
    this.hasQualifiedName(golangJwtRequestPackage(), "ParseFromRequest")
  }

  override int getTokenArgNum() { result = 0 }
}

/** The function `jwt.ParseFromRequestWithClaims`. */
private class GolangJwtParseFromRequestWithClaims extends JwtSafeParse {
  GolangJwtParseFromRequestWithClaims() {
    this.hasQualifiedName(golangJwtRequestPackage(), "ParseFromRequestWithClaims")
  }

  override int getTokenArgNum() { result = 0 }
}

/** Gets the pakcage names `github.com/golang-jwt/jwt` and `github.com/dgrijalva/jwt-go`. */
private string golangJwtPackage() {
  result = package(["github.com/golang-jwt/jwt", "github.com/dgrijalva/jwt-go"], "")
}

/** Gets the package names `github.com/golang-jwt/jwt/request` and `github.com/dgrijalva/jwt-go/request`. */
private string golangJwtRequestPackage() {
  result = package(["github.com/golang-jwt/jwt", "github.com/dgrijalva/jwt-go"], "request")
}
