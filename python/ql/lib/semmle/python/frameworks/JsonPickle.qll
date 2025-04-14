/**
 * Provides classes modeling security-relevant aspects of the `jsonpickle` PyPI package.
 * See https://pypi.org/project/jsonpickle/.
 */

private import python
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `jsonpickle` PyPI package.
 * See https://pypi.org/project/jsonpickle/.
 */
private module Jsonpickle {
  /**
   * A Call to `jsonpickle.decode`.
   * See https://jsonpickle.readthedocs.io/en/latest/api.html#jsonpickle.decode
   */
  private class JsonpickleDecode extends Decoding::Range, API::CallNode {
    JsonpickleDecode() { this = API::moduleImport("jsonpickle").getMember("decode").getACall() }

    override predicate mayExecuteInput() { any() }

    override DataFlow::Node getAnInput() { result = this.getParameter(0, "string").asSink() }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "pickle" }
  }
}
