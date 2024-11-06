/**
 * Provides classes modeling security-relevant aspects of the `jinja2` PyPI package.
 * See https://jinja.palletsprojects.com.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.ApiGraphs
private import semmle.python.Concepts
private import semmle.python.frameworks.data.ModelsAsData

module Jinja2 {
  /** A call to `jinja2.Template`. */
  class Jinja2TemplateConstruction extends TemplateConstruction::Range, API::CallNode {
    Jinja2TemplateConstruction() {
      this = API::moduleImport("jinja2").getMember("Template").getACall()
    }

    override DataFlow::Node getSourceArg() { result = this.getArg(0) }
  }

  module EnvironmentClass {
    /** Gets a reference to the `jinja2.Environment` class. */
    API::Node classRef() {
      result = API::moduleImport("jinja2").getMember("Environment")
      or
      result = ModelOutput::getATypeNode("jinja.Environment~Subclass").getASubclass*()
    }

    /** Gets a reference to an instance of `jinja2.Environment`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result = EnvironmentClass::classRef().getACall()
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `jinja2.Environment`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /** A call to `jinja2.Environment.from_string`. */
    class Jinja2FromStringConstruction extends TemplateConstruction::Range, DataFlow::MethodCallNode
    {
      Jinja2FromStringConstruction() { this.calls(EnvironmentClass::instance(), "from_string") }

      override DataFlow::Node getSourceArg() { result = this.getArg(0) }
    }
  }
}
