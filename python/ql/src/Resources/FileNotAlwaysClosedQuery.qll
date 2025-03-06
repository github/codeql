/** Definitions for reasoning about whether files are closed. */

import python
import semmle.python.dataflow.new.internal.DataFlowDispatch
import semmle.python.ApiGraphs

abstract class FileOpen extends DataFlow::CfgNode { }

class FileOpenCall extends FileOpen {
  FileOpenCall() { this = [API::builtin("open").getACall()] }
}

class FileWrapperClassCall extends FileOpen, DataFlow::CallCfgNode {
  FileOpen wrapped;

  FileWrapperClassCall() {
    wrapped = this.getArg(_).getALocalSource() and
    this.getFunction() = classTracker(_)
  }

  FileOpen getWrapped() { result = wrapped }
}

abstract class FileClose extends DataFlow::CfgNode { }

class FileCloseCall extends FileClose {
  FileCloseCall() { exists(DataFlow::MethodCallNode mc | mc.calls(this, "close")) }
}

class OsCloseCall extends FileClose {
  OsCloseCall() { this = API::moduleImport("os").getMember("close").getACall().getArg(0) }
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
  not fileIsStoredInField(fo) and
  not exists(FileWrapperClassCall fwc | fo = fwc.getWrapped())
}
