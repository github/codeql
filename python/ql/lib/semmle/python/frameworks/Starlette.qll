/**
 * Provides classes modeling security-relevant aspects of the `starlette` PyPI package.
 *
 * See
 * - https://pypi.org/project/starlette/
 * - https://www.starlette.io/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper
private import semmle.python.frameworks.Stdlib
private import semmle.python.frameworks.data.ModelsAsData

/**
 * INTERNAL: Do not use.
 *
 * Provides models for `starlette` PyPI package.
 *
 * See
 * - https://pypi.org/project/starlette/
 * - https://www.starlette.io/
 */
module Starlette {
  /**
   * Provides models for the `starlette.app` class
   */
  module App {
    /** Gets import of `starlette.app`. */
    API::Node cls() { result = API::moduleImport("starlette").getMember("app") }

    /** Gets a reference to a Starlette application (an instance of `starlette.app`). */
    API::Node instance() { result = cls().getAnInstance() }
  }

  /**
   * A call to any of the execute methods on a `app.add_middleware`.
   */
  class AddMiddlewareCall extends DataFlow::CallCfgNode {
    AddMiddlewareCall() {
      this = [App::instance().getMember("add_middleware").getACall(), Middleware::instance()]
    }

    /**
     * Gets the string corresponding to the middleware
     */
    string getMiddlewareName() { result = this.getArg(0).asExpr().(Name).getId() }
  }

  /**
   * A call to any of the execute methods on a `app.add_middleware` with CORSMiddleware.
   */
  class AddCorsMiddlewareCall extends AddMiddlewareCall, Http::Server::CorsMiddleware::Range {
    /**
     * Gets the string corresponding to the middleware
     */
    override string getMiddlewareName() { result = this.getArg(0).asExpr().(Name).getId() }

    override DataFlow::Node getOrigins() { result = this.getArgByName("allow_origins") }

    override DataFlow::Node getCredentialsAllowed() {
      result = this.getArgByName("allow_credentials")
    }

    /**
     * Gets the dataflow node corresponding to the allowed CORS methods
     */
    DataFlow::Node getMethods() { result = this.getArgByName("allow_methods") }

    /**
     * Gets the dataflow node corresponding to the allowed CORS headers
     */
    DataFlow::Node getHeaders() { result = this.getArgByName("allow_headers") }
  }

  /**
   * Provides models for the `starlette.middleware.Middleware` class
   *
   * See https://www.starlette.io/.
   */
  module Middleware {
    /** Gets a reference to the `starlette.middleware.Middleware` class. */
    API::Node classRef() {
      result = API::moduleImport("starlette").getMember("middleware").getMember("Middleware")
      or
      result = ModelOutput::getATypeNode("starlette.middleware.Middleware~Subclass").getASubclass*()
    }

    /** Gets a reference to an instance of `starlette.middleware.Middleware`. */
    DataFlow::Node instance() { result = classRef().getACall() }
  }

  /**
   * Provides models for the `starlette.websockets.WebSocket` class
   *
   * See https://www.starlette.io/websockets/.
   */
  module WebSocket {
    /** Gets a reference to the `starlette.websockets.WebSocket` class. */
    API::Node classRef() {
      result = API::moduleImport("starlette").getMember("websockets").getMember("WebSocket")
      or
      result = API::moduleImport("fastapi").getMember("WebSocket")
      or
      result = ModelOutput::getATypeNode("starlette.websockets.WebSocket~Subclass").getASubclass*()
    }

    /**
     * A source of instances of `starlette.websockets.WebSocket`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `WebSocket::instance()` to get references to instances of `starlette.websockets.WebSocket`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** A direct instantiation of `starlette.websockets.WebSocket`. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
      ClassInstantiation() { this = classRef().getACall() }
    }

    /** Gets a reference to an instance of `starlette.websockets.WebSocket`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `starlette.websockets.WebSocket`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `starlette.websockets.WebSocket`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "starlette.websockets.WebSocket" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() { result in ["url", "headers", "query_params", "cookies"] }

      override string getMethodName() { none() }

      override string getAsyncMethodName() {
        result in [
            "receive", "receive_bytes", "receive_text", "receive_json", "iter_bytes", "iter_text",
            "iter_json"
          ]
      }
    }

    /** An attribute read on a `starlette.websockets.WebSocket` instance that is a `starlette.requests.URL` instance. */
    private class UrlInstances extends Url::InstanceSource {
      UrlInstances() {
        this.(DataFlow::AttrRead).getObject() = instance() and
        this.(DataFlow::AttrRead).getAttributeName() = "url"
      }
    }
  }

  /**
   * Provides models for the `starlette.requests.URL` class
   *
   * See the URL part of https://www.starlette.io/websockets/.
   */
  module Url {
    /** Gets a reference to the `starlette.requests.URL` class. */
    API::Node classRef() {
      result = API::moduleImport("starlette").getMember("requests").getMember("URL")
      or
      result = ModelOutput::getATypeNode("starlette.requests.URL~Subclass").getASubclass*()
    }

    /**
     * A source of instances of `starlette.requests.URL`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `URL::instance()` to get references to instances of `starlette.requests.URL`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** A direct instantiation of `starlette.requests.URL`. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
      ClassInstantiation() { this = classRef().getACall() }
    }

    /** Gets a reference to an instance of `starlette.requests.URL`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `starlette.requests.URL`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `starlette.requests.URL`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "starlette.requests.URL" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() {
        result in [
            "components", "netloc", "path", "query", "fragment", "username", "password", "hostname",
            "port"
          ]
      }

      override string getMethodName() { none() }

      override string getAsyncMethodName() { none() }
    }

    /** An attribute read on a `starlette.requests.URL` instance that is a `urllib.parse.SplitResult` instance. */
    private class UrlSplitInstances extends Stdlib::SplitResult::InstanceSource instanceof DataFlow::AttrRead
    {
      UrlSplitInstances() {
        super.getObject() = instance() and
        super.getAttributeName() = "components"
      }
    }
  }

  /**
   * A call to the `starlette.responses.FileResponse` constructor as a sink for Filesystem access.
   */
  class FileResponseCall extends FileSystemAccess::Range, API::CallNode {
    FileResponseCall() {
      this =
        API::moduleImport("starlette").getMember("responses").getMember("FileResponse").getACall()
    }

    override DataFlow::Node getAPathArgument() { result = this.getParameter(0, "path").asSink() }
  }

  /**
   * Provides models for the `starlette.requests.Request` class
   *
   * See https://www.starlette.io/requests/.
   */
  module Request {
    /** Gets a reference to the `starlette.requests.Request` class. */
    API::Node classRef() {
      result = API::moduleImport("starlette").getMember("requests").getMember("Request")
      or
      result = API::moduleImport("fastapi").getMember("Request")
    }

    /**
     * A source of instances of `starlette.requests.Request`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `Request::instance()` to get references to instances of `starlette.requests.Request`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** A direct instantiation of `starlette.requests.Request`. */
    private class ClassInstantiation extends InstanceSource {
      ClassInstantiation() { this = classRef().getAnInstance().asSource() }
    }

    /** Gets a reference to an instance of `starlette.requests.Request`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `starlette.requests.Request`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `starlette.requests.Request`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "starlette.requests.Request" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() { result in ["cookies"] }

      override string getMethodName() { none() }

      override string getAsyncMethodName() { result in ["body", "json", "form", "stream"] }
    }
  }
}
