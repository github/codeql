/** Definitions for reasoning about whether files are closed. */

import python
//import semmle.python.dataflow.DataFlow
import semmle.python.ApiGraphs

abstract class FileOpen extends DataFlow::CfgNode { }

class FileOpenCall extends FileOpen {
  FileOpenCall() { this = API::builtin("open").getACall() }
}

// todo: type tracking to find wrapping funcs
abstract class FileClose extends DataFlow::CfgNode { }

class FileCloseCall extends FileClose {
  FileCloseCall() { exists(DataFlow::MethodCallNode mc | mc.calls(this, "close")) }
}

class WithStatement extends FileClose {
  WithStatement() { exists(With w | this.asExpr() = w.getContextExpr()) }
}

predicate fileIsClosed(FileOpen fo) { exists(FileClose fc | DataFlow::localFlow(fo, fc)) }

predicate fileIsReturned(FileOpen fo) {
  exists(Return ret | DataFlow::localFlow(fo, DataFlow::exprNode(ret.getValue())))
}

predicate fileIsStoredInField(FileOpen fo) {
  exists(DataFlow::AttrWrite aw | DataFlow::localFlow(fo, aw.getValue()))
}

predicate fileNotAlwaysClosed(FileOpen fo) {
  not fileIsClosed(fo) and
  not fileIsReturned(fo) and
  not fileIsStoredInField(fo)
  // TODO: exception cases
}
