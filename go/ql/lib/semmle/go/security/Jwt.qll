/**
 * Provides classes and predicates for reasoning about JSON Web Tokens (JWT).
 */

import go
private import semmle.go.security.HardcodedCredentials

private class IrisJwt extends HardcodedCredentials::Sink {
  IrisJwt() {
    exists(Field f |
      f.hasQualifiedName(package("github.com/kataras/iris", "middleware/jwt"), "Signer", "Key") and
      f.getAWrite().getRhs() = this
    )
  }
}

private class GogfJwtSign extends HardcodedCredentials::Sink {
  GogfJwtSign() {
    exists(Field f |
      f.hasQualifiedName(package("github.com/gogf/gf-jwt", ""), "GfJWTMiddleware", "Key") and
      f.getAWrite().getRhs() = this
    )
  }
}

private class GinJwtSign extends HardcodedCredentials::Sink {
  GinJwtSign() {
    exists(Field f |
      f.hasQualifiedName(package("github.com/appleboy/gin-jwt", ""), "GinJWTMiddleware", "Key") and
      f.getAWrite().getRhs() = this
    )
  }
}

private class SquareJoseKey extends HardcodedCredentials::Sink {
  SquareJoseKey() {
    exists(Field f, string pkg |
      pkg = ["github.com/square/go-jose/v3", "gopkg.in/square/go-jose.v2"]
    |
      f.hasQualifiedName(pkg, ["Recipient", "SigningKey"], "Key") and
      f.getAWrite().getRhs() = this
    )
  }
}
