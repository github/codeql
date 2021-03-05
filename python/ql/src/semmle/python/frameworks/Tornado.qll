/**
 * Provides classes modeling security-relevant aspects of the `tornado` PyPI package.
 * See https://www.tornadoweb.org/en/stable/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.regex

/**
 * Provides models for the `tornado` PyPI package.
 * See https://www.tornadoweb.org/en/stable/.
 */
private module Tornado {
  // ---------------------------------------------------------------------------
  // tornado
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `tornado` module. */
  private DataFlow::Node tornado(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("tornado")
    or
    exists(DataFlow::TypeTracker t2 | result = tornado(t2).track(t2, t))
  }

  /** Gets a reference to the `tornado` module. */
  DataFlow::Node tornado() { result = tornado(DataFlow::TypeTracker::end()) }

  /**
   * Gets a reference to the attribute `attr_name` of the `tornado` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node tornado_attr(DataFlow::TypeTracker t, string attr_name) {
    attr_name in ["web", "httputil"] and
    (
      t.start() and
      result = DataFlow::importNode("tornado" + "." + attr_name)
      or
      t.startInAttr(attr_name) and
      result = tornado()
    )
    or
    // Due to bad performance when using normal setup with `tornado_attr(t2, attr_name).track(t2, t)`
    // we have inlined that code and forced a join
    exists(DataFlow::TypeTracker t2 |
      exists(DataFlow::StepSummary summary |
        tornado_attr_first_join(t2, attr_name, result, summary) and
        t = t2.append(summary)
      )
    )
  }

  pragma[nomagic]
  private predicate tornado_attr_first_join(
    DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res, DataFlow::StepSummary summary
  ) {
    DataFlow::StepSummary::step(tornado_attr(t2, attr_name), res, summary)
  }

  /**
   * Gets a reference to the attribute `attr_name` of the `tornado` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node tornado_attr(string attr_name) {
    result = tornado_attr(DataFlow::TypeTracker::end(), attr_name)
  }

  /** Provides models for the `tornado` module. */
  module tornado {
    // -------------------------------------------------------------------------
    // tornado.web
    // -------------------------------------------------------------------------
    /** Gets a reference to the `tornado.web` module. */
    DataFlow::Node web() { result = tornado_attr("web") }

    /** Provides models for the `tornado.web` module */
    module web {
      /**
       * Gets a reference to the attribute `attr_name` of the `tornado.web` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node web_attr(DataFlow::TypeTracker t, string attr_name) {
        attr_name in ["RequestHandler", "Application"] and
        (
          t.start() and
          result = DataFlow::importNode("tornado.web" + "." + attr_name)
          or
          t.startInAttr(attr_name) and
          result = web()
        )
        or
        // Due to bad performance when using normal setup with `web_attr(t2, attr_name).track(t2, t)`
        // we have inlined that code and forced a join
        exists(DataFlow::TypeTracker t2 |
          exists(DataFlow::StepSummary summary |
            web_attr_first_join(t2, attr_name, result, summary) and
            t = t2.append(summary)
          )
        )
      }

      pragma[nomagic]
      private predicate web_attr_first_join(
        DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
        DataFlow::StepSummary summary
      ) {
        DataFlow::StepSummary::step(web_attr(t2, attr_name), res, summary)
      }

      /**
       * Gets a reference to the attribute `attr_name` of the `tornado.web` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node web_attr(string attr_name) {
        result = web_attr(DataFlow::TypeTracker::end(), attr_name)
      }

      /**
       * Provides models for the `tornado.web.RequestHandler` class and subclasses.
       *
       * See https://www.tornadoweb.org/en/stable/web.html#tornado.web.RequestHandler.
       */
      module RequestHandler {
        /** Gets a reference to the `tornado.web.RequestHandler` class or any subclass. */
        private DataFlow::Node subclassRef(DataFlow::TypeTracker t) {
          t.start() and
          result = web_attr("RequestHandler")
          or
          // subclasses in project code
          result.asExpr().(ClassExpr).getABase() = subclassRef(t.continue()).asExpr()
          or
          exists(DataFlow::TypeTracker t2 | result = subclassRef(t2).track(t2, t))
        }

        /** Gets a reference to the `tornado.web.RequestHandler` class or any subclass. */
        DataFlow::Node subclassRef() { result = subclassRef(DataFlow::TypeTracker::end()) }

        /** A RequestHandler class (most likely in project code). */
        class RequestHandlerClass extends Class {
          RequestHandlerClass() { this.getParent() = subclassRef().asExpr() }

