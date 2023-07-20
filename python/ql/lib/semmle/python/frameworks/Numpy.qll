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
   * Claiming there is decoding of the input to `numpy.load` is a bit questionable, since
   * it's not the filename, but the contents of the file that is decoded.
   *
   * However, we definitely want to be able to alert if a user is able to control what
   * file is used, since that can lead to code execution (even if that file is free of
   * path injection).
   *
   * So right now the best way we have of modeling this seems to be to treat the filename
   * argument as being deserialized...
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
