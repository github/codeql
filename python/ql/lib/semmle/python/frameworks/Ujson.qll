/**
 * Provides classes modeling security-relevant aspects of the `ujson` PyPI package.
 * See https://pypi.org/project/ujson/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `ujson` PyPI package.
 * See https://pypi.org/project/ujson/.
 */
private module UjsonModel {
  /**
   * A call to `usjon.dumps` or `ujson.encode`.
   */
  private class UjsonDumpsCall extends Encoding::Range, DataFlow::CallCfgNode {
    UjsonDumpsCall() { this = API::moduleImport("ujson").getMember(["dumps", "encode"]).getACall() }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("obj")] }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "JSON" }
  }

  /**
   * A call to `ujson.dump`.
   */
  private class UjsonDumpCall extends Encoding::Range, DataFlow::CallCfgNode {
    UjsonDumpCall() { this = API::moduleImport("ujson").getMember("dump").getACall() }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override DataFlow::Node getOutput() {
      result.(DataFlow::PostUpdateNode).getPreUpdateNode() = this.getArg(1)
    }

    override string getFormat() { result = "JSON" }
  }

  /**
   * A call to `ujson.loads` or `ujson.decode`.
   */
  private class UjsonLoadsCall extends Decoding::Range, DataFlow::CallCfgNode {
    UjsonLoadsCall() { this = API::moduleImport("ujson").getMember(["loads", "decode"]).getACall() }

    // Note: Most other JSON libraries allow the keyword argument `s`, but as of version
    // 4.0.2 `ujson` uses `obj` instead.
    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("obj")] }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "JSON" }

    override predicate mayExecuteInput() { none() }
  }

  /**
   * A call to `ujson.load`.
   */
  private class UjsonLoadCall extends Decoding::Range, DataFlow::CallCfgNode {
    UjsonLoadCall() { this = API::moduleImport("ujson").getMember("load").getACall() }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "JSON" }

    override predicate mayExecuteInput() { none() }
  }
}
