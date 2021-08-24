/**
 * Provides classes for working with untrusted flow sources from the `github.com/go-chi/chi` package.
 */

import go

private module Chi {
  /** Gets the package name `github.com/go-chi/chi`. */
  string packagePath() { result = package("github.com/go-chi/chi", "") }

  /**
   * Functions that extract URL parameters, considered as a source of untrusted flow.
   */
  private class UserControlledFunction extends UntrustedFlowSource::Range, DataFlow::CallNode {
    UserControlledFunction() {
      this.getTarget().hasQualifiedName(packagePath(), ["URLParam", "URLParamFromCtx"])
    }
  }

  /**
   * Methods that extract URL parameters, considered as a source of untrusted flow.
   */
  private class UserControlledRequestMethod extends UntrustedFlowSource::Range,
    DataFlow::MethodCallNode {
    UserControlledRequestMethod() {
      this.getTarget().hasQualifiedName(packagePath(), "Context", "URLParam")
    }
  }
}
