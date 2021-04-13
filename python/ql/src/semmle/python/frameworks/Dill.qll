/**
 * Provides classes modeling security-relevant aspects of the 'dill' package.
 * See https://pypi.org/project/dill/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * A call to `dill.loads`
 * See https://pypi.org/project/dill/ (which currently refers you
 * to https://docs.python.org/3/library/pickle.html#pickle.loads)
 */
private class DillLoadsCall extends Decoding::Range, DataFlow::CallCfgNode {
  DillLoadsCall() { this = API::moduleImport("dill").getMember("loads").getACall() }

  override predicate mayExecuteInput() { any() }

  override DataFlow::Node getAnInput() { result = this.getArg(0) }

  override DataFlow::Node getOutput() { result = this }

  override string getFormat() { result = "dill" }
}
