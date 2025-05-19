/**
 * Defines the default source and sink recognition for `InlineFlowTest.qll`.
 */

import powershell
import semmle.code.powershell.dataflow.DataFlow

predicate defaultSource(DataFlow::Node src) {
  src.asExpr().getExpr().(CmdCall).matchesName(["Source", "Taint"])
  or
  src.asParameter().matchesName(["Source%", "Taint%"])
}

predicate defaultSink(DataFlow::Node sink) {
  exists(CmdCall cmd | cmd.matchesName("Sink") | sink.asExpr().getExpr() = cmd.getAnArgument())
}

string getSourceArgString(DataFlow::Node src) {
  defaultSource(src) and
  (
    src.asExpr().getExpr().(CmdCall).getAnArgument().(StringConstExpr).getValue().getValue() = result
    or
    src.asParameter().getLowerCaseName().regexpCapture(["source(.+)", "taint(.+)"], 1) = result
  )
}
