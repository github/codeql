/**
 * Provides classes for working the `github.com/gogf` package.
 */

import go
private import semmle.go.security.HardcodedCredentials

private module Gogf {
  private class GogfJwtSign extends HardcodedCredentials::Sink {
    GogfJwtSign() {
      exists(Field f |
        f.hasQualifiedName(package("github.com/gogf/gf-jwt", ""), "GfJWTMiddleware", "Key") and
        f.getAWrite().getRhs() = this
      )
    }
  }
}
