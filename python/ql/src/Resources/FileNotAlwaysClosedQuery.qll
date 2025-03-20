/** Definitions for reasoning about whether files are closed. */

import python
import semmle.python.dataflow.new.internal.DataFlowDispatch
import semmle.python.ApiGraphs

/** A CFG node where a file is opened. */
abstract class FileOpenSource extends DataFlow::CfgNode { }

/** A call to the builtin `open` or `os.open`. */
class FileOpenCall extends FileOpenSource {
  FileOpenCall() {
    this = [API::builtin("open").getACall(), API::moduleImport("os").getMember("open").getACall()]
  }
}

private DataFlow::TypeTrackingNode fileOpenInstance(DataFlow::TypeTracker t) {
  t.start() and
  result instanceof FileOpenSource
  or
  exists(DataFlow::TypeTracker t2 | result = fileOpenInstance(t2).track(t2, t))
}

/** A call that returns an instance of an open file object. */
class FileOpen extends DataFlow::CallCfgNode {
  FileOpen() { fileOpenInstance(DataFlow::TypeTracker::end()).flowsTo(this) }
}

/** A call that may wrap a file object in a wrapper class or `os.fdopen`. */
class FileWrapperCall extends DataFlow::CallCfgNode {
  FileOpen wrapped;

  FileWrapperCall() {
    wrapped = this.getArg(_).getALocalSource() and
    this.getFunction() = classTracker(_)
    or
    wrapped = this.getArg(0) and
    this = API::moduleImport("os").getMember("fdopen").getACall()
    or
    wrapped = this.getArg(0) and
    this = API::moduleImport("django").getMember("http").getMember("FileResponse").getACall()
  }

  /** Gets the file that this call wraps. */
  FileOpen getWrapped() { result = wrapped }
}

/** A node where a file is closed. */
abstract class FileClose extends DataFlow::CfgNode {
  /** Holds if this file close will occur if an exception is thrown at `e`. */
  predicate guardsExceptions(Expr e) {
    this.asCfgNode() =
      DataFlow::exprNode(e).asCfgNode().getAnExceptionalSuccessor().getASuccessor*()
    or
    // the expression is after the close call
    DataFlow::exprNode(e).asCfgNode() = this.asCfgNode().getASuccessor*()
  }
}

/** A call to the `.close()` method of a file object. */
class FileCloseCall extends FileClose {
  FileCloseCall() { exists(DataFlow::MethodCallNode mc | mc.calls(this, "close")) }
}

/** A call to `os.close`. */
class OsCloseCall extends FileClose {
  OsCloseCall() { this = API::moduleImport("os").getMember("close").getACall().getArg(0) }
}

/** A `with` statement. */
class WithStatement extends FileClose {
  With w;

  WithStatement() { this.asExpr() = w.getContextExpr() }

  override predicate guardsExceptions(Expr e) {
    super.guardsExceptions(e)
    or
    e = w.getAStmt().getAChildNode*()
  }
}

/** Holds if an exception may be raised at `node` if it is a file object. */
private predicate mayRaiseWithFile(DataFlow::CfgNode node) {
  // Currently just consider any method called on `node`; e.g. `file.write()`; as potentially raising an exception
  exists(DataFlow::MethodCallNode mc | node = mc.getObject()) and
  not node instanceof FileOpen and
  not node instanceof FileClose
}

/** Holds if data flows from `nodeFrom` to `nodeTo` in one step that also includes file wrapper classes. */
private predicate fileLocalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  DataFlow::localFlowStep(nodeFrom, nodeTo)
  or
  exists(FileWrapperCall fw | nodeFrom = fw.getWrapped() and nodeTo = fw)
}

/** Holds if data flows from `source` to `sink`, including file wrapper classes. */
private predicate fileLocalFlow(DataFlow::Node source, DataFlow::Node sink) {
  fileLocalFlowStep*(source, sink)
}

/** Holds if the file opened at `fo` is closed. */
predicate fileIsClosed(FileOpen fo) { exists(FileClose fc | fileLocalFlow(fo, fc)) }

/** Holds if the file opened at `fo` is returned to the caller. This makes the caller responsible for closing the file. */
predicate fileIsReturned(FileOpen fo) {
  exists(Return ret, Expr retVal |
    (
      retVal = ret.getValue()
      or
      retVal = ret.getValue().(List).getAnElt()
      or
      retVal = ret.getValue().(Tuple).getAnElt()
    ) and
    fileLocalFlow(fo, DataFlow::exprNode(retVal))
  )
}

/** Holds if the file opened at `fo` is stored in a field. We assume that another method is then responsible for closing the file. */
predicate fileIsStoredInField(FileOpen fo) {
  exists(DataFlow::AttrWrite aw | fileLocalFlow(fo, aw.getValue()))
}

/** Holds if the file opened at `fo` is not closed, and is expected to be closed. */
predicate fileNotClosed(FileOpen fo) {
  not fileIsClosed(fo) and
  not fileIsReturned(fo) and
  not fileIsStoredInField(fo)
}

predicate fileMayNotBeClosedOnException(FileOpen fo, DataFlow::Node raises) {
  fileIsClosed(fo) and
  mayRaiseWithFile(raises) and
  fileLocalFlow(fo, raises) and
  not exists(FileClose fc |
    DataFlow::localFlow(fo, fc) and
    fc.guardsExceptions(raises.asExpr())
  )
}
