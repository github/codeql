/**
 * @name Writable file handle closed without error handling
 * @description Errors which occur when closing a writable file handle may result in data loss
 *              if the data could not be successfully flushed. Such errors should be handled
 *              explicitly.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id go/unhandled-writable-file-close
 * @tags quality
 *       reliability
 *       error-handling
 *       external/cwe/cwe-252
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
 * deferred or used as an expression statement, so that its result is discarded.
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
    // check that the source is the first result of the call
    source = call.getResult(0) and
    // find a call to the os.OpenFile function
    f.getACall() = call and
    // get the flags expression used for opening the file
    call.getArgument(1) = flags and
    // extract individual flags from the argument
    flag = getConstants(flags.asExpr()) and
    // check for one which signals that the handle will be writable
    // note that we are underestimating here, since the flags may be
    // specified elsewhere
    isWritable(flag.getTarget())
  )
}

/**
 * Holds if `postDominator` post-dominates `node` in the control-flow graph. That is,
 * every path from `node` to the exit of the enclosing function passes through
 * `postDominator`.
 */
pragma[inline]
predicate postDominatesNode(ControlFlow::Node postDominator, ControlFlow::Node node) {
  exists(ReachableBasicBlock pdbb, ReachableBasicBlock nbb, int i, int j |
    postDominator = pdbb.getNode(i) and node = nbb.getNode(j)
  |
    pdbb.strictlyPostDominates(nbb)
    or
    pdbb = nbb and i >= j
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

  predicate isSink(DataFlow::Node sink) {
    // `closeCall` is an unhandled call to `os.File.Close` on `sink` that is not
    // guaranteed to be preceded during execution by a handled call to `os.File.Sync` on the
    // same file handle.
    exists(DataFlow::CallNode closeCall |
      // find calls to the os.File.Close function
      closeCall = any(CloseFileFun f).getACall() and
      // that are unhandled
      unhandledCall(closeCall) and
      // where the function is called on the sink
      closeCall.getReceiver() = sink and
      // and check that the call to `os.File.Close` is not guaranteed to be preceded during
      // execution by a handled call to `os.File.Sync` on the same file handle.
      not exists(DataFlow::Node syncReceiver, DataFlow::CallNode syncCall |
        // check that the call to `os.File.Sync` is handled
        isHandledSync(syncReceiver, syncCall) and
        // check that `os.File.Sync` is called on the same object as `os.File.Close`
        exists(DataFlow::SsaNode ssa | ssa.getAUse() = sink and ssa.getAUse() = syncReceiver)
      |
        if exists(DeferStmt defer | defer.getCall() = closeCall.asExpr())
        then
          // When the call to `os.File.Close` is deferred it runs when the enclosing function
          // returns, but the receiver of the deferred call is evaluated where the `defer`
          // statement appears. It is therefore enough for the handled call to `os.File.Sync`
          // to post-dominate that point, since that guarantees `os.File.Sync` runs before the
          // deferred `os.File.Close` on every path on which the `os.File.Close` is registered.
          // We cannot reuse the domination check below because the control-flow graph splices
          // the deferred call in at the function exit, where it may be reachable along paths
          // that do not pass through the call to `os.File.Sync`.
          postDominatesNode(syncCall.asInstruction(), sink.asInstruction())
        else
          // Otherwise the call to `os.File.Close` is executed where it appears, so we require
          // the handled call to `os.File.Sync` to dominate it.
          syncCall.asInstruction().dominatesNode(closeCall.asInstruction())
      )
    )
  }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSourceLocation(DataFlow::Node source) {
    exists(DataFlow::CallNode openCall | result = [openCall.getLocation(), source.getLocation()] |
      isWritableFileHandle(source, openCall)
    )
  }
}

/**
 * Tracks data flow for reasoning about which writable file handles resulting from calls to
 * `os.OpenFile` have `os.File.Close` called on them.
 */
module UnhandledFileCloseFlow = DataFlow::Global<UnhandledFileCloseConfig>;

import UnhandledFileCloseFlow::PathGraph

from
  UnhandledFileCloseFlow::PathNode source, DataFlow::CallNode openCall,
  UnhandledFileCloseFlow::PathNode sink
where
  // find data flow from an `os.OpenFile` call to an `os.File.Close` call
  // where the handle is writable
  UnhandledFileCloseFlow::flowPath(source, sink) and
  isWritableFileHandle(source.getNode(), openCall)
select sink, source, sink,
  "File handle may be writable as a result of data flow from a $@ and closing it may result in data loss upon failure, which is not handled explicitly.",
  openCall, openCall.toString()
