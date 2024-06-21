/**
 * Provides classes for working with remote flow sources from the `github.com/go-chi/chi` package.
 */

import go

private module Chi {
  /** Gets the package name `github.com/go-chi/chi`. */
  string packagePath() { result = package("github.com/go-chi/chi", "") }

  /**
   * Methods that extract URL parameters, considered as a source of remote flow.
   */
  private class UserControlledRequestMethod extends RemoteFlowSource::Range,
    DataFlow::MethodCallNode
  {
    UserControlledRequestMethod() {
      this.getTarget().hasQualifiedName(packagePath(), "Context", "URLParam")
    }
  }
}
