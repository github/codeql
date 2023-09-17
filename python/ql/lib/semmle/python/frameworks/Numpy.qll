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
   * See https://pypi.org/project/numpy/
   *
   */
  private class PandasReadPickleCall extends Decoding::Range, DataFlow::CallCfgNode {
    PandasReadPickleCall() {
      this = API::moduleImport("numpy").getMember("load").getACall() and
      this.getArgByName("allow_pickle").asExpr() = any(True t)
    }

    override predicate mayExecuteInput() { any() }

    override DataFlow::Node getAnInput() {
      result in [this.getArg(0), this.getArgByName("filename")]
    }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "numpy" }
  }
}
