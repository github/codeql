/**
 * Provides classes modeling security-relevant aspects of the `idna` PyPI package.
 * See https://pypi.org/project/idna/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `idna` PyPI package.
 * See https://pypi.org/project/idna/.
 */
private module IdnaModel {
  /** A call to `idna.encode`. */
  private class IdnaEncodeCall extends Encoding::Range, DataFlow::CallCfgNode {
    IdnaEncodeCall() { this = API::moduleImport("idna").getMember("encode").getACall() }

    override DataFlow::Node getAnInput() { result = [this.getArg(0), this.getArgByName("s")] }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "IDNA" }
  }

  /** A call to `idna.decode`. */
  private class IdnaDecodeCall extends Decoding::Range, DataFlow::CallCfgNode {
    IdnaDecodeCall() { this = API::moduleImport("idna").getMember("decode").getACall() }

    override DataFlow::Node getAnInput() { result = [this.getArg(0), this.getArgByName("s")] }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "IDNA" }

    override predicate mayExecuteInput() { none() }
  }
}
