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
    private class UrlInstances extends URL::InstanceSource {
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
  module URL {
    /** Gets a reference to the `starlette.requests.URL` class. */
    private API::Node classRef() {
      result = API::moduleImport("starlette").getMember("requests").getMember("URL")
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
    private class UrlSplitInstances extends Stdlib::SplitResult::InstanceSource instanceof DataFlow::AttrRead {
      UrlSplitInstances() {
        super.getObject() = instance() and
        super.getAttributeName() = "components"
      }
    }
  }
}
