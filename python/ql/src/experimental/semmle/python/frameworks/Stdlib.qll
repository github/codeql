/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 * Note: some modeling is done internally in the dataflow/taint tracking implementation.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import experimental.semmle.python.Concepts
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

private module SQL {
  // TODO: We need to add the SqlExecution::Range subclasses that cover SqlAlchemy sinks

  private class SqlSanitizerCall extends DataFlow::CallCfgNode, NoSQLSanitizer::Range {
    SqlSanitizerCall() {
      this =
        API::moduleImport("sqlescapy").getMember("sqlescape").getACall()
    }

    override DataFlow::Node getSanitizerNode() { result = this.getArg(0) }
  }
}
