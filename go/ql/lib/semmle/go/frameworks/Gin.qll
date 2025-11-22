/**
 * Provides classes for modeling the `github.com/gin-gonic/gin` package.
 */

import go
import semmle.go.concepts.HTTP

/** Provides models for the `gin-gonic/gin` package. */
module Gin {
  /** Gets the package name `github.com/gin-gonic/gin`. */
  string packagePath() { result = package("github.com/gin-gonic/gin", "") }

  private class GinCookieWrite extends Http::CookieWrite::Range, DataFlow::MethodCallNode {
    GinCookieWrite() { this.getTarget().hasQualifiedName(packagePath(), "Context", "SetCookie") }

    override DataFlow::Node getName() { result = this.getArgument(0) }

    override DataFlow::Node getValue() { result = this.getArgument(1) }

    override DataFlow::Node getSecure() { result = this.getArgument(5) }

    override DataFlow::Node getHttpOnly() { result = this.getArgument(6) }
  }
}
