/**
 * Provides classes modeling security-relevant aspects of the `pyramid` PyPI package.
 * See https://docs.pylonsproject.org/projects/pyramid/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.FlowSummary
private import semmle.python.frameworks.internal.PoorMansFunctionResolution
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper
private import semmle.python.frameworks.data.ModelsAsData

/**
 * Provides models for the `pyramid` PyPI package.
 * See https://docs.pylonsproject.org/projects/pyramid/.
 */
module Pyramid {
  // TODO: qldoc
  module View {
    /**
     * A callable that could be used as a pyramid view callable.
     */
    private class PotentialViewCallable extends Function {
      PotentialViewCallable() {
        this.getPositionalParameterCount() = 1 and
        this.getArgName(0) = "request"
        or
        this.getPositionalParameterCount() = 2 and
        this.getArgName(0) = "context" and
        this.getArgName(1) = "request"
      }

      /** Gets the `request` parameter of this view callable. */
      Parameter getRequestParameter() { result = this.getArgByName("request") }
    }

    abstract class ViewCallable extends PotentialViewCallable, Http::Server::RequestHandler::Range {
      override Parameter getARoutedParameter() { result = this.getRequestParameter() }

      override string getFramework() { result = "Pyramid" }
    }

    private class ViewCallableFromDecorator extends ViewCallable {
      ViewCallableFromDecorator() {
        this.getADecorator() =
          API::moduleImport("pyramid")
              .getMember("view")
              .getMember("view_config")
              .getACall()
              .asExpr()
      }
    }

    private class ViewCallableFromConfigurator extends ViewCallable {
      ViewCallableFromConfigurator() {
        any(Configurator::AddViewCall c).getViewArg() = poorMansFunctionTracker(this)
      }
    }
  }

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

    class AddViewCall extends DataFlow::MethodCallNode {
      AddViewCall() { this.calls(instance(), "add_view") }

      DataFlow::Node getViewArg() { result = [this.getArg(0), this.getArgByName("view")] }
    }
  }

  module Request {
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

    private class RequestParameter extends InstanceSource, DataFlow::ParameterNode {
      RequestParameter() { this.getParameter() = any(View::ViewCallable vc).getRequestParameter() }
    }

    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "pyramid.request.Request" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() {
        result in [
            "accept", "accept_charset", "accept_encoding", "accept_language", "application_url",
            "as_bytes", "authorization", "body", "body_file", "body_file_raw", "body_file_seekable",
            "cache_control", "client_addr", "content_type", "cookies", "domain", "headers", "host",
            "host_port", "host_url", "GET", "if_match", "if_none_match", "if_range",
            "if_none_match", "json", "json_body", "params", "path", "path_info", "path_qs",
            "path_url", "POST", "pragma", "query_string", "range", "referer", "referrer", "text",
            "url", "urlargs", "urlvars", "user_agent"
          ]
      }

      override string getMethodName() {
        result in ["as_bytes", "copy", "copy_body", "copy_get", "path_info_peek", "path_info_pop"]
      }

      override string getAsyncMethodName() { none() }
    }
  }
}
