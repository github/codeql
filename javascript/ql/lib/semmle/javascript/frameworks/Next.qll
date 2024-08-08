/**
 * Provides classes and predicates for reasoning about [Next.js](https://www.npmjs.com/package/next).
 */

import javascript

/**
 * Provides classes and predicates modeling [Next.js](https://www.npmjs.com/package/next).
 */
module NextJS {
  /**
   * Gets a `package.json` that depends on the `Next.js` library.
   */
  PackageJson getANextPackage() { result.getDependencies().getADependency("next", _) }

  /**
   * Gets a "pages" folder in a `Next.js` application.
   * JavaScript files inside these folders are mapped to routes.
   */
  Folder getAPagesFolder() {
    result = getANextPackage().getFile().getParentContainer().getFolder("pages")
    or
    result = getAPagesFolder().getAFolder()
  }

  /**
   * Gets a module corrosponding to a `Next.js` page.
   */
  Module getAPagesModule() { result.getFile().getParentContainer() = getAPagesFolder() }

  /**
   * Gets a module inside a "pages" folder where `fallback` from `getStaticPaths` is not set to false.
   * In such a module the `getStaticProps` method can be called with user-defined parameters.
   * If `fallback` is set to false, then only values defined by `getStaticPaths` are allowed.
   */
  Module getAModuleWithFallbackPaths() {
    result = getAPagesModule() and
    exists(DataFlow::FunctionNode staticPaths, DataFlow::Node fallback |
      staticPaths = result.getAnExportedValue("getStaticPaths").getAFunctionValue() and
      fallback = staticPaths.getAReturn().getALocalSource().getAPropertyWrite("fallback").getRhs() and
      not fallback.mayHaveBooleanValue(false)
    )
  }

  /**
   * A user defined path or query parameter in `Next.js`.
   */
  class NextParams extends RemoteFlowSource {
    NextParams() {
      this =
        getAModuleWithFallbackPaths()
            .getAnExportedValue("getStaticProps")
            .getAFunctionValue()
            .getParameter(0)
            .getAPropertyRead("params")
      or
      this = getServerSidePropsFunction(_).getParameter(0).getAPropertyRead(["params", "query"])
      or
      this = nextRouter().getAPropertyRead("query")
    }

    override string getSourceType() { result = "Next request parameter" }
  }

  /**
   * Gets the `getStaticProps` function in a Next.js page.
   * This function is executed at build time, or when a page with a new URL is requested for the first time (if `fallback` is not false).
   */
  DataFlow::FunctionNode getStaticPropsFunction(Module pageModule) {
    pageModule = getAPagesModule() and
    result = pageModule.getAnExportedValue("getStaticProps").getAFunctionValue()
  }

  /**
   * Gets the `getServerSideProps` function in a Next.js page.
   * This function is executed on the server every time a request for the page is made.
   * The function receives a context parameter, which includes HTTP request/response objects.
   */
  DataFlow::FunctionNode getServerSidePropsFunction(Module pageModule) {
    pageModule = getAPagesModule() and
    result = pageModule.getAnExportedValue("getServerSideProps").getAFunctionValue()
  }

  /**
   * Gets the `getInitialProps` function in a Next.js page.
   * This function is executed on the server every time a request for the page is made.
   * The function receives a context parameter, which includes HTTP request/response objects.
   */
  DataFlow::FunctionNode getInitialProps(Module pageModule) {
    pageModule = getAPagesModule() and
    (
      result =
        pageModule
            .getAnExportedValue("default")
            .getAFunctionValue()
            .getAPropertyWrite("getInitialProps")
            .getRhs()
            .getAFunctionValue()
      or
      result =
        pageModule
            .getAnExportedValue("default")
            .getALocalSource()
            .getAstNode()
            .(ReactComponent)
            .getStaticMethod("getInitialProps")
            .flow()
    )
  }

  /**
   * Gets a reference to a `props` object computed by the Next.js server.
   * This `props` object is both used both by the server and client to render the page.
   */
  DataFlow::Node getAPropsSource(Module pageModule) {
    pageModule = getAPagesModule() and
    (
      result =
        [getStaticPropsFunction(pageModule), getServerSidePropsFunction(pageModule)]
            .getAReturn()
            .getALocalSource()
            .getAPropertyWrite("props")
            .getRhs()
      or
      result = getInitialProps(pageModule).getAReturn()
    )
  }

