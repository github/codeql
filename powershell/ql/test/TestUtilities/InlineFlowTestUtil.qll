/**
 * Defines the default source and sink recognition for `InlineFlowTest.qll`.
 */

import powershell
import semmle.code.powershell.dataflow.DataFlow

predicate defaultSource(DataFlow::Node src) {
  src.asExpr().getExpr().(CmdCall).getName() = ["Source", "Taint"]
  or
  src.asParameter().getName().matches(["Source%", "Taint%"])
}

predicate defaultSink(DataFlow::Node sink) {
  exists(CmdCall cmd | cmd.getName() = "Sink" | sink.asExpr().getExpr() = cmd.getAnArgument())
}

string getSourceArgString(DataFlow::Node src) {
  defaultSource(src) and
  (
    src.asExpr().getExpr().(CmdCall).getAnArgument().(StringConstExpr).getValue().getValue() = result
    or
    src.asParameter().getName().regexpCapture(["Source(.+)", "Taint(.+)"], 1) = result
  )
}
