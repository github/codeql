/**
 * @id js/nodejs-stream-pipe-without-error-handling
 * @name Node.js stream pipe without error handling
 * @description Calling `pipe()` on a stream without error handling will drop errors coming from the input stream
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @tags quality
 *       maintainability
 *       error-handling
 *       frameworks/nodejs
 */

import javascript
import semmle.javascript.filters.ClassifyFiles

/**
 * A call to the `pipe` method on a Node.js stream.
 */
class PipeCall extends DataFlow::MethodCallNode {
  PipeCall() {
    this.getMethodName() = "pipe" and
    this.getNumArgument() = [1, 2] and
    not this.getArgument([0, 1]).asExpr() instanceof Function and
    not this.getArgument(0).asExpr() instanceof ObjectExpr and
    not this.getArgument(0).getALocalSource() = getNonNodeJsStreamType()
  }

  /** Gets the source stream (receiver of the pipe call). */
  DataFlow::Node getSourceStream() { result = this.getReceiver() }

  /** Gets the destination stream (argument of the pipe call). */
  DataFlow::Node getDestinationStream() { result = this.getArgument(0) }
}

/**
 * Gets a reference to a value that is known to not be a Node.js stream.
 * This is used to exclude pipe calls on non-stream objects from analysis.
 */
private DataFlow::Node getNonNodeJsStreamType() {
  result = getNonStreamApi().getAValueReachableFromSource()
}

/**
 * Gets API nodes from modules that are known to not provide Node.js streams.
 * This includes reactive programming libraries, frontend frameworks, and other non-stream APIs.
 */
private API::Node getNonStreamApi() {
  exists(string moduleName |
    moduleName
        .regexpMatch([
            "rxjs(|/.*)", "@strapi(|/.*)", "highland(|/.*)", "execa(|/.*)", "arktype(|/.*)",
            "@ngrx(|/.*)", "@datorama(|/.*)", "@angular(|/.*)", "react.*", "@langchain(|/.*)",
          ]) and
    result = API::moduleImport(moduleName)
  )
  or
  result = getNonStreamApi().getAMember()
  or
  result = getNonStreamApi().getAParameter().getAParameter()
  or
  result = getNonStreamApi().getReturn()
  or
  result = getNonStreamApi().getPromised()
}

/**
 * Gets the method names used to register event handlers on Node.js streams.
 * These methods are used to attach handlers for events like `error`.
 */
private string getEventHandlerMethodName() { result = ["on", "once", "addListener"] }

/**
 * Gets the method names that are chainable on Node.js streams.
 */
private string getChainableStreamMethodName() {
  result =
    [
      "setEncoding", "pause", "resume", "unpipe", "destroy", "cork", "uncork", "setDefaultEncoding",
      "off", "removeListener", getEventHandlerMethodName()
    ]
}

/**
 * Gets the method names that are not chainable on Node.js streams.
 */
private string getNonchainableStreamMethodName() {
  result = ["read", "write", "end", "pipe", "unshift", "push", "isPaused", "wrap", "emit"]
}

/**
 * Gets the property names commonly found on Node.js streams.
 */
private string getStreamPropertyName() {
  result =
    [
      "readable", "writable", "destroyed", "closed", "readableHighWaterMark", "readableLength",
      "readableObjectMode", "readableEncoding", "readableFlowing", "readableEnded", "flowing",
      "writableHighWaterMark", "writableLength", "writableObjectMode", "writableFinished",
      "writableCorked", "writableEnded", "defaultEncoding", "allowHalfOpen", "objectMode",
      "errored", "pending", "autoDestroy", "encoding", "path", "fd", "bytesRead", "bytesWritten",
      "_readableState", "_writableState"
    ]
}

/**
 * Gets all method names commonly found on Node.js streams.
 */
private string getStreamMethodName() {
  result = [getChainableStreamMethodName(), getNonchainableStreamMethodName()]
}

/**
 * A call to register an event handler on a Node.js stream.
 * This includes methods like `on`, `once`, and `addListener`.
 */
class ErrorHandlerRegistration extends DataFlow::MethodCallNode {
  ErrorHandlerRegistration() {
    this.getMethodName() = getEventHandlerMethodName() and
    this.getArgument(0).getStringValue() = "error"
  }
}

/**
 * Holds if the stream in `node1` will propagate to `node2`.
 */
private predicate streamFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(PipeCall pipe |
    node1 = pipe.getDestinationStream() and
    node2 = pipe
  )
  or
  exists(DataFlow::MethodCallNode chainable |
    chainable.getMethodName() = getChainableStreamMethodName() and
    node1 = chainable.getReceiver() and
    node2 = chainable
  )
}

/**
 * Tracks the result of a pipe call as it flows through the program.
 */
private DataFlow::SourceNode destinationStreamRef(DataFlow::TypeTracker t, PipeCall pipe) {
  t.start() and
  (result = pipe or result = pipe.getDestinationStream().getALocalSource())
  or
  exists(DataFlow::SourceNode prev |
    prev = destinationStreamRef(t.continue(), pipe) and
    streamFlowStep(prev, result)
  )
  or
  exists(DataFlow::TypeTracker t2 | result = destinationStreamRef(t2, pipe).track(t2, t))
}

/**
 * Gets a reference to the result of a pipe call.
 */
private DataFlow::SourceNode destinationStreamRef(PipeCall pipe) {
  result = destinationStreamRef(DataFlow::TypeTracker::end(), pipe)
}

/**
 * Holds if the pipe call result is used to call a non-stream method.
 * Since pipe() returns the destination stream, this finds cases where
 * the destination stream is used with methods not typical of streams.
 */