          /** Gets a function that could handle incoming requests, if any. */
          Function getARequestHandler() {
            // TODO: This doesn't handle attribute assignment. Should be OK, but analysis is not as complete as with
            // points-to and `.lookup`, which would handle `post = my_post_handler` inside class def
            result = this.getAMethod() and
            result.getName() = HTTP::httpVerbLower()
          }

          /** Gets a reference to this class. */
          private DataFlow::Node getARef(DataFlow::TypeTracker t) {
            t.start() and
            result.asExpr().(ClassExpr) = this.getParent()
            or
            exists(DataFlow::TypeTracker t2 | result = this.getARef(t2).track(t2, t))
          }

          /** Gets a reference to this class. */
          DataFlow::Node getARef() { result = this.getARef(DataFlow::TypeTracker::end()) }
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
        abstract class InstanceSource extends DataFlow::Node { }

        /** The `self` parameter in a method on the `tornado.web.RequestHandler` class or any subclass. */
        private class SelfParam extends InstanceSource, RemoteFlowSource::Range,
          DataFlow::ParameterNode {
          SelfParam() {
            exists(RequestHandlerClass cls | cls.getAMethod().getArg(0) = this.getParameter())
          }

          override string getSourceType() { result = "tornado.web.RequestHandler" }
        }

        /** Gets a reference to an instance of the `tornado.web.RequestHandler` class or any subclass. */
        private DataFlow::Node instance(DataFlow::TypeTracker t) {
          t.start() and
          result instanceof InstanceSource
          or
          exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
        }

        /** Gets a reference to an instance of the `tornado.web.RequestHandler` class or any subclass. */
        DataFlow::Node instance() { result = instance(DataFlow::TypeTracker::end()) }

        /** Gets a reference to one of the methods `get_argument`, `get_body_argument`, `get_query_argument`. */
        private DataFlow::Node argumentMethod(DataFlow::TypeTracker t) {
          t.startInAttr(["get_argument", "get_body_argument", "get_query_argument"]) and
          result = instance()
          or
          exists(DataFlow::TypeTracker t2 | result = argumentMethod(t2).track(t2, t))
        }

        /** Gets a reference to one of the methods `get_argument`, `get_body_argument`, `get_query_argument`. */
        DataFlow::Node argumentMethod() { result = argumentMethod(DataFlow::TypeTracker::end()) }

        /** Gets a reference to one of the methods `get_arguments`, `get_body_arguments`, `get_query_arguments`. */
        private DataFlow::Node argumentsMethod(DataFlow::TypeTracker t) {
          t.startInAttr(["get_arguments", "get_body_arguments", "get_query_arguments"]) and
          result = instance()
          or
          exists(DataFlow::TypeTracker t2 | result = argumentsMethod(t2).track(t2, t))
        }

        /** Gets a reference to one of the methods `get_arguments`, `get_body_arguments`, `get_query_arguments`. */
        DataFlow::Node argumentsMethod() { result = argumentsMethod(DataFlow::TypeTracker::end()) }

        /** Gets a reference the `redirect` method. */
        private DataFlow::Node redirectMethod(DataFlow::TypeTracker t) {
          t.startInAttr("redirect") and
          result = instance()
          or
          exists(DataFlow::TypeTracker t2 | result = redirectMethod(t2).track(t2, t))
        }

        /** Gets a reference the `redirect` method. */
        DataFlow::Node redirectMethod() { result = redirectMethod(DataFlow::TypeTracker::end()) }

        /** Gets a reference to the `write` method. */
        private DataFlow::Node writeMethod(DataFlow::TypeTracker t) {
          t.startInAttr("write") and
          result = instance()
          or
          exists(DataFlow::TypeTracker t2 | result = writeMethod(t2).track(t2, t))
        }

        /** Gets a reference to the `write` method. */
        DataFlow::Node writeMethod() { result = writeMethod(DataFlow::TypeTracker::end()) }

        private class AdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
          override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
            // Method access
            nodeTo.(DataFlow::AttrRead).getObject() = nodeFrom and
            nodeFrom = instance() and
            nodeTo in [argumentMethod(), argumentsMethod()]
            or
            // Method call
            nodeTo.asCfgNode().(CallNode).getFunction() = nodeFrom.asCfgNode() and
            nodeFrom in [argumentMethod(), argumentsMethod()]
            or
            // Attributes
            nodeFrom = instance() and
            exists(DataFlow::AttrRead read | nodeTo = read and read.getObject() = nodeFrom |
              read.getAttributeName() in [
                  // List[str]
                  "path_args",
                  // Dict[str, str]
                  "path_kwargs",
                  // tornado.httputil.HTTPServerRequest
                  "request"
                ]
            )
          }
        }

