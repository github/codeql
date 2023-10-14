/**
 * Provides classes modeling security-relevant aspects of the `joblib` PyPI package.
 * See https://pypi.org/project/joblib/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `joblib` PyPI package.
 * See https://pypi.org/project/joblib/.
 */
private module Joblib {
  /**
   * A call to `joblib.load`
   * See https://pypi.org/project/joblib/
   */
  private class JoblibLoadCall extends Decoding::Range, DataFlow::CallCfgNode {
    JoblibLoadCall() { this = API::moduleImport("joblib").getMember("load").getACall() }

    override predicate mayExecuteInput() { any() }

    override DataFlow::Node getAnInput() {
      result in [this.getArg(0), this.getArgByName("filename")]
    }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "joblib" }
  }
}
