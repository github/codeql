/**
 * Defines the default source and sink recognition for `InlineFlowTest.qll`.
 */

import powershell
import semmle.code.powershell.dataflow.DataFlow

predicate defaultSource(DataFlow::Node src) {
  src.asStmt().getStmt().(Cmd).getCommandName() = ["Source", "Taint"]
  or
  src.asParameter().getName().matches(["Source%", "Taint%"])
}

predicate defaultSink(DataFlow::Node sink) {
  exists(Cmd cmd | cmd.getCommandName() = "Sink" | sink.asExpr().getExpr() = cmd.getAnArgument())
}

string getSourceArgString(DataFlow::Node src) {
  defaultSource(src) and
  (
    src.asStmt().getStmt().(Cmd).getAnArgument().(StringConstExpr).getValue().getValue() = result
    or
    src.asParameter().getName().regexpCapture(["Source(.+)", "Taint(.+)"], 1) = result
  )
}