  /**
   * A step modeling the flow from the server-computed props object to the default exported function that renders the page.
   */
  class NextJSStaticPropsStep extends DataFlow::SharedFlowStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(Module pageModule, DataFlow::FunctionNode function |
        pageModule = getAPagesModule() and
        function = pageModule.getAnExportedValue("default").getAFunctionValue() and
        pred = getAPropsSource(pageModule) and
        succ = function.getParameter(0)
      )
    }
  }

  /**
   * A step modeling the flow from the server-computed props object to the default exported React component that renders the page.
   */
  class NextJSStaticReactComponentPropsStep extends DataFlow::SharedFlowStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(Module pageModule, ReactComponent component |
        pageModule = getAPagesModule() and
        pageModule.getAnExportedValue("default").getALocalSource() = DataFlow::valueNode(component) and
        pred = getAPropsSource(pageModule) and
        succ = component.getADirectPropsAccess()
      )
    }
  }

  /**
   * A Next.js function that is exected on the server for every request, seen as a routehandler.
   */
  class NextHttpRouteHandler extends Http::Servers::StandardRouteHandler, DataFlow::FunctionNode {
    NextHttpRouteHandler() { this = getServerSidePropsFunction(_) or this = getInitialProps(_) }
  }

  /**
   * A function that handles both a request and response from Next.js, seen as a routehandler.
   */
  class NextReqResHandler extends Http::Servers::StandardRouteHandler, DataFlow::FunctionNode {
    DataFlow::ParameterNode req;
    DataFlow::ParameterNode res;

    NextReqResHandler() {
      res = this.getAParameter() and
      req = this.getAParameter() and
      req.hasUnderlyingType("next", "NextApiRequest") and
      res.hasUnderlyingType("next", "NextApiResponse")
    }

    /** Gets the request parameter */
    DataFlow::ParameterNode getRequest() { result = req }

    /** Gets the response parameter */
    DataFlow::ParameterNode getResponse() { result = res }
  }

  /**
   * A NodeJS HTTP request object in a Next.js page.
   */
  class NextHttpRequestSource extends NodeJSLib::RequestSource {
    Http::RouteHandler rh;

    NextHttpRequestSource() {
      this = rh.(NextHttpRouteHandler).getParameter(0).getAPropertyRead("req") or
      this = rh.(NextReqResHandler).getRequest()
    }

    override Http::RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A NodeJS HTTP response object in a Next.js page.
   */
  class NextHttpResponseSource extends NodeJSLib::ResponseSource {
    Http::RouteHandler rh;

    NextHttpResponseSource() {
      this = rh.(NextHttpRouteHandler).getParameter(0).getAPropertyRead("res") or
      this = rh.(NextReqResHandler).getResponse()
    }

    override Http::RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * Gets a folder that contains API endpoints for a Next.js application.
   * These API endpoints act as Express-like route-handlers.
   */
  Folder apiFolder() {
    result = getANextPackage().getFile().getParentContainer().getFolder("pages").getFolder("api")
    or
    result = apiFolder().getAFolder()
  }

  /**
   * A Next.js route handler for an API endpoint.
   * The response (res) includes a set of Express.js-like methods,
   * and we therefore model the routehandler as an Express.js routehandler.
   */
  class NextApiRouteHandler extends DataFlow::FunctionNode, Express::RouteHandler,
    Http::Servers::StandardRouteHandler
  {
    NextApiRouteHandler() {
      exists(Module mod | mod.getFile().getParentContainer() = apiFolder() |
        this = mod.getAnExportedValue("default").getAFunctionValue()
      )
    }

    override DataFlow::ParameterNode getRouteHandlerParameter(string kind) {
      kind = "request" and result = this.getParameter(0)
      or
      kind = "response" and result = this.getParameter(1)
    }
  }

  /**
   * Gets a reference to a [Next.js router](https://nextjs.org/docs/api-reference/next/router).
   */
  DataFlow::SourceNode nextRouter() {
    result = API::moduleImport("next/router").getMember("useRouter").getACall()
    or
    result =
      API::moduleImport("next/router")
          .getMember("withRouter")
          .getParameter(0)
          .getParameter(0)
          .getMember("router")
          .asSource()
  }

  /**
   * Provides classes and predicates modeling the `next-auth` library.
   */
  private module NextAuth {
    /**
     * A random string used to hash tokens, sign cookies and generate cryptographic keys as a `CredentialsNode`.
     */
    private class SecretKey extends CredentialsNode {
      SecretKey() {
        this = API::moduleImport("next-auth").getParameter(0).getMember("secret").asSink()
      }

      override string getCredentialsKind() { result = "jwt key" }
    }
  }
}
