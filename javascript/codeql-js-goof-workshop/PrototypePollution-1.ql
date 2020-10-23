/**
 * @name Prototype pollution
 * @description Recursively merging a user-controlled object into another object
 *              can allow an attacker to modify the built-in Object prototype.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/prototype-pollution
 * @tags security
 *       external/cwe/cwe-250
 *       external/cwe/cwe-400
 */

import javascript
import semmle.javascript.security.dataflow.PrototypePollution::PrototypePollution
import DataFlow::PathGraph
import semmle.javascript.dependencies.Dependencies

// Extend the Sink and Source classes with our sink and source
class GoofChatHandlerAsSource extends Source {
    GoofChatHandlerAsSource() { chatHandler(this) }

    override DataFlow::FlowLabel getAFlowLabel() { result.isTaint() }
}

class MergeSinkNode extends Sink {
    MergeSinkNode() { mergeCallArg(this) }

    override DataFlow::FlowLabel getAFlowLabel() { result.isTaint() }

    override predicate dependencyInfo(string moduleName_, Locatable loc) {
        moduleName_ = "just-a-test" and
        loc = this.getAstNode()
    }
}

// This finds a good set of results, including the local query's results found earlier.

from
    Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, string moduleName,
    Locatable dependencyLoc
where
    cfg.hasFlowPath(source, sink) and
    sink.getNode().(Sink).dependencyInfo(moduleName, dependencyLoc)
select sink.getNode(), source, sink,
    "Prototype pollution caused by merging a user-controlled value from $@ using a vulnerable version of $@.",
    source, "here", dependencyLoc, moduleName

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
// Introduce explicit predicates for the source and sink Nodes
predicate chatHandler(DataFlow::Node sourceparam) { chatHandler(_, sourceparam.getAstNode()) }

predicate mergeCallArg(DataFlow::Node sinkargument) {
    exists(Expr sink, ASTNode child |
        mergeCallArg(_, sink) and 
        child = sink.getAChild*() and
        child = sinkargument.getAstNode()
    )
}
