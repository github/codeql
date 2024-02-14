/**
 * Provides classes for working with the `github.com/square/go-jose`, `github.com/go-jose/go-jose`,
 * and `gopkg.in/square-go-jose.v2` packages.
 */

import go
private import semmle.go.security.HardcodedCredentials

private module GoJose {
  private class GoJoseKey extends HardcodedCredentials::Sink {
    GoJoseKey() {
      exists(Field f, string pkg |
        pkg =
          [
            package("github.com/square/go-jose", ""), package("github.com/go-jose/go-jose", ""),
            "gopkg.in/square/go-jose.v2"
          ]
      |
        f.hasQualifiedName(pkg, ["Recipient", "SigningKey"], "Key") and
        f.getAWrite().getRhs() = this
      )
    }
  }
}
