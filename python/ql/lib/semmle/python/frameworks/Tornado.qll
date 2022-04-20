/**
 * Provides classes modeling security-relevant aspects of the `tornado` PyPI package.
 * See https://www.tornadoweb.org/en/stable/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.regex
private import semmle.python.frameworks.Stdlib
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper

/**
 * Provides models for the `tornado` PyPI package.
 * See https://www.tornadoweb.org/en/stable/.
 */
private module Tornado {
  /**
   * Provides models for the `tornado.httputil.HTTPHeaders` class
   *
   * See https://www.tornadoweb.org/en/stable/httputil.html#tornado.httputil.HTTPHeaders.
   */
  module HttpHeaders {
    /**
     * A source of instances of `tornado.httputil.HTTPHeaders`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `HTTPHeaders::instance()` to get references to instances of `tornado.httputil.HTTPHeaders`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of `tornado.httputil.HttpHeaders`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `tornado.httputil.HttpHeaders`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `tornado.httputil.HTTPHeaders`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "tornado.httputil.HTTPHeaders" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() { none() }

      override string getMethodName() { result in ["get_list", "get_all"] }

      override string getAsyncMethodName() { none() }
    }
  }

  /** DEPRECATED: Alias for HttpHeaders */
  deprecated module HTTPHeaders = HttpHeaders;

  // ---------------------------------------------------------------------------
  // tornado
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `tornado` module. */
  API::Node tornado() { result = API::moduleImport("tornado") }

  /** Provides models for the `tornado` module. */
  module TornadoModule {
    // -------------------------------------------------------------------------
    // tornado.web
    // -------------------------------------------------------------------------
    /** Gets a reference to the `tornado.web` module. */
    API::Node web() { result = tornado().getMember("web") }

    /** Provides models for the `tornado.web` module */
    module Web {
      /**
       * Provides models for the `tornado.web.RequestHandler` class and subclasses.
       *
       * See https://www.tornadoweb.org/en/stable/web.html#tornado.web.RequestHandler.
       */
      module RequestHandler {
        /** Gets a reference to the `tornado.web.RequestHandler` class or any subclass. */
        API::Node subclassRef() { result = web().getMember("RequestHandler").getASubclass*() }

        /** A RequestHandler class (most likely in project code). */
        class RequestHandlerClass extends Class {
          RequestHandlerClass() { this.getParent() = subclassRef().getAnImmediateUse().asExpr() }

          /** Gets a function that could handle incoming requests, if any. */
          Function getARequestHandler() {
            // TODO: This doesn't handle attribute assignment. Should be OK, but analysis is not as complete as with
            // points-to and `.lookup`, which would handle `post = my_post_handler` inside class def
            result = this.getAMethod() and
            result.getName() = HTTP::httpVerbLower()
          }

          /** Gets a reference to this class. */
          private DataFlow::TypeTrackingNode getARef(DataFlow::TypeTracker t) {
            t.start() and
            result.asExpr() = this.getParent()
            or
            exists(DataFlow::TypeTracker t2 | result = this.getARef(t2).track(t2, t))
          }

