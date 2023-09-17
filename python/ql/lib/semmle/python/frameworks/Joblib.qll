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
   *
   * Claiming there is decoding of the input to `joblib.load` is a bit questionable, since
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
    PandasReadPickleCall() { this = API::moduleImport("joblib").getMember("load").getACall() }

    override predicate mayExecuteInput() { any() }

    override DataFlow::Node getAnInput() {
      result in [this.getArg(0), this.getArgByName("filename")]
    }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "joblib" }
  }
}
