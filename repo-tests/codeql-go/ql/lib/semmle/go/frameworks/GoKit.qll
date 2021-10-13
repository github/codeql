/**
 * Provides classes for working with concepts relating to the [github.com/go-kit/kit](https://pkg.go.dev/github.com/go-kit/kit) package.
 *
 * Note that these models are not included by default; to include them, add `import semmle.go.frameworks.GoKit` to your query or to
 * `Customizations.qll`.
 */

import go

/**
 * Provides classes for working with concepts relating to the [github.com/go-kit/kit](https://pkg.go.dev/github.com/go-kit/kit) package.
 */
module GoKit {
  /** Gets the package name. */
  string packagePath() { result = package("github.com/go-kit/kit", "") }

  /**
   * Provides classes for working with concepts relating to the `endpoint` package of the
   * [github.com/go-kit/kit](https://pkg.go.dev/github.com/go-kit/kit) package.
   */
  module Endpoint {
    /** Gets the package name. */
    string endpointPackagePath() { result = package("github.com/go-kit/kit", "endpoint") }

    // gets a function that returns an endpoint
    private DataFlow::Node getAnEndpointFactoryResult() {
      exists(Function mkFn, FunctionOutput res |
        mkFn.getResultType(0).hasQualifiedName(endpointPackagePath(), "Endpoint") and
        result = res.getEntryNode(mkFn.getFuncDecl()).getAPredecessor*()
      )
    }

    private FuncDef getAnEndpointFunction() {
      exists(Function endpointFn | endpointFn.getFuncDecl() = result |
        endpointFn.getARead() = getAnEndpointFactoryResult()
      )
      or
      DataFlow::exprNode(result.(FuncLit)) = getAnEndpointFactoryResult()
    }

    private class EndpointRequest extends UntrustedFlowSource::Range {
      EndpointRequest() { this = DataFlow::parameterNode(getAnEndpointFunction().getParameter(1)) }
    }
  }
}