          /** Gets a reference to this class. */
          DataFlow::Node getARef() { this.getARef(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * A source of instances of the `tornado.web.RequestHandler` class or any subclass, extend this class to model new instances.
         *
         * This can include instantiations of the class, return values from function
         * calls, or a special parameter that will be set when functions are called by an external
         * library.
         *
         * Use the predicate `RequestHandler::instance()` to get references to instances of the `tornado.web.RequestHandler` class or any subclass.
         */
        abstract class InstanceSource extends DataFlow::LocalSourceNode { }

        /** The `self` parameter in a method on the `tornado.web.RequestHandler` class or any subclass. */
        private class SelfParam extends InstanceSource, RemoteFlowSource::Range,
          DataFlow::ParameterNode {
          SelfParam() {
            exists(RequestHandlerClass cls | cls.getAMethod().getArg(0) = this.getParameter())
          }

          override string getSourceType() { result = "tornado.web.RequestHandler" }
        }

        /** Gets a reference to an instance of the `tornado.web.RequestHandler` class or any subclass. */
        private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
          t.start() and
          result instanceof InstanceSource
          or
          exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
        }

        /** Gets a reference to an instance of the `tornado.web.RequestHandler` class or any subclass. */
        DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

        /** Gets a reference the `redirect` method. */
        private DataFlow::TypeTrackingNode redirectMethod(DataFlow::TypeTracker t) {
          t.startInAttr("redirect") and
          result = instance()
          or
          exists(DataFlow::TypeTracker t2 | result = redirectMethod(t2).track(t2, t))
        }

        /** Gets a reference the `redirect` method. */
        DataFlow::Node redirectMethod() {
          redirectMethod(DataFlow::TypeTracker::end()).flowsTo(result)
        }

        /** Gets a reference to the `write` method. */
        private DataFlow::TypeTrackingNode writeMethod(DataFlow::TypeTracker t) {
          t.startInAttr("write") and
          result = instance()
          or
          exists(DataFlow::TypeTracker t2 | result = writeMethod(t2).track(t2, t))
        }

        /** Gets a reference to the `write` method. */
        DataFlow::Node writeMethod() { writeMethod(DataFlow::TypeTracker::end()).flowsTo(result) }

        /**
         * Taint propagation for `tornado.web.RequestHandler`.
         */
        private class InstanceTaintSteps extends InstanceTaintStepsHelper {
          InstanceTaintSteps() { this = "tornado.web.RequestHandler" }

          override DataFlow::Node getInstance() { result = instance() }

          override string getAttributeName() {
            result in [
                // List[str]
                "path_args",
                // Dict[str, str]
                "path_kwargs",
                // tornado.httputil.HTTPServerRequest
                "request"
              ]
          }

          override string getMethodName() {
            result in [
                "get_argument", "get_body_argument", "get_query_argument", "get_arguments",
                "get_body_arguments", "get_query_arguments"
              ]
          }

          override string getAsyncMethodName() { none() }
        }

        private class RequestAttrAccess extends TornadoModule::HttpUtil::HttpServerRequest::InstanceSource {
          RequestAttrAccess() {
            this.(DataFlow::AttrRead).getObject() = instance() and
            this.(DataFlow::AttrRead).getAttributeName() = "request"
          }
        }
      }

      /**
       * Provides models for the `tornado.web.Application` class
       *
       * See https://www.tornadoweb.org/en/stable/web.html#tornado.web.Application.
       */
      module Application {
        /** Gets a reference to the `tornado.web.Application` class. */
        API::Node classRef() { result = web().getMember("Application") }

        /**
         * A source of instances of `tornado.web.Application`, extend this class to model new instances.
         *
         * This can include instantiations of the class, return values from function
         * calls, or a special parameter that will be set when functions are called by an external
         * library.
         *
         * Use the predicate `Application::instance()` to get references to instances of `tornado.web.Application`.
         */
        abstract class InstanceSource extends DataFlow::LocalSourceNode { }

        /** A direct instantiation of `tornado.web.Application`. */
        class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
          ClassInstantiation() { this = classRef().getACall() }
        }

        /** Gets a reference to an instance of `tornado.web.Application`. */
        private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
          t.start() and
          result instanceof InstanceSource
          or
          exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
        }

        /** Gets a reference to an instance of `tornado.web.Application`. */
        DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

        /** Gets a reference to the `add_handlers` method. */
        private DataFlow::TypeTrackingNode add_handlers(DataFlow::TypeTracker t) {
          t.startInAttr("add_handlers") and
          result = instance()
          or
          exists(DataFlow::TypeTracker t2 | result = add_handlers(t2).track(t2, t))
        }

        /** Gets a reference to the `add_handlers` method. */
        DataFlow::Node add_handlers() { add_handlers(DataFlow::TypeTracker::end()).flowsTo(result) }
      }
    }

    // -------------------------------------------------------------------------
    // tornado.httputil
    // -------------------------------------------------------------------------
    /** Gets a reference to the `tornado.httputil` module. */
    API::Node httputil() { result = tornado().getMember("httputil") }

    /** Provides models for the `tornado.httputil` module */
    module HttpUtil {
      /**
       * Provides models for the `tornado.httputil.HttpServerRequest` class
       *
       * See https://www.tornadoweb.org/en/stable/httputil.html#tornado.httputil.HTTPServerRequest.
       */
      module HttpServerRequest {
        /** Gets a reference to the `tornado.httputil.HttpServerRequest` class. */
        API::Node classRef() { result = httputil().getMember("HttpServerRequest") }

