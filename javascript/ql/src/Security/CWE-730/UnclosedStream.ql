/**
 * @name Unclosed stream
 * @description A stream that is not closed may leak system resources.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/unclosed-stream
 * @tags security
 *       external/cwe/cwe-730
 *       external/cwe/cwe-404
 */

import javascript

/**
 * Gets a function that `caller` invokes directly or indirectly as a callback to a library function.
 */
Function getACallee(Function caller) {
  exists(DataFlow::InvokeNode invk | invk.getEnclosingFunction() = caller |
    result = invk.getACallee()
    or
    not exists(invk.getACallee()) and
    result = invk.getCallback(invk.getNumArgument()).getFunction()
  )
}

/**
 * A function that can be terminated meaningfully in an asynchronous context.
 */
abstract class AsyncTerminatableFunction extends DataFlow::FunctionNode {
  /**
   * Gets a node where this function terminates.
   *
   * It can be expected that no further expressions in this function will be evaluated after the evaluation of this node.
   */
  abstract DataFlow::Node getTermination();

  /**
   * Gets a brief description of this function.
   */
  abstract string getKind();
}

/**
 * A promise executor as a function that can be terminated in an asynchronous context.
 */
class PromiseExecutor extends AsyncTerminatableFunction {
  PromiseDefinition def;

  PromiseExecutor() { this = def.getExecutor() }

  override DataFlow::CallNode getTermination() {
    result = [def.getRejectParameter(), def.getResolveParameter()].getACall()
  }

  override string getKind() { result = "promise" }
}

/**
 * A callback-invoking function heuristic as a function that can be terminated in an asynchronous context.
 */
class FunctionWithCallback extends AsyncTerminatableFunction {
  DataFlow::ParameterNode callbackParameter;

  FunctionWithCallback() {
    // the last parameter is the callback
    callbackParameter = this.getLastParameter() and
    // simple escape analysis
    not exists(DataFlow::Node escape | callbackParameter.flowsTo(escape) |
      escape = any(DataFlow::PropWrite w).getRhs() or
      escape = any(DataFlow::CallNode c).getAnArgument()
    ) and
    // no return value
    (this.getFunction() instanceof ArrowFunctionExpr or not exists(this.getAReturn())) and
    // all callback invocations are terminal (note that this permits calls in closures)
    forex(DataFlow::CallNode termination | termination = callbackParameter.getACall() |
      termination.asExpr() = any(Function f).getExit().getAPredecessor()
    ) and
    // avoid confusion with promises
    not this instanceof PromiseExecutor and
    not exists(PromiseCandidate c | this.flowsTo(c.getAnArgument()))
  }

  override DataFlow::CallNode getTermination() { result = callbackParameter.getACall() }

  override string getKind() { result = "asynchronous function" }
}

/**
 * A data stream.
 */
class Stream extends DataFlow::SourceNode {
  DataFlow::FunctionNode processor;

  Stream() {
    exists(DataFlow::CallNode onData |
      this instanceof EventEmitter and
      onData = this.getAMethodCall(EventEmitter::on()) and
      onData.getArgument(0).mayHaveStringValue("data") and
      processor = onData.getCallback(1)
    )
  }

  /**
   * Gets a call that closes thes stream.
   */
  DataFlow::Node getClose() { result = this.getAMethodCall("destroy") }

  /**
   * Gets a function that processes the content of the stream.
   */
  DataFlow::FunctionNode getProcessor() { result = processor }
}

from
  AsyncTerminatableFunction terminatable, DataFlow::CallNode termination, Stream stream,
  Function processor
where
  stream.getAstNode().getContainer() = getACallee*(terminatable.getFunction()) and
  termination = terminatable.getTermination() and
  processor = stream.getProcessor().getFunction() and
  termination.asExpr().getEnclosingFunction() = getACallee*(processor) and
  not exists(Function destroyFunction |
    destroyFunction = getACallee*(processor) and
    stream.getClose().asExpr().getEnclosingFunction() = destroyFunction
  )
select processor, "This stream processor $@ the enclosing $@ without closing the stream.",
  termination, "terminates", terminatable, terminatable.getKind()
