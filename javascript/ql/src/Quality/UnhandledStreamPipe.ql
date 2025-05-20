/**
 * @id js/nodejs-stream-pipe-without-error-handling
 * @name Node.js stream pipe without error handling
 * @description Calling `pipe()` on a stream without error handling may silently drop errors and prevent proper propagation.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @tags quality
 *       frameworks/nodejs
 */

import javascript

/**
 * A call to the `pipe` method on a Node.js stream.
 */
class PipeCall extends DataFlow::MethodCallNode {
  PipeCall() { this.getMethodName() = "pipe" }

  /** Gets the source stream (receiver of the pipe call). */
  DataFlow::Node getSourceStream() { result = this.getReceiver() }

  /** Gets the destination stream (argument of the pipe call). */
  DataFlow::Node getDestinationStream() { result = this.getArgument(0) }
}

/**
 * Gets the method names used to register event handlers on Node.js streams.
 * These methods are used to attach handlers for events like `error`.
 */
string getEventHandlerMethodName() { result = ["on", "once", "addListener"] }

/**
 * Gets the method names that are chainable on Node.js streams.
 */
string getChainableStreamMethodName() {
  result =
    [
      "setEncoding", "pause", "resume", "unpipe", "destroy", "cork", "uncork", "setDefaultEncoding",
      "off", "removeListener", getEventHandlerMethodName()
    ]
}

/**
 * A call to register an event handler on a Node.js stream.
 * This includes methods like `on`, `once`, and `addListener`.
 */
class StreamEventRegistration extends DataFlow::MethodCallNode {
  StreamEventRegistration() { this.getMethodName() = getEventHandlerMethodName() }
}

/**
 * Models flow relationships between streams and related operations.
 * Connects destination streams to their corresponding pipe call nodes.
 * Connects streams to their chainable methods.
 */
predicate streamFlowStep(DataFlow::Node streamNode, DataFlow::Node relatedNode) {
  exists(PipeCall pipe |
    streamNode = pipe.getDestinationStream() and
    relatedNode = pipe
  )
  or
  exists(DataFlow::MethodCallNode chainable |
    chainable.getMethodName() = getChainableStreamMethodName() and
    streamNode = chainable.getReceiver() and
    relatedNode = chainable
  )
}

/**
 * Gets a reference to a stream that may be the source of the given pipe call.
 * Uses type back-tracking to trace stream references in the data flow.
 */
private DataFlow::SourceNode streamRef(DataFlow::TypeBackTracker t, PipeCall pipeCall) {
  t.start() and
  result = pipeCall.getSourceStream().getALocalSource()
  or
  exists(DataFlow::SourceNode prev |
    prev = streamRef(t.continue(), pipeCall) and
    streamFlowStep(result.getALocalUse(), prev)
  )
  or
  exists(DataFlow::TypeBackTracker t2 | result = streamRef(t2, pipeCall).backtrack(t2, t))
}

/**
 * Gets a reference to a stream that may be the source of the given pipe call.
 */
private DataFlow::SourceNode streamRef(PipeCall pipeCall) {
  result = streamRef(DataFlow::TypeBackTracker::end(), pipeCall)
}

/**
 * Holds if the source stream of the given pipe call has an `error` handler registered.
 */
predicate hasErrorHandlerRegistered(PipeCall pipeCall) {
  exists(StreamEventRegistration handler |
    handler = streamRef(pipeCall).getAMethodCall(getEventHandlerMethodName()) and
    handler.getArgument(0).getStringValue() = "error"
  )
}

from PipeCall pipeCall
where not hasErrorHandlerRegistered(pipeCall)
select pipeCall,
  "Stream pipe without error handling on the source stream. Errors won't propagate downstream and may be silently dropped."