        /**
         * A source of instances of `tornado.httputil.HttpServerRequest`, extend this class to model new instances.
         *
         * This can include instantiations of the class, return values from function
         * calls, or a special parameter that will be set when functions are called by an external
         * library.
         *
         * Use the predicate `HttpServerRequest::instance()` to get references to instances of `tornado.httputil.HttpServerRequest`.
         */
        abstract class InstanceSource extends DataFlow::LocalSourceNode { }

        /** A direct instantiation of `tornado.httputil.HttpServerRequest`. */
        private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
          ClassInstantiation() { this = classRef().getACall() }
        }

        /** Gets a reference to an instance of `tornado.httputil.HttpServerRequest`. */
        private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
          t.start() and
          result instanceof InstanceSource
          or
          exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
        }

        /** Gets a reference to an instance of `tornado.httputil.HttpServerRequest`. */
        DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

        /**
         * Taint propagation for `tornado.httputil.HttpServerRequest`.
         */
        private class InstanceTaintSteps extends InstanceTaintStepsHelper {
          InstanceTaintSteps() { this = "tornado.httputil.HttpServerRequest" }

          override DataFlow::Node getInstance() { result = instance() }

          override string getAttributeName() {
            result in [
                // str / bytes
                "uri", "path", "query", "remote_ip", "body",
                // Dict[str, List[bytes]]
                "arguments", "query_arguments", "body_arguments",
                // dict-like, https://www.tornadoweb.org/en/stable/httputil.html#tornado.httputil.HTTPHeaders
                "headers",
                // Dict[str, http.cookies.Morsel]
                "cookies"
              ]
          }

          override string getMethodName() { result = "full_url" }

          override string getAsyncMethodName() { none() }
        }

        /** An `HttpHeaders` instance that originates from a Tornado request. */
        private class TornadoRequestHttpHeadersInstances extends HttpHeaders::InstanceSource {
          TornadoRequestHttpHeadersInstances() {
            this.(DataFlow::AttrRead).accesses(instance(), "headers")
          }
        }

        /** An `Morsel` instance that originates from a Tornado request. */
        private class TornadoRequestMorselInstances extends Stdlib::Morsel::InstanceSource {
          TornadoRequestMorselInstances() {
            // TODO: this currently only works in local-scope, since writing type-trackers for
            // this is a little too much effort. Once API-graphs are available for more
            // things, we can rewrite this.
            //
            // TODO: This approach for identifying member-access is very adhoc, and we should
            // be able to do something more structured for providing modeling of the members
            // of a container-object.
            exists(DataFlow::AttrRead files | files.accesses(instance(), "cookies") |
              this.asCfgNode().(SubscriptNode).getObject() = files.asCfgNode()
              or
              this.(DataFlow::MethodCallNode).calls(files, "get")
            )
          }
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  // routing
  // ---------------------------------------------------------------------------
  /** Gets a sequence that defines a number of route rules */
  SequenceNode routeSetupRuleList() {
    exists(CallNode call |
      call = any(TornadoModule::Web::Application::ClassInstantiation c).asCfgNode()
    |
      result in [call.getArg(0), call.getArgByName("handlers")]
    )
    or
    exists(CallNode call |
      call.getFunction() = TornadoModule::Web::Application::add_handlers().asCfgNode()
    |
      result in [call.getArg(1), call.getArgByName("host_handlers")]
    )
    or
    result = routeSetupRuleList().getElement(_).(TupleNode).getElement(1)
  }

  /** A tornado route setup. */
  abstract class TornadoRouteSetup extends HTTP::Server::RouteSetup::Range {
    override string getFramework() { result = "Tornado" }
  }

  /**
   * A regex that is used to set up a route.
   *
   * Needs this subclass to be considered a RegexString.
   */
  private class TornadoRouteRegex extends RegexString {
    TornadoRouteSetup setup;

    TornadoRouteRegex() {
      this instanceof StrConst and
      setup.getUrlPatternArg().getALocalSource() = DataFlow::exprNode(this)
    }

    TornadoRouteSetup getRouteSetup() { result = setup }
  }

  /** A route setup using a tuple. */
  private class TornadoTupleRouteSetup extends TornadoRouteSetup, DataFlow::CfgNode {
    override TupleNode node;

    TornadoTupleRouteSetup() {
      node = routeSetupRuleList().getElement(_) and
      count(node.getElement(_)) = 2 and
      not node.getElement(1) instanceof SequenceNode
    }

