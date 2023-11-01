/**
 * @name Writable file handle closed without error handling
 * @description Errors which occur when closing a writable file handle may result in data loss
 *              if the data could not be successfully flushed. Such errors should be handled
 *              explicitly.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id go/unhandled-writable-file-close
 * @tags maintainability
 *  correctness
 *  call
 *  defer
 */

import go

/**
 * Holds if a `flag` for use with `os.OpenFile` implies that the resulting
 * file handle will be writable.
 */
predicate isWritable(Entity flag) {
  flag.hasQualifiedName("os", "O_WRONLY") or
  flag.hasQualifiedName("os", "O_RDWR")
}

/**
 * Gets constant names from `expr`.
 */
QualifiedName getConstants(ValueExpr expr) {
  result = expr or
  result = getConstants(expr.getAChild())
}

/**
 * The `os.OpenFile` function.
 */
class OpenFileFun extends Function {
  OpenFileFun() { this.hasQualifiedName("os", "OpenFile") }
}

/**
 * The `os.File.Close` function.
 */
class CloseFileFun extends Method {
  CloseFileFun() { this.hasQualifiedName("os", "File", "Close") }
}

/**
 * The `os.File.Sync` function.
 */
class SyncFileFun extends Method {
  SyncFileFun() { this.hasQualifiedName("os", "File", "Sync") }
}

/**
 * Holds if a `call` to a function is "unhandled". That is, it is either
 * deferred or its result is not assigned to anything.
 *
 * TODO: maybe we should check that something is actually done with the result
 */
predicate unhandledCall(DataFlow::CallNode call) {
  exists(DeferStmt defer | defer.getCall() = call.asExpr()) or
  exists(ExprStmt stmt | stmt.getExpr() = call.asExpr())
}

/**
 * Holds if `source` is a writable file handle returned by a `call` to the
 * `os.OpenFile` function.
 */
predicate isWritableFileHandle(DataFlow::Node source, DataFlow::CallNode call) {
  exists(OpenFileFun f, DataFlow::Node flags, QualifiedName flag |
    // check that the source is a result of the call
    source = call.getAResult() and
    // find a call to the os.OpenFile function
    f.getACall() = call and
    // get the flags expression used for opening the file
    call.getArgument(1) = flags and
    // extract individual flags from the argument
    // flag = flag.getAChild*() and
    flag = getConstants(flags.asExpr()) and
    // check for one which signals that the handle will be writable
    // note that we are underestimating here, since the flags may be
    // specified elsewhere
    isWritable(flag.getTarget())
  )
}

/**
 * Holds if `os.File.Close` is called on `sink`.
 */
predicate isCloseSink(DataFlow::Node sink, DataFlow::CallNode closeCall) {
  // find calls to the os.File.Close function
  closeCall = any(CloseFileFun f).getACall() and
  // that are unhandled
  unhandledCall(closeCall) and
  // where the function is called on the sink
  closeCall.getReceiver() = sink and
  // and check that it is not dominated by a call to `os.File.Sync`.
  not exists(IR::Instruction syncInstr, DataFlow::Node syncReceiver, DataFlow::CallNode syncCall |
    // match the instruction corresponding to an `os.File.Sync` call with the predecessor
    syncCall.asInstruction() = syncInstr and
    // check that the call to `os.File.Sync` is handled
    isHandledSync(syncReceiver, syncCall) and
    // find a predecessor to `closeCall` in the control flow graph which dominates the call to
    // `os.File.Close`
    syncInstr.dominatesNode(closeCall.asInstruction()) and
    // check that `os.File.Sync` is called on the same object as `os.File.Close`
    exists(DataFlow::SsaNode ssa | ssa.getAUse() = sink and ssa.getAUse() = syncReceiver)
  )
}

/**
 * Holds if `os.File.Sync` is called on `sink` and the result of the call is neither
 * deferred nor discarded.
 */
predicate isHandledSync(DataFlow::Node sink, DataFlow::CallNode syncCall) {
  // find a call of the `os.File.Sync` function
  syncCall = any(SyncFileFun f).getACall() and
  // match the sink with the object on which the method is called
  syncCall.getReceiver() = sink and
  // check that the result is neither deferred nor discarded
  not unhandledCall(syncCall)
}

module UnhandledFileCloseConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isWritableFileHandle(source, _) }

  predicate isSink(DataFlow::Node sink) { isCloseSink(sink, _) }
}

/**
 * Tracks data flow for reasoning about which writable file handles resulting from calls to
 * `os.OpenFile` have `os.File.Close` called on them.
 */
module UnhandledFileCloseFlow = DataFlow::Global<UnhandledFileCloseConfig>;

import UnhandledFileCloseFlow::PathGraph

from
  UnhandledFileCloseFlow::PathNode source, DataFlow::CallNode openCall,
  UnhandledFileCloseFlow::PathNode sink, DataFlow::CallNode closeCall
where
  // find data flow from an `os.OpenFile` call to an `os.File.Close` call
  // where the handle is writable
  UnhandledFileCloseFlow::flowPath(source, sink) and
  isWritableFileHandle(source.getNode(), openCall) and
  // get the `CallNode` corresponding to the sink
  isCloseSink(sink.getNode(), closeCall)
select sink, source, sink,
  "File handle may be writable as a result of data flow from a $@ and closing it may result in data loss upon failure, which is not handled explicitly.",
  openCall, openCall.toString()
