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
}
