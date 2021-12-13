import javascript

// 1. The sink is any argumnent[i], i >= 1, to  _.merge(message, req.body.message,...)
predicate mergeCallArg(MethodCallExpr call, Expr sink) {
    // Identify the call
    call.getReceiver().toString() = "_" and
    call.getMethodName() = "merge" and
    // Pick any argument -- even the first, although not quite correct
    call.getAnArgument() = sink
}

// 2. The source is the `req` argument in the definition of `exports.chat.add(req, res)`
// Start simple, found 11 results; narrow via the signature; add the source.
predicate chatHandler(FunctionExpr func, Expr source) {
    func.getName() = "add" and
    // 2 parameters
    func.getNumParameter() = 2 and
    // body not empty
    func.getBody().getNumChild() > 0 and
    // the source argument
    source = func.getParameter(0)
}

// 3. Local flow between the source and sink
// Re-introduce the source restriction, get flow.
from DataFlow::Node sinkargument, DataFlow::Node sourceparam, Expr sink
where
    // specify the flow
    sourceparam.getASuccessor+() = sinkargument and
    // specify source
    chatHandler(_, sourceparam.getAstNode()) and
    // specify sink
    mergeCallArg(_, sink) and
    sink.getAChild*() = sinkargument.getAstNode()
select sourceparam, sink, sinkargument
