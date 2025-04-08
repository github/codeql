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

/**
 * A call that returns an instance of an open file object.
 * This includes calls to methods that transitively call `open` or similar.
 */
class FileOpen extends DataFlow::CallCfgNode {
  FileOpen() { fileOpenInstance(DataFlow::TypeTracker::end()).flowsTo(this) }
}

/** A call that may wrap a file object in a wrapper class or `os.fdopen`. */
class FileWrapperCall extends DataFlow::CallCfgNode {
  DataFlow::Node wrapped;

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
  DataFlow::Node getWrapped() { result = wrapped }
}

/** A node where a file is closed. */
abstract class FileClose extends DataFlow::CfgNode {
  /** Holds if this file close will occur if an exception is thrown at `raises`. */
  predicate guardsExceptions(DataFlow::CfgNode raises) {
    this.asCfgNode() = raises.asCfgNode().getAnExceptionalSuccessor().getASuccessor*()
    or
    // The expression is after the close call.
    // This also covers the body of a `with` statement.
    raises.asCfgNode() = this.asCfgNode().getASuccessor*()
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
  WithStatement() { this.asExpr() = any(With w).getContextExpr() }
}

/** Holds if an exception may be raised at `raises` if `file` is a file object. */
private predicate mayRaiseWithFile(DataFlow::CfgNode file, DataFlow::CfgNode raises) {
  // Currently just consider any method called on `file`; e.g. `file.write()`; as potentially raising an exception
  raises.(DataFlow::MethodCallNode).getObject() = file and
  not file instanceof FileOpen and
  not file instanceof FileClose
}

/** Holds if data flows from `nodeFrom` to `nodeTo` in one step that also includes file wrapper classes. */
private predicate fileAdditionalLocalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  exists(FileWrapperCall fw | nodeFrom = fw.getWrapped() and nodeTo = fw)
}

private predicate fileLocalFlowHelper0(
  DataFlow::LocalSourceNode nodeFrom, DataFlow::LocalSourceNode nodeTo
) {
  exists(DataFlow::Node nodeMid |
    nodeFrom.flowsTo(nodeMid) and fileAdditionalLocalFlowStep(nodeMid, nodeTo)
  )
}

private predicate fileLocalFlowHelper1(
  DataFlow::LocalSourceNode nodeFrom, DataFlow::LocalSourceNode nodeTo
) {
  fileLocalFlowHelper0*(nodeFrom, nodeTo)
}

/** Holds if data flows from `source` to `sink`, including file wrapper classes. */
pragma[inline]
private predicate fileLocalFlow(FileOpen source, DataFlow::Node sink) {
  exists(DataFlow::LocalSourceNode mid | fileLocalFlowHelper1(source, mid) and mid.flowsTo(sink))
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
  exists(DataFlow::CfgNode fileRaised |
    mayRaiseWithFile(fileRaised, raises) and
    fileLocalFlow(fo, fileRaised) and
    not exists(FileClose fc |
      fileLocalFlow(fo, fc) and
      fc.guardsExceptions(raises)
    )
  )
}