private predicate isPipeFollowedByNonStreamMethod(PipeCall pipeCall) {
  exists(DataFlow::MethodCallNode call |
    call = destinationStreamRef(pipeCall).getAMethodCall() and
    not call.getMethodName() = getStreamMethodName()
  )
}

/**
 * Holds if the pipe call result is used to access a property that is not typical of streams.
 */
private predicate isPipeFollowedByNonStreamProperty(PipeCall pipeCall) {
  exists(DataFlow::PropRef propRef |
    propRef = destinationStreamRef(pipeCall).getAPropertyRead() and
    not propRef.getPropertyName() = [getStreamPropertyName(), getStreamMethodName()]
  )
}

/**
 * Holds if the pipe call result is used in a non-stream-like way,
 * either by calling non-stream methods or accessing non-stream properties.
 */
private predicate isPipeFollowedByNonStreamAccess(PipeCall pipeCall) {
  isPipeFollowedByNonStreamMethod(pipeCall) or
  isPipeFollowedByNonStreamProperty(pipeCall)
}

/**
 * Gets a reference to a stream that may be the source of the given pipe call.
 * Uses type back-tracking to trace stream references in the data flow.
 */
private DataFlow::SourceNode sourceStreamRef(DataFlow::TypeBackTracker t, PipeCall pipeCall) {
  t.start() and
  result = pipeCall.getSourceStream().getALocalSource()
  or
  exists(DataFlow::SourceNode prev |
    prev = sourceStreamRef(t.continue(), pipeCall) and
    streamFlowStep(result.getALocalUse(), prev)
  )
  or
  exists(DataFlow::TypeBackTracker t2 | result = sourceStreamRef(t2, pipeCall).backtrack(t2, t))
}

/**
 * Gets a reference to a stream that may be the source of the given pipe call.
 */
private DataFlow::SourceNode sourceStreamRef(PipeCall pipeCall) {
  result = sourceStreamRef(DataFlow::TypeBackTracker::end(), pipeCall)
}

/**
 * Holds if the source stream of the given pipe call has an `error` handler registered.
 */
private predicate hasErrorHandlerRegistered(PipeCall pipeCall) {
  exists(DataFlow::Node stream |
    stream = sourceStreamRef(pipeCall).getALocalUse() and
    (
      stream.(DataFlow::SourceNode).getAMethodCall(_) instanceof ErrorHandlerRegistration
      or
      exists(DataFlow::SourceNode base, string propName |
        stream = base.getAPropertyRead(propName) and
        base.getAPropertyRead(propName).getAMethodCall(_) instanceof ErrorHandlerRegistration
      )
      or
      exists(DataFlow::PropWrite propWrite, DataFlow::SourceNode instance |
        propWrite.getRhs().getALocalSource() = stream and
        instance = propWrite.getBase().getALocalSource() and
        instance.getAPropertyRead(propWrite.getPropertyName()).getAMethodCall(_) instanceof
          ErrorHandlerRegistration
      )
    )
  )
  or
  hasPlumber(pipeCall)
}

/**
 * Holds if the pipe call uses `gulp-plumber`, which automatically handles stream errors.
 * `gulp-plumber` returns a stream that uses monkey-patching to ensure all subsequent streams in the pipeline propagate their errors.
 */
private predicate hasPlumber(PipeCall pipeCall) {
  pipeCall.getDestinationStream().getALocalSource() = API::moduleImport("gulp-plumber").getACall()
  or
  sourceStreamRef+(pipeCall) = API::moduleImport("gulp-plumber").getACall()
}

/**
 * Holds if the source or destination of the given pipe call is identified as a non-Node.js stream.
 */
private predicate hasNonNodeJsStreamSource(PipeCall pipeCall) {
  sourceStreamRef(pipeCall) = getNonNodeJsStreamType() or
  destinationStreamRef(pipeCall) = getNonNodeJsStreamType()
}

/**
 * Holds if the source stream of the given pipe call is used in a non-stream-like way.
 */
private predicate hasNonStreamSourceLikeUsage(PipeCall pipeCall) {
  exists(DataFlow::MethodCallNode call, string name |
    call.getReceiver().getALocalSource() = sourceStreamRef(pipeCall) and
    name = call.getMethodName() and
    not name = getStreamMethodName()
  )
  or
  exists(DataFlow::PropRef propRef, string propName |
    propRef.getBase().getALocalSource() = sourceStreamRef(pipeCall) and
    propName = propRef.getPropertyName() and
    not propName = [getStreamPropertyName(), getStreamMethodName()]
  )
}

/**
 * Holds if the pipe call destination stream has an error handler registered.
 */
private predicate hasErrorHandlerDownstream(PipeCall pipeCall) {
  exists(DataFlow::SourceNode stream |
    stream = destinationStreamRef(pipeCall) and
    (
      exists(ErrorHandlerRegistration handler | handler.getReceiver().getALocalSource() = stream)
      or
      exists(DataFlow::SourceNode base, string propName |
        stream = base.getAPropertyRead(propName) and
        base.getAPropertyRead(propName).getAMethodCall(_) instanceof ErrorHandlerRegistration
      )
    )
  )
}

from PipeCall pipeCall
where
  not hasErrorHandlerRegistered(pipeCall) and
  hasErrorHandlerDownstream(pipeCall) and
  not isPipeFollowedByNonStreamAccess(pipeCall) and
  not hasNonStreamSourceLikeUsage(pipeCall) and
  not hasNonNodeJsStreamSource(pipeCall) and
  not isTestFile(pipeCall.getFile())
select pipeCall,
  "Stream pipe without error handling on the source stream. Errors won't propagate downstream and may be silently dropped."
