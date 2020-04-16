private import javascript

/**
 * Holds if the receiver of `call` is a global variable for which we cannot find a global variable
 * definition with the same name.
 */
private predicate isReceiverUndefinedGlobalVar(DataFlow::CallNode call) {
  exists(GlobalVariable var |
    var.getAnAccess().flow() = call.getReceiver() and
    not exists(VarDef def | def.getAVariable().getName() = var.getName())
  )
}

/**
 * Gets a node that flows to callback-parameter `p`.
 */
private DataFlow::SourceNode getACallback(DataFlow::ParameterNode p, DataFlow::TypeBackTracker t) {
  t.start() and
  result = p and
  any(DataFlow::FunctionNode f).getLastParameter() = p and
  exists(p.getACall())
  or
  exists(DataFlow::TypeBackTracker t2 | result = getACallback(p, t2).backtrack(t2, t))
}

/**
 * Get calls for which we do not have the callee (i.e. the definition of the called function). This
 * acts as a heuristic for identifying calls to external library functions.
 */
private DataFlow::CallNode getACallWithoutCallee() {
  not exists(result.getACallee()) and
  not exists(DataFlow::ParameterNode param, DataFlow::FunctionNode callback |
    param.flowsTo(result.getCalleeNode()) and
    callback = getACallback(param, DataFlow::TypeBackTracker::end())
  )
}

/**
 * Get calls which are likely to be to external non-built-in libraries.
 *
 * We filter out any function call where the receiver is a global variable without definition as a
 * heuristic for identifying built-in global variables.
 */
DataFlow::CallNode getALikelyExternalLibraryCall() {
  result = getACallWithoutCallee() and
  not isReceiverUndefinedGlobalVar(result)
}
