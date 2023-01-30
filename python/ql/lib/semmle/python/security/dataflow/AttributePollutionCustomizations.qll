/**
 * Provides default sources, sinks and sanitizers for detecting
 * "attribute pollution" vulnerabilities, as well as extension
 * points for adding your own.
 */

private import python
private import semmle.python.Concepts
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.ApiGraphs

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "attribute pollution" vulnerabilities, as well as extension
 * points for adding your own.
 */
module AttributePollution {
  /** A data flow source for "attribute pollution" vulnerabilities. */
  abstract class Source extends DataFlow::Node { }

  /** A sink for "attribute pollution" vulnerabilities. */
  abstract class Sink extends DataFlow::Node {
    /** Gets the object being polluted. */
    abstract DataFlow::Node getPollutedObject();
  }

  /** A source of remote user input, considered as a flow source. */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  // TODO: MODULARIZE ALL SINKS
  /** A sink for `pydash`. */
  class PyDash extends Sink {
    DataFlow::CallCfgNode setCall;

    PyDash() {
      setCall = API::moduleImport("pydash").getMember("set_").getACall() and
      this = setCall.getArg(1)
    }

    override DataFlow::Node getPollutedObject() { result = setCall.getArg(0) }
  }
}
