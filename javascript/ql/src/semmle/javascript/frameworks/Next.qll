/**
 * Provides classes and predicates for reasoning about [Next.js](https://www.npmjs.com/package/next).
 */

import javascript

/**
 * Provides classes and predicates modelling [Next.js](https://www.npmjs.com/package/next).
 */
module NextJS {
  // TODO: Private.
  /**
   * Gets a `package.json` that depends on the `Next.js` library.
   */
  PackageJSON getANextPackage() { result.getDependencies().getADependency("next", _) }

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
    exists(DataFlow::FunctionNode staticPaths, Expr fallback |
      staticPaths = result.getAnExportedValue("getStaticPaths").getAFunctionValue() and
      fallback =
        staticPaths.getAReturn().getALocalSource().getAPropertyWrite("fallback").getRhs().asExpr() and
      not fallback.(BooleanLiteral).getValue() = "false"
    )
  }

  /**
   * User defined path parameter in `Next.js`.
   */
  class NextParams extends RemoteFlowSource {
    NextParams() {
      this =
        getAModuleWithFallbackPaths()
            .getAnExportedValue("getStaticProps")
            .getAFunctionValue()
            .getParameter(0)
            .getAPropertyRead("params")
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
   * A step modelling the flow from the server-computed props object to the default exported function that renders the page.
   */
  class NextJSStaticPropsStep extends DataFlow::AdditionalFlowStep, DataFlow::FunctionNode {
    Module pageModule;

    NextJSStaticPropsStep() {
      pageModule = getAPagesModule() and
      this = pageModule.getAnExportedValue("default").getAFunctionValue()
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = getAPropsSource(pageModule) and
      succ = this.getParameter(0)
    }
  }

  /**
   * A step modelling the flow from the server-computed props object to the default exported React component that renders the page.
   */
  class NextJSStaticReactComponentPropsStep extends DataFlow::AdditionalFlowStep,
    DataFlow::ValueNode {
    Module pageModule;
    ReactComponent component;

    NextJSStaticReactComponentPropsStep() {
      pageModule = getAPagesModule() and
      this.getAstNode() = component and
      this = pageModule.getAnExportedValue("default").getALocalSource()
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = getAPropsSource(pageModule) and
      succ = component.getADirectPropsAccess()
    }
  }

  /**
   * A Next.js function that is exected on the server for every request, seen as a routehandler.
   */
  class NextHttpRouteHandler extends HTTP::Servers::StandardRouteHandler, DataFlow::FunctionNode {
    Module pageModule;

    NextHttpRouteHandler() {
      this = getServerSidePropsFunction(pageModule) or this = getInitialProps(pageModule)
    }
  }

  /**
   * A NodeJS HTTP request object in a Next.js page.
   */
  class NextHttpRequestSource extends NodeJSLib::RequestSource {
    NextHttpRouteHandler rh;

    NextHttpRequestSource() { this = rh.getParameter(0).getAPropertyRead("req") }

    override HTTP::RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A NodeJS HTTP response object in a Next.js page.
   */
  class NextHttpResponseSource extends NodeJSLib::ResponseSource {
    NextHttpRouteHandler rh;

    NextHttpResponseSource() { this = rh.getParameter(0).getAPropertyRead("res") }

    override HTTP::RouteHandler getRouteHandler() { result = rh }
  }
}
