/**
 * Provides classes modeling security-relevant aspects of the `numpy` PyPI package.
 * See https://pypi.org/project/numpy/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `numpy` PyPI package.
 * See https://pypi.org/project/numpy/.
 */
private module Numpy {
  /**
   * A call to `numpy.load`
   * See https://numpy.org/doc/stable/reference/generated/numpy.load.html
   */
  private class NumpyLoadCall extends Decoding::Range, API::CallNode {
    NumpyLoadCall() { this = API::moduleImport("numpy").getMember("load").getACall() }

    override predicate mayExecuteInput() {
      this.getParameter(2, "allow_pickle")
          .getAValueReachingSink()
          .asExpr()
          .(ImmutableLiteral)
          .booleanValue() = true
    }

    override DataFlow::Node getAnInput() { result = this.getParameter(0, "filename").asSink() }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() {
      result = "numpy"
      or
      this.mayExecuteInput() and result = "pickle"
    }
  }
}
