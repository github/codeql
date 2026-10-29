/**
 * Provides classes modeling security-relevant aspects of the `simplejson` PyPI package.
 * See https://simplejson.readthedocs.io/en/latest/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `simplejson` PyPI package.
 * See https://simplejson.readthedocs.io/en/latest/.
 */
private module SimplejsonModel {
  /**
   * A call to `simplejson.dumps`.
   *
   * See https://simplejson.readthedocs.io/en/latest/#simplejson.dumps
   */
  private class SimplejsonDumpsCall extends Encoding::Range, DataFlow::CallCfgNode {
    SimplejsonDumpsCall() { this = API::moduleImport("simplejson").getMember("dumps").getACall() }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("obj")] }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "JSON" }
  }

  /**
   * A call to `simplejson.dump`.
   *
   * See https://simplejson.readthedocs.io/en/latest/#simplejson.dump
   */
  private class SimplejsonDumpCall extends Encoding::Range, DataFlow::CallCfgNode {
    SimplejsonDumpCall() { this = API::moduleImport("simplejson").getMember("dump").getACall() }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("obj")] }

    override DataFlow::Node getOutput() {
      result.(DataFlow::PostUpdateNode).getPreUpdateNode() in [
          this.getArg(1), this.getArgByName("fp")
        ]
    }

    override string getFormat() { result = "JSON" }
  }

  /**
   * A call to `simplejson.loads`.
   *
   * See https://simplejson.readthedocs.io/en/latest/#simplejson.loads
   */
  private class SimplejsonLoadsCall extends Decoding::Range, DataFlow::CallCfgNode {
    SimplejsonLoadsCall() { this = API::moduleImport("simplejson").getMember("loads").getACall() }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("s")] }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "JSON" }

    override predicate mayExecuteInput() { none() }
  }

  /**
   * A call to `simplejson.load`.
   *
   * See https://simplejson.readthedocs.io/en/latest/#simplejson.load
   */
  private class SimplejsonLoadCall extends Decoding::Range, DataFlow::CallCfgNode {
    SimplejsonLoadCall() { this = API::moduleImport("simplejson").getMember("load").getACall() }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("fp")] }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "JSON" }

    override predicate mayExecuteInput() { none() }
  }
}