    override DataFlow::Node getUrlPatternArg() { result.asCfgNode() = node.getElement(0) }

    override Function getARequestHandler() {
      exists(TornadoModule::Web::RequestHandler::RequestHandlerClass cls |
        cls.getARef().asCfgNode() = node.getElement(1) and
        result = cls.getARequestHandler()
      )
    }

    override Parameter getARoutedParameter() {
      // If we don't know the URL pattern, we simply mark all parameters as a routed
      // parameter. This should give us more RemoteFlowSources but could also lead to
      // more FPs. If this turns out to be the wrong tradeoff, we can always change our mind.
      exists(Function requestHandler | requestHandler = this.getARequestHandler() |
        not exists(this.getUrlPattern()) and
        result in [requestHandler.getArg(_), requestHandler.getArgByName(_)] and
        not result = requestHandler.getArg(0)
      )
      or
      exists(Function requestHandler, TornadoRouteRegex regex |
        requestHandler = this.getARequestHandler() and
        regex.getRouteSetup() = this
      |
        // first group will have group number 1
        result = requestHandler.getArg(regex.getGroupNumber(_, _))
        or
        result = requestHandler.getArgByName(regex.getGroupName(_, _))
      )
    }
  }

  /** A request handler defined in a tornado RequestHandler class, that has no known route. */
  private class TornadoRequestHandlerWithoutKnownRoute extends HTTP::Server::RequestHandler::Range {
    TornadoRequestHandlerWithoutKnownRoute() {
      exists(TornadoModule::Web::RequestHandler::RequestHandlerClass cls |
        cls.getARequestHandler() = this
      ) and
      not exists(TornadoRouteSetup setup | setup.getARequestHandler() = this)
    }

    override Parameter getARoutedParameter() {
      // Since we don't know the URL pattern, we simply mark all parameters as a routed
      // parameter. This should give us more RemoteFlowSources but could also lead to
      // more FPs. If this turns out to be the wrong tradeoff, we can always change our mind.
      result in [this.getArg(_), this.getArgByName(_)] and
      not result = this.getArg(0)
    }

    override string getFramework() { result = "Tornado" }
  }

  // ---------------------------------------------------------------------------
  // Response modeling
  // ---------------------------------------------------------------------------
  /**
   * A call to the `tornado.web.RequestHandler.redirect` method.
   *
   * See https://www.tornadoweb.org/en/stable/web.html#tornado.web.RequestHandler.redirect
   */
  private class TornadoRequestHandlerRedirectCall extends HTTP::Server::HttpRedirectResponse::Range,
    DataFlow::CallCfgNode {
    TornadoRequestHandlerRedirectCall() {
      this.getFunction() = TornadoModule::Web::RequestHandler::redirectMethod()
    }

    override DataFlow::Node getRedirectLocation() {
      result in [this.getArg(0), this.getArgByName("url")]
    }

    override DataFlow::Node getBody() { none() }

    override string getMimetypeDefault() { none() }

    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }
  }

  /**
   * A call to the `tornado.web.RequestHandler.write` method.
   *
   * See https://www.tornadoweb.org/en/stable/web.html#tornado.web.RequestHandler.write
   */
  private class TornadoRequestHandlerWriteCall extends HTTP::Server::HttpResponse::Range,
    DataFlow::CallCfgNode {
    TornadoRequestHandlerWriteCall() {
      this.getFunction() = TornadoModule::Web::RequestHandler::writeMethod()
    }

    override DataFlow::Node getBody() { result in [this.getArg(0), this.getArgByName("chunk")] }

    override string getMimetypeDefault() { result = "text/html" }

    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }
  }

  /**
   * A call to the `tornado.web.RequestHandler.set_cookie` method.
   *
   * See https://www.tornadoweb.org/en/stable/web.html#tornado.web.RequestHandler.set_cookie
   */
  class TornadoRequestHandlerSetCookieCall extends HTTP::Server::CookieWrite::Range,
    DataFlow::MethodCallNode {
    TornadoRequestHandlerSetCookieCall() {
      this.calls(TornadoModule::Web::RequestHandler::instance(), "set_cookie")
    }

    override DataFlow::Node getHeaderArg() { none() }

    override DataFlow::Node getNameArg() { result in [this.getArg(0), this.getArgByName("name")] }

    override DataFlow::Node getValueArg() { result in [this.getArg(1), this.getArgByName("value")] }
  }
}