        private class RequestAttrAccess extends tornado::httputil::HttpServerRequest::InstanceSource {
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
        private DataFlow::Node classRef(DataFlow::TypeTracker t) {
          t.start() and
          result = web_attr("Application")
          or
          exists(DataFlow::TypeTracker t2 | result = classRef(t2).track(t2, t))
        }

        /** Gets a reference to the `tornado.web.Application` class. */
        DataFlow::Node classRef() { result = classRef(DataFlow::TypeTracker::end()) }

        /**
         * A source of instances of `tornado.web.Application`, extend this class to model new instances.
         *
         * This can include instantiations of the class, return values from function
         * calls, or a special parameter that will be set when functions are called by an external
         * library.
         *
         * Use the predicate `Application::instance()` to get references to instances of `tornado.web.Application`.
         */
        abstract class InstanceSource extends DataFlow::Node { }

        /** A direct instantiation of `tornado.web.Application`. */
        class ClassInstantiation extends InstanceSource, DataFlow::CfgNode {
          override CallNode node;

          ClassInstantiation() { node.getFunction() = classRef().asCfgNode() }
        }

        /** Gets a reference to an instance of `tornado.web.Application`. */
        private DataFlow::Node instance(DataFlow::TypeTracker t) {
          t.start() and
          result instanceof InstanceSource
          or
          exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
        }

        /** Gets a reference to an instance of `tornado.web.Application`. */
        DataFlow::Node instance() { result = instance(DataFlow::TypeTracker::end()) }

        /** Gets a reference to the `add_handlers` method. */
        private DataFlow::Node add_handlers(DataFlow::TypeTracker t) {
          t.startInAttr("add_handlers") and
          result = instance()
          or
          exists(DataFlow::TypeTracker t2 | result = add_handlers(t2).track(t2, t))
        }

        /** Gets a reference to the `add_handlers` method. */
        DataFlow::Node add_handlers() { result = add_handlers(DataFlow::TypeTracker::end()) }
      }
    }

    // -------------------------------------------------------------------------
    // tornado.httputil
    // -------------------------------------------------------------------------
    /** Gets a reference to the `tornado.httputil` module. */
    DataFlow::Node httputil() { result = tornado_attr("httputil") }

    /** Provides models for the `tornado.httputil` module */
    module httputil {
      /**
       * Gets a reference to the attribute `attr_name` of the `tornado.httputil` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node httputil_attr(DataFlow::TypeTracker t, string attr_name) {
        attr_name in ["HTTPServerRequest"] and
        (
          t.start() and
          result = DataFlow::importNode("tornado.httputil" + "." + attr_name)
          or
          t.startInAttr(attr_name) and
          result = httputil()
        )
        or
        // Due to bad performance when using normal setup with `httputil_attr(t2, attr_name).track(t2, t)`
        // we have inlined that code and forced a join
        exists(DataFlow::TypeTracker t2 |
          exists(DataFlow::StepSummary summary |
            httputil_attr_first_join(t2, attr_name, result, summary) and
            t = t2.append(summary)
          )
        )
      }

      pragma[nomagic]
      private predicate httputil_attr_first_join(
        DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
        DataFlow::StepSummary summary
      ) {
        DataFlow::StepSummary::step(httputil_attr(t2, attr_name), res, summary)
      }

      /**
       * Gets a reference to the attribute `attr_name` of the `tornado.httputil` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node httputil_attr(string attr_name) {
        result = httputil_attr(DataFlow::TypeTracker::end(), attr_name)
      }

      /**
       * Provides models for the `tornado.httputil.HttpServerRequest` class
       *
       * See https://www.tornadoweb.org/en/stable/httputil.html#tornado.httputil.HTTPServerRequest.
       */
      module HttpServerRequest {
        /** Gets a reference to the `tornado.httputil.HttpServerRequest` class. */
        private DataFlow::Node classRef(DataFlow::TypeTracker t) {
          t.start() and
          result = httputil_attr("HttpServerRequest")
          or
          exists(DataFlow::TypeTracker t2 | result = classRef(t2).track(t2, t))
        }

        /** Gets a reference to the `tornado.httputil.HttpServerRequest` class. */
        DataFlow::Node classRef() { result = classRef(DataFlow::TypeTracker::end()) }

