/**
 * Provides classes modeling security-relevant aspects of the `pyramid` PyPI package.
 * See https://docs.pylonsproject.org/projects/pyramid/.
 */

private import python
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.FlowSummary
private import semmle.python.frameworks.internal.PoorMansFunctionResolution
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper
private import semmle.python.frameworks.data.ModelsAsData
private import semmle.python.frameworks.Stdlib

/**
 * Provides models for the `pyramid` PyPI package.
 * See https://docs.pylonsproject.org/projects/pyramid/.
 */
module Pyramid {
  /** Provides models for pyramid View callables. */
  module View {
    /** A dataflow node that sets up a route on a server using the Pyramid framework. */
    abstract private class PyramidRouteSetup extends Http::Server::RouteSetup::Range {
      override string getFramework() { result = "Pyramid" }
    }

    /**
     * A Pyramid view callable, that handles incoming requests.
     */
    class ViewCallable extends Function {
      ViewCallable() { this = any(PyramidRouteSetup rs).getARequestHandler() }

      /** Gets the `request` parameter of this callable. */
      Parameter getRequestParameter() {
        this.getPositionalParameterCount() = 1 and
        result = this.getArg(0)
        or
        this.getPositionalParameterCount() = 2 and
        result = this.getArg(1)
      }
    }

    /** A pyramid route setup using the `pyramid.view.view_config` decorator. */
    private class DecoratorSetup extends PyramidRouteSetup {
      DecoratorSetup() {
        this = API::moduleImport("pyramid").getMember("view").getMember("view_config").getACall()
      }

      override Function getARequestHandler() { result.getADecorator() = this.asExpr() }

      override DataFlow::Node getUrlPatternArg() { none() } // there is a `route_name` arg, but that does not contain the url pattern

      override Parameter getARoutedParameter() { none() }
    }

    /** A pyramid route setup using a call to `pyramid.config.Configurator.add_view`. */
    private class ConfiguratorSetup extends PyramidRouteSetup instanceof Configurator::AddViewCall {
      override Function getARequestHandler() {
        this.(Configurator::AddViewCall).getViewArg() = poorMansFunctionTracker(result)
      }

      override DataFlow::Node getUrlPatternArg() { none() } // there is a `route_name` arg, but that does not contain the url pattern

      override Parameter getARoutedParameter() { none() }
    }
  }

  /** Provides models for `pyramid.config.Configurator` */
  module Configurator {
    /** Gets a reference to the class `pyramid.config.Configurator`. */
    API::Node classRef() {
      result = API::moduleImport("pyramid").getMember("config").getMember("Configurator")
    }

    /** Gets a reference to an instance of `pyramid.config.Configurator`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result = classRef().getACall()
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `pyramid.config.Configurator`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /** A call to the `add_view` method of an instance of `pyramid.config.Configurator`. */
    class AddViewCall extends DataFlow::MethodCallNode {
      AddViewCall() { this.calls(instance(), "add_view") }

      /** Gets the `view` argument of this call. */
      DataFlow::Node getViewArg() { result = [this.getArg(0), this.getArgByName("view")] }
    }
  }

  /** Provides modeling for pyramid requests. */
  module Request {
    /**
     * A source of instances of `pyramid.request.Request`, extend this class to model new instances.
     *
     * Use the predicate `Request::instance()` to get references to instances of `pyramid.request.Request`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of `pyramid.request.Request`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `pyramid.request.Request`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    private class RequestParameter extends InstanceSource, RemoteFlowSource::Range instanceof DataFlow::ParameterNode
    {
      RequestParameter() { this.getParameter() = any(View::ViewCallable vc).getRequestParameter() }

      override string getSourceType() { result = "Pyramid request parameter" }
    }

    /** Taint steps for request instances. */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "pyramid.request.Request" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() {
        result in [
            "accept", "accept_charset", "accept_encoding", "accept_language", "application_url",
            "as_bytes", "authorization", "body", "body_file", "body_file_raw", "body_file_seekable",
            "cache_control", "client_addr", "content_type", "cookies", "domain", "headers", "host",
            "host_port", "host_url", "GET", "if_match", "if_none_match", "if_range",
            "if_none_match", "json", "json_body", "matchdict", "params", "path", "path_info",
            "path_qs", "path_url", "POST", "pragma", "query_string", "range", "referer", "referrer",
            "text", "url", "urlargs", "urlvars", "user_agent"
          ]
      }

      override string getMethodName() {
        result in ["as_bytes", "copy", "copy_get", "path_info_peek", "path_info_pop"]
      }

