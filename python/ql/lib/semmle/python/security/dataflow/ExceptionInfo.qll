/** Provides classes representing various sources of information about raised exceptions. */

import python
import semmle.python.dataflow.new.DataFlow
private import semmle.python.ApiGraphs

/**
 * INTERNAL: Do not use.
 *
 * A data-flow node that carries information about a raised exception.
 * Such information should rarely be exposed directly to the user.
 */
abstract class ExceptionInfo extends DataFlow::Node { }

/** A call to a function from the `traceback` module revealing information about a raised exception. */
private class TracebackFunctionCall extends ExceptionInfo, DataFlow::CallCfgNode {
  TracebackFunctionCall() {
    this =
      API::moduleImport("traceback")
          .getMember([
              "extract_tb", "extract_stack", "format_list", "format_exception_only",
              "format_exception", "format_exc", "format_tb", "format_stack"
            ])
          .getACall()
  }
}

/** A caught exception. */
private class CaughtException extends ExceptionInfo {
  CaughtException() {
    this.asExpr() = any(ExceptStmt s).getName() and
    this.asCfgNode() = any(EssaNodeDefinition def).getDefiningNode()
  }
}

/** A call to `sys.exc_info`. */
private class SysExcInfoCall extends ExceptionInfo, DataFlow::CallCfgNode {
  SysExcInfoCall() { this = API::moduleImport("sys").getMember("exc_info").getACall() }
}