        /**
         * A source of instances of `tornado.httputil.HttpServerRequest`, extend this class to model new instances.
         *
         * This can include instantiations of the class, return values from function
         * calls, or a special parameter that will be set when functions are called by an external
         * library.
         *
         * Use the predicate `HttpServerRequest::instance()` to get references to instances of `tornado.httputil.HttpServerRequest`.
         */
        abstract class InstanceSource extends DataFlow::Node { }

        /** A direct instantiation of `tornado.httputil.HttpServerRequest`. */
        private class ClassInstantiation extends InstanceSource, DataFlow::CfgNode {
          override CallNode node;

          ClassInstantiation() { node.getFunction() = classRef().asCfgNode() }
        }

        /** Gets a reference to an instance of `tornado.httputil.HttpServerRequest`. */
        private DataFlow::Node instance(DataFlow::TypeTracker t) {
          t.start() and
          result instanceof InstanceSource
          or
          exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
        }

        /** Gets a reference to an instance of `tornado.httputil.HttpServerRequest`. */
        DataFlow::Node instance() { result = instance(DataFlow::TypeTracker::end()) }

        /** Gets a reference to the `full_url` method. */
        private DataFlow::Node full_url(DataFlow::TypeTracker t) {
          t.startInAttr("full_url") and
          result = instance()
          or
          exists(DataFlow::TypeTracker t2 | result = full_url(t2).track(t2, t))
        }

        /** Gets a reference to the `full_url` method. */
        DataFlow::Node full_url() { result = full_url(DataFlow::TypeTracker::end()) }

        private class AdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
          override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
            // Method access
            nodeTo.(DataFlow::AttrRead).getObject() = nodeFrom and
            nodeFrom = instance() and
            nodeTo in [full_url()]
            or
            // Method call
            nodeTo.asCfgNode().(CallNode).getFunction() = nodeFrom.asCfgNode() and
            nodeFrom in [full_url()]
            or
            // Attributes
            nodeFrom = instance() and
            exists(DataFlow::AttrRead read | nodeTo = read and read.getObject() = nodeFrom |
              read.getAttributeName() in [
                  // str / bytes
                  "uri", "path", "query", "remote_ip", "body",
                  // Dict[str, List[bytes]]
                  "arguments", "query_arguments", "body_arguments",
                  // dict-like, https://www.tornadoweb.org/en/stable/httputil.html#tornado.httputil.HTTPHeaders
                  "headers",
                  // Dict[str, http.cookies.Morsel]
                  "cookies"
                ]
            )
          }
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  // routing
  // ---------------------------------------------------------------------------
  /** A sequence that defines a number of route rules */
  SequenceNode routeSetupRuleList() {
    exists(CallNode call | call = any(tornado::web::Application::ClassInstantiation c).asCfgNode() |
      result in [call.getArg(0), call.getArgByName("handlers")]
    )
    or
    exists(CallNode call |
      call.getFunction() = tornado::web::Application::add_handlers().asCfgNode()
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
      DataFlow::exprNode(this).(DataFlow::LocalSourceNode).flowsTo(setup.getUrlPatternArg())
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
      exists(tornado::web::RequestHandler::RequestHandlerClass cls |
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
      exists(tornado::web::RequestHandler::RequestHandlerClass cls |
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
   * See https://www.tornadoweb.org/en/stable/web.html?highlight=write#tornado.web.RequestHandler.redirect
   */
  private class TornadoRequestHandlerRedirectCall extends HTTP::Server::HttpRedirectResponse::Range,
    DataFlow::CfgNode {
    override CallNode node;

    TornadoRequestHandlerRedirectCall() {
      node.getFunction() = tornado::web::RequestHandler::redirectMethod().asCfgNode()
    }

    override DataFlow::Node getRedirectLocation() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("url")]
    }

    override DataFlow::Node getBody() { none() }

    override string getMimetypeDefault() { none() }

    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }
  }

  /**
   * A call to the `tornado.web.RequestHandler.write` method.
   *
   * See https://www.tornadoweb.org/en/stable/web.html?highlight=write#tornado.web.RequestHandler.write
   */
  private class TornadoRequestHandlerWriteCall extends HTTP::Server::HttpResponse::Range,
    DataFlow::CfgNode {
    override CallNode node;

    TornadoRequestHandlerWriteCall() {
      node.getFunction() = tornado::web::RequestHandler::writeMethod().asCfgNode()
    }

    override DataFlow::Node getBody() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("chunk")]
    }

    override string getMimetypeDefault() { result = "text/html" }

    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }
  }
}