      override string getAsyncMethodName() { none() }
    }

    /** A call to a method of a `request` that copies the request. */
    private class RequestCopyCall extends InstanceSource, DataFlow::MethodCallNode {
      RequestCopyCall() { this.calls(instance(), ["copy", "copy_get"]) }
    }

    /** A member of a request that is a file-like object. */
    private class RequestBodyFileLike extends Stdlib::FileLikeObject::InstanceSource instanceof DataFlow::AttrRead
    {
      RequestBodyFileLike() {
        this.getObject() = instance() and
        this.getAttributeName() = ["body_file", "body_file_raw", "body_file_seekable"]
      }
    }
  }

  /** Provides modeling for pyramid responses. */
  module Response {
    /** A response returned by a view callable. */
    private class PyramidReturnResponse extends Http::Server::HttpResponse::Range {
      PyramidReturnResponse() {
        this.asCfgNode() = any(View::ViewCallable vc).getAReturnValueFlowNode() and
        not this = instance()
      }

      override DataFlow::Node getBody() { result = this }

      override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

      override string getMimetypeDefault() { result = "text/html" }
    }

    /** Gets a reference to the class `pyramid.response.Response`. */
    API::Node classRef() {
      result = API::moduleImport("pyramid").getMember("response").getMember("Response")
    }

    /**
     * A source of instances of `pyramid.response.Response`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `Response::instance()` to get references to instances of `pyramid.response.Response`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode,
      Http::Server::HttpResponse::Range
    { }

    /** Gets a reference to an instance of `pyramid.response.Response`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `pyramid.response.Response`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /** An instantiation of the class `pyramid.response.Response` or a subclass. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
      ClassInstantiation() { this = classRef().getACall() }

      override DataFlow::Node getBody() { result = [this.getArg(0), this.getArgByName("body")] }

      override DataFlow::Node getMimetypeOrContentTypeArg() {
        result = [this.getArg(4), this.getArgByName("content_type")]
      }

      override string getMimetypeDefault() { result = "text/html" }
    }

    /** A write to a field that sets the body of a response. */
    private class ResponseBodySet extends Http::Server::HttpResponse::Range instanceof DataFlow::AttrWrite
    {
      string attrName;

      ResponseBodySet() {
        this.getObject() = instance() and
        this.getAttributeName() = attrName and
        attrName in ["body", "body_file", "json", "json_body", "text", "ubody", "unicode_body"]
      }

      override DataFlow::Node getBody() { result = this.(DataFlow::AttrWrite).getValue() }

      override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

      override string getMimetypeDefault() {
        if attrName in ["json", "json_body"]
        then result = "application/json"
        else result = "text/html"
      }
    }

    /** A use of the `response` attribute of a `Request`. */
    private class RequestResponseAttr extends InstanceSource instanceof DataFlow::AttrRead {
      RequestResponseAttr() {
        this.getObject() = Request::instance() and this.getAttributeName() = "response"
      }

      override DataFlow::Node getBody() { none() }

      override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

      override string getMimetypeDefault() { result = "text/html" }
    }

    /** A call to `response.set_cookie`. */
    private class SetCookieCall extends Http::Server::SetCookieCall, DataFlow::MethodCallNode {
      SetCookieCall() { this.calls(instance(), "set_cookie") }

      override DataFlow::Node getHeaderArg() { none() }

      override DataFlow::Node getNameArg() { result = [this.getArg(0), this.getArgByName("name")] }

      override DataFlow::Node getValueArg() {
        result = [this.getArg(1), this.getArgByName("value")]
      }
    }
  }

  /** Provides models for pyramid http redirects. */
  module Redirect {
    /** Gets a reference to a class that represents an HTTP redirect response.. */
    API::Node classRef() {
      result =
        API::moduleImport("pyramid")
            .getMember("httpexceptions")
            .getMember([
                "HTTPMultipleChoices", "HTTPMovedPermanently", "HTTPFound", "HTTPSeeOther",
                "HTTPUseProxy", "HTTPTemporaryRedirect", "HTTPPermanentRedirect"
              ])
    }

    /** A call to a pyramid HTTP exception class that represents an HTTP redirect response. */
    class PyramidRedirect extends Http::Server::HttpRedirectResponse::Range, DataFlow::CallCfgNode {
      PyramidRedirect() { this = classRef().getACall() }

      override DataFlow::Node getRedirectLocation() {
        result = [this.getArg(0), this.getArgByName("location")]
      }

      override DataFlow::Node getBody() { none() }

      override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

      override string getMimetypeDefault() { result = "text/html" }
    }
  }
}
